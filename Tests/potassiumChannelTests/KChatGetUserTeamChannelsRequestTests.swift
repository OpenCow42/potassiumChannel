import Foundation
import Testing
@testable import potassiumChannel

@Suite("kChat get user team channels requests")
struct KChatGetUserTeamChannelsRequestTests {
    @Test("kChat get user team channels request matches the OpenAPI path and query")
    func kChatGetUserTeamChannelsRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let userId = try KChatTestEnvironment.requireKChatUserId()
        let request = KChatRequests.getUserTeamChannels(
            userId: userId,
            teamId: "team-id",
            options: KChatUserTeamChannelsOptions(includeDeleted: true, lastDeleteAt: 123)
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == nil)
        #expect(url.path == "/api/v4/users/\(userId)/teams/team-id/channels")
        #expect(components.queryItems?.contains(URLQueryItem(name: "include_deleted", value: "true")) == true)
        #expect(components.queryItems?.contains(URLQueryItem(name: "last_delete_at", value: "123")) == true)
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat channel decodes Mattermost-compatible snake-case fields")
    func kChatChannelDecodesSnakeCaseFields() throws {
        let json = #"{"id":"channel-id","create_at":1,"update_at":2,"delete_at":0,"team_id":"team-id","type":"O","display_name":"Town Square","name":"town-square","header":"Header","purpose":"Purpose","last_post_at":3,"total_msg_count":4,"creator_id":"creator-id"}"#.data(using: .utf8)!

        let channel = try JSONDecoder.kChat.decode(KChatChannel.self, from: json)

        #expect(channel.id == "channel-id")
        #expect(channel.createAt == 1)
        #expect(channel.teamId == "team-id")
        #expect(channel.displayName == "Town Square")
        #expect(channel.name == "town-square")
        #expect(channel.totalMsgCount == 4)
        #expect(channel.creatorId == "creator-id")
    }
}

private extension JSONDecoder {
    static var kChat: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
