import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKChat

@Suite("kChat get team stats requests")
struct KChatGetTeamStatsRequestTests {
    @Test("kChat get team stats request matches the OpenAPI path")
    func kChatGetTeamStatsRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.getTeamStats(teamId: "team-id")

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == nil)
        #expect(url.path == "/api/v4/teams/team-id/stats")
        #expect(url.query?.isEmpty ?? true)
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat get team stats request percent-encodes the team id path segment")
    func kChatGetTeamStatsRequestPercentEncodesTeamIdPathSegment() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.getTeamStats(teamId: "team/id with space")

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(url.path == "/api/v4/teams/team/id with space/stats")
        #expect(url.absoluteString.contains("/api/v4/teams/team%2Fid%20with%20space/stats"))
        #expect(url.query?.isEmpty ?? true)
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat get team stats decodes Mattermost-compatible team stats")
    func kChatGetTeamStatsDecodesTeamStats() throws {
        let json = #"{"team_id":"team-id","total_member_count":42,"active_member_count":27}"#.data(using: .utf8)!

        let stats = try JSONDecoder.kChat.decode(KChatTeamStats.self, from: json)

        #expect(stats.teamId == "team-id")
        #expect(stats.totalMemberCount == 42)
        #expect(stats.activeMemberCount == 27)
    }
}

private extension JSONDecoder {
    static var kChat: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
