import Foundation

/// A Mattermost-compatible kChat client configuration response.
public struct KChatClientConfig: Codable, Equatable, Sendable {
    /// Raw client configuration values keyed by Mattermost configuration name.
    public let values: [String: String]

    /// Creates a kChat client configuration value.
    public init(values: [String: String]) {
        self.values = values
    }

    /// Accesses a configuration value by key.
    public subscript(_ key: String) -> String? {
        values[key]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        values = try container.decode([String: String].self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(values)
    }
}


/// Search criteria accepted by the Mattermost-compatible kChat user search endpoint.
public struct KChatUserSearchOptions: Encodable, Equatable, Sendable {
    /// Free-text search term.
    public let term: String?

    /// Restricts the search to users in a team.
    public let teamId: String?

    /// Restricts the search to users not in a team.
    public let notInTeamId: String?

    /// Restricts the search to users in a channel.
    public let inChannelId: String?

    /// Restricts the search to users not in a channel.
    public let notInChannelId: String?

    /// Restricts the search to users in a group.
    public let inGroupId: String?

    /// Applies group-constrained filtering with team or channel exclusion filters.
    public let groupConstrained: Bool?

    /// Includes deactivated users when true.
    public let allowInactive: Bool?

    /// Searches users without a team when true.
    public let withoutTeam: Bool?

    /// Maximum number of users returned by the API.
    public let limit: Int?

    public enum CodingKeys: String, CodingKey {
        case term
        case teamId = "team_id"
        case notInTeamId = "not_in_team_id"
        case inChannelId = "in_channel_id"
        case notInChannelId = "not_in_channel_id"
        case inGroupId = "in_group_id"
        case groupConstrained = "group_constrained"
        case allowInactive = "allow_inactive"
        case withoutTeam = "without_team"
        case limit
    }

    /// Creates kChat user search options.
    public init(
        term: String? = nil,
        teamId: String? = nil,
        notInTeamId: String? = nil,
        inChannelId: String? = nil,
        notInChannelId: String? = nil,
        inGroupId: String? = nil,
        groupConstrained: Bool? = nil,
        allowInactive: Bool? = nil,
        withoutTeam: Bool? = nil,
        limit: Int? = nil
    ) {
        self.term = term
        self.teamId = teamId
        self.notInTeamId = notInTeamId
        self.inChannelId = inChannelId
        self.notInChannelId = notInChannelId
        self.inGroupId = inGroupId
        self.groupConstrained = groupConstrained
        self.allowInactive = allowInactive
        self.withoutTeam = withoutTeam
        self.limit = limit
    }
}

/// Query options accepted by the Mattermost-compatible kChat teams list endpoint.
public struct KChatListTeamsOptions: Equatable, Sendable {
    /// The page to select.
    public let page: Int?

    /// The number of teams per page.
    public let perPage: Int?

    /// Whether the API should include a total count when supported by the server.
    public let includeTotalCount: Bool?

    /// Whether policy-constrained teams should be excluded.
    public let excludePolicyConstrained: Bool?

    /// Creates kChat teams list query options.
    public init(
        page: Int? = nil,
        perPage: Int? = nil,
        includeTotalCount: Bool? = nil,
        excludePolicyConstrained: Bool? = nil
    ) {
        self.page = page
        self.perPage = perPage
        self.includeTotalCount = includeTotalCount
        self.excludePolicyConstrained = excludePolicyConstrained
    }
}

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

/// Query options accepted by the Mattermost-compatible kChat team members list endpoint.
public struct KChatTeamMembersOptions: Equatable, Sendable {
    /// The page to select.
    public let page: Int?

    /// The number of team members per page.
    public let perPage: Int?

    /// Creates kChat team members list query options.
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

/// Query options accepted by the Mattermost-compatible kChat team channels autocomplete endpoint.
public struct KChatChannelsForTeamAutocompleteOptions: Equatable, Sendable {
    /// Channel name or display name search term.
    public let name: String

    /// Creates kChat team channels autocomplete query options.
    public init(name: String) {
        self.name = name
    }
}

/// Query options accepted by the Mattermost-compatible kChat team channels search autocomplete endpoint.
public struct KChatChannelsForTeamSearchAutocompleteOptions: Equatable, Sendable {
    /// Channel name or display name search term.
    public let name: String

    /// Creates kChat team channels search autocomplete query options.
    public init(name: String) {
        self.name = name
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

/// A Mattermost-compatible kChat team statistics response.
public struct KChatTeamStats: Codable, Equatable, Sendable {
    /// Team identifier these statistics belong to.
    public let teamId: String?

    /// Total number of members in the team.
    public let totalMemberCount: Int?

    /// Number of active members in the team.
    public let activeMemberCount: Int?

    /// Creates kChat team statistics.
    public init(
        teamId: String? = nil,
        totalMemberCount: Int? = nil,
        activeMemberCount: Int? = nil
    ) {
        self.teamId = teamId
        self.totalMemberCount = totalMemberCount
        self.activeMemberCount = activeMemberCount
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

/// Query options accepted by the Mattermost-compatible kChat users list endpoint.
public struct KChatListUsersOptions: Equatable, Sendable {
    /// The page to select.
    public let page: Int?

    /// The number of users per page.
    public let perPage: Int?

    /// Restricts the list to users in a team.
    public let inTeam: String?

    /// Excludes users in a team.
    public let notInTeam: String?

    /// Restricts the list to users in a channel.
    public let inChannel: String?

    /// Excludes users in a channel.
    public let notInChannel: String?

    /// Restricts the list to users in a group.
    public let inGroup: String?

    /// Applies group-constrained filtering.
    public let groupConstrained: Bool?

    /// Lists users that are not on any team.
    public let withoutTeam: Bool?

    /// Lists only active users.
    public let active: Bool?

    /// Lists only deactivated users.
    public let inactive: Bool?

    /// Returns users that have this role.
    public let role: String?

    /// Sort mode supported by the selected filter.
    public let sort: String?

    /// Comma-separated system roles filter.
    public let roles: String?

    /// Comma-separated channel roles filter.
    public let channelRoles: String?

    /// Comma-separated team roles filter.
    public let teamRoles: String?

    /// Creates kChat users list query options.
    public init(
        page: Int? = nil,
        perPage: Int? = nil,
        inTeam: String? = nil,
        notInTeam: String? = nil,
        inChannel: String? = nil,
        notInChannel: String? = nil,
        inGroup: String? = nil,
        groupConstrained: Bool? = nil,
        withoutTeam: Bool? = nil,
        active: Bool? = nil,
        inactive: Bool? = nil,
        role: String? = nil,
        sort: String? = nil,
        roles: String? = nil,
        channelRoles: String? = nil,
        teamRoles: String? = nil
    ) {
        self.page = page
        self.perPage = perPage
        self.inTeam = inTeam
        self.notInTeam = notInTeam
        self.inChannel = inChannel
        self.notInChannel = notInChannel
        self.inGroup = inGroup
        self.groupConstrained = groupConstrained
        self.withoutTeam = withoutTeam
        self.active = active
        self.inactive = inactive
        self.role = role
        self.sort = sort
        self.roles = roles
        self.channelRoles = channelRoles
        self.teamRoles = teamRoles
    }
}

/// Query options accepted by the Mattermost-compatible kChat users autocomplete endpoint.
public struct KChatUserAutocompleteOptions: Equatable, Sendable {
    /// Team ID used to filter autocomplete results.
    public let teamId: String?

    /// Channel ID used to filter autocomplete results.
    public let channelId: String?

    /// Username, nickname, first name, or last name search term.
    public let name: String

    /// Maximum number of users to return in each subresult.
    public let limit: Int?

    /// Creates kChat users autocomplete query options.
    public init(teamId: String? = nil, channelId: String? = nil, name: String, limit: Int? = nil) {
        self.teamId = teamId
        self.channelId = channelId
        self.name = name
        self.limit = limit
    }
}

/// A Mattermost-compatible kChat user autocomplete response.
public struct KChatUserAutocomplete: Codable, Equatable, Sendable {
    /// Main user autocomplete results.
    public let users: [KChatUser]?

    /// Users outside the channel when autocompleting in a specific channel.
    public let outOfChannel: [KChatUser]?

    public init(users: [KChatUser]? = nil, outOfChannel: [KChatUser]? = nil) {
        self.users = users
        self.outOfChannel = outOfChannel
    }
}

/// A Mattermost-compatible kChat user returned by user endpoints.
public struct KChatUser: Codable, Equatable, Sendable {
    public let id: String?
    public let createAt: Int64?
    public let updateAt: Int64?
    public let deleteAt: Int64?
    public let username: String?
    public let firstName: String?
    public let lastName: String?
    public let nickname: String?
    public let email: String?
    public let emailVerified: Bool?
    public let authService: String?
    public let roles: String?
    public let locale: String?
    public let lastPasswordUpdate: Int?
    public let lastPictureUpdate: Int?
    public let failedAttempts: Int?
    public let mfaActive: Bool?
    public let termsOfServiceId: String?
    public let termsOfServiceCreateAt: Int64?

    public init(
        id: String? = nil,
        createAt: Int64? = nil,
        updateAt: Int64? = nil,
        deleteAt: Int64? = nil,
        username: String? = nil,
        firstName: String? = nil,
        lastName: String? = nil,
        nickname: String? = nil,
        email: String? = nil,
        emailVerified: Bool? = nil,
        authService: String? = nil,
        roles: String? = nil,
        locale: String? = nil,
        lastPasswordUpdate: Int? = nil,
        lastPictureUpdate: Int? = nil,
        failedAttempts: Int? = nil,
        mfaActive: Bool? = nil,
        termsOfServiceId: String? = nil,
        termsOfServiceCreateAt: Int64? = nil
    ) {
        self.id = id
        self.createAt = createAt
        self.updateAt = updateAt
        self.deleteAt = deleteAt
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.nickname = nickname
        self.email = email
        self.emailVerified = emailVerified
        self.authService = authService
        self.roles = roles
        self.locale = locale
        self.lastPasswordUpdate = lastPasswordUpdate
        self.lastPictureUpdate = lastPictureUpdate
        self.failedAttempts = failedAttempts
        self.mfaActive = mfaActive
        self.termsOfServiceId = termsOfServiceId
        self.termsOfServiceCreateAt = termsOfServiceCreateAt
    }
}

/// A Mattermost-compatible kChat user status response.
public struct KChatUserStatus: Codable, Equatable, Sendable {
    /// User identifier for this status value.
    public let userId: String?

    /// User presence status, for example `online`, `away`, `offline`, or `dnd`.
    public let status: String?

    /// Whether the status was set manually.
    public let manual: Bool?

    /// Last user activity timestamp in epoch milliseconds.
    public let lastActivityAt: Int64?

    /// Do-not-disturb end timestamp when supplied by Mattermost-compatible servers.
    public let dndEndTime: Int64?

    /// Creates a kChat user status response.
    public init(
        userId: String? = nil,
        status: String? = nil,
        manual: Bool? = nil,
        lastActivityAt: Int64? = nil,
        dndEndTime: Int64? = nil
    ) {
        self.userId = userId
        self.status = status
        self.manual = manual
        self.lastActivityAt = lastActivityAt
        self.dndEndTime = dndEndTime
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userId = try container.decodeIfPresent(String.self, forKey: .userId)
        status = try container.decodeIfPresent(String.self, forKey: .status)
        if let boolValue = try? container.decodeIfPresent(Bool.self, forKey: .manual) {
            manual = boolValue
        } else if let intValue = try? container.decodeIfPresent(Int.self, forKey: .manual) {
            manual = intValue != 0
        } else {
            manual = nil
        }
        lastActivityAt = try container.decodeIfPresent(Int64.self, forKey: .lastActivityAt)
        dndEndTime = try container.decodeIfPresent(Int64.self, forKey: .dndEndTime)
    }
}

/// A Mattermost-compatible kChat team returned by user team endpoints.
public struct KChatTeam: Codable, Equatable, Sendable {
    public let id: String?
    public let createAt: Int64?
    public let updateAt: Int64?
    public let deleteAt: Int64?
    public let displayName: String?
    public let name: String?
    public let description: String?
    public let email: String?
    public let type: String?
    public let allowedDomains: String?
    public let inviteId: String?
    public let allowOpenInvite: Bool?
    public let policyId: String?

    public init(
        id: String? = nil,
        createAt: Int64? = nil,
        updateAt: Int64? = nil,
        deleteAt: Int64? = nil,
        displayName: String? = nil,
        name: String? = nil,
        description: String? = nil,
        email: String? = nil,
        type: String? = nil,
        allowedDomains: String? = nil,
        inviteId: String? = nil,
        allowOpenInvite: Bool? = nil,
        policyId: String? = nil
    ) {
        self.id = id
        self.createAt = createAt
        self.updateAt = updateAt
        self.deleteAt = deleteAt
        self.displayName = displayName
        self.name = name
        self.description = description
        self.email = email
        self.type = type
        self.allowedDomains = allowedDomains
        self.inviteId = inviteId
        self.allowOpenInvite = allowOpenInvite
        self.policyId = policyId
    }
}

/// A Mattermost-compatible kChat team membership returned by team member endpoints.
public struct KChatTeamMember: Codable, Equatable, Sendable {
    /// Team identifier for this membership.
    public let teamId: String?

    /// User identifier for this membership.
    public let userId: String?

    /// Complete role list, including implicit scheme roles.
    public let roles: String?

    /// Deletion timestamp in epoch milliseconds.
    public let deleteAt: Int64?

    /// Whether this member receives the team's default user role from the permission scheme.
    public let schemeUser: Bool?

    /// Whether this member receives the team's default admin role from the permission scheme.
    public let schemeAdmin: Bool?

    /// Explicitly assigned roles, excluding implicit scheme roles.
    public let explicitRoles: String?

    /// Creates a kChat team membership.
    public init(
        teamId: String? = nil,
        userId: String? = nil,
        roles: String? = nil,
        deleteAt: Int64? = nil,
        schemeUser: Bool? = nil,
        schemeAdmin: Bool? = nil,
        explicitRoles: String? = nil
    ) {
        self.teamId = teamId
        self.userId = userId
        self.roles = roles
        self.deleteAt = deleteAt
        self.schemeUser = schemeUser
        self.schemeAdmin = schemeAdmin
        self.explicitRoles = explicitRoles
    }

    private enum CodingKeys: String, CodingKey {
        case teamId
        case userId
        case roles
        case deleteAt
        case schemeUser
        case schemeAdmin
        case explicitRoles
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.teamId = try Self.decodeStringOrNumberIfPresent(from: container, forKey: .teamId)
        self.userId = try Self.decodeStringOrNumberIfPresent(from: container, forKey: .userId)
        self.roles = try container.decodeIfPresent(String.self, forKey: .roles)
        self.deleteAt = try container.decodeIfPresent(Int64.self, forKey: .deleteAt)
        self.schemeUser = try container.decodeIfPresent(Bool.self, forKey: .schemeUser)
        self.schemeAdmin = try container.decodeIfPresent(Bool.self, forKey: .schemeAdmin)
        self.explicitRoles = try container.decodeIfPresent(String.self, forKey: .explicitRoles)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(teamId, forKey: .teamId)
        try container.encodeIfPresent(userId, forKey: .userId)
        try container.encodeIfPresent(roles, forKey: .roles)
        try container.encodeIfPresent(deleteAt, forKey: .deleteAt)
        try container.encodeIfPresent(schemeUser, forKey: .schemeUser)
        try container.encodeIfPresent(schemeAdmin, forKey: .schemeAdmin)
        try container.encodeIfPresent(explicitRoles, forKey: .explicitRoles)
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

/// A Mattermost-compatible kChat unread count for a team.
public struct KChatTeamUnread: Codable, Equatable, Sendable {
    /// Team identifier for these unread counters.
    public let teamId: String?

    /// Number of unread messages in the team.
    public let msgCount: Int?

    /// Number of unread mentions in the team.
    public let mentionCount: Int?

    /// Creates a kChat team unread count.
    public init(teamId: String? = nil, msgCount: Int? = nil, mentionCount: Int? = nil) {
        self.teamId = teamId
        self.msgCount = msgCount
        self.mentionCount = mentionCount
    }
}

/// Query parameters accepted by the kChat user team channels endpoint.
public struct KChatUserTeamChannelsOptions: Equatable, Sendable {
    /// Whether deleted channels should be included.
    public let includeDeleted: Bool?

    /// Filters deleted channels by deletion timestamp when `includeDeleted` is true.
    public let lastDeleteAt: Int?

    /// Creates kChat user team channel listing options.
    public init(includeDeleted: Bool? = nil, lastDeleteAt: Int? = nil) {
        self.includeDeleted = includeDeleted
        self.lastDeleteAt = lastDeleteAt
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
}

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

/// A Mattermost-compatible status response.
public struct KChatStatusOK: Codable, Equatable, Sendable {
    public let status: String?

    public init(status: String? = nil) {
        self.status = status
    }
}

/// Response returned by the Mattermost-compatible kChat file upload endpoint.
public struct KChatFileUploadResponse: Codable, Equatable, Sendable {
    public let fileInfos: [KChatFileInfo]?
    public let clientIds: [String]?

    public init(fileInfos: [KChatFileInfo]? = nil, clientIds: [String]? = nil) {
        self.fileInfos = fileInfos
        self.clientIds = clientIds
    }
}

/// Mattermost-compatible kChat file metadata.
public struct KChatFileInfo: Codable, Equatable, Sendable {
    public let id: String?
    public let userId: String?
    public let postId: String?
    public let createAt: Int64?
    public let updateAt: Int64?
    public let deleteAt: Int64?
    public let name: String?
    public let `extension`: String?
    public let size: Int?
    public let mimeType: String?
    public let width: Int?
    public let height: Int?
    public let hasPreviewImage: Bool?

    public init(
        id: String? = nil,
        userId: String? = nil,
        postId: String? = nil,
        createAt: Int64? = nil,
        updateAt: Int64? = nil,
        deleteAt: Int64? = nil,
        name: String? = nil,
        extension: String? = nil,
        size: Int? = nil,
        mimeType: String? = nil,
        width: Int? = nil,
        height: Int? = nil,
        hasPreviewImage: Bool? = nil
    ) {
        self.id = id
        self.userId = userId
        self.postId = postId
        self.createAt = createAt
        self.updateAt = updateAt
        self.deleteAt = deleteAt
        self.name = name
        self.extension = `extension`
        self.size = size
        self.mimeType = mimeType
        self.width = width
        self.height = height
        self.hasPreviewImage = hasPreviewImage
    }
}
