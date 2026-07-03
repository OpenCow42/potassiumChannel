import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKChat

@Suite("kChat get team member requests")
struct KChatGetTeamMemberRequestTests {
    @Test("kChat get team member request matches the OpenAPI path")
    func kChatGetTeamMemberRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.getTeamMember(teamId: "team-id", userId: "user-id")

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == nil)
        #expect(url.path == "/api/v4/teams/team-id/members/user-id")
        #expect(url.query?.isEmpty ?? true)
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat get team member request percent-encodes both path segments")
    func kChatGetTeamMemberRequestPercentEncodesPathSegments() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.getTeamMember(teamId: "team/id with space", userId: "user/id with space")

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(url.path == "/api/v4/teams/team/id with space/members/user/id with space")
        #expect(url.absoluteString.contains("/api/v4/teams/team%2Fid%20with%20space/members/user%2Fid%20with%20space"))
        #expect(url.query?.isEmpty ?? true)
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat get team member decodes Mattermost-compatible member")
    func kChatGetTeamMemberDecodesMember() throws {
        let json = #"{"team_id":"team-id","user_id":"user-id","roles":"team_user","delete_at":0,"scheme_user":true,"scheme_admin":false,"explicit_roles":"team_user"}"#.data(using: .utf8)!

        let member = try JSONDecoder.kChat.decode(KChatTeamMember.self, from: json)

        #expect(member.teamId == "team-id")
        #expect(member.userId == "user-id")
        #expect(member.roles == "team_user")
        #expect(member.deleteAt == 0)
        #expect(member.schemeUser == true)
        #expect(member.schemeAdmin == false)
        #expect(member.explicitRoles == "team_user")
    }

    @Test("kChat get team member decodes numeric user id")
    func kChatGetTeamMemberDecodesNumericUserId() throws {
        let json = #"{"team_id":"team-id","user_id":12345,"roles":"team_user","delete_at":0}"#.data(using: .utf8)!

        let member = try JSONDecoder.kChat.decode(KChatTeamMember.self, from: json)

        #expect(member.teamId == "team-id")
        #expect(member.userId == "12345")
        #expect(member.roles == "team_user")
        #expect(member.deleteAt == 0)
    }
}

private extension JSONDecoder {
    static var kChat: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
