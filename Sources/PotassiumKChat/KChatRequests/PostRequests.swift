import Foundation
import PotassiumChannelCore

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

    /// Creates a request that gets posts around the oldest unread kChat channel post.
    public static func getPostsAroundLastUnread(
        userId: String,
        channelId: String,
        options: KChatPostsAroundLastUnreadOptions = KChatPostsAroundLastUnreadOptions()
    ) -> APIRequest<KChatPostList> {
        var queryParameters: [QueryParameter] = []

        if let limitBefore = options.limitBefore {
            queryParameters.append(QueryParameter(name: "limit_before", value: .integer(limitBefore)))
        }

        if let limitAfter = options.limitAfter {
            queryParameters.append(QueryParameter(name: "limit_after", value: .integer(limitAfter)))
        }

        if let skipFetchThreads = options.skipFetchThreads {
            queryParameters.append(QueryParameter(name: "skipFetchThreads", value: .bool(skipFetchThreads)))
        }

        if let collapsedThreads = options.collapsedThreads {
            queryParameters.append(QueryParameter(name: "collapsedThreads", value: .bool(collapsedThreads)))
        }

        if let collapsedThreadsExtended = options.collapsedThreadsExtended {
            queryParameters.append(QueryParameter(name: "collapsedThreadsExtended", value: .bool(collapsedThreadsExtended)))
        }

        return APIRequest(
            method: .get,
            path: "/api/v4/users/\(percentEncodePathSegment(userId))/channels/\(percentEncodePathSegment(channelId))/posts/unread",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that gets flagged posts for a kChat user.
    public static func getFlaggedPostsForUser(
        userId: String,
        options: KChatFlaggedPostsOptions = KChatFlaggedPostsOptions()
    ) -> APIRequest<KChatFlaggedPosts> {
        var queryParameters: [QueryParameter] = []

        if let teamId = options.teamId {
            queryParameters.append(QueryParameter(name: "team_id", value: .string(teamId)))
        }

        if let channelId = options.channelId {
            queryParameters.append(QueryParameter(name: "channel_id", value: .string(channelId)))
        }

        if let page = options.page {
            queryParameters.append(QueryParameter(name: "page", value: .integer(page)))
        }

        if let perPage = options.perPage {
            queryParameters.append(QueryParameter(name: "per_page", value: .integer(perPage)))
        }

        return APIRequest(
            method: .get,
            path: "/api/v4/users/\(percentEncodePathSegment(userId))/posts/flagged",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that gets all followed kChat threads for a user in a team.
    public static func getUserThreads(
        userId: String,
        teamId: String,
        options: KChatUserThreadsOptions = KChatUserThreadsOptions()
    ) -> APIRequest<KChatUserThreads> {
        var queryParameters: [QueryParameter] = []

        if let since = options.since {
            queryParameters.append(QueryParameter(name: "since", value: .integer(since)))
        }

        if let deleted = options.deleted {
            queryParameters.append(QueryParameter(name: "deleted", value: .bool(deleted)))
        }

        if let extended = options.extended {
            queryParameters.append(QueryParameter(name: "extended", value: .bool(extended)))
        }

        if let page = options.page {
            queryParameters.append(QueryParameter(name: "page", value: .integer(page)))
        }

        if let pageSize = options.pageSize {
            queryParameters.append(QueryParameter(name: "pageSize", value: .integer(pageSize)))
        }

        if let totalsOnly = options.totalsOnly {
            queryParameters.append(QueryParameter(name: "totalsOnly", value: .bool(totalsOnly)))
        }

        if let threadsOnly = options.threadsOnly {
            queryParameters.append(QueryParameter(name: "threadsOnly", value: .bool(threadsOnly)))
        }

        return APIRequest(
            method: .get,
            path: "/api/v4/users/\(percentEncodePathSegment(userId))/teams/\(percentEncodePathSegment(teamId))/threads",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that gets one followed kChat thread for a user in a team.
    public static func getUserThread(userId: String, teamId: String, threadId: String) -> APIRequest<KChatUserThread> {
        APIRequest(
            method: .get,
            path: "/api/v4/users/\(percentEncodePathSegment(userId))/teams/\(percentEncodePathSegment(teamId))/threads/\(percentEncodePathSegment(threadId))"
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
