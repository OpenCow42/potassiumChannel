import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKChat

@Suite("kChat get user team members requests")
struct KChatGetUserTeamMembersRequestTests {
    @Test("kChat get user team members request matches the OpenAPI path")
    func kChatGetUserTeamMembersRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let userId = try KChatTestEnvironment.requireKChatUserId()
        let request = KChatRequests.getUserTeamMembers(userId: userId)

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == nil)
        #expect(url.path == "/api/v4/users/\(userId)/teams/members")
        #expect(components.queryItems?.isEmpty != false)
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat get user team members request supports the special me id")
    func kChatGetUserTeamMembersRequestSupportsMe() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.getUserTeamMembers(userId: "me")

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(url.path == "/api/v4/users/me/teams/members")
    }

    @Test("kChat get user team members request percent-encodes path segments")
    func kChatGetUserTeamMembersRequestPercentEncodesUserId() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.getUserTeamMembers(userId: "user/id")

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(url.path == "/api/v4/users/user/id/teams/members")
        #expect(url.absoluteString.contains("/api/v4/users/user%2Fid/teams/members"))
    }

    @Test("kChat team member decodes Mattermost-compatible snake-case fields")
    func kChatTeamMemberDecodesSnakeCaseFields() throws {
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
}

private extension JSONDecoder {
    static var kChat: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
