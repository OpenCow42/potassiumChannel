import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKChat

@Suite("kChat get user by username requests")
struct KChatGetUserByUsernameRequestTests {
    @Test("kChat get user by username request matches the OpenAPI path")
    func kChatGetUserByUsernameRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.getUserByUsername(username: "alice")

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == nil)
        #expect(url.path == "/api/v4/users/username/alice")
        #expect(url.query?.isEmpty ?? true)
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat get user by username request percent-encodes the path username")
    func kChatGetUserByUsernameRequestEncodesUsernamePathSegment() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.getUserByUsername(username: "alice bob/slash")

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))

        #expect(components.percentEncodedPath == "/api/v4/users/username/alice%20bob%2Fslash")
        #expect(url.query?.isEmpty ?? true)
    }

    @Test("kChat get user by username response decodes a user row")
    func kChatGetUserByUsernameResponseDecodesUser() throws {
        let json = #"{"id":"user-id","create_at":1,"update_at":2,"delete_at":0,"username":"alice","first_name":"Alice","last_name":"Example","email":"alice@example.com","roles":"system_user"}"#.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let user = try decoder.decode(KChatUser.self, from: json)

        #expect(user.id == "user-id")
        #expect(user.username == "alice")
        #expect(user.firstName == "Alice")
        #expect(user.email == "alice@example.com")
    }
}
