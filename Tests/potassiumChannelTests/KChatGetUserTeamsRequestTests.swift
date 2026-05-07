import Foundation
import Testing
@testable import potassiumChannel

@Suite("kChat get user teams requests")
struct KChatGetUserTeamsRequestTests {
    @Test("kChat get user teams request matches the OpenAPI path")
    func kChatGetUserTeamsRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let userId = try KChatTestEnvironment.requireKChatUserId()
        let request = KChatRequests.getUserTeams(userId: userId)

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == nil)
        #expect(url.path == "/api/v4/users/\(userId)/teams")
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat team decodes Mattermost-compatible snake-case fields")
    func kChatTeamDecodesSnakeCaseFields() throws {
        let json = #"{"id":"team-id","create_at":1,"update_at":2,"delete_at":0,"display_name":"Bob Team","name":"bob-team","description":"Team description","email":"team@example.com","type":"O","allowed_domains":"example.com","invite_id":"invite","allow_open_invite":true,"policy_id":"policy"}"#.data(using: .utf8)!

        let team = try JSONDecoder.kChat.decode(KChatTeam.self, from: json)

        #expect(team.id == "team-id")
        #expect(team.createAt == 1)
        #expect(team.displayName == "Bob Team")
        #expect(team.name == "bob-team")
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
