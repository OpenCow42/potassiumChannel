import Foundation

/// Included-resource presets used by kDrive advanced listing endpoints.
public enum KDriveAdvancedListingIncludedResources {
    /// Minimal file resources used by the official kDrive advanced listing flow.
    public static let minimalFiles = [
        "files",
        "files.capabilities",
        "files.categories",
        "files.conversion_capabilities",
        "files.dropbox",
        "files.dropbox.capabilities",
        "files.external_import",
        "files.is_favorite",
        "files.sharelink",
        "files.sorted_name",
        "files.supported_by",
    ].joined(separator: ",")

    /// File resource used by the partial file activity listing endpoint.
    public static let file = "file"
}

/// Query parameters accepted by the kDrive advanced directory listing endpoint.
public struct ListKDriveAdvancedDirectoryListingOptions: Equatable, Sendable {
    /// The maximum number of items returned.
    public let limit: Int?

    /// Sort fields, such as `type`, `name`, or `updated_at`.
    public let orderBy: [String]

    /// Default sorting direction.
    public let order: String?

    /// Per-field sorting directions keyed by order field.
    public let orderFor: [String: String]

    /// Creates options for listing files and actions in a kDrive directory.
    public init(
        limit: Int? = nil,
        orderBy: [String] = [],
        order: String? = nil,
        orderFor: [String: String] = [:]
    ) {
        self.limit = limit
        self.orderBy = orderBy
        self.order = order
        self.orderFor = orderFor
    }
}

/// Query parameters accepted by the kDrive advanced directory listing continuation endpoint.
public struct ContinueKDriveAdvancedDirectoryListingOptions: Equatable, Sendable {
    /// The maximum number of items returned.
    public let limit: Int?

    /// Sort fields, such as `type`, `name`, or `updated_at`.
    public let orderBy: [String]

    /// Default sorting direction.
    public let order: String?

    /// Per-field sorting directions keyed by order field.
    public let orderFor: [String: String]

    /// Creates options for continuing an advanced kDrive directory listing.
    public init(
        limit: Int? = nil,
        orderBy: [String] = [],
        order: String? = nil,
        orderFor: [String: String] = [:]
    ) {
        self.limit = limit
        self.orderBy = orderBy
        self.order = order
        self.orderFor = orderFor
    }
}

/// Files and actions returned by kDrive advanced directory listing endpoints.
public struct KDriveAdvancedDirectoryListing: Codable, Equatable, Sendable {
    /// Actions that occurred since the supplied listing cursor, oldest first.
    public let actions: [KDriveAdvancedDirectoryListingAction]

    /// The listing actions ordered newest first for latest-state reducers.
    ///
    /// kDrive returns `actions` chronologically. Consumers that retain the first
    /// action for each item or property should use this view so the newest state
    /// wins.
    public var actionsNewestFirst: [KDriveAdvancedDirectoryListingAction] {
        actions.reversed()
    }

    /// Files and directories in the listed directory.
    public let files: [KDriveFileItem]

    /// Files referenced by listing actions.
    public let actionsFiles: [KDriveFileItem]

    /// Creates an advanced directory listing value.
    public init(
        actions: [KDriveAdvancedDirectoryListingAction],
        files: [KDriveFileItem],
        actionsFiles: [KDriveFileItem]
    ) {
        self.actions = actions
        self.files = files
        self.actionsFiles = actionsFiles
    }
}

/// A file action returned by kDrive advanced directory listing endpoints.
public struct KDriveAdvancedDirectoryListingAction: Codable, Equatable, Sendable {
    /// The raw kDrive action name, such as `file_create`, `file_update`, or `file_delete`.
    public let action: String

    /// The affected file or directory identifier.
    public let fileId: Int

    /// The affected parent directory identifier.
    public let parentId: Int

    /// Creates an advanced directory listing action value.
    public init(action: String, fileId: Int, parentId: Int) {
        self.action = action
        self.fileId = fileId
        self.parentId = parentId
    }
}

/// JSON body accepted by the kDrive partial file activity listing endpoint.
public struct ListKDrivePartialFileActivitiesOptions: Encodable, Equatable, Sendable {
    /// Activity action filters included in the partial listing check.
    public let actions: [String]

    /// Files to check for recent activity.
    public let files: [KDrivePartialFileActivityRequestFile]

    /// Creates options for listing recent activity for specific kDrive files.
    public init(
        actions: [String] = ["file_delete", "file_trash", "file_update", "file_rename"],
        files: [KDrivePartialFileActivityRequestFile]
    ) {
        self.actions = actions
        self.files = files
    }
}

/// A file entry in a kDrive partial file activity listing request body.
public struct KDrivePartialFileActivityRequestFile: Encodable, Equatable, Sendable {
    /// The file or directory identifier to check.
    public let id: Int

    /// The timestamp from which activity should be checked.
    public let fromDate: Int

    public enum CodingKeys: String, CodingKey {
        case id
        case fromDate = "from_date"
    }

    /// Creates a partial file activity request file value.
    public init(id: Int, fromDate: Int) {
        self.id = id
        self.fromDate = fromDate
    }
}

/// A partial activity result for a specific kDrive file or directory.
public struct KDrivePartialFileActivity: Codable, Equatable, Sendable {
    /// The last matching activity action, when one exists.
    public let lastAction: String?

    /// The checked file or directory identifier.
    public let fileId: Int

    /// The timestamp of the last matching action, when one exists.
    public let lastActionAt: Int?

    /// The current file metadata, when returned and the file still exists.
    public let file: KDriveFileItem?

    /// Creates a partial file activity value.
    public init(lastAction: String?, fileId: Int, lastActionAt: Int?, file: KDriveFileItem?) {
        self.lastAction = lastAction
        self.fileId = fileId
        self.lastActionAt = lastActionAt
        self.file = file
    }
}
