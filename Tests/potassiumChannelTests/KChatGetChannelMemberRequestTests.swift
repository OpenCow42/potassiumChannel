import Foundation
import Testing
@testable import potassiumChannel

@Suite("kChat get channel member requests")
struct KChatGetChannelMemberRequestTests {
    @Test("kChat get channel member request matches the OpenAPI path")
    func kChatGetChannelMemberRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.getChannelMember(channelId: "channel-id", userId: "user-id")

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == nil)
        #expect(url.path == "/api/v4/channels/channel-id/members/user-id")
        #expect(url.query?.isEmpty ?? true)
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat get channel member request percent-encodes both path segments")
    func kChatGetChannelMemberRequestPercentEncodesPathSegments() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.getChannelMember(channelId: "channel/id with space", userId: "user/id with space")

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(url.path == "/api/v4/channels/channel/id with space/members/user/id with space")
        #expect(url.absoluteString.contains("/api/v4/channels/channel%2Fid%20with%20space/members/user%2Fid%20with%20space"))
        #expect(url.query?.isEmpty ?? true)
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat get channel member decodes Mattermost-compatible member")
    func kChatGetChannelMemberDecodesMember() throws {
        let json = #"{"channel_id":"channel-id","user_id":"user-id","roles":"channel_user","last_viewed_at":1710000000000,"msg_count":10,"mention_count":1,"notify_props":{"desktop":"default","email":"default","mark_unread":"all","push":"default","ignore_channel_mentions":"default"},"last_update_at":1710000001000}"#.data(using: .utf8)!

        let member = try JSONDecoder.kChat.decode(KChatChannelMember.self, from: json)

        #expect(member.channelId == "channel-id")
        #expect(member.userId == "user-id")
        #expect(member.roles == "channel_user")
        #expect(member.lastViewedAt == 1_710_000_000_000)
        #expect(member.msgCount == 10)
        #expect(member.mentionCount == 1)
        #expect(member.notifyProps?.desktop == "default")
        #expect(member.notifyProps?.markUnread == "all")
        #expect(member.lastUpdateAt == 1_710_000_001_000)
    }

    @Test("kChat get channel member decodes numeric ids returned by live kChat")
    func kChatGetChannelMemberDecodesNumericIds() throws {
        let json = #"{"channel_id":67890,"user_id":12345,"roles":"channel_user","last_viewed_at":0,"msg_count":0,"mention_count":0,"last_update_at":0}"#.data(using: .utf8)!

        let member = try JSONDecoder.kChat.decode(KChatChannelMember.self, from: json)

        #expect(member.channelId == "67890")
        #expect(member.userId == "12345")
        #expect(member.roles == "channel_user")
        #expect(member.lastViewedAt == 0)
        #expect(member.lastUpdateAt == 0)
    }
}

private extension JSONDecoder {
    static var kChat: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
