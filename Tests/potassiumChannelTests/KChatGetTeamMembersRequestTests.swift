import Foundation
import Testing
@testable import potassiumChannel

@Suite("kChat get team members requests")
struct KChatGetTeamMembersRequestTests {
    @Test("kChat get team members request matches the OpenAPI path and query")
    func kChatGetTeamMembersRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.getTeamMembers(
            teamId: "team-id",
            options: KChatTeamMembersOptions(page: 2, perPage: 25)
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
        #expect(url.path == "/api/v4/teams/team-id/members")
        #expect(query["page"] == "2")
        #expect(query["per_page"] == "25")
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat get team members request omits empty options")
    func kChatGetTeamMembersRequestOmitsEmptyOptions() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.getTeamMembers(teamId: "team-id")

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(url.path == "/api/v4/teams/team-id/members")
        #expect(url.query?.isEmpty ?? true)
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat get team members request percent-encodes the team id path segment")
    func kChatGetTeamMembersRequestPercentEncodesTeamIdPathSegment() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.getTeamMembers(teamId: "team/id")

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(url.path == "/api/v4/teams/team/id/members")
        #expect(url.absoluteString.contains("/api/v4/teams/team%2Fid/members"))
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat get team members decodes Mattermost-compatible member arrays")
    func kChatGetTeamMembersDecodesMemberArray() throws {
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

    @Test("kChat get team members decodes numeric member ids returned by live kChat")
    func kChatGetTeamMembersDecodesNumericMemberIds() throws {
        let json = #"[{"team_id":"team-id","user_id":12345,"roles":"team_user","delete_at":0}]"#.data(using: .utf8)!

        let members = try JSONDecoder.kChat.decode([KChatTeamMember].self, from: json)
        let member = try #require(members.first)

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
