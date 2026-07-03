import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKChat

@Suite("kChat get pinned posts requests")
struct KChatGetPinnedPostsRequestTests {
    @Test("kChat get pinned posts request matches the OpenAPI path")
    func kChatGetPinnedPostsRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.getPinnedPosts(channelId: "channel-id")

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == nil)
        #expect(url.path == "/api/v4/channels/channel-id/pinned")
        #expect(url.query?.isEmpty != false)
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat get pinned posts request percent-encodes channel id path segment")
    func kChatGetPinnedPostsRequestPercentEncodesChannelIdPathSegment() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.getPinnedPosts(channelId: "channel/id with spaces%")

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))

        #expect(components.percentEncodedPath == "/api/v4/channels/channel%2Fid%20with%20spaces%25/pinned")
        #expect(url.query?.isEmpty != false)
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat pinned post list decodes Mattermost-compatible snake-case fields")
    func kChatPinnedPostListDecodesSnakeCaseFields() throws {
        let json = #"{"order":["post-id"],"posts":{"post-id":{"id":"post-id","create_at":1,"update_at":2,"delete_at":0,"edit_at":0,"user_id":"user-id","channel_id":"channel-id","root_id":"","original_id":"","message":"Pinned hello","type":"","hashtag":"","file_ids":["file-id"],"pending_post_id":"pending-id"}},"next_post_id":"next-id","prev_post_id":"prev-id","has_next":true}"#.data(using: .utf8)!

        let postList = try JSONDecoder.kChat.decode(KChatPostList.self, from: json)
        let post = try #require(postList.posts?["post-id"])

        #expect(postList.order == ["post-id"])
        #expect(postList.nextPostId == "next-id")
        #expect(postList.prevPostId == "prev-id")
        #expect(postList.hasNext == true)
        #expect(post.id == "post-id")
        #expect(post.channelId == "channel-id")
        #expect(post.message == "Pinned hello")
    }
}

private extension JSONDecoder {
    static var kChat: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
