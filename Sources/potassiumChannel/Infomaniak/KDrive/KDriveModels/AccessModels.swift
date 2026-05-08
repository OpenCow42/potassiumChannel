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
