import Foundation
import Testing
@testable import potassiumChannel

@Suite("kChat autocomplete channels for team requests")
struct KChatAutocompleteChannelsForTeamRequestTests {
    @Test("kChat autocomplete channels for team request matches the OpenAPI path and query")
    func kChatAutocompleteChannelsForTeamRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.autocompleteChannelsForTeam(
            teamId: "team-id",
            options: KChatChannelsForTeamAutocompleteOptions(name: "town")
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
        #expect(url.path == "/api/v4/teams/team-id/channels/autocomplete")
        #expect(query["name"] == "town")
        #expect(query.count == 1)
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat autocomplete channels for team request percent-encodes the team id path segment and query")
    func kChatAutocompleteChannelsForTeamRequestPercentEncodesTeamIdPathSegmentAndQuery() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.autocompleteChannelsForTeam(
            teamId: "team/id with space",
            options: KChatChannelsForTeamAutocompleteOptions(name: "town square")
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        let queryName = try #require(components.queryItems?.first { $0.name == "name" }?.value)

        #expect(url.path == "/api/v4/teams/team/id with space/channels/autocomplete")
        #expect(url.absoluteString.contains("/api/v4/teams/team%2Fid%20with%20space/channels/autocomplete"))
        #expect(queryName == "town square")
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat autocomplete channels for team request keeps required name query when empty")
    func kChatAutocompleteChannelsForTeamRequestKeepsRequiredNameQueryWhenEmpty() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.autocompleteChannelsForTeam(
            teamId: "team-id",
            options: KChatChannelsForTeamAutocompleteOptions(name: "")
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        let queryName = try #require(components.queryItems?.first { $0.name == "name" }?.value)

        #expect(url.path == "/api/v4/teams/team-id/channels/autocomplete")
        #expect(queryName == "")
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat autocomplete channels for team decodes Mattermost-compatible channel arrays")
    func kChatAutocompleteChannelsForTeamDecodesChannelArray() throws {
        let json = #"[{"id":"channel-id","create_at":1,"update_at":2,"delete_at":0,"team_id":"team-id","type":"O","display_name":"Town Square","name":"town-square","header":"Welcome","purpose":"General chat","last_post_at":3,"total_msg_count":4,"creator_id":"creator-id","team_display_name":"Example Team","team_name":"example","team_update_at":5,"policy_id":"policy-id"}]"#.data(using: .utf8)!

        let channels = try JSONDecoder.kChat.decode([KChatChannel].self, from: json)
        let channel = try #require(channels.first)

        #expect(channel.id == "channel-id")
        #expect(channel.teamId == "team-id")
        #expect(channel.displayName == "Town Square")
        #expect(channel.name == "town-square")
        #expect(channel.teamName == "example")
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
