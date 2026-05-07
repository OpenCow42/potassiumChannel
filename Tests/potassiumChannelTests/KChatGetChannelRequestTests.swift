import Foundation
import Testing
@testable import potassiumChannel

@Suite("kChat get channel requests")
struct KChatGetChannelRequestTests {
    @Test("kChat get channel request matches the OpenAPI path")
    func kChatGetChannelRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.getChannel(channelId: "channel-id")

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == nil)
        #expect(url.path == "/api/v4/channels/channel-id")
        #expect(url.query?.isEmpty ?? true)
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat get channel percent-encodes the channel id path segment")
    func kChatGetChannelPercentEncodesChannelId() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.getChannel(channelId: "channel/id with space")

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))

        #expect(components.percentEncodedPath == "/api/v4/channels/channel%2Fid%20with%20space")
        #expect(url.query?.isEmpty ?? true)
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat get channel decodes Mattermost-compatible channel fields")
    func kChatGetChannelDecodesChannel() throws {
        let json = #"{"id":"channel-id","create_at":1,"update_at":2,"delete_at":0,"team_id":"team-id","type":"O","display_name":"Town Square","name":"town-square","header":"Welcome","purpose":"General chat","last_post_at":3,"total_msg_count":4,"creator_id":"creator-id","team_display_name":"Example Team","team_name":"example","team_update_at":5,"policy_id":"policy-id"}"#.data(using: .utf8)!

        let channel = try JSONDecoder.kChat.decode(KChatChannel.self, from: json)

        #expect(channel.id == "channel-id")
        #expect(channel.createAt == 1)
        #expect(channel.updateAt == 2)
        #expect(channel.deleteAt == 0)
        #expect(channel.teamId == "team-id")
        #expect(channel.type == "O")
        #expect(channel.displayName == "Town Square")
        #expect(channel.name == "town-square")
        #expect(channel.header == "Welcome")
        #expect(channel.purpose == "General chat")
        #expect(channel.lastPostAt == 3)
        #expect(channel.totalMsgCount == 4)
        #expect(channel.creatorId == "creator-id")
        #expect(channel.teamDisplayName == "Example Team")
        #expect(channel.teamName == "example")
        #expect(channel.teamUpdateAt == 5)
        #expect(channel.policyId == "policy-id")
    }
}

private extension JSONDecoder {
    static var kChat: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
