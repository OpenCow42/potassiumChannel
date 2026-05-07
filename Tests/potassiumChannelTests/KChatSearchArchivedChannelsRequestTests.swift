import Foundation
import Testing
@testable import potassiumChannel

@Suite("kChat archived team channels search requests")
struct KChatSearchArchivedChannelsRequestTests {
    @Test("kChat archived team channels search request matches the OpenAPI path and JSON body")
    func kChatSearchArchivedChannelsRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = try KChatRequests.searchArchivedChannels(
            teamId: "team-id",
            options: KChatChannelSearchOptions(term: "archive")
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        let body = try #require(urlRequest.httpBody)
        let object = try JSONSerialization.jsonObject(with: body) as? [String: Any]

        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(url.path == "/api/v4/teams/team-id/channels/search_archived")
        #expect((components.queryItems ?? []).isEmpty)
        #expect(object?["term"] as? String == "archive")
        #expect(object?.count == 1)
    }

    @Test("kChat archived team channels search request percent-encodes the team id path segment and JSON body")
    func kChatSearchArchivedChannelsRequestPercentEncodesTeamIdPathSegmentAndBody() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = try KChatRequests.searchArchivedChannels(
            teamId: "team/id with space",
            options: KChatChannelSearchOptions(term: "old town")
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)
        let body = try #require(urlRequest.httpBody)
        let object = try JSONSerialization.jsonObject(with: body) as? [String: Any]

        #expect(url.path == "/api/v4/teams/team/id with space/channels/search_archived")
        #expect(url.absoluteString.contains("/api/v4/teams/team%2Fid%20with%20space/channels/search_archived"))
        #expect(object?["term"] as? String == "old town")
    }

    @Test("kChat archived team channels search request keeps required term when empty")
    func kChatSearchArchivedChannelsRequestKeepsRequiredTermWhenEmpty() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = try KChatRequests.searchArchivedChannels(
            teamId: "team-id",
            options: KChatChannelSearchOptions(term: "")
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let body = try #require(urlRequest.httpBody)
        let object = try JSONSerialization.jsonObject(with: body) as? [String: Any]

        #expect(object?["term"] as? String == "")
        #expect(object?.count == 1)
    }

    @Test("kChat archived team channels search decodes Mattermost-compatible channel arrays")
    func kChatSearchArchivedChannelsDecodesChannelArray() throws {
        let json = #"[{"id":"channel-id","create_at":1,"update_at":2,"delete_at":4,"team_id":"team-id","type":"O","display_name":"Old Town","name":"old-town","header":"Archived","purpose":"Historical chat","last_post_at":3,"total_msg_count":4,"creator_id":"creator-id","team_display_name":"Example Team","team_name":"example","team_update_at":5,"policy_id":"policy-id"}]"#.data(using: .utf8)!

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let channels = try decoder.decode([KChatChannel].self, from: json)
        let channel = try #require(channels.first)

        #expect(channel.id == "channel-id")
        #expect(channel.teamId == "team-id")
        #expect(channel.displayName == "Old Town")
        #expect(channel.name == "old-town")
        #expect(channel.deleteAt == 4)
        #expect(channel.policyId == "policy-id")
    }
}
