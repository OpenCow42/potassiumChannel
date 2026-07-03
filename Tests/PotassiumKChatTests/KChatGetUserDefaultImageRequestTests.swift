import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKChat

@Suite("kChat get user default image requests")
struct KChatGetUserDefaultImageRequestTests {
    @Test("kChat get user default image request matches the OpenAPI path")
    func kChatGetUserDefaultImageRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.getUserDefaultImage(userId: "user-id")

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == nil)
        #expect(url.path == "/api/v4/users/user-id/image/default")
        #expect(url.query == nil || url.query == "")
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat get user default image supports the special me user id")
    func kChatGetUserDefaultImageSupportsMePath() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.getUserDefaultImage(userId: "me")

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(url.path == "/api/v4/users/me/image/default")
    }
}
