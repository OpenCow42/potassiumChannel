import Foundation
import Testing
@testable import potassiumChannel

@Suite("kChat create post requests")
struct KChatCreatePostRequestTests {
    @Test("kChat create post request matches the OpenAPI path and JSON body")
    func kChatCreatePostRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let body = try JSONEncoder().encode(KChatPostCreateRequest(
            channelId: "channel-id",
            message: "Hello from test",
            rootId: "root-id",
            fileIds: ["file-id"]
        ))
        let request = KChatRequests.createPost(body: body)

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)
        let httpBody = try #require(urlRequest.httpBody)
        let json = try #require(JSONSerialization.jsonObject(with: httpBody) as? [String: Any])

        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(url.path == "/api/v4/posts")
        #expect(json["channel_id"] as? String == "channel-id")
        #expect(json["message"] as? String == "Hello from test")
        #expect(json["root_id"] as? String == "root-id")
        #expect(json["file_ids"] as? [String] == ["file-id"])
    }

    @Test("kChat delete post request is available for cleanup")
    func kChatDeletePostRequestIsAvailableForCleanup() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.deletePost(postId: "post-id")

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(urlRequest.httpMethod == "DELETE")
        #expect(url.path == "/api/v4/posts/post-id")
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat post decodes Mattermost-compatible snake-case fields")
    func kChatPostDecodesSnakeCaseFields() throws {
        let json = #"{"id":"post-id","create_at":1,"update_at":2,"delete_at":0,"edit_at":0,"user_id":"user-id","channel_id":"channel-id","root_id":"root-id","original_id":"original-id","message":"Hello","type":"","hashtag":"","file_ids":["file-id"],"pending_post_id":"pending-id"}"#.data(using: .utf8)!

        let post = try JSONDecoder.kChat.decode(KChatPost.self, from: json)

        #expect(post.id == "post-id")
        #expect(post.createAt == 1)
        #expect(post.userId == "user-id")
        #expect(post.channelId == "channel-id")
        #expect(post.rootId == "root-id")
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
