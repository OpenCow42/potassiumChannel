import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKChat

@Suite("kChat get team members by ids requests")
struct KChatGetTeamMembersByIdsRequestTests {
    @Test("kChat get team members by ids request matches the OpenAPI shape")
    func kChatGetTeamMembersByIdsRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = try KChatRequests.getTeamMembersByIds(
            teamId: "team-id",
            userIds: ["user-one", "user-two"]
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(url.path == "/api/v4/teams/team-id/members/ids")
        #expect(url.query?.isEmpty ?? true)
        #expect(urlRequest.httpBody == #"["user-one","user-two"]"#.data(using: .utf8))
    }

    @Test("kChat get team members by ids request percent-encodes the team id path segment")
    func kChatGetTeamMembersByIdsRequestPercentEncodesTeamIdPathSegment() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = try KChatRequests.getTeamMembersByIds(
            teamId: "team/id with space",
            userIds: ["user/id with space"]
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(url.path == "/api/v4/teams/team/id with space/members/ids")
        #expect(url.absoluteString.contains("/api/v4/teams/team%2Fid%20with%20space/members/ids"))
        #expect(url.query?.isEmpty ?? true)
        let body = try JSONDecoder().decode([String].self, from: try #require(urlRequest.httpBody))
        #expect(body == ["user/id with space"])
    }

    @Test("kChat get team members by ids decodes Mattermost-compatible member arrays")
    func kChatGetTeamMembersByIdsDecodesMemberArray() throws {
        let json = #"[{"team_id":"team-id","user_id":"user-id","roles":"team_user","delete_at":0,"scheme_user":true,"scheme_admin":false,"explicit_roles":"team_user"}]"#.data(using: .utf8)!

        let members = try JSONDecoder.kChat.decode([KChatTeamMember].self, from: json)
        let member = try #require(members.first)

        #expect(member.teamId == "team-id")
        #expect(member.userId == "user-id")
        #expect(member.roles == "team_user")
        #expect(member.deleteAt == 0)
        #expect(member.schemeUser == true)
        #expect(member.schemeAdmin == false)
        #expect(member.explicitRoles == "team_user")
    }

    @Test("kChat get team members by ids decodes numeric ids returned by live kChat")
    func kChatGetTeamMembersByIdsDecodesNumericIds() throws {
        let json = #"[{"team_id":67890,"user_id":12345,"roles":"team_user","delete_at":0,"scheme_user":true,"scheme_admin":false,"explicit_roles":"team_user"}]"#.data(using: .utf8)!

        let members = try JSONDecoder.kChat.decode([KChatTeamMember].self, from: json)
        let member = try #require(members.first)

        #expect(member.teamId == "67890")
        #expect(member.userId == "12345")
        #expect(member.roles == "team_user")
    }
}

private extension JSONDecoder {
    static var kChat: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
