import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKChat

@Suite("kChat user search requests")
struct KChatUserSearchRequestTests {
    @Test("kChat user search request matches the OpenAPI path and JSON body")
    func kChatUserSearchRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let body = Data(#"{"term":"alice","limit":5,"allow_inactive":true,"without_team":false}"#.utf8)
        let request = KChatRequests.searchUsers(body: body)

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(url.path == "/api/v4/users/search")
        #expect(urlRequest.httpBody == body)
    }

    @Test("kChat user search options encode snake-case request fields")
    func kChatUserSearchOptionsEncodeSnakeCaseFields() throws {
        let options = KChatUserSearchOptions(
            term: "alice",
            teamId: "team-id",
            notInTeamId: "not-team-id",
            inChannelId: "channel-id",
            notInChannelId: "not-channel-id",
            inGroupId: "group-id",
            groupConstrained: true,
            allowInactive: false,
            withoutTeam: true,
            limit: 3
        )

        let object = try JSONSerialization.jsonObject(with: JSONEncoder().encode(options)) as? [String: Any]

        #expect(object?["term"] as? String == "alice")
        #expect(object?["team_id"] as? String == "team-id")
        #expect(object?["not_in_team_id"] as? String == "not-team-id")
        #expect(object?["in_channel_id"] as? String == "channel-id")
        #expect(object?["not_in_channel_id"] as? String == "not-channel-id")
        #expect(object?["in_group_id"] as? String == "group-id")
        #expect(object?["group_constrained"] as? Bool == true)
        #expect(object?["allow_inactive"] as? Bool == false)
        #expect(object?["without_team"] as? Bool == true)
        #expect(object?["limit"] as? Int == 3)
    }

    @Test("kChat user decodes Mattermost-compatible snake-case fields")
    func kChatUserDecodesSnakeCaseFields() throws {
        let json = #"{"id":"user-id","create_at":1,"update_at":2,"delete_at":0,"username":"alice","first_name":"Alice","last_name":"Example","nickname":"A","email":"alice@example.com","email_verified":true,"auth_service":"","roles":"system_user","locale":"fr","last_password_update":3,"last_picture_update":4,"failed_attempts":0,"mfa_active":false,"terms_of_service_id":"tos","terms_of_service_create_at":5}"#.data(using: .utf8)!

        let user = try JSONDecoder.kChat.decode(KChatUser.self, from: json)

        #expect(user.id == "user-id")
        #expect(user.createAt == 1)
        #expect(user.username == "alice")
        #expect(user.firstName == "Alice")
        #expect(user.emailVerified == true)
        #expect(user.termsOfServiceCreateAt == 5)
    }
}

private extension JSONDecoder {
    static var kChat: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
