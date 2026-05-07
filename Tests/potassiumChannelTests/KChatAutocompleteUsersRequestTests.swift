import Foundation
import Testing
@testable import potassiumChannel

@Suite("kChat autocomplete users requests")
struct KChatAutocompleteUsersRequestTests {
    @Test("kChat autocomplete users request matches the OpenAPI path and query")
    func kChatAutocompleteUsersRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.autocompleteUsers(options: KChatUserAutocompleteOptions(
            teamId: "team-id",
            channelId: "channel-id",
            name: "adr",
            limit: 5
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
        #expect(url.path == "/api/v4/users/autocomplete")
        #expect(query["team_id"] == "team-id")
        #expect(query["channel_id"] == "channel-id")
        #expect(query["name"] == "adr")
        #expect(query["limit"] == "5")
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat autocomplete users request keeps only the required name query when options are empty")
    func kChatAutocompleteUsersRequestOmitsEmptyOptions() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.autocompleteUsers(options: KChatUserAutocompleteOptions(name: "a"))

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        let queryItems = components.queryItems ?? []

        #expect(url.path == "/api/v4/users/autocomplete")
        #expect(queryItems == [URLQueryItem(name: "name", value: "a")])
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat autocomplete users response decodes users and out-of-channel users")
    func kChatAutocompleteUsersResponseDecodesSeparateUserArrays() throws {
        let json = #"{"users":[{"id":"user-one","create_at":1,"username":"alice","first_name":"Alice","roles":"system_user"}],"out_of_channel":[{"id":"user-two","username":"bob","nickname":"Bob"}]}"#.data(using: .utf8)!

        let autocomplete = try JSONDecoder.kChat.decode(KChatUserAutocomplete.self, from: json)

        #expect(autocomplete.users?.count == 1)
        #expect(autocomplete.users?.first?.id == "user-one")
        #expect(autocomplete.users?.first?.createAt == 1)
        #expect(autocomplete.users?.first?.username == "alice")
        #expect(autocomplete.users?.first?.firstName == "Alice")
        #expect(autocomplete.users?.first?.roles == "system_user")
        #expect(autocomplete.outOfChannel?.count == 1)
        #expect(autocomplete.outOfChannel?.first?.id == "user-two")
        #expect(autocomplete.outOfChannel?.first?.username == "bob")
        #expect(autocomplete.outOfChannel?.first?.nickname == "Bob")
    }
}

private extension JSONDecoder {
    static var kChat: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
