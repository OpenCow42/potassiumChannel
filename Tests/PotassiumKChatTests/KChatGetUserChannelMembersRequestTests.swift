import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKChat

@Suite("kChat get user channel members requests")
struct KChatGetUserChannelMembersRequestTests {
    @Test("kChat get user channel members request matches the OpenAPI path")
    func kChatGetUserChannelMembersRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let userId = try KChatTestEnvironment.requireKChatUserId()
        let request = KChatRequests.getUserChannelMembers(userId: userId)

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == nil)
        #expect(url.path == "/api/v4/users/\(userId)/channel_members")
        #expect(url.query == nil || url.query == "")
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat get user channel members request percent-encodes path segments")
    func kChatGetUserChannelMembersRequestPercentEncodesPathSegments() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.getUserChannelMembers(userId: "user/id with space")

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(url.absoluteString.hasPrefix("https://example-team.kchat.infomaniak.com/api/v4/users/user%2Fid%20with%20space/channel_members"))
    }

    @Test("kChat get user channel members supports the special me user id")
    func kChatGetUserChannelMembersSupportsMePath() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.getUserChannelMembers(userId: "me")

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(url.path == "/api/v4/users/me/channel_members")
        #expect(url.query == nil || url.query == "")
    }

    @Test("kChat get user channel members request includes optional pagination query")
    func kChatGetUserChannelMembersRequestIncludesPaginationQuery() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.getUserChannelMembers(
            userId: "me",
            options: KChatUserChannelMembersOptions(page: 2, pageSize: 50)
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))

        #expect(components.queryItems?.contains(URLQueryItem(name: "page", value: "2")) == true)
        #expect(components.queryItems?.contains(URLQueryItem(name: "pageSize", value: "50")) == true)
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat channel member decodes Mattermost-compatible snake-case fields")
    func kChatChannelMemberDecodesSnakeCaseFields() throws {
        let json = #"[{"channel_id":"channel-id","user_id":"user-id","roles":"channel_user channel_admin","last_viewed_at":10,"msg_count":20,"mention_count":3,"notify_props":{"desktop":"default","email":"default","mark_unread":"mention","push":"all","ignore_channel_mentions":"off"},"last_update_at":30,"team_display_name":"Example Team","team_name":"example","team_update_at":40}]"#.data(using: .utf8)!

        let members = try JSONDecoder.kChat.decode([KChatChannelMember].self, from: json)
        let member = try #require(members.first)

        #expect(member.channelId == "channel-id")
        #expect(member.userId == "user-id")
        #expect(member.roles == "channel_user channel_admin")
        #expect(member.lastViewedAt == 10)
        #expect(member.msgCount == 20)
        #expect(member.mentionCount == 3)
        #expect(member.notifyProps?.markUnread == "mention")
        #expect(member.notifyProps?.ignoreChannelMentions == "off")
        #expect(member.lastUpdateAt == 30)
        #expect(member.teamDisplayName == "Example Team")
        #expect(member.teamName == "example")
        #expect(member.teamUpdateAt == 40)
    }
}

private extension JSONDecoder {
    static var kChat: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
