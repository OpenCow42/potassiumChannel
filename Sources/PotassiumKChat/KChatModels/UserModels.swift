import Foundation
import PotassiumChannelCore

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

/// A Mattermost-compatible kChat user preference.
public struct KChatPreference: Codable, Equatable, Sendable {
    /// Identifier of the user that owns the preference.
    public let userId: String?

    /// Preference category.
    public let category: String?

    /// Preference name inside the category.
    public let name: String?

    /// Stored preference value.
    public let value: String?

    /// Creates a kChat user preference.
    public init(userId: String? = nil, category: String? = nil, name: String? = nil, value: String? = nil) {
        self.userId = userId
        self.category = category
        self.name = name
        self.value = value
    }
}
