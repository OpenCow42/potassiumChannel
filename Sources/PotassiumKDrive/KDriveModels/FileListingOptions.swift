import Foundation
import PotassiumChannelCore

/// Query parameters accepted by the kDrive trash listing endpoint.
public struct ListKDriveTrashOptions: Equatable, Sendable {
    /// Cursor marker used to fetch the next batch of results.
    public let cursor: String?

    /// The maximum number of items returned.
    public let limit: Int?

    /// Sort fields, such as `deleted_at`, `name`, or `updated_at`.
    public let orderBy: [String]

    /// Default sorting direction.
    public let order: String?

    /// Per-field sorting directions keyed by order field.
    public let orderFor: [String: String]

    /// File structure types to include, such as `dir`, `file`, or `vault`.
    public let types: [String]

    /// Creates options for listing kDrive trash.
    public init(
        cursor: String? = nil,
        limit: Int? = nil,
        orderBy: [String] = [],
        order: String? = nil,
        orderFor: [String: String] = [:],
        types: [String] = []
    ) {
        self.cursor = cursor
        self.limit = limit
        self.orderBy = orderBy
        self.order = order
        self.orderFor = orderFor
        self.types = types
    }
}

/// Query parameters accepted by the kDrive directory file listing endpoint.
public struct ListKDriveDirectoryFilesOptions: Equatable, Sendable {
    /// Cursor marker used to fetch the next batch of results.
    public let cursor: String?

    /// The maximum number of items returned.
    public let limit: Int?

    /// Sort fields, such as `added_at`, `name`, or `updated_at`.
    public let orderBy: [String]

    /// Default sorting direction.
    public let order: String?

    /// Per-field sorting directions keyed by order field.
    public let orderFor: [String: String]

    /// Listing depth. The API disallows this on file identifier `1`.
    public let depth: String?

    /// File structure types to include, such as `dir`, `file`, or `vault`.
    public let types: [String]

    /// Creates options for listing files in a kDrive directory.
    public init(
        cursor: String? = nil,
        limit: Int? = nil,
        orderBy: [String] = [],
        order: String? = nil,
        orderFor: [String: String] = [:],
        depth: String? = nil,
        types: [String] = []
    ) {
        self.cursor = cursor
        self.limit = limit
        self.orderBy = orderBy
        self.order = order
        self.orderFor = orderFor
        self.depth = depth
        self.types = types
    }
}

/// Query parameters accepted by the kDrive trashed file endpoint.
public struct GetKDriveTrashedFileOptions: Equatable, Sendable {
    /// Sort fields, such as `deleted_at`, `name`, or `path`.
    public let orderBy: [String]

    /// Default sorting direction.
    public let order: String?

    /// Per-field sorting directions keyed by order field.
    public let orderFor: [String: String]

    /// Creates options for getting a kDrive trashed file.
    public init(
        orderBy: [String] = [],
        order: String? = nil,
        orderFor: [String: String] = [:]
    ) {
        self.orderBy = orderBy
        self.order = order
        self.orderFor = orderFor
    }
}

/// Query parameters accepted by the kDrive trashed directory files endpoint.
public struct ListKDriveTrashedDirectoryFilesOptions: Equatable, Sendable {
    /// Cursor marker used to fetch the next batch of results.
    public let cursor: String?

    /// The maximum number of items returned.
    public let limit: Int?

    /// Sort fields, such as `deleted_at`, `name`, or `updated_at`.
    public let orderBy: [String]

    /// Default sorting direction.
    public let order: String?

    /// Per-field sorting directions keyed by order field.
    public let orderFor: [String: String]

    /// File structure types to include, such as `dir`, `file`, or `vault`.
    public let types: [String]

    /// Creates options for listing files in a kDrive trashed directory.
    public init(
        cursor: String? = nil,
        limit: Int? = nil,
        orderBy: [String] = [],
        order: String? = nil,
        orderFor: [String: String] = [:],
        types: [String] = []
    ) {
        self.cursor = cursor
        self.limit = limit
        self.orderBy = orderBy
        self.order = order
        self.orderFor = orderFor
        self.types = types
    }
}
