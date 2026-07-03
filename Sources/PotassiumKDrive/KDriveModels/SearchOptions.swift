import Foundation
import PotassiumChannelCore

/// Query parameters accepted by the kDrive file search endpoint.
public struct SearchKDriveFilesOptions: Equatable, Sendable {
    /// Cursor marker used to fetch the next batch of results.
    public let cursor: String?

    /// The maximum number of items returned.
    public let limit: Int?

    /// Sort fields, such as `last_modified_at` or `relevance`.
    public let orderBy: [String]

    /// Default sorting direction.
    public let order: String?

    /// Per-field sorting directions keyed by order field.
    public let orderFor: [String: String]

    /// Author identifier to filter by.
    public let authorId: Int?

    /// Category pattern to filter by.
    public let category: String?

    /// Search depth, such as `child` or `unlimited`.
    public let depth: String?

    /// Directory identifier to search within.
    public let directoryId: Int?

    /// File extensions to include.
    public let extensions: [String]

    /// Lower bound for last modification timestamp.
    public let modifiedAfter: Int?

    /// Relative last modification period.
    public let modifiedAt: String?

    /// Upper bound for last modification timestamp.
    public let modifiedBefore: Int?

    /// Name filter.
    public let name: String?

    /// Search query.
    public let query: String?

    /// Query scope, such as `all`, `content`, or `filename`.
    public let queryScope: String?

    /// File types to include.
    public let types: [String]

    /// Creates options for searching kDrive files and directories.
    public init(
        cursor: String? = nil,
        limit: Int? = nil,
        orderBy: [String] = [],
        order: String? = nil,
        orderFor: [String: String] = [:],
        authorId: Int? = nil,
        category: String? = nil,
        depth: String? = nil,
        directoryId: Int? = nil,
        extensions: [String] = [],
        modifiedAfter: Int? = nil,
        modifiedAt: String? = nil,
        modifiedBefore: Int? = nil,
        name: String? = nil,
        query: String? = nil,
        queryScope: String? = nil,
        types: [String] = []
    ) {
        self.cursor = cursor
        self.limit = limit
        self.orderBy = orderBy
        self.order = order
        self.orderFor = orderFor
        self.authorId = authorId
        self.category = category
        self.depth = depth
        self.directoryId = directoryId
        self.extensions = extensions
        self.modifiedAfter = modifiedAfter
        self.modifiedAt = modifiedAt
        self.modifiedBefore = modifiedBefore
        self.name = name
        self.query = query
        self.queryScope = queryScope
        self.types = types
    }
}

/// Query parameters accepted by the kDrive favorite file search endpoint.
public struct SearchKDriveFavoritesOptions: Equatable, Sendable {
    /// Cursor marker used to fetch the next batch of results.
    public let cursor: String?

    /// The maximum number of items returned.
    public let limit: Int?

    /// Sort fields, such as `last_modified_at` or `relevance`.
    public let orderBy: [String]

    /// Default sorting direction.
    public let order: String?

    /// Per-field sorting directions keyed by order field.
    public let orderFor: [String: String]

    /// Author identifier to filter by.
    public let authorId: Int?

    /// Category pattern to filter by.
    public let category: String?

    /// Search depth, such as `child` or `unlimited`.
    public let depth: String?

    /// Directory identifier to search within.
    public let directoryId: Int?

    /// File extensions to include.
    public let extensions: [String]

    /// Lower bound for last modification timestamp.
    public let modifiedAfter: Int?

    /// Relative last modification period.
    public let modifiedAt: String?

    /// Upper bound for last modification timestamp.
    public let modifiedBefore: Int?

    /// Name filter.
    public let name: String?

    /// Search query.
    public let query: String?

    /// Query scope, such as `all`, `content`, or `filename`.
    public let queryScope: String?

    /// File types to include.
    public let types: [String]

    /// Creates options for searching favorite kDrive files and directories.
    public init(
        cursor: String? = nil,
        limit: Int? = nil,
        orderBy: [String] = [],
        order: String? = nil,
        orderFor: [String: String] = [:],
        authorId: Int? = nil,
        category: String? = nil,
        depth: String? = nil,
        directoryId: Int? = nil,
        extensions: [String] = [],
        modifiedAfter: Int? = nil,
        modifiedAt: String? = nil,
        modifiedBefore: Int? = nil,
        name: String? = nil,
        query: String? = nil,
        queryScope: String? = nil,
        types: [String] = []
    ) {
        self.cursor = cursor
        self.limit = limit
        self.orderBy = orderBy
        self.order = order
        self.orderFor = orderFor
        self.authorId = authorId
        self.category = category
        self.depth = depth
        self.directoryId = directoryId
        self.extensions = extensions
        self.modifiedAfter = modifiedAfter
        self.modifiedAt = modifiedAt
        self.modifiedBefore = modifiedBefore
        self.name = name
        self.query = query
        self.queryScope = queryScope
        self.types = types
    }
}

/// Query parameters accepted by the kDrive my-shared file search endpoint.
public struct SearchKDriveMySharedOptions: Equatable, Sendable {
    /// Cursor marker used to fetch the next batch of results.
    public let cursor: String?

    /// The maximum number of items returned.
    public let limit: Int?

    /// Sort fields, such as `last_modified_at` or `relevance`.
    public let orderBy: [String]

    /// Default sorting direction.
    public let order: String?

    /// Per-field sorting directions keyed by order field.
    public let orderFor: [String: String]

    /// Author identifier to filter by.
    public let authorId: Int?

    /// Category pattern to filter by.
    public let category: String?

    /// Search depth, such as `child` or `unlimited`.
    public let depth: String?

    /// Directory identifier to search within.
    public let directoryId: Int?

    /// File extensions to include.
    public let extensions: [String]

    /// Lower bound for last modification timestamp.
    public let modifiedAfter: Int?

    /// Relative last modification period.
    public let modifiedAt: String?

    /// Upper bound for last modification timestamp.
    public let modifiedBefore: Int?

    /// Name filter.
    public let name: String?

    /// Search query.
    public let query: String?

    /// Query scope, such as `all`, `content`, or `filename`.
    public let queryScope: String?

    /// File types to include.
    public let types: [String]

    /// Creates options for searching kDrive files and directories shared by the user.
    public init(
        cursor: String? = nil,
        limit: Int? = nil,
        orderBy: [String] = [],
        order: String? = nil,
        orderFor: [String: String] = [:],
        authorId: Int? = nil,
        category: String? = nil,
        depth: String? = nil,
        directoryId: Int? = nil,
        extensions: [String] = [],
        modifiedAfter: Int? = nil,
        modifiedAt: String? = nil,
        modifiedBefore: Int? = nil,
        name: String? = nil,
        query: String? = nil,
        queryScope: String? = nil,
        types: [String] = []
    ) {
        self.cursor = cursor
        self.limit = limit
        self.orderBy = orderBy
        self.order = order
        self.orderFor = orderFor
        self.authorId = authorId
        self.category = category
        self.depth = depth
        self.directoryId = directoryId
        self.extensions = extensions
        self.modifiedAfter = modifiedAfter
        self.modifiedAt = modifiedAt
        self.modifiedBefore = modifiedBefore
        self.name = name
        self.query = query
        self.queryScope = queryScope
        self.types = types
    }
}

/// Query parameters accepted by the kDrive shared-with-me file search endpoint.
public struct SearchKDriveSharedWithMeOptions: Equatable, Sendable {
    /// Cursor marker used to fetch the next batch of results.
    public let cursor: String?

    /// The maximum number of items returned.
    public let limit: Int?

    /// Sort fields, such as `last_modified_at` or `relevance`.
    public let orderBy: [String]

    /// Default sorting direction.
    public let order: String?

    /// Per-field sorting directions keyed by order field.
    public let orderFor: [String: String]

    /// Author identifier to filter by.
    public let authorId: Int?

    /// Category pattern to filter by.
    public let category: String?

    /// Search depth, such as `child` or `unlimited`.
    public let depth: String?

    /// Directory identifier to search within.
    public let directoryId: Int?

    /// File extensions to include.
    public let extensions: [String]

    /// Lower bound for last modification timestamp.
    public let modifiedAfter: Int?

    /// Relative last modification period.
    public let modifiedAt: String?

    /// Upper bound for last modification timestamp.
    public let modifiedBefore: Int?

    /// Name filter.
    public let name: String?

    /// Search query.
    public let query: String?

    /// Query scope, such as `all`, `content`, or `filename`.
    public let queryScope: String?

    /// File types to include.
    public let types: [String]

    /// Creates options for searching kDrive files and directories shared with the user.
    public init(
        cursor: String? = nil,
        limit: Int? = nil,
        orderBy: [String] = [],
        order: String? = nil,
        orderFor: [String: String] = [:],
        authorId: Int? = nil,
        category: String? = nil,
        depth: String? = nil,
        directoryId: Int? = nil,
        extensions: [String] = [],
        modifiedAfter: Int? = nil,
        modifiedAt: String? = nil,
        modifiedBefore: Int? = nil,
        name: String? = nil,
        query: String? = nil,
        queryScope: String? = nil,
        types: [String] = []
    ) {
        self.cursor = cursor
        self.limit = limit
        self.orderBy = orderBy
        self.order = order
        self.orderFor = orderFor
        self.authorId = authorId
        self.category = category
        self.depth = depth
        self.directoryId = directoryId
        self.extensions = extensions
        self.modifiedAfter = modifiedAfter
        self.modifiedAt = modifiedAt
        self.modifiedBefore = modifiedBefore
        self.name = name
        self.query = query
        self.queryScope = queryScope
        self.types = types
    }
}

/// Query parameters accepted by the kDrive trash search endpoint.
public struct SearchKDriveTrashOptions: Equatable, Sendable {
    /// Cursor marker used to fetch the next batch of results.
    public let cursor: String?

    /// The maximum number of items returned.
    public let limit: Int?

    /// Sort fields, such as `last_modified_at` or `relevance`.
    public let orderBy: [String]

    /// Default sorting direction.
    public let order: String?

    /// Per-field sorting directions keyed by order field.
    public let orderFor: [String: String]

    /// Author identifier to filter by.
    public let authorId: Int?

    /// Category pattern to filter by.
    public let category: String?

    /// Lower bound for deletion timestamp.
    public let deletedAfter: Int?

    /// Relative deletion period.
    public let deletedAt: String?

    /// Upper bound for deletion timestamp.
    public let deletedBefore: Int?

    /// User identifier that deleted the file.
    public let deletedBy: Int?

    /// Search query.
    public let query: String?

    /// Query scope, such as `all`, `content`, or `filename`.
    public let queryScope: String?

    /// File types to include.
    public let types: [String]

    /// Creates options for searching kDrive trash.
    public init(
        cursor: String? = nil,
        limit: Int? = nil,
        orderBy: [String] = [],
        order: String? = nil,
        orderFor: [String: String] = [:],
        authorId: Int? = nil,
        category: String? = nil,
        deletedAfter: Int? = nil,
        deletedAt: String? = nil,
        deletedBefore: Int? = nil,
        deletedBy: Int? = nil,
        query: String? = nil,
        queryScope: String? = nil,
        types: [String] = []
    ) {
        self.cursor = cursor
        self.limit = limit
        self.orderBy = orderBy
        self.order = order
        self.orderFor = orderFor
        self.authorId = authorId
        self.category = category
        self.deletedAfter = deletedAfter
        self.deletedAt = deletedAt
        self.deletedBefore = deletedBefore
        self.deletedBy = deletedBy
        self.query = query
        self.queryScope = queryScope
        self.types = types
    }
}

/// Query parameters accepted by the kDrive dropbox search endpoint.
public struct SearchKDriveDropboxesOptions: Equatable, Sendable {
    /// Cursor marker used to fetch the next batch of results.
    public let cursor: String?

    /// The maximum number of items returned.
    public let limit: Int?

    /// Sort fields, such as `last_modified_at` or `relevance`.
    public let orderBy: [String]

    /// Default sorting direction.
    public let order: String?

    /// Per-field sorting directions keyed by order field.
    public let orderFor: [String: String]

    /// Author identifier to filter by.
    public let authorId: Int?

    /// Category pattern to filter by.
    public let category: String?

    /// Lower bound for creation timestamp.
    public let createdAfter: Int?

    /// Relative creation period.
    public let createdAt: String?

    /// Upper bound for creation timestamp.
    public let createdBefore: Int?

    /// Expiration filter, such as `any`, `yes`, or `no`.
    public let expires: String?

    /// Password filter, such as `any`, `yes`, or `no`.
    public let hasPassword: String?

    /// Lower bound for last import timestamp.
    public let lastImportAfter: Int?

    /// Relative last import period.
    public let lastImportAt: String?

    /// Upper bound for last import timestamp.
    public let lastImportBefore: Int?

    /// Search query.
    public let query: String?

    /// Query scope, such as `all`, `content`, or `filename`.
    public let queryScope: String?

    /// Creates options for searching kDrive dropbox directories.
    public init(
        cursor: String? = nil,
        limit: Int? = nil,
        orderBy: [String] = [],
        order: String? = nil,
        orderFor: [String: String] = [:],
        authorId: Int? = nil,
        category: String? = nil,
        createdAfter: Int? = nil,
        createdAt: String? = nil,
        createdBefore: Int? = nil,
        expires: String? = nil,
        hasPassword: String? = nil,
        lastImportAfter: Int? = nil,
        lastImportAt: String? = nil,
        lastImportBefore: Int? = nil,
        query: String? = nil,
        queryScope: String? = nil
    ) {
        self.cursor = cursor
        self.limit = limit
        self.orderBy = orderBy
        self.order = order
        self.orderFor = orderFor
        self.authorId = authorId
        self.category = category
        self.createdAfter = createdAfter
        self.createdAt = createdAt
        self.createdBefore = createdBefore
        self.expires = expires
        self.hasPassword = hasPassword
        self.lastImportAfter = lastImportAfter
        self.lastImportAt = lastImportAt
        self.lastImportBefore = lastImportBefore
        self.query = query
        self.queryScope = queryScope
    }
}

/// Query parameters accepted by the kDrive share-link search endpoint.
public struct SearchKDriveShareLinksOptions: Equatable, Sendable {
    /// Cursor marker used to fetch the next batch of results.
    public let cursor: String?

    /// The maximum number of items returned.
    public let limit: Int?

    /// Sort fields, such as `last_modified_at` or `relevance`.
    public let orderBy: [String]

    /// Default sorting direction.
    public let order: String?

    /// Per-field sorting directions keyed by order field.
    public let orderFor: [String: String]

    /// Author identifier to filter by.
    public let authorId: Int?

    /// Category pattern to filter by.
    public let category: String?

    /// Lower bound for creation timestamp.
    public let createdAfter: Int?

    /// Relative creation period.
    public let createdAt: String?

    /// Upper bound for creation timestamp.
    public let createdBefore: Int?

    /// Expiration filter, such as `any`, `yes`, or `no`.
    public let expires: String?

    /// Password filter, such as `any`, `yes`, or `no`.
    public let hasPassword: String?

    /// Search query.
    public let query: String?

    /// Query scope, such as `all`, `content`, or `filename`.
    public let queryScope: String?

    /// Creates options for searching kDrive files and directories with share links.
    public init(
        cursor: String? = nil,
        limit: Int? = nil,
        orderBy: [String] = [],
        order: String? = nil,
        orderFor: [String: String] = [:],
        authorId: Int? = nil,
        category: String? = nil,
        createdAfter: Int? = nil,
        createdAt: String? = nil,
        createdBefore: Int? = nil,
        expires: String? = nil,
        hasPassword: String? = nil,
        query: String? = nil,
        queryScope: String? = nil
    ) {
        self.cursor = cursor
        self.limit = limit
        self.orderBy = orderBy
        self.order = order
        self.orderFor = orderFor
        self.authorId = authorId
        self.category = category
        self.createdAfter = createdAfter
        self.createdAt = createdAt
        self.createdBefore = createdBefore
        self.expires = expires
        self.hasPassword = hasPassword
        self.query = query
        self.queryScope = queryScope
    }
}
