import Foundation
import Testing
@testable import potassiumChannel

@Suite("kChat get channel posts requests")
struct KChatGetChannelPostsRequestTests {
    @Test("kChat get channel posts request matches the OpenAPI path and query")
    func kChatGetChannelPostsRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.getChannelPosts(
            channelId: "channel-id",
            options: KChatChannelPostsOptions(
                page: 2,
                perPage: 30,
                since: 1_777_809_259,
                before: "before-post-id",
                after: "after-post-id",
                includeDeleted: true
            )
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == nil)
        #expect(url.path == "/api/v4/channels/channel-id/posts")
        #expect(components.queryItems?.contains(URLQueryItem(name: "page", value: "2")) == true)
        #expect(components.queryItems?.contains(URLQueryItem(name: "per_page", value: "30")) == true)
        #expect(components.queryItems?.contains(URLQueryItem(name: "since", value: "1777809259")) == true)
        #expect(components.queryItems?.contains(URLQueryItem(name: "before", value: "before-post-id")) == true)
        #expect(components.queryItems?.contains(URLQueryItem(name: "after", value: "after-post-id")) == true)
        #expect(components.queryItems?.contains(URLQueryItem(name: "include_deleted", value: "true")) == true)
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat get channel posts request can omit optional query parameters")
    func kChatGetChannelPostsRequestCanOmitQueryParameters() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.getChannelPosts(channelId: "channel-id")

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(url.path == "/api/v4/channels/channel-id/posts")
        #expect(url.query?.isEmpty != false)
    }

    @Test("kChat post list decodes Mattermost-compatible snake-case fields")
    func kChatPostListDecodesSnakeCaseFields() throws {
        let json = #"{"order":["post-id"],"posts":{"post-id":{"id":"post-id","create_at":1,"update_at":2,"delete_at":0,"edit_at":0,"user_id":"user-id","channel_id":"channel-id","root_id":"","original_id":"","message":"Hello","type":"","hashtag":"","file_ids":["file-id"],"pending_post_id":"pending-id"}},"next_post_id":"next-id","prev_post_id":"prev-id","has_next":true}"#.data(using: .utf8)!

        let postList = try JSONDecoder.kChat.decode(KChatPostList.self, from: json)
        let post = try #require(postList.posts?["post-id"])

        #expect(postList.order == ["post-id"])
        #expect(postList.nextPostId == "next-id")
        #expect(postList.prevPostId == "prev-id")
        #expect(postList.hasNext == true)
        #expect(post.id == "post-id")
        #expect(post.channelId == "channel-id")
        #expect(post.message == "Hello")
    }
}

private extension JSONDecoder {
    static var kChat: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
