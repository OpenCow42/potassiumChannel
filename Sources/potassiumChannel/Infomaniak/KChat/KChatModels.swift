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

/// A Mattermost-compatible kChat user returned by the user search endpoint.
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
