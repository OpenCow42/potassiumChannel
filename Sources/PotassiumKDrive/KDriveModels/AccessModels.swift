import Foundation
import PotassiumChannelCore

/// Multi-access information for a kDrive file or directory.
public struct KDriveFileMultiAccess: Codable, Equatable, Sendable {
    /// Raw access payload returned by the API, keyed by access section.
    public let values: [String: KDriveJSONValue]

    public init(values: [String: KDriveJSONValue]) {
        self.values = values
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.values = try container.decode([String: KDriveJSONValue].self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(values)
    }
}

/// A requested access entry for a kDrive file or directory.
public struct KDriveFileAccessRequest: Codable, Equatable, Sendable {
    /// Raw access-request payload returned by the API.
    public let values: [String: KDriveJSONValue]

    public init(values: [String: KDriveJSONValue]) {
        self.values = values
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.values = try container.decode([String: KDriveJSONValue].self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(values)
    }
}

/// An invitation access entry for a kDrive file or directory.
public struct KDriveFileAccessInvitation: Codable, Equatable, Sendable {
    /// Raw invitation payload returned by the API.
    public let values: [String: KDriveJSONValue]

    public init(values: [String: KDriveJSONValue]) {
        self.values = values
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.values = try container.decode([String: KDriveJSONValue].self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(values)
    }
}

/// Options for checking a proposed access-right change for a kDrive file or directory.
public struct CheckKDriveFileAccessChangeOptions: Encodable, Equatable, Sendable {
    /// Email addresses to check.
    public let emails: [String]?

    /// Infomaniak user identifiers to check.
    public let userIds: [Int]?

    /// kDrive team identifiers to check.
    public let teamIds: [Int]?

    /// Access right to check.
    public let right: String

    /// Invitation language fallback when a user preference is unavailable.
    public let language: String?

    public enum CodingKeys: String, CodingKey {
        case emails
        case userIds = "user_ids"
        case teamIds = "team_ids"
        case right
        case language = "lang"
    }

    /// Creates options for checking a kDrive access-right change.
    public init(
        emails: [String]? = nil,
        userIds: [Int]? = nil,
        teamIds: [Int]? = nil,
        right: String,
        language: String? = nil
    ) {
        self.emails = emails
        self.userIds = userIds
        self.teamIds = teamIds
        self.right = right
        self.language = language
    }
}

/// Feedback for a proposed kDrive access-right change.
public struct KDriveFileAccessChangeFeedback: Codable, Equatable, Sendable {
    /// User identifier checked by the API.
    public let userId: Int

    /// Current access right for the user.
    public let currentRight: String

    /// Whether applying the requested right would change remote state.
    public let needChange: Bool

    /// API feedback message explaining the decision.
    public let message: String

    /// Creates kDrive access-change feedback.
    public init(userId: Int, currentRight: String, needChange: Bool, message: String) {
        self.userId = userId
        self.currentRight = currentRight
        self.needChange = needChange
        self.message = message
    }
}

/// Options for checking whether file-access invitations already exist.
public struct CheckKDriveFileAccessInvitationsOptions: Encodable, Equatable, Sendable {
    /// Email addresses to check.
    public let emails: [String]?

    /// Infomaniak user identifiers to check.
    public let userIds: [Int]?

    public enum CodingKeys: String, CodingKey {
        case emails
        case userIds = "user_ids"
    }

    /// Creates options for checking pending kDrive file-access invitations.
    public init(emails: [String]? = nil, userIds: [Int]? = nil) {
        self.emails = emails
        self.userIds = userIds
    }
}

/// Feedback describing whether a kDrive file-access invitation is already pending.
public struct KDriveFileAccessPendingInvitationFeedback: Codable, Equatable, Sendable {
    /// Pending file invitation identifier, when one exists.
    public let invitationId: Int?

    /// Pending drive invitation identifier, when one exists.
    public let driveInvitationId: Int?

    /// API indicator describing whether an invitation exists.
    public let hasInvitation: String

    /// User identifier checked by the API, when the target was a user.
    public let userId: Int?

    /// Email address checked by the API, when the target was an email address.
    public let email: String?

    public enum CodingKeys: String, CodingKey {
        case invitationId
        case driveInvitationId
        case hasInvitation
        case userId
        case email
    }

    /// Creates pending invitation feedback.
    public init(
        invitationId: Int?,
        driveInvitationId: Int?,
        hasInvitation: String,
        userId: Int? = nil,
        email: String? = nil
    ) {
        self.invitationId = invitationId
        self.driveInvitationId = driveInvitationId
        self.hasInvitation = hasInvitation
        self.userId = userId
        self.email = email
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        invitationId = try container.decodeIfPresent(Int.self, forKey: .invitationId)
        driveInvitationId = try container.decodeIfPresent(Int.self, forKey: .driveInvitationId)
        userId = try container.decodeIfPresent(Int.self, forKey: .userId)
        email = try container.decodeIfPresent(String.self, forKey: .email)

        if let value = try? container.decode(String.self, forKey: .hasInvitation) {
            hasInvitation = value
        } else if let value = try? container.decode(Bool.self, forKey: .hasInvitation) {
            hasInvitation = String(value)
        } else {
            throw DecodingError.typeMismatch(
                String.self,
                DecodingError.Context(
                    codingPath: decoder.codingPath + [CodingKeys.hasInvitation],
                    debugDescription: "Expected has_invitation to be a string or boolean"
                )
            )
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(invitationId, forKey: .invitationId)
        try container.encodeIfPresent(driveInvitationId, forKey: .driveInvitationId)
        try container.encode(hasInvitation, forKey: .hasInvitation)
        try container.encodeIfPresent(userId, forKey: .userId)
        try container.encodeIfPresent(email, forKey: .email)
    }
}

/// Share-link metadata for a kDrive file or directory.
public struct KDriveShareLink: Codable, Equatable, Sendable {
    /// Share-link URL.
    public let url: String

    /// Shared file identifier.
    public let fileId: Int

    /// Access right required to view the share link.
    public let right: String

    /// Timestamp until which the share link is valid, when limited.
    public let validUntil: Int?

    /// User identifier of the link creator.
    public let createdBy: Int

    /// Link creation timestamp, when returned.
    public let createdAt: Int?

    /// Link update timestamp, when returned.
    public let updatedAt: Int?

    /// Share-link capabilities.
    public let capabilities: KDriveShareLinkCapabilities

    /// Whether link access is blocked.
    public let accessBlocked: Bool

    /// Number of views on the share link, when returned.
    public let views: Int?

    /// Creates a kDrive share-link value.
    public init(
        url: String,
        fileId: Int,
        right: String,
        validUntil: Int?,
        createdBy: Int,
        createdAt: Int?,
        updatedAt: Int?,
        capabilities: KDriveShareLinkCapabilities,
        accessBlocked: Bool,
        views: Int? = nil
    ) {
        self.url = url
        self.fileId = fileId
        self.right = right
        self.validUntil = validUntil
        self.createdBy = createdBy
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.capabilities = capabilities
        self.accessBlocked = accessBlocked
        self.views = views
    }
}

/// Capability flags attached to a kDrive share link.
public struct KDriveShareLinkCapabilities: Codable, Equatable, Sendable {
    public let canEdit: Bool
    public let canSeeStats: Bool
    public let canSeeInfo: Bool
    public let canDownload: Bool
    public let canComment: Bool
    public let canRequestAccess: Bool

    public init(canEdit: Bool, canSeeStats: Bool, canSeeInfo: Bool, canDownload: Bool, canComment: Bool, canRequestAccess: Bool) {
        self.canEdit = canEdit
        self.canSeeStats = canSeeStats
        self.canSeeInfo = canSeeInfo
        self.canDownload = canDownload
        self.canComment = canComment
        self.canRequestAccess = canRequestAccess
    }
}

/// JSON body accepted by the kDrive create file share-link endpoint.
public struct CreateKDriveFileShareLinkOptions: Encodable, Equatable, Sendable {
    /// Permission of the shared link: `public`, `inherit`, or `password`.
    public let right: String

    /// Whether share-link users may comment on shared files.
    public let canComment: Bool?

    /// Whether share-link users may download shared content.
    public let canDownload: Bool?

    /// Whether share-link users may edit shared content.
    public let canEdit: Bool?

    /// Whether connected users may request access from the share-link.
    public let canRequestAccess: Bool?

    /// Whether share-link users may see file information.
    public let canSeeInfo: Bool?

    /// Whether share-link users may see statistics.
    public let canSeeStats: Bool?

    /// Password used when `right` is `password`.
    public let password: String?

    /// Maximum validity timestamp of the share-link.
    public let validUntil: Int?

    public enum CodingKeys: String, CodingKey {
        case right
        case canComment = "can_comment"
        case canDownload = "can_download"
        case canEdit = "can_edit"
        case canRequestAccess = "can_request_access"
        case canSeeInfo = "can_see_info"
        case canSeeStats = "can_see_stats"
        case password
        case validUntil = "valid_until"
    }

    /// Creates options for creating a kDrive file share-link.
    public init(
        right: String,
        canComment: Bool? = nil,
        canDownload: Bool? = nil,
        canEdit: Bool? = nil,
        canRequestAccess: Bool? = nil,
        canSeeInfo: Bool? = nil,
        canSeeStats: Bool? = nil,
        password: String? = nil,
        validUntil: Int? = nil
    ) {
        self.right = right
        self.canComment = canComment
        self.canDownload = canDownload
        self.canEdit = canEdit
        self.canRequestAccess = canRequestAccess
        self.canSeeInfo = canSeeInfo
        self.canSeeStats = canSeeStats
        self.password = password
        self.validUntil = validUntil
    }
}

/// JSON body accepted by the kDrive update file share-link endpoint.
public struct UpdateKDriveFileShareLinkOptions: Encodable, Equatable, Sendable {
    /// Whether share-link users may comment on shared files.
    public let canComment: Bool?

    /// Whether share-link users may download shared content.
    public let canDownload: Bool?

    /// Whether share-link users may edit shared content.
    public let canEdit: Bool?

    /// Whether connected users may request access from the share-link.
    public let canRequestAccess: Bool?

    /// Whether share-link users may see file information.
    public let canSeeInfo: Bool?

    /// Whether share-link users may see statistics.
    public let canSeeStats: Bool?

    /// Password used when `right` is `password`.
    public let password: String?

    /// Permission of the shared link: `public`, `inherit`, or `password`.
    public let right: String?

    /// Maximum validity timestamp of the share-link.
    public let validUntil: Int?

    public enum CodingKeys: String, CodingKey {
        case canComment = "can_comment"
        case canDownload = "can_download"
        case canEdit = "can_edit"
        case canRequestAccess = "can_request_access"
        case canSeeInfo = "can_see_info"
        case canSeeStats = "can_see_stats"
        case password
        case right
        case validUntil = "valid_until"
    }

    /// Creates options for updating a kDrive file share-link.
    public init(
        canComment: Bool? = nil,
        canDownload: Bool? = nil,
        canEdit: Bool? = nil,
        canRequestAccess: Bool? = nil,
        canSeeInfo: Bool? = nil,
        canSeeStats: Bool? = nil,
        password: String? = nil,
        right: String? = nil,
        validUntil: Int? = nil
    ) {
        self.canComment = canComment
        self.canDownload = canDownload
        self.canEdit = canEdit
        self.canRequestAccess = canRequestAccess
        self.canSeeInfo = canSeeInfo
        self.canSeeStats = canSeeStats
        self.password = password
        self.right = right
        self.validUntil = validUntil
    }
}

/// A user access entry for a kDrive file or directory.
public struct KDriveFileAccessUser: Codable, Equatable, Sendable {
    /// Raw user access payload returned by the API.
    public let values: [String: KDriveJSONValue]

    public init(values: [String: KDriveJSONValue]) {
        self.values = values
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.values = try container.decode([String: KDriveJSONValue].self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(values)
    }
}

/// A team access entry for a kDrive file or directory.
public struct KDriveFileAccessTeam: Codable, Equatable, Sendable {
    /// Raw team access payload returned by the API.
    public let values: [String: KDriveJSONValue]

    public init(values: [String: KDriveJSONValue]) {
        self.values = values
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.values = try container.decode([String: KDriveJSONValue].self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(values)
    }
}
