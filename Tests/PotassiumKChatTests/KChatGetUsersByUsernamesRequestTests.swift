import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKChat

@Suite("kChat get users by usernames requests")
struct KChatGetUsersByUsernamesRequestTests {
    @Test("kChat get users by usernames request matches the OpenAPI path and JSON body")
    func kChatGetUsersByUsernamesRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let usernames = ["alice", "bob"]
        let body = try JSONEncoder().encode(usernames)
        let request = KChatRequests.getUsersByUsernames(body: body)

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)
        let httpBody = try #require(urlRequest.httpBody)
        let decodedBody = try JSONDecoder().decode([String].self, from: httpBody)

        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(url.path == "/api/v4/users/usernames")
        #expect(url.query?.isEmpty ?? true)
        #expect(decodedBody == usernames)
    }

    @Test("kChat get users by usernames response decodes user rows")
    func kChatGetUsersByUsernamesResponseDecodesUsers() throws {
        let json = #"[{"id":"user-one","create_at":1,"update_at":2,"delete_at":0,"username":"alice","first_name":"Alice","last_name":"Example","email":"alice@example.com","roles":"system_user"},{"id":"user-two","username":"bob","nickname":"Bob"}]"#.data(using: .utf8)!

        let users = try JSONDecoder.kChat.decode([KChatUser].self, from: json)

        #expect(users.count == 2)
        #expect(users[0].id == "user-one")
        #expect(users[0].createAt == 1)
        #expect(users[0].username == "alice")
        #expect(users[0].firstName == "Alice")
        #expect(users[0].roles == "system_user")
        #expect(users[1].id == "user-two")
        #expect(users[1].username == "bob")
        #expect(users[1].nickname == "Bob")
    }
}

private extension JSONDecoder {
    static var kChat: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
