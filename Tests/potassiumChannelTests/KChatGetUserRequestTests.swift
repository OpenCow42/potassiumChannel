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
        let request = KChatRequests.getUser(userId: "019dea2d-d615-713d-a516-0f634c4c7c5e")

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == nil)
        #expect(url.path == "/api/v4/users/019dea2d-d615-713d-a516-0f634c4c7c5e")
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
