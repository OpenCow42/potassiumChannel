import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// A lazily started HTTP request with observable byte progress.
///
/// An operation owns one suspended ``URLSessionTask``. Awaiting ``value`` starts
/// the task at most once, while every waiter observes the same terminal result.
/// Cancelling the operation, its progress, or a task awaiting its value cancels
/// the underlying network task for all waiters.
public final class APIRequestOperation<Output: Sendable>: @unchecked Sendable {
    /// The live progress owned and updated by the underlying URL session task.
    public let progress: Progress

    private let task: URLSessionTask
    private let state: APIRequestOperationState<Output>

    init(task: URLSessionTask, state: APIRequestOperationState<Output>) {
        self.task = task
        self.state = state
        self.progress = task.progress

        task.progress.cancellationHandler = { [weak state] in
            state?.cancel()
        }
    }

    deinit {
        state.cancel()
    }

    /// The shared response value.
    ///
    /// The first access starts the network task. Cancelling any task awaiting
    /// this value cancels the operation because the underlying request cannot
    /// continue independently for another waiter.
    public var value: Output {
        get async throws {
            try await withTaskCancellationHandler {
                try Task.checkCancellation()
                if progress.isCancelled {
                    state.cancel()
                }

                return try await withCheckedThrowingContinuation { continuation in
                    state.addWaiter(continuation)
                }
            } onCancel: {
                state.cancel()
            }
        }
    }

    /// Cancels the operation and all tasks waiting for its value.
    public func cancel() {
        state.cancel()
    }
}

final class APIRequestOperationState<Output: Sendable>: @unchecked Sendable {
    private enum Phase {
        case suspended
        case running
        case completed(Result<Output, Error>)
    }

    private let lock = NSLock()
    private weak var task: URLSessionTask?
    private var phase = Phase.suspended
    private var waiters: [CheckedContinuation<Output, Error>] = []

    func install(task: URLSessionTask) {
        lock.lock()
        self.task = task
        lock.unlock()
    }

    func addWaiter(_ continuation: CheckedContinuation<Output, Error>) {
        var taskToStart: URLSessionTask?
        var completedResult: Result<Output, Error>?

        lock.lock()
        switch phase {
        case .suspended:
            phase = .running
            waiters.append(continuation)
            taskToStart = task
        case .running:
            waiters.append(continuation)
        case .completed(let result):
            completedResult = result
        }
        lock.unlock()

        taskToStart?.resume()
        if let completedResult {
            continuation.resume(with: completedResult)
        }
    }

    func complete(with result: Result<Output, Error>) {
        let continuations: [CheckedContinuation<Output, Error>]

        lock.lock()
        guard case .completed = phase else {
            phase = .completed(result)
            continuations = waiters
            waiters.removeAll(keepingCapacity: false)
            task = nil
            lock.unlock()

            for continuation in continuations {
                continuation.resume(with: result)
            }
            return
        }
        lock.unlock()
    }

    func cancel() {
        let taskToCancel: URLSessionTask?
        let continuations: [CheckedContinuation<Output, Error>]
        let cancellation = Result<Output, Error>.failure(CancellationError())

        lock.lock()
        guard case .completed = phase else {
            phase = .completed(cancellation)
            taskToCancel = task
            continuations = waiters
            waiters.removeAll(keepingCapacity: false)
            task = nil
            lock.unlock()

            taskToCancel?.cancel()
            for continuation in continuations {
                continuation.resume(with: cancellation)
            }
            return
        }
        lock.unlock()
    }
}
