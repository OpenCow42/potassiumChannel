import Foundation
import Testing
@testable import potassiumChannel

@Suite("kChat get team requests")
struct KChatGetTeamRequestTests {
    @Test("kChat get team request matches the OpenAPI path")
    func kChatGetTeamRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.getTeam(teamId: "team-id")

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == nil)
        #expect(url.path == "/api/v4/teams/team-id")
        #expect(url.query?.isEmpty ?? true)
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat get team request percent-encodes the team id path segment")
    func kChatGetTeamRequestPercentEncodesTeamIdPathSegment() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.getTeam(teamId: "team/id")

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(url.path == "/api/v4/teams/team/id")
        #expect(url.absoluteString.contains("/api/v4/teams/team%2Fid"))
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat get team decodes Mattermost-compatible teams")
    func kChatGetTeamDecodesTeam() throws {
        let json = #"{"id":"team-id","create_at":1,"update_at":2,"delete_at":0,"display_name":"Demo Team","name":"demo","description":"Team description","email":"team@example.com","type":"O","allowed_domains":"example.com","invite_id":"invite","allow_open_invite":true,"policy_id":"policy"}"#.data(using: .utf8)!

        let team = try JSONDecoder.kChat.decode(KChatTeam.self, from: json)

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
