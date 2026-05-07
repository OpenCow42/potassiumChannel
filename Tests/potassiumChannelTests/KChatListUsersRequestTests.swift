import Foundation
import Testing
@testable import potassiumChannel

@Suite("kChat list users requests")
struct KChatListUsersRequestTests {
    @Test("kChat list users request matches the OpenAPI path and query")
    func kChatListUsersRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.listUsers(options: KChatListUsersOptions(
            page: 2,
            perPage: 25,
            inTeam: "team-id",
            notInTeam: "other-team-id",
            inChannel: "channel-id",
            notInChannel: "other-channel-id",
            inGroup: "group-id",
            groupConstrained: true,
            withoutTeam: false,
            active: true,
            inactive: false,
            role: "system_user",
            sort: "create_at",
            roles: "system_user,system_admin",
            channelRoles: "channel_user",
            teamRoles: "team_user"
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
        #expect(url.path == "/api/v4/users")
        #expect(query["page"] == "2")
        #expect(query["per_page"] == "25")
        #expect(query["in_team"] == "team-id")
        #expect(query["not_in_team"] == "other-team-id")
        #expect(query["in_channel"] == "channel-id")
        #expect(query["not_in_channel"] == "other-channel-id")
        #expect(query["in_group"] == "group-id")
        #expect(query["group_constrained"] == "true")
        #expect(query["without_team"] == "false")
        #expect(query["active"] == "true")
        #expect(query["inactive"] == "false")
        #expect(query["role"] == "system_user")
        #expect(query["sort"] == "create_at")
        #expect(query["roles"] == "system_user,system_admin")
        #expect(query["channel_roles"] == "channel_user")
        #expect(query["team_roles"] == "team_user")
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat list users request omits empty options")
    func kChatListUsersRequestOmitsEmptyOptions() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.listUsers()

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(url.path == "/api/v4/users")
        #expect(url.query?.isEmpty ?? true)
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat list users decodes Mattermost-compatible user arrays")
    func kChatListUsersDecodesUserArray() throws {
        let json = #"[{"id":"user-id","create_at":1,"update_at":2,"delete_at":0,"username":"alice","first_name":"Alice","last_name":"Example","email":"alice@example.com","roles":"system_user"}]"#.data(using: .utf8)!

        let users = try JSONDecoder.kChat.decode([KChatUser].self, from: json)

        let user = try #require(users.first)
        #expect(user.id == "user-id")
        #expect(user.createAt == 1)
        #expect(user.username == "alice")
        #expect(user.firstName == "Alice")
        #expect(user.roles == "system_user")
    }
}

private extension JSONDecoder {
    static var kChat: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
