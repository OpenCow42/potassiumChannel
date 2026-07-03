import Foundation
import PotassiumChannelCore

/// JSON body accepted by the kDrive rename endpoint.
public struct RenameKDriveFileOptions: Encodable, Equatable, Sendable {
    /// New name for the file or directory.
    public let name: String

    /// Creates options for renaming a kDrive file or directory.
    public init(name: String) {
        self.name = name
    }
}

/// JSON body accepted by the kDrive archive build endpoint.
public struct BuildKDriveArchiveOptions: Encodable, Equatable, Sendable {
    /// File identifiers to include in the archive. Required when `parentId` is not set.
    public let fileIds: [Int]?

    /// Directory containing files to include in the archive. Required when `fileIds` is not set.
    public let parentId: Int?

    /// File identifiers to exclude when building an archive from `parentId`.
    public let exceptFileIds: [Int]?

    public enum CodingKeys: String, CodingKey {
        case fileIds = "file_ids"
        case parentId = "parent_id"
        case exceptFileIds = "except_file_ids"
    }

    /// Creates options for building a kDrive archive.
    public init(fileIds: [Int]? = nil, parentId: Int? = nil, exceptFileIds: [Int]? = nil) {
        self.fileIds = fileIds
        self.parentId = parentId
        self.exceptFileIds = exceptFileIds
    }
}

/// JSON body accepted by the kDrive create default file endpoint.
public struct CreateKDriveDefaultFileOptions: Encodable, Equatable, Sendable {
    /// Name of the default file to create.
    public let name: String

    /// Extension/type of file to create, such as `docx`, `drawio`, `pptx`, `txt`, or `xlsx`.
    public let type: String

    /// Creates options for creating a default kDrive file.
    public init(name: String, type: String) {
        self.name = name
        self.type = type
    }
}

/// JSON body accepted by the kDrive create directory endpoint.
public struct CreateKDriveDirectoryOptions: Encodable, Equatable, Sendable {
    /// Name of the directory to create.
    public let name: String

    /// Optional color of the directory for the user creating it, such as `#0098ff`.
    public let color: String?

    /// Whether to create the directory only for the authenticated user.
    public let onlyForMe: Bool?

    /// Optional relative path to create from the destination directory.
    public let relativePath: String?

    public enum CodingKeys: String, CodingKey {
        case name
        case color
        case onlyForMe = "only_for_me"
        case relativePath = "relative_path"
    }

    /// Creates options for creating a kDrive directory.
    public init(
        name: String,
        color: String? = nil,
        onlyForMe: Bool? = nil,
        relativePath: String? = nil
    ) {
        self.name = name
        self.color = color
        self.onlyForMe = onlyForMe
        self.relativePath = relativePath
    }
}

/// JSON body accepted by the kDrive file copy endpoint.
public struct CopyKDriveFileOptions: Encodable, Equatable, Sendable {
    /// Conflict behavior: `error`, `rename`, or `version`.
    public let conflict: String?

    /// Optional name for the copied file or directory.
    public let name: String?

    /// Creates options for copying a kDrive file or directory.
    public init(conflict: String? = nil, name: String? = nil) {
        self.conflict = conflict
        self.name = name
    }
}

/// JSON body accepted by the kDrive file move endpoint.
public struct MoveKDriveFileOptions: Encodable, Equatable, Sendable {
    /// Conflict behavior: `error` or `rename`.
    public let conflict: String?

    /// Optional name for the moved file or directory.
    public let name: String?

    /// Creates options for moving a kDrive file or directory.
    public init(conflict: String? = nil, name: String? = nil) {
        self.conflict = conflict
        self.name = name
    }
}

/// JSON body accepted by the kDrive restore trashed file endpoint.
public struct RestoreKDriveTrashedFileOptions: Encodable, Equatable, Sendable {
    /// Directory where the trashed file or directory should be restored.
    public let destinationDirectoryId: Int

    public enum CodingKeys: String, CodingKey {
        case destinationDirectoryId = "destination_directory_id"
    }

    /// Creates options for restoring a trashed kDrive file or directory.
    public init(destinationDirectoryId: Int) {
        self.destinationDirectoryId = destinationDirectoryId
    }
}

/// JSON body accepted by the kDrive file duplicate endpoint.
public struct DuplicateKDriveFileOptions: Encodable, Equatable, Sendable {
    /// Optional name for the duplicated file or directory.
    public let name: String?

    /// Creates options for duplicating a kDrive file or directory.
    public init(name: String? = nil) {
        self.name = name
    }
}

/// JSON body accepted by the kDrive update modification date endpoint.
public struct UpdateKDriveFileLastModifiedOptions: Encodable, Equatable, Sendable {
    /// Unix timestamp to store as the file modification date.
    public let lastModifiedAt: Int

    enum CodingKeys: String, CodingKey {
        case lastModifiedAt = "last_modified_at"
    }

    /// Creates options for updating a kDrive file modification date.
    public init(lastModifiedAt: Int) {
        self.lastModifiedAt = lastModifiedAt
    }
}
