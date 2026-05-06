import Foundation
import Testing
@testable import potassiumChannel

@Suite("kChat get user statuses by ids requests")
struct KChatGetUserStatusesByIdsRequestTests {
    @Test("kChat get user statuses by ids request matches the OpenAPI path and JSON body")
    func kChatGetUserStatusesByIdsRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let userIds = ["user-one", "user-two"]
        let body = try JSONEncoder().encode(userIds)
        let request = KChatRequests.getUserStatusesByIds(body: body)

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)
        let httpBody = try #require(urlRequest.httpBody)
        let decodedBody = try JSONDecoder().decode([String].self, from: httpBody)

        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(url.path == "/api/v4/users/status/ids")
        #expect(decodedBody == userIds)
    }

    @Test("kChat get user statuses by ids response decodes status rows")
    func kChatGetUserStatusesByIdsResponseDecodesStatuses() throws {
        let json = #"[{"user_id":"user-one","status":"online","manual":false,"last_activity_at":123456789},{"user_id":"user-two","status":"away","manual":1,"dnd_end_time":123456999}]"#.data(using: .utf8)!

        let statuses = try JSONDecoder.kChat.decode([KChatUserStatus].self, from: json)

        #expect(statuses.count == 2)
        #expect(statuses[0].userId == "user-one")
        #expect(statuses[0].status == "online")
        #expect(statuses[0].manual == false)
        #expect(statuses[0].lastActivityAt == 123456789)
        #expect(statuses[1].userId == "user-two")
        #expect(statuses[1].status == "away")
        #expect(statuses[1].manual == true)
        #expect(statuses[1].dndEndTime == 123456999)
    }
}

private extension JSONDecoder {
    static var kChat: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
