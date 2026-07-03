import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKChat

@Suite("kChat get user team unreads requests")
struct KChatGetUserTeamsUnreadRequestTests {
    @Test("kChat get user team unreads request matches the OpenAPI path")
    func kChatGetUserTeamsUnreadRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let userId = try KChatTestEnvironment.requireKChatUserId()
        let request = KChatRequests.getUserTeamsUnread(userId: userId)

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == nil)
        #expect(url.path == "/api/v4/users/\(userId)/teams/unread")
        #expect(components.queryItems?.isEmpty != false)
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat get user team unreads request supports the special me id")
    func kChatGetUserTeamsUnreadRequestSupportsMe() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.getUserTeamsUnread(userId: "me")

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(url.path == "/api/v4/users/me/teams/unread")
    }

    @Test("kChat get user team unreads request percent-encodes path segments")
    func kChatGetUserTeamsUnreadRequestPercentEncodesUserId() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.getUserTeamsUnread(userId: "user/id")

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(url.path == "/api/v4/users/user/id/teams/unread")
        #expect(url.absoluteString.contains("/api/v4/users/user%2Fid/teams/unread"))
    }

    @Test("kChat team unread decodes Mattermost-compatible snake-case fields")
    func kChatTeamUnreadDecodesSnakeCaseFields() throws {
        let json = #"[{"team_id":"team-id","msg_count":7,"mention_count":2}]"#.data(using: .utf8)!

        let unreads = try JSONDecoder.kChat.decode([KChatTeamUnread].self, from: json)
        let unread = try #require(unreads.first)

        #expect(unread.teamId == "team-id")
        #expect(unread.msgCount == 7)
        #expect(unread.mentionCount == 2)
    }
}

private extension JSONDecoder {
    static var kChat: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
