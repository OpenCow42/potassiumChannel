import Foundation
import Testing
@testable import potassiumChannel

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
        let json = #"{"channel-one":[{"id":"user-one","create_at":1,"update_at":2,"delete_at":0,"username":"adrien","first_name":"Adrien","last_name":"Example","email":"adrien@example.com","roles":"system_user"}],"channel-two":[{"id":"user-two","username":"cow","nickname":"Moo"}]}"#.data(using: .utf8)!

        let usersByChannel = try JSONDecoder.kChat.decode([String: [KChatUser]].self, from: json)

        #expect(usersByChannel.keys.sorted() == ["channel-one", "channel-two"])
        #expect(usersByChannel["channel-one"]?.count == 1)
        #expect(usersByChannel["channel-one"]?.first?.id == "user-one")
        #expect(usersByChannel["channel-one"]?.first?.createAt == 1)
        #expect(usersByChannel["channel-one"]?.first?.username == "adrien")
        #expect(usersByChannel["channel-one"]?.first?.firstName == "Adrien")
        #expect(usersByChannel["channel-one"]?.first?.roles == "system_user")
        #expect(usersByChannel["channel-two"]?.first?.id == "user-two")
        #expect(usersByChannel["channel-two"]?.first?.username == "cow")
        #expect(usersByChannel["channel-two"]?.first?.nickname == "Moo")
    }
}

private extension JSONDecoder {
    static var kChat: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
