import Foundation
import Testing
@testable import potassiumChannel

@Suite("kChat get post thread requests")
struct KChatGetPostThreadRequestTests {
    @Test("kChat get post thread request matches the OpenAPI path and headers")
    func kChatGetPostThreadRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.getPostThread(postId: "post-id")

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == nil)
        #expect(url.path == "/api/v4/posts/post-id/thread")
        #expect(url.query?.isEmpty ?? true)
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat get post thread decodes Mattermost-compatible snake-case post list fields")
    func kChatGetPostThreadDecodesSnakeCaseFields() throws {
        let json = #"{"order":["root-id","reply-id"],"posts":{"root-id":{"id":"root-id","create_at":1,"update_at":2,"delete_at":0,"edit_at":0,"user_id":"user-id","channel_id":"channel-id","root_id":"","original_id":"","message":"Root","type":"","hashtag":"","file_ids":[],"pending_post_id":"pending-root"},"reply-id":{"id":"reply-id","create_at":3,"update_at":4,"delete_at":0,"edit_at":0,"user_id":"user-id","channel_id":"channel-id","root_id":"root-id","original_id":"","message":"Reply","type":"","hashtag":"","file_ids":["file-id"],"pending_post_id":"pending-reply"}},"next_post_id":"next-id","prev_post_id":"prev-id","has_next":false}"#.data(using: .utf8)!

        let postList = try JSONDecoder.kChat.decode(KChatPostList.self, from: json)
        let rootPost = try #require(postList.posts?["root-id"])
        let replyPost = try #require(postList.posts?["reply-id"])

        #expect(postList.order == ["root-id", "reply-id"])
        #expect(postList.nextPostId == "next-id")
        #expect(postList.prevPostId == "prev-id")
        #expect(postList.hasNext == false)
        #expect(rootPost.id == "root-id")
        #expect(rootPost.createAt == 1)
        #expect(rootPost.message == "Root")
        #expect(replyPost.id == "reply-id")
        #expect(replyPost.rootId == "root-id")
        #expect(replyPost.fileIds == ["file-id"])
        #expect(replyPost.pendingPostId == "pending-reply")
    }
}

private extension JSONDecoder {
    static var kChat: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
