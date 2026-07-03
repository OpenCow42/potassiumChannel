import Foundation
import PotassiumChannelCore

/// A kDrive file or directory item returned by the v3 file-list APIs.
public struct KDriveFileItem: Codable, Equatable, Sendable {
    /// The unique file or directory identifier.
    public let id: Int

    /// The display name.
    public let name: String

    /// The item type, when available.
    public let type: String?

    /// The item status.
    public let status: String

    /// The item visibility.
    public let visibility: String

    /// The owning drive identifier.
    public let driveId: Int

    /// The parent directory identifier.
    public let parentId: Int

    /// The full item path, when returned.
    public let path: String?

    /// The item depth in the drive tree.
    public let depth: Int

    /// The creation timestamp, when available.
    public let createdAt: Int?

    /// The last modification timestamp.
    public let lastModifiedAt: Int

    /// The update timestamp.
    public let updatedAt: Int

    /// File size in bytes, when the item is a file.
    public let size: Int?

    /// MIME type, when the item is a file.
    public let mimeType: String?

    /// Whether the item is marked as favorite, when returned.
    public let isFavorite: Bool?

    /// Creates a kDrive file item value.
    public init(
        id: Int,
        name: String,
        type: String?,
        status: String,
        visibility: String,
        driveId: Int,
        parentId: Int,
        path: String?,
        depth: Int,
        createdAt: Int?,
        lastModifiedAt: Int,
        updatedAt: Int,
        size: Int? = nil,
        mimeType: String? = nil,
        isFavorite: Bool? = nil
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.status = status
        self.visibility = visibility
        self.driveId = driveId
        self.parentId = parentId
        self.path = path
        self.depth = depth
        self.createdAt = createdAt
        self.lastModifiedAt = lastModifiedAt
        self.updatedAt = updatedAt
        self.size = size
        self.mimeType = mimeType
        self.isFavorite = isFavorite
    }
}

/// Dropbox metadata for a kDrive file or directory.
public struct KDriveFileDropbox: Codable, Equatable, Sendable {
    /// Raw dropbox payload returned by the API.
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

/// JSON body accepted by the v3 create Dropbox endpoint.
public struct CreateKDriveDropboxOptions: Encodable, Equatable, Sendable {
    /// Name of the Dropbox directory to create.
    public let name: String

    /// Parent directory identifier in which the Dropbox should be created.
    public let parentDirectoryId: Int?

    public enum CodingKeys: String, CodingKey {
        case name
        case parentDirectoryId = "parent_directory_id"
    }

    /// Creates options for creating a kDrive Dropbox directory.
    public init(name: String, parentDirectoryId: Int? = nil) {
        self.name = name
        self.parentDirectoryId = parentDirectoryId
    }
}

/// JSON body accepted by the kDrive create and update file Dropbox endpoints.
public struct KDriveFileDropboxOptions: Encodable, Equatable, Sendable {
    /// Alias of the Dropbox.
    public let alias: String?

    /// Whether kDrive should send an email when the Dropbox upload is finished.
    public let emailWhenFinished: Bool?

    /// Maximum accepted file size in bytes.
    public let limitFileSize: Int?

    /// Password used to protect the Dropbox.
    public let password: String?

    /// Maximum validity timestamp.
    public let validUntil: Int?

    public enum CodingKeys: String, CodingKey {
        case alias
        case emailWhenFinished = "email_when_finished"
        case limitFileSize = "limit_file_size"
        case password
        case validUntil = "valid_until"
    }

    /// Creates options for creating or updating a kDrive file Dropbox.
    public init(
        alias: String? = nil,
        emailWhenFinished: Bool? = nil,
        limitFileSize: Int? = nil,
        password: String? = nil,
        validUntil: Int? = nil
    ) {
        self.alias = alias
        self.emailWhenFinished = emailWhenFinished
        self.limitFileSize = limitFileSize
        self.password = password
        self.validUntil = validUntil
    }
}

/// A category configured on a kDrive.
public struct KDriveCategory: Codable, Equatable, Sendable {
    /// The unique category identifier.
    public let id: Int

    /// The category display name.
    public let name: String

    /// The display color as a hexadecimal string.
    public let color: String

    /// Whether this category is predefined by the system.
    public let isPredefined: Bool

    /// The user identifier that created the category.
    public let createdBy: Int

    /// The creation timestamp.
    public let createdAt: Int

    /// The number of times the authenticated user uses this category, when returned.
    public let userUses: Int?

    /// Creates a kDrive category value.
    public init(id: Int, name: String, color: String, isPredefined: Bool, createdBy: Int, createdAt: Int, userUses: Int? = nil) {
        self.id = id
        self.name = name
        self.color = color
        self.isPredefined = isPredefined
        self.createdBy = createdBy
        self.createdAt = createdAt
        self.userUses = userUses
    }
}

/// Options for creating a kDrive category.
public struct CreateKDriveCategoryOptions: Encodable, Equatable, Sendable {
    /// Category display name.
    public let name: String

    /// Display color as a hexadecimal string.
    public let color: String?

    /// Creates options for creating a kDrive category.
    public init(name: String, color: String? = nil) {
        self.name = name
        self.color = color
    }
}

/// Options for updating a kDrive category.
public struct UpdateKDriveCategoryOptions: Encodable, Equatable, Sendable {
    /// Category display name.
    public let name: String?

    /// Display color as a hexadecimal string.
    public let color: String?

    /// Creates options for updating a kDrive category.
    public init(name: String? = nil, color: String? = nil) {
        self.name = name
        self.color = color
    }
}

/// Options for applying a kDrive category to multiple files or directories.
public struct KDriveFileCategoryBulkOptions: Encodable, Equatable, Sendable {
    /// File or directory identifiers to act upon.
    public let fileIds: [Int]

    public enum CodingKeys: String, CodingKey {
        case fileIds = "file_ids"
    }

    /// Creates options for applying a category to multiple kDrive items.
    public init(fileIds: [Int]) {
        self.fileIds = fileIds
    }
}

/// Feedback returned after applying a category operation to a kDrive file or directory.
public struct KDriveFileCategoryFeedback: Codable, Equatable, Sendable {
    /// File or directory identifier affected by the operation.
    public let id: Int

    /// Whether the operation succeeded for the item.
    public let result: Bool

    /// Optional API message, usually present when `result` is false.
    public let message: String?

    /// Creates category operation feedback.
    public init(id: Int, result: Bool, message: String? = nil) {
        self.id = id
        self.result = result
        self.message = message
    }
}

/// Category permissions for the authenticated user on a kDrive.
public struct KDriveCategoryRights: Codable, Equatable, Sendable {
    /// Whether the user can create categories.
    public let canCreate: Bool

    /// Whether the user can edit categories.
    public let canEdit: Bool

    /// Whether the user can delete categories.
    public let canDelete: Bool

    /// Whether the user can read categories present on files.
    public let canReadOnFile: Bool

    /// Whether the user can add categories to files.
    public let canPutOnFile: Bool

    /// Creates a category rights value.
    public init(canCreate: Bool, canEdit: Bool, canDelete: Bool, canReadOnFile: Bool, canPutOnFile: Bool) {
        self.canCreate = canCreate
        self.canEdit = canEdit
        self.canDelete = canDelete
        self.canReadOnFile = canReadOnFile
        self.canPutOnFile = canPutOnFile
    }
}

/// Counts files and directories in a kDrive trash.
public struct KDriveTrashCount: Codable, Equatable, Sendable {
    /// Total number of items in trash.
    public let count: Int

    /// Number of files in trash.
    public let files: Int

    /// Number of directories in trash.
    public let directories: Int

    /// Creates a kDrive trash count value.
    public init(count: Int, files: Int, directories: Int) {
        self.count = count
        self.files = files
        self.directories = directories
    }
}

/// Counts files and directories inside a trashed kDrive item.
public typealias KDriveTrashedItemCount = KDriveDirectoryCount

/// Counts files and directories inside a trashed kDrive item using the deprecated v2 endpoint.
public typealias KDriveV2TrashedItemCount = KDriveDirectoryCount

/// Counts files and directories inside a kDrive directory.
public struct KDriveDirectoryCount: Codable, Equatable, Sendable {
    /// Total number of items in the directory.
    public let count: Int

    /// Number of files in the directory.
    public let files: Int

    /// Number of directories in the directory.
    public let directories: Int

    /// Creates a kDrive directory count value.
    public init(count: Int, files: Int, directories: Int) {
        self.count = count
        self.files = files
        self.directories = directories
    }
}

/// Total file and storage size for a kDrive file or directory.
public struct KDriveFileSize: Codable, Equatable, Sendable {
    /// Total size of files, in bytes.
    public let size: Int

    /// Total storage size including versions, in bytes.
    public let storageSize: Int

    /// Creates a kDrive file size value.
    public init(size: Int, storageSize: Int) {
        self.size = size
        self.storageSize = storageSize
    }
}

/// Content hash for a kDrive file.
public struct KDriveFileHash: Codable, Equatable, Sendable {
    /// Hash of the file content, including the algorithm prefix when returned by the API.
    public let hash: String

    /// Creates a kDrive file hash value.
    public init(hash: String) {
        self.hash = hash
    }
}

/// Temporary public URL for a kDrive file.
public struct KDriveFileTemporaryURL: Codable, Equatable, Sendable {
    /// Temporary URL for the file.
    public let temporaryUrl: String

    /// Creates a kDrive file temporary URL value.
    public init(temporaryUrl: String) {
        self.temporaryUrl = temporaryUrl
    }
}

/// JSON body accepted when restoring a kDrive file version as a copy.
public struct RestoreKDriveFileVersionToDirectoryOptions: Encodable, Equatable, Sendable {
    /// Optional name for the restored copy.
    public let name: String?

    /// Creates options for restoring a kDrive file version into a directory.
    public init(name: String? = nil) {
        self.name = name
    }
}

/// File metadata returned after restoring a kDrive file version.
public struct KDriveFileVersionRestoreResult: Codable, Equatable, Sendable {
    /// The restored file identifier.
    public let id: Int

    /// The restored file name.
    public let name: String

    /// The item type, when returned.
    public let type: String?

    /// The item status, when returned.
    public let status: String?

    /// The item visibility, when returned.
    public let visibility: String?

    /// The owning drive identifier, when returned.
    public let driveId: Int?

    /// The parent directory identifier, when returned.
    public let parentId: Int?

    /// The full item path, when returned.
    public let path: String?

    /// The item depth in the drive tree, when returned.
    public let depth: Int?

    /// The creation timestamp, when returned.
    public let createdAt: Int?

    /// The last modification timestamp, when returned.
    public let lastModifiedAt: Int?

    /// The update timestamp, when returned.
    public let updatedAt: Int?

    /// File size in bytes, when returned.
    public let size: Int?

    /// MIME type, when returned.
    public let mimeType: String?

    /// Whether the item is marked as favorite, when returned.
    public let isFavorite: Bool?

    /// Creates restored file version metadata.
    public init(
        id: Int,
        name: String,
        type: String? = nil,
        status: String? = nil,
        visibility: String? = nil,
        driveId: Int? = nil,
        parentId: Int? = nil,
        path: String? = nil,
        depth: Int? = nil,
        createdAt: Int? = nil,
        lastModifiedAt: Int? = nil,
        updatedAt: Int? = nil,
        size: Int? = nil,
        mimeType: String? = nil,
        isFavorite: Bool? = nil
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.status = status
        self.visibility = visibility
        self.driveId = driveId
        self.parentId = parentId
        self.path = path
        self.depth = depth
        self.createdAt = createdAt
        self.lastModifiedAt = lastModifiedAt
        self.updatedAt = updatedAt
        self.size = size
        self.mimeType = mimeType
        self.isFavorite = isFavorite
    }
}

/// A version of a kDrive file returned by the deprecated v2 versions endpoint.
public struct KDriveFileVersionV2: Codable, Equatable, Sendable {
    /// The unique file version identifier.
    public let id: Int

    /// Whether this version should be kept forever.
    public let keepForever: Bool

    /// MIME type for the version, when known.
    public let mimeType: String?

    /// Generic converted file type.
    public let convertedType: String

    /// Version name, when returned.
    public let name: String?

    /// Version size in bytes.
    public let size: Int

    /// The user that updated this file version.
    public let updatedBy: KDriveUser

    /// The creation timestamp.
    public let createdAt: Int

    /// The update timestamp, when known.
    public let updatedAt: Int?

    /// The last modified timestamp, when known.
    public let lastModifiedAt: Int?

    /// Creates a kDrive v2 file version value.
    public init(
        id: Int,
        keepForever: Bool,
        mimeType: String?,
        convertedType: String,
        name: String?,
        size: Int,
        updatedBy: KDriveUser,
        createdAt: Int,
        updatedAt: Int?,
        lastModifiedAt: Int?
    ) {
        self.id = id
        self.keepForever = keepForever
        self.mimeType = mimeType
        self.convertedType = convertedType
        self.name = name
        self.size = size
        self.updatedBy = updatedBy
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.lastModifiedAt = lastModifiedAt
    }
}

/// A version of a kDrive file.
public struct KDriveFileVersion: Codable, Equatable, Sendable {
    /// The unique file version identifier.
    public let id: Int

    /// Whether this version should be kept forever.
    public let keepForever: Bool

    /// MIME type for the version, when known.
    public let mimeType: String?

    /// Generic file extension type.
    public let extensionType: String

    /// Version size in bytes.
    public let size: Int

    /// The user that updated this file version.
    public let updatedBy: KDriveUser

    /// The creation timestamp.
    public let createdAt: Int

    /// The update timestamp, when known.
    public let updatedAt: Int?

    /// The last modified timestamp, when known.
    public let lastModifiedAt: Int?

    /// Creates a kDrive file version value.
    public init(
        id: Int,
        keepForever: Bool,
        mimeType: String?,
        extensionType: String,
        size: Int,
        updatedBy: KDriveUser,
        createdAt: Int,
        updatedAt: Int?,
        lastModifiedAt: Int?
    ) {
        self.id = id
        self.keepForever = keepForever
        self.mimeType = mimeType
        self.extensionType = extensionType
        self.size = size
        self.updatedBy = updatedBy
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.lastModifiedAt = lastModifiedAt
    }
}
