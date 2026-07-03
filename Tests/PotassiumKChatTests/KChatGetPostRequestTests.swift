import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKChat

@Suite("kChat get post requests")
struct KChatGetPostRequestTests {
    @Test("kChat get post request matches the OpenAPI path and headers")
    func kChatGetPostRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.getPost(postId: "post-id")

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == nil)
        #expect(url.path == "/api/v4/posts/post-id")
        #expect(url.query?.isEmpty ?? true)
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat get post decodes Mattermost-compatible snake-case fields")
    func kChatGetPostDecodesSnakeCaseFields() throws {
        let json = #"{"id":"post-id","create_at":1,"update_at":2,"delete_at":0,"edit_at":0,"user_id":"user-id","channel_id":"channel-id","root_id":"root-id","original_id":"original-id","message":"Hello","type":"","hashtag":"","file_ids":["file-id"],"pending_post_id":"pending-id"}"#.data(using: .utf8)!

        let post = try JSONDecoder.kChat.decode(KChatPost.self, from: json)

        #expect(post.id == "post-id")
        #expect(post.createAt == 1)
        #expect(post.updateAt == 2)
        #expect(post.userId == "user-id")
        #expect(post.channelId == "channel-id")
        #expect(post.rootId == "root-id")
        #expect(post.originalId == "original-id")
        #expect(post.message == "Hello")
        #expect(post.fileIds == ["file-id"])
        #expect(post.pendingPostId == "pending-id")
    }
}

private extension JSONDecoder {
    static var kChat: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
