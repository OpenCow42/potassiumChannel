import Foundation
import Testing
@testable import potassiumChannel

@Suite("kChat get user requests")
struct KChatGetUserRequestTests {
    @Test("kChat get user request matches the OpenAPI path")
    func kChatGetUserRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let userId = try KChatTestEnvironment.requireKChatUserId()
        let request = KChatRequests.getUser(userId: userId)

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == nil)
        #expect(url.path == "/api/v4/users/\(userId)")
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat get user request supports the special me id")
    func kChatGetUserRequestSupportsMe() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.getUser(userId: "me")

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(url.path == "/api/v4/users/me")
    }
}

enum KChatTestEnvironment {
    static func requireKChatUserId() throws -> String {
        guard let content = try? String(contentsOfFile: "Tests/Env.swift", encoding: .utf8),
              let range = content.range(of: #"kchatAdminId\s*=\s*\"([^\"]+)\""#, options: .regularExpression)
        else {
            throw KChatTestEnvironmentError.missingKChatAdminId
        }

        let assignment = String(content[range])
        guard let firstQuote = assignment.firstIndex(of: "\"") else {
            throw KChatTestEnvironmentError.missingKChatAdminId
        }

        let valueStart = assignment.index(after: firstQuote)
        guard let lastQuote = assignment[valueStart...].firstIndex(of: "\"") else {
            throw KChatTestEnvironmentError.missingKChatAdminId
        }

        return String(assignment[valueStart..<lastQuote])
    }
}

enum KChatTestEnvironmentError: Error {
    case missingKChatAdminId
}
