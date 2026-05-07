import Foundation
import Testing
@testable import potassiumChannel

@Suite("kChat get deleted channels for team requests")
struct KChatGetDeletedChannelsForTeamRequestTests {
    @Test("kChat get deleted channels for team request matches the OpenAPI path and query")
    func kChatGetDeletedChannelsForTeamRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.getDeletedChannelsForTeam(
            teamId: "team-id",
            options: KChatDeletedChannelsForTeamOptions(page: 2, perPage: 25)
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        let query = Dictionary(uniqueKeysWithValues: (components.queryItems ?? []).compactMap { item in
            item.value.map { (item.name, $0) }
        })

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == nil)
        #expect(url.path == "/api/v4/teams/team-id/channels/deleted")
        #expect(query["page"] == "2")
        #expect(query["per_page"] == "25")
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat get deleted channels for team request omits empty options")
    func kChatGetDeletedChannelsForTeamRequestOmitsEmptyOptions() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.getDeletedChannelsForTeam(teamId: "team-id")

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(url.path == "/api/v4/teams/team-id/channels/deleted")
        #expect(url.query?.isEmpty ?? true)
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat get deleted channels for team request percent-encodes the team id path segment")
    func kChatGetDeletedChannelsForTeamRequestPercentEncodesTeamIdPathSegment() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.getDeletedChannelsForTeam(teamId: "team/id with space")

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(url.path == "/api/v4/teams/team/id with space/channels/deleted")
        #expect(url.absoluteString.contains("/api/v4/teams/team%2Fid%20with%20space/channels/deleted"))
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat get deleted channels for team decodes Mattermost-compatible channel arrays")
    func kChatGetDeletedChannelsForTeamDecodesChannelArray() throws {
        let json = #"[{"id":"channel-id","create_at":1,"update_at":2,"delete_at":6,"team_id":"team-id","type":"O","display_name":"Old Channel","name":"old-channel","header":"Archive","purpose":"Past chat","last_post_at":3,"total_msg_count":4,"creator_id":"creator-id","team_display_name":"Example Team","team_name":"example","team_update_at":5,"policy_id":"policy-id"}]"#.data(using: .utf8)!

        let channels = try JSONDecoder.kChat.decode([KChatChannel].self, from: json)
        let channel = try #require(channels.first)

        #expect(channel.id == "channel-id")
        #expect(channel.createAt == 1)
        #expect(channel.deleteAt == 6)
        #expect(channel.teamId == "team-id")
        #expect(channel.displayName == "Old Channel")
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
