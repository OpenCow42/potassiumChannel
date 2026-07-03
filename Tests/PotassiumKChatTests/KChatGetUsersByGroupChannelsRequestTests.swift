import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKChat

@Suite("kChat get users by group channels requests")
struct KChatGetUsersByGroupChannelsRequestTests {
    @Test("kChat get users by group channels request matches the OpenAPI path and JSON body")
    func kChatGetUsersByGroupChannelsRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let channelIds = ["channel-one", "channel-two"]
        let body = try JSONEncoder().encode(channelIds)
        let request = KChatRequests.getUsersByGroupChannels(body: body)

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)
        let httpBody = try #require(urlRequest.httpBody)
        let decodedBody = try JSONDecoder().decode([String].self, from: httpBody)

        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(url.path == "/api/v4/users/group_channels")
        #expect(url.query?.isEmpty ?? true)
        #expect(decodedBody == channelIds)
    }

    @Test("kChat get users by group channels response decodes users keyed by channel id")
    func kChatGetUsersByGroupChannelsResponseDecodesUsersByChannelId() throws {
        let json = #"{"channel-one":[{"id":"user-one","create_at":1,"update_at":2,"delete_at":0,"username":"alice","first_name":"Alice","last_name":"Example","email":"alice@example.com","roles":"system_user"}],"channel-two":[{"id":"user-two","username":"bob","nickname":"Bob"}]}"#.data(using: .utf8)!

        let usersByChannel = try JSONDecoder.kChat.decode([String: [KChatUser]].self, from: json)

        #expect(usersByChannel.keys.sorted() == ["channel-one", "channel-two"])
        #expect(usersByChannel["channel-one"]?.count == 1)
        #expect(usersByChannel["channel-one"]?.first?.id == "user-one")
        #expect(usersByChannel["channel-one"]?.first?.createAt == 1)
        #expect(usersByChannel["channel-one"]?.first?.username == "alice")
        #expect(usersByChannel["channel-one"]?.first?.firstName == "Alice")
        #expect(usersByChannel["channel-one"]?.first?.roles == "system_user")
        #expect(usersByChannel["channel-two"]?.first?.id == "user-two")
        #expect(usersByChannel["channel-two"]?.first?.username == "bob")
        #expect(usersByChannel["channel-two"]?.first?.nickname == "Bob")
    }
}

private extension JSONDecoder {
    static var kChat: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
