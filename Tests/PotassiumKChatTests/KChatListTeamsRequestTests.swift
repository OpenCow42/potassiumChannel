import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKChat

@Suite("kChat list teams requests")
struct KChatListTeamsRequestTests {
    @Test("kChat list teams request matches the OpenAPI path and query")
    func kChatListTeamsRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.listTeams(options: KChatListTeamsOptions(
            page: 2,
            perPage: 25,
            includeTotalCount: false,
            excludePolicyConstrained: true
        ))

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
        #expect(url.path == "/api/v4/teams")
        #expect(query["page"] == "2")
        #expect(query["per_page"] == "25")
        #expect(query["include_total_count"] == "false")
        #expect(query["exclude_policy_constrained"] == "true")
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat list teams request omits empty options")
    func kChatListTeamsRequestOmitsEmptyOptions() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.listTeams()

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(url.path == "/api/v4/teams")
        #expect(url.query?.isEmpty ?? true)
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat list teams decodes Mattermost-compatible team arrays")
    func kChatListTeamsDecodesTeamArray() throws {
        let json = #"[{"id":"team-id","create_at":1,"update_at":2,"delete_at":0,"display_name":"Demo Team","name":"demo","description":"Team description","email":"team@example.com","type":"O","allowed_domains":"example.com","invite_id":"invite","allow_open_invite":true,"policy_id":"policy"}]"#.data(using: .utf8)!

        let teams = try JSONDecoder.kChat.decode([KChatTeam].self, from: json)

        let team = try #require(teams.first)
        #expect(team.id == "team-id")
        #expect(team.createAt == 1)
        #expect(team.displayName == "Demo Team")
        #expect(team.name == "demo")
        #expect(team.allowOpenInvite == true)
        #expect(team.policyId == "policy")
    }
}

private extension JSONDecoder {
    static var kChat: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
