import Foundation

/// Query options accepted by the Mattermost-compatible kChat channels list endpoint.
public struct KChatListChannelsOptions: Equatable, Sendable {
    /// The page to select.
    public let page: Int?

    /// The number of channels per page.
    public let perPage: Int?

    /// Whether default channels should be excluded.
    public let excludeDefaultChannels: Bool?

    /// Whether archived channels should be included.
    public let includeDeleted: Bool?

    /// Whether the API should include a total count when supported by the server.
    public let includeTotalCount: Bool?

    /// Whether policy-constrained channels should be excluded.
    public let excludePolicyConstrained: Bool?

    /// Creates kChat channels list query options.
    public init(
        page: Int? = nil,
        perPage: Int? = nil,
        excludeDefaultChannels: Bool? = nil,
        includeDeleted: Bool? = nil,
        includeTotalCount: Bool? = nil,
        excludePolicyConstrained: Bool? = nil
    ) {
        self.page = page
        self.perPage = perPage
        self.excludeDefaultChannels = excludeDefaultChannels
        self.includeDeleted = includeDeleted
        self.includeTotalCount = includeTotalCount
        self.excludePolicyConstrained = excludePolicyConstrained
    }
}

/// Query options accepted by the Mattermost-compatible kChat channel members list endpoint.
public struct KChatChannelMembersOptions: Equatable, Sendable {
    /// The page to select.
    public let page: Int?

    /// The number of channel members per page.
    public let perPage: Int?

    /// Creates kChat channel members list query options.
    public init(page: Int? = nil, perPage: Int? = nil) {
        self.page = page
        self.perPage = perPage
    }
}

/// Query options accepted by the Mattermost-compatible kChat public team channels endpoint.
public struct KChatPublicChannelsForTeamOptions: Equatable, Sendable {
    /// The page to select.
    public let page: Int?

    /// The number of public channels per page.
    public let perPage: Int?

    /// Creates kChat public team channels query options.
    public init(page: Int? = nil, perPage: Int? = nil) {
        self.page = page
        self.perPage = perPage
    }
}

/// Query options accepted by the Mattermost-compatible kChat private team channels endpoint.
public struct KChatPrivateChannelsForTeamOptions: Equatable, Sendable {
    /// The page to select.
    public let page: Int?

    /// The number of private channels per page.
    public let perPage: Int?

    /// Creates kChat private team channels query options.
    public init(page: Int? = nil, perPage: Int? = nil) {
        self.page = page
        self.perPage = perPage
    }
}

/// Query options accepted by the Mattermost-compatible kChat deleted team channels endpoint.
public struct KChatDeletedChannelsForTeamOptions: Equatable, Sendable {
    /// The page to select.
    public let page: Int?

    /// The number of deleted channels per page.
    public let perPage: Int?

    /// Creates kChat deleted team channels query options.
    public init(page: Int? = nil, perPage: Int? = nil) {
        self.page = page
        self.perPage = perPage
    }
}

/// Query options accepted by the kChat user channels endpoint.
public struct KChatUserChannelsOptions: Equatable, Sendable {
    /// Whether deleted channels should be included.
    public let includeDeleted: Bool?

    /// Filters deleted channels by deletion timestamp when `includeDeleted` is true.
    public let lastDeleteAt: Int?

    /// Creates kChat user channel listing options.
    public init(includeDeleted: Bool? = nil, lastDeleteAt: Int? = nil) {
        self.includeDeleted = includeDeleted
        self.lastDeleteAt = lastDeleteAt
    }
}

/// A Mattermost-compatible kChat channel statistics response.
public struct KChatChannelStats: Codable, Equatable, Sendable {
    /// Channel identifier these statistics belong to.
    public let channelId: String?

    /// Total number of members in the channel.
    public let memberCount: Int?

    /// Creates kChat channel statistics.
    public init(channelId: String? = nil, memberCount: Int? = nil) {
        self.channelId = channelId
        self.memberCount = memberCount
    }
}

/// A Mattermost-compatible kChat channel unread count response.
public struct KChatChannelUnread: Codable, Equatable, Sendable {
    /// Team identifier for the channel unread counters.
    public let teamId: String?

    /// Channel identifier for the unread counters.
    public let channelId: String?

    /// Number of unread messages in the channel.
    public let msgCount: Int?

    /// Number of unread mentions in the channel.
    public let mentionCount: Int?

    /// Creates a kChat channel unread count.
    public init(teamId: String? = nil, channelId: String? = nil, msgCount: Int? = nil, mentionCount: Int? = nil) {
        self.teamId = teamId
        self.channelId = channelId
        self.msgCount = msgCount
        self.mentionCount = mentionCount
    }
}

/// Moderation flags for one kChat channel role group.
public struct KChatChannelModeratedRole: Codable, Equatable, Sendable {
    /// Whether moderation applies to this role.
    public let value: Bool?

    /// Whether this moderation option is enabled.
    public let enabled: Bool?

    /// Creates a kChat channel moderated role value.
    public init(value: Bool? = nil, enabled: Bool? = nil) {
        self.value = value
        self.enabled = enabled
    }
}

/// Role groups affected by a kChat channel moderation option.
public struct KChatChannelModeratedRoles: Codable, Equatable, Sendable {
    /// Moderation state for guests.
    public let guests: KChatChannelModeratedRole?

    /// Moderation state for members.
    public let members: KChatChannelModeratedRole?

    /// Creates kChat channel moderated role groups.
    public init(guests: KChatChannelModeratedRole? = nil, members: KChatChannelModeratedRole? = nil) {
        self.guests = guests
        self.members = members
    }
}

/// A Mattermost-compatible kChat channel moderation option.
public struct KChatChannelModeration: Codable, Equatable, Sendable {
    /// Moderation setting name.
    public let name: String?

    /// Role values for this moderation setting.
    public let roles: KChatChannelModeratedRoles?

    /// Creates a kChat channel moderation option.
    public init(name: String? = nil, roles: KChatChannelModeratedRoles? = nil) {
        self.name = name
        self.roles = roles
    }
}

/// Query parameters accepted by the kChat user channel memberships endpoint.
public struct KChatUserChannelMembersOptions: Equatable, Sendable {
    /// The page to select.
    public let page: Int?

    /// The number of memberships per page.
    public let pageSize: Int?

    /// Creates kChat user channel membership listing options.
    public init(page: Int? = nil, pageSize: Int? = nil) {
        self.page = page
        self.pageSize = pageSize
    }
}

/// Mattermost-compatible channel notification settings for a kChat channel member.
public struct KChatChannelNotifyProps: Codable, Equatable, Sendable {
    public let desktop: String?
    public let email: String?
    public let markUnread: String?
    public let push: String?
    public let ignoreChannelMentions: String?

    /// Creates kChat channel notification settings.
    public init(
        desktop: String? = nil,
        email: String? = nil,
        markUnread: String? = nil,
        push: String? = nil,
        ignoreChannelMentions: String? = nil
    ) {
        self.desktop = desktop
        self.email = email
        self.markUnread = markUnread
        self.push = push
        self.ignoreChannelMentions = ignoreChannelMentions
    }
}

/// A Mattermost-compatible kChat channel membership with team metadata.
public struct KChatChannelMember: Codable, Equatable, Sendable {
    public let channelId: String?
    public let userId: String?
    public let roles: String?
    public let lastViewedAt: Int64?
    public let msgCount: Int?
    public let mentionCount: Int?
    public let notifyProps: KChatChannelNotifyProps?
    public let lastUpdateAt: Int64?
    public let teamDisplayName: String?
    public let teamName: String?
    public let teamUpdateAt: Int64?

    /// Creates a kChat channel membership with optional team metadata.
    public init(
        channelId: String? = nil,
        userId: String? = nil,
        roles: String? = nil,
        lastViewedAt: Int64? = nil,
        msgCount: Int? = nil,
        mentionCount: Int? = nil,
        notifyProps: KChatChannelNotifyProps? = nil,
        lastUpdateAt: Int64? = nil,
        teamDisplayName: String? = nil,
        teamName: String? = nil,
        teamUpdateAt: Int64? = nil
    ) {
        self.channelId = channelId
        self.userId = userId
        self.roles = roles
        self.lastViewedAt = lastViewedAt
        self.msgCount = msgCount
        self.mentionCount = mentionCount
        self.notifyProps = notifyProps
        self.lastUpdateAt = lastUpdateAt
        self.teamDisplayName = teamDisplayName
        self.teamName = teamName
        self.teamUpdateAt = teamUpdateAt
    }

    private enum CodingKeys: String, CodingKey {
        case channelId
        case userId
        case roles
        case lastViewedAt
        case msgCount
        case mentionCount
        case notifyProps
        case lastUpdateAt
        case teamDisplayName
        case teamName
        case teamUpdateAt
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.channelId = try Self.decodeStringOrNumberIfPresent(from: container, forKey: .channelId)
        self.userId = try Self.decodeStringOrNumberIfPresent(from: container, forKey: .userId)
        self.roles = try container.decodeIfPresent(String.self, forKey: .roles)
        self.lastViewedAt = try container.decodeIfPresent(Int64.self, forKey: .lastViewedAt)
        self.msgCount = try container.decodeIfPresent(Int.self, forKey: .msgCount)
        self.mentionCount = try container.decodeIfPresent(Int.self, forKey: .mentionCount)
        self.notifyProps = try container.decodeIfPresent(KChatChannelNotifyProps.self, forKey: .notifyProps)
        self.lastUpdateAt = try container.decodeIfPresent(Int64.self, forKey: .lastUpdateAt)
        self.teamDisplayName = try container.decodeIfPresent(String.self, forKey: .teamDisplayName)
        self.teamName = try container.decodeIfPresent(String.self, forKey: .teamName)
        self.teamUpdateAt = try container.decodeIfPresent(Int64.self, forKey: .teamUpdateAt)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(channelId, forKey: .channelId)
        try container.encodeIfPresent(userId, forKey: .userId)
        try container.encodeIfPresent(roles, forKey: .roles)
        try container.encodeIfPresent(lastViewedAt, forKey: .lastViewedAt)
        try container.encodeIfPresent(msgCount, forKey: .msgCount)
        try container.encodeIfPresent(mentionCount, forKey: .mentionCount)
        try container.encodeIfPresent(notifyProps, forKey: .notifyProps)
        try container.encodeIfPresent(lastUpdateAt, forKey: .lastUpdateAt)
        try container.encodeIfPresent(teamDisplayName, forKey: .teamDisplayName)
        try container.encodeIfPresent(teamName, forKey: .teamName)
        try container.encodeIfPresent(teamUpdateAt, forKey: .teamUpdateAt)
    }

    private static func decodeStringOrNumberIfPresent(
        from container: KeyedDecodingContainer<CodingKeys>,
        forKey key: CodingKeys
    ) throws -> String? {
        if let string = try? container.decodeIfPresent(String.self, forKey: key) {
            return string
        }

        if let integer = try? container.decodeIfPresent(Int64.self, forKey: key) {
            return String(integer)
        }

        return nil
    }
}

/// A Mattermost-compatible kChat channel returned by user team channel endpoints.
public struct KChatChannel: Codable, Equatable, Sendable {
    public let id: String?
    public let createAt: Int64?
    public let updateAt: Int64?
    public let deleteAt: Int64?
    public let teamId: String?
    public let type: String?
    public let displayName: String?
    public let name: String?
    public let header: String?
    public let purpose: String?
    public let lastPostAt: Int?
    public let totalMsgCount: Int?
    public let creatorId: String?
    public let teamDisplayName: String?
    public let teamName: String?
    public let teamUpdateAt: Int64?
    public let policyId: String?

    public init(
        id: String? = nil,
        createAt: Int64? = nil,
        updateAt: Int64? = nil,
        deleteAt: Int64? = nil,
        teamId: String? = nil,
        type: String? = nil,
        displayName: String? = nil,
        name: String? = nil,
        header: String? = nil,
        purpose: String? = nil,
        lastPostAt: Int? = nil,
        totalMsgCount: Int? = nil,
        creatorId: String? = nil,
        teamDisplayName: String? = nil,
        teamName: String? = nil,
        teamUpdateAt: Int64? = nil,
        policyId: String? = nil
    ) {
        self.id = id
        self.createAt = createAt
        self.updateAt = updateAt
        self.deleteAt = deleteAt
        self.teamId = teamId
        self.type = type
        self.displayName = displayName
        self.name = name
        self.header = header
        self.purpose = purpose
        self.lastPostAt = lastPostAt
        self.totalMsgCount = totalMsgCount
        self.creatorId = creatorId
        self.teamDisplayName = teamDisplayName
        self.teamName = teamName
        self.teamUpdateAt = teamUpdateAt
        self.policyId = policyId
    }
}

/// A Mattermost-compatible kChat sidebar category.
public struct KChatSidebarCategory: Codable, Equatable, Sendable {
    public let id: String?
    public let userId: String?
    public let teamId: String?
    public let displayName: String?
    public let type: String?

    /// Creates a kChat sidebar category.
    public init(id: String? = nil, userId: String? = nil, teamId: String? = nil, displayName: String? = nil, type: String? = nil) {
        self.id = id
        self.userId = userId
        self.teamId = teamId
        self.displayName = displayName
        self.type = type
    }
}

/// A Mattermost-compatible kChat sidebar category with channel ids.
public struct KChatSidebarCategoryWithChannels: Codable, Equatable, Sendable {
    public let id: String?
    public let userId: String?
    public let teamId: String?
    public let displayName: String?
    public let type: String?
    public let channelIds: [String]?

    /// Creates a kChat sidebar category with channel ids.
    public init(
        id: String? = nil,
        userId: String? = nil,
        teamId: String? = nil,
        displayName: String? = nil,
        type: String? = nil,
        channelIds: [String]? = nil
    ) {
        self.id = id
        self.userId = userId
        self.teamId = teamId
        self.displayName = displayName
        self.type = type
        self.channelIds = channelIds
    }
}

/// A Mattermost-compatible ordered sidebar category response.
public struct KChatOrderedSidebarCategories: Codable, Equatable, Sendable {
    /// Sidebar category ids in display order.
    public let order: [String]?

    /// Sidebar categories with their channel ids.
    public let categories: [KChatSidebarCategoryWithChannels]?

    /// Creates ordered kChat sidebar categories.
    public init(order: [String]? = nil, categories: [KChatSidebarCategoryWithChannels]? = nil) {
        self.order = order
        self.categories = categories
    }
}
