import Foundation
import Testing
@testable import potassiumChannel

@Suite("kChat get user team unread request")
struct KChatGetUserTeamUnreadRequestTests {
    @Test("kChat get user team unread request matches the OpenAPI path")
    func kChatGetUserTeamUnreadRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let userId = try KChatTestEnvironment.requireKChatUserId()
        let request = KChatRequests.getUserTeamUnread(userId: userId, teamId: "team-id")

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == nil)
        #expect(url.path == "/api/v4/users/\(userId)/teams/team-id/unread")
        #expect(components.queryItems?.isEmpty != false)
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat get user team unread request supports the special me id")
    func kChatGetUserTeamUnreadRequestSupportsMe() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.getUserTeamUnread(userId: "me", teamId: "team-id")

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(url.path == "/api/v4/users/me/teams/team-id/unread")
    }

    @Test("kChat get user team unread request percent-encodes user and team path segments")
    func kChatGetUserTeamUnreadRequestPercentEncodesUserAndTeamIds() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.getUserTeamUnread(userId: "user/id", teamId: "team/id")

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(url.path == "/api/v4/users/user/id/teams/team/id/unread")
        #expect(url.absoluteString.contains("/api/v4/users/user%2Fid/teams/team%2Fid/unread"))
    }

    @Test("kChat single team unread decodes Mattermost-compatible snake-case fields")
    func kChatSingleTeamUnreadDecodesSnakeCaseFields() throws {
        let json = #"{"team_id":"team-id","msg_count":7,"mention_count":2}"#.data(using: .utf8)!

        let unread = try JSONDecoder.kChat.decode(KChatTeamUnread.self, from: json)

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
