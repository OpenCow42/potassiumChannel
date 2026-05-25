import Foundation

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
