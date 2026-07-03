import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKChat

@Suite("kChat create channel requests")
struct KChatCreateChannelRequestTests {
    @Test("kChat create channel request matches the OpenAPI path and JSON body")
    func kChatCreateChannelRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let body = try JSONEncoder().encode(KChatChannelCreateRequest(
            teamId: "team-id",
            name: "project-alpha",
            displayName: "Project Alpha",
            type: "O",
            purpose: "Project discussion",
            header: "Welcome to **Project Alpha**"
        ))
        let request = KChatRequests.createChannel(body: body)

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)
        let httpBody = try #require(urlRequest.httpBody)
        let json = try #require(JSONSerialization.jsonObject(with: httpBody) as? [String: Any])

        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(url.path == "/api/v4/channels")
        #expect(json["team_id"] as? String == "team-id")
        #expect(json["name"] as? String == "project-alpha")
        #expect(json["display_name"] as? String == "Project Alpha")
        #expect(json["type"] as? String == "O")
        #expect(json["purpose"] as? String == "Project discussion")
        #expect(json["header"] as? String == "Welcome to **Project Alpha**")
        #expect(json["teamId"] == nil)
        #expect(json["displayName"] == nil)
    }

    @Test("kChat create channel response decodes a channel")
    func kChatCreateChannelResponseDecodesChannel() throws {
        let json = #"{"id":"channel-id","create_at":1,"update_at":2,"delete_at":0,"team_id":"team-id","type":"O","display_name":"Project Alpha","name":"project-alpha","header":"Welcome","purpose":"Project discussion","last_post_at":3,"total_msg_count":4,"creator_id":"creator-id"}"#.data(using: .utf8)!

        let channel = try JSONDecoder.kChat.decode(KChatChannel.self, from: json)

        #expect(channel.id == "channel-id")
        #expect(channel.createAt == 1)
        #expect(channel.teamId == "team-id")
        #expect(channel.type == "O")
        #expect(channel.displayName == "Project Alpha")
        #expect(channel.name == "project-alpha")
        #expect(channel.header == "Welcome")
        #expect(channel.purpose == "Project discussion")
        #expect(channel.creatorId == "creator-id")
    }
}

private extension JSONDecoder {
    static var kChat: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
