import Foundation
import Testing
@testable import potassiumChannel

@Suite("kChat get user status requests")
struct KChatGetUserStatusRequestTests {
    @Test("kChat get user status request matches the OpenAPI path")
    func kChatGetUserStatusRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let userId = try KChatTestEnvironment.requireKChatUserId()
        let request = KChatRequests.getUserStatus(userId: userId)

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == nil)
        #expect(url.path == "/api/v4/users/\(userId)/status")
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat get user status request supports the special me id")
    func kChatGetUserStatusRequestSupportsMe() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.getUserStatus(userId: "me")

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(url.path == "/api/v4/users/me/status")
    }

    @Test("kChat user status decodes Mattermost-compatible snake-case fields")
    func kChatUserStatusDecodesSnakeCaseFields() throws {
        let json = #"{"user_id":"user-id","status":"online","manual":true,"last_activity_at":123456789,"dnd_end_time":123456999}"#.data(using: .utf8)!

        let status = try JSONDecoder.kChat.decode(KChatUserStatus.self, from: json)

        #expect(status.userId == "user-id")
        #expect(status.status == "online")
        #expect(status.manual == true)
        #expect(status.lastActivityAt == 123456789)
        #expect(status.dndEndTime == 123456999)
    }
}

private extension JSONDecoder {
    static var kChat: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
