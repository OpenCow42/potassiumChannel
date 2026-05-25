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

/// Query parameters accepted by the kChat unread channel posts endpoint.
public struct KChatPostsAroundLastUnreadOptions: Equatable, Sendable {
    /// Number of posts to return before the oldest unread post.
    public let limitBefore: Int?

    /// Number of posts to return after the oldest unread post.
    public let limitAfter: Int?

    /// Whether the server should skip fetching thread data.
    public let skipFetchThreads: Bool?

    /// Whether collapsed thread data should be requested.
    public let collapsedThreads: Bool?

    /// Whether extended collapsed thread data should be requested.
    public let collapsedThreadsExtended: Bool?

    /// Creates kChat unread channel post query options.
    public init(
        limitBefore: Int? = nil,
        limitAfter: Int? = nil,
        skipFetchThreads: Bool? = nil,
        collapsedThreads: Bool? = nil,
        collapsedThreadsExtended: Bool? = nil
    ) {
        self.limitBefore = limitBefore
        self.limitAfter = limitAfter
        self.skipFetchThreads = skipFetchThreads
        self.collapsedThreads = collapsedThreads
        self.collapsedThreadsExtended = collapsedThreadsExtended
    }
}

/// Query parameters accepted by the kChat flagged posts endpoint.
public struct KChatFlaggedPostsOptions: Equatable, Sendable {
    /// Restricts flagged posts to a team.
    public let teamId: String?

    /// Restricts flagged posts to a channel.
    public let channelId: String?

    /// The page to select.
    public let page: Int?

    /// The number of post pages per response.
    public let perPage: Int?

    /// Creates kChat flagged post query options.
    public init(teamId: String? = nil, channelId: String? = nil, page: Int? = nil, perPage: Int? = nil) {
        self.teamId = teamId
        self.channelId = channelId
        self.page = page
        self.perPage = perPage
    }
}

/// Query parameters accepted by the kChat user threads endpoint.
public struct KChatUserThreadsOptions: Equatable, Sendable {
    /// Selects threads updated after this Unix timestamp in milliseconds.
    public let since: Int?

    /// Whether deleted threads should be included.
    public let deleted: Bool?

    /// Whether extended thread participant data should be included.
    public let extended: Bool?

    /// The page to select.
    public let page: Int?

    /// The number of threads per page.
    public let pageSize: Int?

    /// Whether only totals should be returned.
    public let totalsOnly: Bool?

    /// Whether only thread rows should be returned.
    public let threadsOnly: Bool?

    /// Creates kChat user thread query options.
    public init(
        since: Int? = nil,
        deleted: Bool? = nil,
        extended: Bool? = nil,
        page: Int? = nil,
        pageSize: Int? = nil,
        totalsOnly: Bool? = nil,
        threadsOnly: Bool? = nil
    ) {
        self.since = since
        self.deleted = deleted
        self.extended = extended
        self.page = page
        self.pageSize = pageSize
        self.totalsOnly = totalsOnly
        self.threadsOnly = threadsOnly
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

    private enum CodingKeys: String, CodingKey {
        case order
        case posts
        case nextPostId
        case prevPostId
        case hasNext
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let decodedOrder = try container.decodeIfPresent([String].self, forKey: .order)
        nextPostId = try container.decodeIfPresent(String.self, forKey: .nextPostId)
        prevPostId = try container.decodeIfPresent(String.self, forKey: .prevPostId)
        hasNext = try container.decodeIfPresent(Bool.self, forKey: .hasNext)

        if let postsById = try? container.decodeIfPresent([String: KChatPost].self, forKey: .posts) {
            posts = postsById
            order = decodedOrder
            return
        }

        if let postRows = try? container.decodeIfPresent([KChatPost].self, forKey: .posts) {
            posts = Dictionary(uniqueKeysWithValues: postRows.enumerated().map { index, post in
                (post.id ?? String(index), post)
            })
            order = decodedOrder ?? postRows.enumerated().map { index, post in
                post.id ?? String(index)
            }
            return
        }

        posts = nil
        order = decodedOrder
    }
}

/// A flexible response for kChat flagged posts.
public struct KChatFlaggedPosts: Codable, Equatable, Sendable {
    /// Returned post-list pages.
    public let postLists: [KChatPostList]

    /// Creates a kChat flagged posts response.
    public init(postLists: [KChatPostList]) {
        self.postLists = postLists
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let postLists = try? container.decode([KChatPostList].self) {
            self.postLists = postLists
        } else {
            self.postLists = [try container.decode(KChatPostList.self)]
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(postLists)
    }
}

/// A Mattermost-compatible list of followed kChat threads for a user.
public struct KChatUserThreads: Codable, Equatable, Sendable {
    /// Total number of followed threads available.
    public let total: Int?

    /// Followed thread rows.
    public let threads: [KChatUserThread]?

    /// Creates a followed kChat threads response.
    public init(total: Int? = nil, threads: [KChatUserThread]? = nil) {
        self.total = total
        self.threads = threads
    }
}

/// A Mattermost-compatible kChat thread followed by a user.
public struct KChatUserThread: Codable, Equatable, Sendable {
    public let id: String?
    public let replyCount: Int?
    public let lastReplyAt: Int64?
    public let lastViewedAt: Int64?
    public let participants: [KChatUserThreadParticipant]?
    public let post: KChatPost?

    /// Creates a followed kChat thread.
    public init(
        id: String? = nil,
        replyCount: Int? = nil,
        lastReplyAt: Int64? = nil,
        lastViewedAt: Int64? = nil,
        participants: [KChatUserThreadParticipant]? = nil,
        post: KChatPost? = nil
    ) {
        self.id = id
        self.replyCount = replyCount
        self.lastReplyAt = lastReplyAt
        self.lastViewedAt = lastViewedAt
        self.participants = participants
        self.post = post
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case replyCount
        case lastReplyAt
        case lastViewedAt
        case participants
        case capitalizedParticipants = "Participants"
        case post
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        replyCount = try container.decodeIfPresent(Int.self, forKey: .replyCount)
        lastReplyAt = try container.decodeIfPresent(Int64.self, forKey: .lastReplyAt)
        lastViewedAt = try container.decodeIfPresent(Int64.self, forKey: .lastViewedAt)
        participants = try container.decodeIfPresent([KChatUserThreadParticipant].self, forKey: .participants)
            ?? container.decodeIfPresent([KChatUserThreadParticipant].self, forKey: .capitalizedParticipants)
        post = try container.decodeIfPresent(KChatPost.self, forKey: .post)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(replyCount, forKey: .replyCount)
        try container.encodeIfPresent(lastReplyAt, forKey: .lastReplyAt)
        try container.encodeIfPresent(lastViewedAt, forKey: .lastViewedAt)
        try container.encodeIfPresent(participants, forKey: .participants)
        try container.encodeIfPresent(post, forKey: .post)
    }
}

/// A flexible kChat thread participant value.
public struct KChatUserThreadParticipant: Codable, Equatable, Sendable {
    /// Participant user id when the API returns compact participant ids.
    public let userId: String?

    /// Participant post/user object when the API returns extended values.
    public let post: KChatPost?

    /// Creates a kChat thread participant.
    public init(userId: String? = nil, post: KChatPost? = nil) {
        self.userId = userId
        self.post = post
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let userId = try? container.decode(String.self) {
            self.userId = userId
            self.post = nil
        } else {
            self.userId = nil
            self.post = try container.decode(KChatPost.self)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let userId {
            try container.encode(userId)
        } else {
            try container.encode(post)
        }
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
