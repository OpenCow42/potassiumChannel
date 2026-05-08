import Foundation

extension KChatRequests {
    /// Creates a request that lists posts for a kChat channel.
    public static func getChannelPosts(
        channelId: String,
        options: KChatChannelPostsOptions = KChatChannelPostsOptions()
    ) -> APIRequest<KChatPostList> {
        var queryParameters: [QueryParameter] = []

        if let page = options.page {
            queryParameters.append(QueryParameter(name: "page", value: .integer(page)))
        }

        if let perPage = options.perPage {
            queryParameters.append(QueryParameter(name: "per_page", value: .integer(perPage)))
        }

        if let since = options.since {
            queryParameters.append(QueryParameter(name: "since", value: .integer(since)))
        }

        if let before = options.before {
            queryParameters.append(QueryParameter(name: "before", value: .string(before)))
        }

        if let after = options.after {
            queryParameters.append(QueryParameter(name: "after", value: .string(after)))
        }

        if let includeDeleted = options.includeDeleted {
            queryParameters.append(QueryParameter(name: "include_deleted", value: .bool(includeDeleted)))
        }

        return APIRequest(
            method: .get,
            path: "/api/v4/channels/\(channelId)/posts",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that gets pinned posts for a kChat channel.
    public static func getPinnedPosts(channelId: String) -> APIRequest<KChatPostList> {
        APIRequest(
            method: .get,
            path: "/api/v4/channels/\(percentEncodePathSegment(channelId))/pinned"
        )
    }

    /// Creates a request that posts a message to kChat.
    public static func createPost(body: Data) -> APIRequest<KChatPost> {
        APIRequest(
            method: .post,
            path: "/api/v4/posts",
            body: body
        )
    }

    /// Creates a request that gets a single kChat post.
    public static func getPost(postId: String) -> APIRequest<KChatPost> {
        APIRequest(
            method: .get,
            path: "/api/v4/posts/\(postId)"
        )
    }

    /// Creates a request that gets a kChat post thread.
    public static func getPostThread(postId: String) -> APIRequest<KChatPostList> {
        APIRequest(
            method: .get,
            path: "/api/v4/posts/\(postId)/thread"
        )
    }

    /// Creates a request that gets file information for files attached to a kChat post.
    public static func getPostFilesInfo(
        postId: String,
        options: KChatPostFilesInfoOptions = KChatPostFilesInfoOptions()
    ) -> APIRequest<[KChatFileInfo]> {
        var queryParameters: [QueryParameter] = []

        if let includeDeleted = options.includeDeleted {
            queryParameters.append(QueryParameter(name: "include_deleted", value: .bool(includeDeleted)))
        }

        return APIRequest(
            method: .get,
            path: "/api/v4/posts/\(postId)/files/info",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that deletes a kChat post.
    public static func deletePost(postId: String) -> APIRequest<KChatStatusOK> {
        APIRequest(
            method: .delete,
            path: "/api/v4/posts/\(postId)"
        )
    }
}
