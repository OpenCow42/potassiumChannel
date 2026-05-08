import Foundation

/// Query parameters accepted by the kChat channel posts endpoint.
public struct KChatChannelPostsOptions: Equatable, Sendable {
    /// The page to select.
    public let page: Int?

    /// The number of posts per page.
    public let perPage: Int?

    /// Selects posts modified after this Unix timestamp in milliseconds.
    public let since: Int?

    /// Selects posts before this post id.
    public let before: String?

    /// Selects posts after this post id.
    public let after: String?

    /// Whether deleted posts should be included.
    public let includeDeleted: Bool?

    /// Creates kChat channel posts listing options.
    public init(
        page: Int? = nil,
        perPage: Int? = nil,
        since: Int? = nil,
        before: String? = nil,
        after: String? = nil,
        includeDeleted: Bool? = nil
    ) {
        self.page = page
        self.perPage = perPage
        self.since = since
        self.before = before
        self.after = after
        self.includeDeleted = includeDeleted
    }
}

/// Query parameters accepted by the kChat post file info endpoint.
public struct KChatPostFilesInfoOptions: Equatable, Sendable {
    /// Whether deleted files should be included. Requires system management permission.
    public let includeDeleted: Bool?

    /// Creates kChat post file info options.
    public init(includeDeleted: Bool? = nil) {
        self.includeDeleted = includeDeleted
    }
}

/// A Mattermost-compatible kChat channel post list.
public struct KChatPostList: Codable, Equatable, Sendable {
    public let order: [String]?
    public let posts: [String: KChatPost]?
    public let nextPostId: String?
    public let prevPostId: String?
    public let hasNext: Bool?

    public init(
        order: [String]? = nil,
        posts: [String: KChatPost]? = nil,
        nextPostId: String? = nil,
        prevPostId: String? = nil,
        hasNext: Bool? = nil
    ) {
        self.order = order
        self.posts = posts
        self.nextPostId = nextPostId
        self.prevPostId = prevPostId
        self.hasNext = hasNext
    }
}

/// Request body for creating a Mattermost-compatible kChat post.
public struct KChatPostCreateRequest: Encodable, Equatable, Sendable {
    /// The channel ID to post in.
    public let channelId: String

    /// The post message contents. Markdown is accepted by the API.
    public let message: String

    /// Optional root post ID when creating a reply.
    public let rootId: String?

    /// Optional file IDs to attach to the post.
    public let fileIds: [String]?

    public enum CodingKeys: String, CodingKey {
        case channelId = "channel_id"
        case message
        case rootId = "root_id"
        case fileIds = "file_ids"
    }

    /// Creates a kChat post creation request body.
    public init(channelId: String, message: String, rootId: String? = nil, fileIds: [String]? = nil) {
        self.channelId = channelId
        self.message = message
        self.rootId = rootId
        self.fileIds = fileIds
    }
}

/// A Mattermost-compatible kChat post.
public struct KChatPost: Codable, Equatable, Sendable {
    public let id: String?
    public let createAt: Int64?
    public let updateAt: Int64?
    public let deleteAt: Int64?
    public let editAt: Int64?
    public let userId: String?
    public let channelId: String?
    public let rootId: String?
    public let originalId: String?
    public let message: String?
    public let type: String?
    public let hashtag: String?
    public let fileIds: [String]?
    public let pendingPostId: String?

    public init(
        id: String? = nil,
        createAt: Int64? = nil,
        updateAt: Int64? = nil,
        deleteAt: Int64? = nil,
        editAt: Int64? = nil,
        userId: String? = nil,
        channelId: String? = nil,
        rootId: String? = nil,
        originalId: String? = nil,
        message: String? = nil,
        type: String? = nil,
        hashtag: String? = nil,
        fileIds: [String]? = nil,
        pendingPostId: String? = nil
    ) {
        self.id = id
        self.createAt = createAt
        self.updateAt = updateAt
        self.deleteAt = deleteAt
        self.editAt = editAt
        self.userId = userId
        self.channelId = channelId
        self.rootId = rootId
        self.originalId = originalId
        self.message = message
        self.type = type
        self.hashtag = hashtag
        self.fileIds = fileIds
        self.pendingPostId = pendingPostId
    }
}
