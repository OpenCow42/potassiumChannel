import Foundation
import Testing
@testable import potassiumChannel

@Suite("kChat missing read route requests")
struct KChatMissingReadRoutesRequestTests {
    @Test("kChat channel moderations request matches the OpenAPI path")
    func kChatChannelModerationsRequestMatchesOpenAPIShape() async throws {
        let urlRequest = try await makeURLRequest(for: KChatRequests.getChannelModerations(channelId: "channel-id"))
        let url = try #require(urlRequest.url)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == nil)
        #expect(url.path == "/api/v4/channels/channel-id/moderations")
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat file preview and thumbnail requests match the OpenAPI paths")
    func kChatFilePreviewAndThumbnailRequestsMatchOpenAPIShape() async throws {
        let preview = try await makeURLRequest(for: KChatRequests.getFilePreview(fileId: "file/id"))
        let thumbnail = try await makeURLRequest(for: KChatRequests.getFileThumbnail(fileId: "file/id"))

        #expect(preview.httpMethod == "GET")
        #expect(preview.url?.path == "/api/v4/files/file/id/preview")
        #expect(preview.url?.absoluteString.contains("/api/v4/files/file%2Fid/preview") == true)
        #expect(preview.httpBody == nil)
        #expect(thumbnail.httpMethod == "GET")
        #expect(thumbnail.url?.path == "/api/v4/files/file/id/thumbnail")
        #expect(thumbnail.url?.absoluteString.contains("/api/v4/files/file%2Fid/thumbnail") == true)
        #expect(thumbnail.httpBody == nil)
    }

    @Test("kChat user channels request matches the OpenAPI path and query")
    func kChatUserChannelsRequestMatchesOpenAPIShape() async throws {
        let request = KChatRequests.getUserChannels(
            userId: "user-id",
            options: KChatUserChannelsOptions(includeDeleted: true, lastDeleteAt: 123)
        )
        let urlRequest = try await makeURLRequest(for: request)
        let url = try #require(urlRequest.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))

        #expect(urlRequest.httpMethod == "GET")
        #expect(url.path == "/api/v4/users/user-id/channels")
        #expect(components.queryItems?.contains(URLQueryItem(name: "last_delete_at", value: "123")) == true)
        #expect(components.queryItems?.contains(URLQueryItem(name: "include_deleted", value: "true")) == true)
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat channel unread request matches the OpenAPI path")
    func kChatChannelUnreadRequestMatchesOpenAPIShape() async throws {
        let urlRequest = try await makeURLRequest(for: KChatRequests.getChannelUnread(userId: "me", channelId: "channel-id"))
        let url = try #require(urlRequest.url)

        #expect(urlRequest.httpMethod == "GET")
        #expect(url.path == "/api/v4/users/me/channels/channel-id/unread")
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat posts around last unread request matches the OpenAPI path and query")
    func kChatPostsAroundLastUnreadRequestMatchesOpenAPIShape() async throws {
        let request = KChatRequests.getPostsAroundLastUnread(
            userId: "user-id",
            channelId: "channel-id",
            options: KChatPostsAroundLastUnreadOptions(
                limitBefore: 12,
                limitAfter: 5,
                skipFetchThreads: true,
                collapsedThreads: true,
                collapsedThreadsExtended: true
            )
        )
        let urlRequest = try await makeURLRequest(for: request)
        let url = try #require(urlRequest.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))

        #expect(urlRequest.httpMethod == "GET")
        #expect(url.path == "/api/v4/users/user-id/channels/channel-id/posts/unread")
        #expect(components.queryItems?.contains(URLQueryItem(name: "limit_before", value: "12")) == true)
        #expect(components.queryItems?.contains(URLQueryItem(name: "limit_after", value: "5")) == true)
        #expect(components.queryItems?.contains(URLQueryItem(name: "skipFetchThreads", value: "true")) == true)
        #expect(components.queryItems?.contains(URLQueryItem(name: "collapsedThreads", value: "true")) == true)
        #expect(components.queryItems?.contains(URLQueryItem(name: "collapsedThreadsExtended", value: "true")) == true)
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat flagged posts request matches the OpenAPI path and query")
    func kChatFlaggedPostsRequestMatchesOpenAPIShape() async throws {
        let request = KChatRequests.getFlaggedPostsForUser(
            userId: "user-id",
            options: KChatFlaggedPostsOptions(teamId: "team-id", channelId: "channel-id", page: 2, perPage: 30)
        )
        let urlRequest = try await makeURLRequest(for: request)
        let url = try #require(urlRequest.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))

        #expect(urlRequest.httpMethod == "GET")
        #expect(url.path == "/api/v4/users/user-id/posts/flagged")
        #expect(components.queryItems?.contains(URLQueryItem(name: "team_id", value: "team-id")) == true)
        #expect(components.queryItems?.contains(URLQueryItem(name: "channel_id", value: "channel-id")) == true)
        #expect(components.queryItems?.contains(URLQueryItem(name: "page", value: "2")) == true)
        #expect(components.queryItems?.contains(URLQueryItem(name: "per_page", value: "30")) == true)
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat preference requests match the OpenAPI paths")
    func kChatPreferenceRequestsMatchOpenAPIShapes() async throws {
        let all = try await makeURLRequest(for: KChatRequests.getPreferences(userId: "user-id"))
        let category = try await makeURLRequest(for: KChatRequests.getPreferencesByCategory(userId: "user-id", category: "display settings"))
        let preference = try await makeURLRequest(for: KChatRequests.getPreference(
            userId: "user-id",
            category: "display settings",
            preferenceName: "name/value"
        ))

        #expect(all.httpMethod == "GET")
        #expect(all.url?.path == "/api/v4/users/user-id/preferences")
        #expect(category.url?.path == "/api/v4/users/user-id/preferences/display settings")
        #expect(category.url?.absoluteString.contains("/preferences/display%20settings") == true)
        #expect(preference.url?.path == "/api/v4/users/user-id/preferences/display settings/name/name/value")
        #expect(preference.url?.absoluteString.contains("/preferences/display%20settings/name/name%2Fvalue") == true)
    }

    @Test("kChat sidebar category requests match the OpenAPI paths")
    func kChatSidebarCategoryRequestsMatchOpenAPIShapes() async throws {
        let categories = try await makeURLRequest(for: KChatRequests.getSidebarCategoriesForTeamForUser(userId: "me", teamId: "team-id"))
        let order = try await makeURLRequest(for: KChatRequests.getSidebarCategoryOrderForTeamForUser(userId: "me", teamId: "team-id"))
        let category = try await makeURLRequest(for: KChatRequests.getSidebarCategoryForTeamForUser(
            userId: "me",
            teamId: "team-id",
            categoryId: "category/id"
        ))

        #expect(categories.httpMethod == "GET")
        #expect(categories.url?.path == "/api/v4/users/me/teams/team-id/channels/categories")
        #expect(order.url?.path == "/api/v4/users/me/teams/team-id/channels/categories/order")
        #expect(category.url?.path == "/api/v4/users/me/teams/team-id/channels/categories/category/id")
        #expect(category.url?.absoluteString.contains("/channels/categories/category%2Fid") == true)
    }

    @Test("kChat user threads request matches the OpenAPI path and query")
    func kChatUserThreadsRequestMatchesOpenAPIShape() async throws {
        let request = KChatRequests.getUserThreads(
            userId: "me",
            teamId: "team-id",
            options: KChatUserThreadsOptions(
                since: 1_777_809_259,
                deleted: true,
                extended: true,
                page: 2,
                pageSize: 15,
                totalsOnly: true,
                threadsOnly: true
            )
        )
        let urlRequest = try await makeURLRequest(for: request)
        let url = try #require(urlRequest.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))

        #expect(urlRequest.httpMethod == "GET")
        #expect(url.path == "/api/v4/users/me/teams/team-id/threads")
        #expect(components.queryItems?.contains(URLQueryItem(name: "since", value: "1777809259")) == true)
        #expect(components.queryItems?.contains(URLQueryItem(name: "deleted", value: "true")) == true)
        #expect(components.queryItems?.contains(URLQueryItem(name: "extended", value: "true")) == true)
        #expect(components.queryItems?.contains(URLQueryItem(name: "page", value: "2")) == true)
        #expect(components.queryItems?.contains(URLQueryItem(name: "pageSize", value: "15")) == true)
        #expect(components.queryItems?.contains(URLQueryItem(name: "totalsOnly", value: "true")) == true)
        #expect(components.queryItems?.contains(URLQueryItem(name: "threadsOnly", value: "true")) == true)
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat user thread request matches the OpenAPI path")
    func kChatUserThreadRequestMatchesOpenAPIShape() async throws {
        let urlRequest = try await makeURLRequest(for: KChatRequests.getUserThread(userId: "me", teamId: "team-id", threadId: "thread/id"))
        let url = try #require(urlRequest.url)

        #expect(urlRequest.httpMethod == "GET")
        #expect(url.path == "/api/v4/users/me/teams/team-id/threads/thread/id")
        #expect(url.absoluteString.contains("/threads/thread%2Fid") == true)
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat new read DTOs decode Mattermost-compatible snake-case fields")
    func kChatNewReadDTOsDecodeSnakeCaseFields() throws {
        let unreadJSON = #"{"team_id":"team-id","channel_id":"channel-id","msg_count":7,"mention_count":2}"#.data(using: .utf8)!
        let unread = try JSONDecoder.kChat.decode(KChatChannelUnread.self, from: unreadJSON)

        #expect(unread.teamId == "team-id")
        #expect(unread.channelId == "channel-id")
        #expect(unread.msgCount == 7)
        #expect(unread.mentionCount == 2)

        let moderationJSON = #"[{"name":"town_square","roles":{"guests":{"value":true,"enabled":false},"members":{"value":false,"enabled":true}}}]"#.data(using: .utf8)!
        let moderations = try JSONDecoder.kChat.decode([KChatChannelModeration].self, from: moderationJSON)

        #expect(moderations.first?.name == "town_square")
        #expect(moderations.first?.roles?.guests?.value == true)
        #expect(moderations.first?.roles?.members?.enabled == true)

        let preferenceJSON = #"{"user_id":"user-id","category":"display_settings","name":"theme","value":"dark"}"#.data(using: .utf8)!
        let preference = try JSONDecoder.kChat.decode(KChatPreference.self, from: preferenceJSON)

        #expect(preference.userId == "user-id")
        #expect(preference.category == "display_settings")
        #expect(preference.name == "theme")
        #expect(preference.value == "dark")
    }

    @Test("kChat sidebar and thread DTOs decode Mattermost-compatible snake-case fields")
    func kChatSidebarAndThreadDTOsDecodeSnakeCaseFields() throws {
        let sidebarJSON = #"{"order":["category-id"],"categories":[{"id":"category-id","user_id":"user-id","team_id":"team-id","display_name":"Favorites","type":"favorites","channel_ids":["channel-id"]}]}"#.data(using: .utf8)!
        let sidebar = try JSONDecoder.kChat.decode(KChatOrderedSidebarCategories.self, from: sidebarJSON)
        let sidebarObjectResponse = try JSONDecoder.kChat.decode(KChatSidebarCategories.self, from: sidebarJSON)
        let sidebarArrayResponse = try JSONDecoder.kChat.decode(KChatSidebarCategories.self, from: "[\(String(data: sidebarJSON, encoding: .utf8)!)]".data(using: .utf8)!)

        #expect(sidebar.order == ["category-id"])
        #expect(sidebar.categories?.first?.id == "category-id")
        #expect(sidebar.categories?.first?.channelIds == ["channel-id"])
        #expect(sidebarObjectResponse.items.count == 1)
        #expect(sidebarArrayResponse.items.count == 1)

        let threadJSON = #"{"total":1,"threads":[{"id":"thread-id","reply_count":3,"last_reply_at":4,"last_viewed_at":5,"participants":["user-id",42,{"user_id":43}],"post":{"id":"thread-id","message":"Hello"}}]}"#.data(using: .utf8)!
        let threads = try JSONDecoder.kChat.decode(KChatUserThreads.self, from: threadJSON)

        #expect(threads.total == 1)
        #expect(threads.threads?.first?.id == "thread-id")
        #expect(threads.threads?.first?.replyCount == 3)
        #expect(threads.threads?.first?.participants?.first?.userId == "user-id")
        #expect(threads.threads?.first?.participants?[1].userId == "42")
        #expect(threads.threads?.first?.participants?[2].userId == "43")
        #expect(threads.threads?.first?.post?.message == "Hello")
    }

    @Test("kChat flagged posts decode array and object response shapes")
    func kChatFlaggedPostsDecodeFlexibleShapes() throws {
        let arrayJSON = #"[{"order":["post-id"],"posts":{"post-id":{"id":"post-id","message":"Hello"}}}]"#.data(using: .utf8)!
        let objectJSON = #"{"order":["post-id"],"posts":{"post-id":{"id":"post-id","message":"Hello"}}}"#.data(using: .utf8)!
        let postsArrayJSON = #"{"posts":[{"id":"post-id","message":"Hello"}]}"#.data(using: .utf8)!

        let arrayResponse = try JSONDecoder.kChat.decode(KChatFlaggedPosts.self, from: arrayJSON)
        let objectResponse = try JSONDecoder.kChat.decode(KChatFlaggedPosts.self, from: objectJSON)
        let postsArrayResponse = try JSONDecoder.kChat.decode(KChatFlaggedPosts.self, from: postsArrayJSON)

        #expect(arrayResponse.postLists.count == 1)
        #expect(objectResponse.postLists.count == 1)
        #expect(objectResponse.postLists.first?.posts?["post-id"]?.message == "Hello")
        #expect(postsArrayResponse.postLists.first?.order == ["post-id"])
        #expect(postsArrayResponse.postLists.first?.posts?["post-id"]?.message == "Hello")
    }

    private func makeURLRequest<Response>(for request: APIRequest<Response>) async throws -> URLRequest {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        return try await client.makeURLRequest(for: request)
    }
}

private extension JSONDecoder {
    static var kChat: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
