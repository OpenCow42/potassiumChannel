import Foundation
import PotassiumChannelCore

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
