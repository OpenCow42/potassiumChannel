import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Testing
@testable import PotassiumChannelCore

@Suite("API request operations", .serialized)
struct APIRequestOperationTests {
    @Test("operation is lazy, exposes progress, and shares one response")
    func lazySharedResponse() async throws {
        OperationURLProtocol.reset(
            behavior: .success(Data("payload".utf8), delay: 0.03)
        )
        let client = makeClient()
        let operation = try client.dataOperation(for: testRequest())

        #expect(OperationURLProtocol.startedCount == 0)
        #expect(!operation.progress.isCancelled)

        async let first = operation.value
        async let second = operation.value
        let values = try await [first, second]

        #expect(values == [Data("payload".utf8), Data("payload".utf8)])
        #expect(OperationURLProtocol.startedCount == 1)
        #expect(!operation.progress.isCancelled)
    }

    @Test("explicit cancellation before value prevents the request")
    func cancellationBeforeStart() async throws {
        OperationURLProtocol.reset(behavior: .pending)
        let operation = try makeClient().dataOperation(for: testRequest())

        operation.cancel()

        await #expect(throws: CancellationError.self) {
            try await operation.value
        }
        #expect(OperationURLProtocol.startedCount == 0)
    }

    @Test("progress cancellation before value prevents the request")
    func progressCancellationBeforeStart() async throws {
        OperationURLProtocol.reset(behavior: .pending)
        let operation = try makeClient().dataOperation(for: testRequest())

        operation.progress.cancel()

        await #expect(throws: CancellationError.self) {
            try await operation.value
        }
        #expect(OperationURLProtocol.startedCount == 0)
    }

    @Test("cancelling an awaiting task cancels the URL session task")
    func awaitingTaskCancellation() async throws {
        OperationURLProtocol.reset(behavior: .pending)
        let operation = try makeClient().dataOperation(for: testRequest())
        let waiter = Task {
            try await operation.value
        }

        try await waitUntil { OperationURLProtocol.startedCount == 1 }
        waiter.cancel()

        await #expect(throws: CancellationError.self) {
            try await waiter.value
        }
        try await waitUntil { OperationURLProtocol.stoppedCount == 1 }
    }

    @Test("cancelling live progress cancels all waiters exactly once")
    func liveProgressCancellation() async throws {
        OperationURLProtocol.reset(behavior: .pending)
        let operation = try makeClient().dataOperation(for: testRequest())
        let first = Task { try await operation.value }
        let second = Task { try await operation.value }

        try await waitUntil { OperationURLProtocol.startedCount == 1 }
        operation.progress.cancel()

        await #expect(throws: CancellationError.self) { try await first.value }
        await #expect(throws: CancellationError.self) { try await second.value }
        try await waitUntil { OperationURLProtocol.stoppedCount == 1 }
    }

    @Test("typed operations validate status and decode with fresh state")
    func typedResponseAndHTTPFailure() async throws {
        struct Response: Decodable, Equatable, Sendable {
            let responseValue: String
        }

        OperationURLProtocol.reset(
            behavior: .response(
                statusCode: 200,
                data: Data(#"{"response_value":"decoded"}"#.utf8),
                delay: 0
            )
        )
        let response = try await makeClient()
            .operation(for: APIRequest<Response>(method: .get, path: "/operation"))
            .value
        #expect(response == Response(responseValue: "decoded"))

        OperationURLProtocol.reset(
            behavior: .response(statusCode: 503, data: Data("unavailable".utf8), delay: 0)
        )
        let failure = try makeClient().dataOperation(for: testRequest())
        await #expect(throws: APIClientError.self) {
            try await failure.value
        }
    }

    private func makeClient() -> InfomaniakAPIClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [OperationURLProtocol.self]
        return InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.example.test")!,
                bearerToken: "test-token"
            ),
            session: URLSession(configuration: configuration)
        )
    }

    private func testRequest() -> APIRequest<String> {
        APIRequest(method: .get, path: "/operation")
    }

    private func waitUntil(
        _ predicate: @escaping @Sendable () -> Bool
    ) async throws {
        let clock = ContinuousClock()
        let deadline = clock.now.advanced(by: .seconds(1))
        while !predicate() {
            guard clock.now < deadline else {
                Issue.record("Timed out waiting for URL protocol state")
                return
            }
            try await Task.sleep(for: .milliseconds(5))
        }
    }
}

private final class OperationURLProtocol: URLProtocol, @unchecked Sendable {
    enum Behavior: Sendable {
        case pending
        case success(Data, delay: TimeInterval)
        case response(statusCode: Int, data: Data, delay: TimeInterval)
    }

    private struct State {
        var behavior = Behavior.pending
        var startedCount = 0
        var stoppedCount = 0
    }

    private final class Storage: @unchecked Sendable {
        let lock = NSLock()
        var state = State()
    }

    private static let storage = Storage()

    private let instanceLock = NSLock()
    private var stopped = false

    static var startedCount: Int {
        storage.lock.lock()
        defer { storage.lock.unlock() }
        return storage.state.startedCount
    }

    static var stoppedCount: Int {
        storage.lock.lock()
        defer { storage.lock.unlock() }
        return storage.state.stoppedCount
    }

    static func reset(behavior: Behavior) {
        storage.lock.lock()
        storage.state = State(behavior: behavior)
        storage.lock.unlock()
    }

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        let behavior: Behavior
        Self.storage.lock.lock()
        Self.storage.state.startedCount += 1
        behavior = Self.storage.state.behavior
        Self.storage.lock.unlock()

        switch behavior {
        case .pending:
            break
        case .success(let data, let delay):
            respond(statusCode: 200, data: data, after: delay)
        case .response(let statusCode, let data, let delay):
            respond(statusCode: statusCode, data: data, after: delay)
        }
    }

    override func stopLoading() {
        instanceLock.lock()
        stopped = true
        instanceLock.unlock()

        Self.storage.lock.lock()
        Self.storage.state.stoppedCount += 1
        Self.storage.lock.unlock()
    }

    private func respond(statusCode: Int, data: Data, after delay: TimeInterval) {
        if delay > 0 {
            Thread.sleep(forTimeInterval: delay)
        }
        guard !isStopped else { return }
        let response = HTTPURLResponse(
            url: request.url!,
            statusCode: statusCode,
            httpVersion: "HTTP/1.1",
            headerFields: ["Content-Length": String(data.count)]
        )!
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: data)
        client?.urlProtocolDidFinishLoading(self)
    }

    private var isStopped: Bool {
        instanceLock.lock()
        defer { instanceLock.unlock() }
        return stopped
    }
}
