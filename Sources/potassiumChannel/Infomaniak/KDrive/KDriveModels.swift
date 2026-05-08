import Foundation

/// Placeholder response type for kDrive endpoints that return binary data.
public struct KDriveBinaryResponse: Decodable, Sendable {
    public init() {}
}

/// Lossless JSON value used by kDrive endpoints whose payload shape can vary by access type.
public enum KDriveJSONValue: Codable, Equatable, Sendable {
    case string(String)
    case number(Double)
    case bool(Bool)
    case object([String: KDriveJSONValue])
    case array([KDriveJSONValue])
    case null

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            self = .null
        } else if let value = try? container.decode(Bool.self) {
            self = .bool(value)
        } else if let value = try? container.decode(Double.self) {
            self = .number(value)
        } else if let value = try? container.decode(String.self) {
            self = .string(value)
        } else if let value = try? container.decode([String: KDriveJSONValue].self) {
            self = .object(value)
        } else if let value = try? container.decode([KDriveJSONValue].self) {
            self = .array(value)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unsupported JSON value")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case let .string(value):
            try container.encode(value)
        case let .number(value):
            try container.encode(value)
        case let .bool(value):
            try container.encode(value)
        case let .object(value):
            try container.encode(value)
        case let .array(value):
            try container.encode(value)
        case .null:
            try container.encodeNil()
        }
    }
}

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

/// A comment entry for a kDrive file or directory.
public struct KDriveFileComment: Codable, Equatable, Sendable {
    /// Raw comment payload returned by the API.
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

/// JSON body accepted by the kDrive add file comment endpoint.
public struct AddKDriveFileCommentOptions: Encodable, Equatable, Sendable {
    /// Comment body text.
    public let body: String

    /// Creates options for adding a comment to a kDrive file or directory.
    public init(body: String) {
        self.body = body
    }
}

/// JSON body accepted by the kDrive add file comment reply endpoint.
public struct AddKDriveFileCommentReplyOptions: Encodable, Equatable, Sendable {
    /// Reply body text.
    public let body: String

    /// Creates options for adding a reply to a kDrive file comment.
    public init(body: String) {
        self.body = body
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

/// A cancellation token returned after a file is moved to kDrive trash.
public struct KDriveCancelResource: Codable, Equatable, Sendable {
    /// Identifier that can be used by Infomaniak APIs to cancel the action while it remains valid.
    public let cancelId: String

    /// Unix timestamp until which the cancellation identifier remains valid.
    public let validUntil: Int

    /// Creates a cancellation resource value.
    public init(cancelId: String, validUntil: Int) {
        self.cancelId = cancelId
        self.validUntil = validUntil
    }
}

/// UUID token returned after requesting an asynchronous kDrive archive build.
public struct KDriveUUIDResource: Codable, Equatable, Sendable {
    /// Universally unique identifier of the built archive resource.
    public let uuid: String

    /// Creates a UUID resource value.
    public init(uuid: String) {
        self.uuid = uuid
    }
}

/// Query parameters and headers accepted by the kDrive file download endpoint.
public struct DownloadKDriveFileOptions: Equatable, Sendable {
    /// Optional conversion format before download, such as `pdf` or `text`.
    public let conversionFormat: String?

    /// Password for protected files when conversion needs it.
    public let password: String?

    /// Creates options for downloading a kDrive file.
    public init(conversionFormat: String? = nil, password: String? = nil) {
        self.conversionFormat = conversionFormat
        self.password = password
    }
}

/// Query parameters accepted by the kDrive file thumbnail endpoint.
public struct GetKDriveFileThumbnailOptions: Equatable, Sendable {
    /// Optional thumbnail height in pixels. The API accepts values from 10 through 400.
    public let height: Int?

    /// Optional thumbnail width in pixels. The API accepts values from 10 through 400.
    public let width: Int?

    /// Creates options for requesting a kDrive file thumbnail.
    public init(height: Int? = nil, width: Int? = nil) {
        self.height = height
        self.width = width
    }
}

/// Query parameters and headers accepted by the kDrive file preview endpoint.
public struct GetKDriveFilePreviewOptions: Equatable, Sendable {
    /// Optional conversion format before preview rendering, such as `jpg` or `png`.
    public let conversionFormat: String?

    /// Optional preview height in pixels.
    public let height: Int?

    /// Optional preview quality.
    public let quality: Int?

    /// Optional preview width in pixels.
    public let width: Int?

    /// Password for protected files when preview generation needs it.
    public let password: String?

    /// Creates options for requesting a kDrive file preview.
    public init(
        conversionFormat: String? = nil,
        height: Int? = nil,
        quality: Int? = nil,
        width: Int? = nil,
        password: String? = nil
    ) {
        self.conversionFormat = conversionFormat
        self.height = height
        self.quality = quality
        self.width = width
        self.password = password
    }
}

/// Request body for the kDrive files-exists endpoint.
public struct KDriveFilesExistenceRequestBody: Codable, Equatable, Sendable {
    /// The file or directory identifiers to check.
    public let ids: [Int]

    /// Creates a files-exists request body.
    public init(ids: [Int]) {
        self.ids = ids
    }
}

/// A kDrive file-existence check result.
public struct KDriveFilesExistenceResult: Codable, Equatable, Sendable {
    /// The file or directory identifier that was checked.
    public let id: Int

    /// Whether the item exists.
    public let result: Bool

    /// Optional API message, usually present when `result` is false.
    public let message: String?

    /// Creates a file-existence result.
    public init(id: Int, result: Bool, message: String? = nil) {
        self.id = id
        self.result = result
        self.message = message
    }
}

/// Query parameters and headers accepted by the kDrive single-request upload endpoint.
public struct UploadKDriveFileOptions: Equatable, Sendable {
    /// Optional related resources to include in the response.
    public let with: String?

    /// ETag used when replacing a specific existing file version.
    public let ifMatch: String?

    /// Client-generated idempotency token.
    public let clientToken: String?

    /// Conflict behavior: `error`, `rename`, or `version`.
    public let conflict: String?

    /// Creation timestamp override.
    public let createdAt: Int?

    /// Destination directory identifier. Required unless `directoryPath` or `fileId` is provided.
    public let directoryId: Int?

    /// Destination directory path. Required unless `directoryId` or `fileId` is provided.
    public let directoryPath: String?

    /// Existing file identifier to replace.
    public let fileId: Int?

    /// Uploaded file name. Required when uploading a new file.
    public let fileName: String?

    /// Last modification timestamp override.
    public let lastModifiedAt: Int?

    /// Symbolic link target, when uploading a symbolic link.
    public let symbolicLink: String?

    /// Expected hash of the uploaded content.
    public let totalChunkHash: String?

    /// Creates options for uploading a kDrive file.
    public init(
        with: String? = nil,
        ifMatch: String? = nil,
        clientToken: String? = nil,
        conflict: String? = nil,
        createdAt: Int? = nil,
        directoryId: Int? = nil,
        directoryPath: String? = nil,
        fileId: Int? = nil,
        fileName: String? = nil,
        lastModifiedAt: Int? = nil,
        symbolicLink: String? = nil,
        totalChunkHash: String? = nil
    ) {
        self.with = with
        self.ifMatch = ifMatch
        self.clientToken = clientToken
        self.conflict = conflict
        self.createdAt = createdAt
        self.directoryId = directoryId
        self.directoryPath = directoryPath
        self.fileId = fileId
        self.fileName = fileName
        self.lastModifiedAt = lastModifiedAt
        self.symbolicLink = symbolicLink
        self.totalChunkHash = totalChunkHash
    }
}

/// A kDrive visible to the authenticated Infomaniak user.
public struct KDrive: Codable, Equatable, Sendable {
    /// The unique kDrive identifier.
    public let id: Int

    /// The display name of the kDrive.
    public let name: String

    /// The account identifier that owns the kDrive.
    public let accountId: Int

    /// The user's role in the kDrive.
    public let role: String

    /// The product status reported by the API.
    public let status: String

    /// Whether the kDrive is currently in maintenance.
    public let inMaintenance: Bool

    /// Creates a kDrive value.
    public init(id: Int, name: String, accountId: Int, role: String, status: String, inMaintenance: Bool) {
        self.id = id
        self.name = name
        self.accountId = accountId
        self.role = role
        self.status = status
        self.inMaintenance = inMaintenance
    }
}

/// A user associated with the authenticated user's accessible kDrives.
public struct KDriveUser: Codable, Equatable, Sendable {
    /// The unique user identifier.
    public let id: Int

    /// The display name of the user.
    public let displayName: String?

    /// The user's first name.
    public let firstName: String?

    /// The user's last name.
    public let lastName: String?

    /// The user's email address.
    public let email: String?

    /// Whether the user is provided by an external identity provider.
    public let isSso: Bool?

    /// The user's avatar URL, when available.
    public let avatar: String?

    /// The timestamp at which the user was deleted, when applicable.
    public let deletedAt: Int?

    /// Creates a kDrive user value.
    public init(
        id: Int,
        displayName: String? = nil,
        firstName: String? = nil,
        lastName: String? = nil,
        email: String? = nil,
        isSso: Bool? = nil,
        avatar: String? = nil,
        deletedAt: Int? = nil
    ) {
        self.id = id
        self.displayName = displayName
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.isSso = isSso
        self.avatar = avatar
        self.deletedAt = deletedAt
    }
}

/// A user associated with a specific kDrive.
public struct KDriveDriveUser: Codable, Equatable, Sendable {
    /// The unique user identifier.
    public let id: Int

    /// The display name of the user.
    public let displayName: String?

    /// The user's first name.
    public let firstName: String?

    /// The user's last name.
    public let lastName: String?

    /// The user's email address.
    public let email: String?

    /// Whether the user is provided by an external identity provider.
    public let isSso: Bool?

    /// The user's avatar URL, when available.
    public let avatar: String?

    /// The user's role on the kDrive, when available.
    public let role: String?

    /// The timestamp at which the user was deleted, when applicable.
    public let deletedAt: Int?

    /// Creates a kDrive-scoped user value.
    public init(
        id: Int,
        displayName: String? = nil,
        firstName: String? = nil,
        lastName: String? = nil,
        email: String? = nil,
        isSso: Bool? = nil,
        avatar: String? = nil,
        role: String? = nil,
        deletedAt: Int? = nil
    ) {
        self.id = id
        self.displayName = displayName
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.isSso = isSso
        self.avatar = avatar
        self.role = role
        self.deletedAt = deletedAt
    }
}

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

/// A file activity recorded on a kDrive.
public struct KDriveActivity: Codable, Equatable, Sendable {
    /// The unique activity identifier.
    public let id: Int

    /// The timestamp at which the activity was created.
    public let createdAt: Int

    /// The activity action name.
    public let action: String

    /// The current file or directory path, when available.
    public let newPath: String?

    /// The previous file or directory path, when available.
    public let oldPath: String?

    /// The logged file identifier.
    public let fileId: Int

    /// The user identifier responsible for the action, when available.
    public let userId: Int?

    /// Creates a kDrive activity value.
    public init(id: Int, createdAt: Int, action: String, newPath: String?, oldPath: String?, fileId: Int, userId: Int?) {
        self.id = id
        self.createdAt = createdAt
        self.action = action
        self.newPath = newPath
        self.oldPath = oldPath
        self.fileId = fileId
        self.userId = userId
    }
}

/// A chart returned by kDrive statistics endpoints.
public struct KDriveChart: Codable, Equatable, Sendable {
    /// Chart title.
    public let title: String

    /// X-axis labels for the chart.
    public let labels: KDriveChartData

    /// Chart data series.
    public let data: [KDriveChartData]

    /// Creates a kDrive chart value.
    public init(title: String, labels: KDriveChartData, data: [KDriveChartData]) {
        self.title = title
        self.labels = labels
        self.data = data
    }
}

/// A labels or metric data series in a kDrive chart.
public struct KDriveChartData: Codable, Equatable, Sendable {
    /// Data coordinate or series name.
    public let name: String

    /// Data unit.
    public let unit: String

    /// Data points. The API schema allows timestamp arrays, string arrays, and object-shaped values.
    public let data: KDriveChartDataValue

    /// Requested metric associated with this series, when present.
    public let metric: String?

    /// Creates a kDrive chart data value.
    public init(name: String, unit: String, data: KDriveChartDataValue, metric: String? = nil) {
        self.name = name
        self.unit = unit
        self.data = data
        self.metric = metric
    }
}

/// A flexible JSON value for kDrive chart data points.
public enum KDriveChartDataValue: Codable, Equatable, Sendable {
    /// Null value.
    case null

    /// Boolean value.
    case bool(Bool)

    /// Integer value.
    case integer(Int)

    /// Floating-point value.
    case double(Double)

    /// String value.
    case string(String)

    /// Array value.
    case array([KDriveChartDataValue])

    /// Object value.
    case object([String: KDriveChartDataValue])

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            self = .null
        } else if let value = try? container.decode(Bool.self) {
            self = .bool(value)
        } else if let value = try? container.decode(Int.self) {
            self = .integer(value)
        } else if let value = try? container.decode(Double.self) {
            self = .double(value)
        } else if let value = try? container.decode(String.self) {
            self = .string(value)
        } else if let value = try? container.decode([KDriveChartDataValue].self) {
            self = .array(value)
        } else {
            self = .object(try container.decode([String: KDriveChartDataValue].self))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .null:
            try container.encodeNil()
        case let .bool(value):
            try container.encode(value)
        case let .integer(value):
            try container.encode(value)
        case let .double(value):
            try container.encode(value)
        case let .string(value):
            try container.encode(value)
        case let .array(value):
            try container.encode(value)
        case let .object(value):
            try container.encode(value)
        }
    }
}

/// A user active on a kDrive during a statistics period.
public struct KDriveActiveMember: Codable, Equatable, Sendable {
    /// User identifier, when Infomaniak can associate the activity with a user.
    public let userId: Int?

    /// Connected user display name, when available.
    public let name: String?

    /// User agent used on connection.
    public let agent: String

    /// IP address used on connection.
    public let ip: String

    /// Last login timestamp.
    public let lastLoginAt: Int

    /// Creates an active-member statistics value.
    public init(userId: Int?, name: String?, agent: String, ip: String, lastLoginAt: Int) {
        self.userId = userId
        self.name = name
        self.agent = agent
        self.ip = ip
        self.lastLoginAt = lastLoginAt
    }
}

/// A file shared during a kDrive statistics period.
public struct KDriveSharedFileActivity: Codable, Equatable, Sendable {
    /// Shared file identifier.
    public let id: Int

    /// File name.
    public let name: String

    /// Last update timestamp.
    public let updateAt: Int

    /// Number of active users on the file.
    public let users: Int

    /// Creates a shared-file activity statistics value.
    public init(id: Int, name: String, updateAt: Int, users: Int) {
        self.id = id
        self.name = name
        self.updateAt = updateAt
        self.users = users
    }
}

/// A share link returned by kDrive activity statistics.
public struct KDriveStatisticShareLink: Codable, Equatable, Sendable {
    /// Share link URL.
    public let url: String

    /// Shared file identifier.
    public let fileId: Int

    /// Access right required to view the link (`inherit`, `password`, or `public`).
    public let right: String

    /// Timestamp until which the share link is valid, when limited.
    public let validUntil: Int?

    /// User identifier of the link creator.
    public let createdBy: Int

    /// Link creation timestamp, when returned.
    public let createdAt: Int?

    /// Link update timestamp, when returned.
    public let updatedAt: Int?

    /// Share link capabilities.
    public let capabilities: KDriveStatisticShareLinkCapabilities

    /// Whether link access is blocked.
    public let accessBlocked: Bool

    /// Total number of views on the share link.
    public let views: Int

    /// File information, when the authenticated user can see it.
    public let file: KDriveFileItem?

    /// Number of unique views on the share link.
    public let uniqueViews: Int

    /// Creates a kDrive statistic share link value.
    public init(
        url: String,
        fileId: Int,
        right: String,
        validUntil: Int?,
        createdBy: Int,
        createdAt: Int?,
        updatedAt: Int?,
        capabilities: KDriveStatisticShareLinkCapabilities,
        accessBlocked: Bool,
        views: Int,
        file: KDriveFileItem? = nil,
        uniqueViews: Int
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
        self.file = file
        self.uniqueViews = uniqueViews
    }
}

/// Capability flags attached to a kDrive statistic share link.
public struct KDriveStatisticShareLinkCapabilities: Codable, Equatable, Sendable {
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

/// A drive-scoped file activity returned by the kDrive v3 API.
public struct KDriveDriveActivity: Codable, Equatable, Sendable {
    /// The unique activity identifier.
    public let id: Int

    /// The timestamp at which the activity was created.
    public let createdAt: Int

    /// The activity action name.
    public let action: String

    /// The current file or directory path, when available.
    public let newPath: String?

    /// The previous file or directory path, when available.
    public let oldPath: String?

    /// The private path user identifier, when available.
    public let privatePathUserId: Int?

    /// The logged file identifier.
    public let fileId: Int

    /// The user identifier responsible for the action, when available.
    public let userId: Int?

    /// Creates a drive-scoped activity value.
    public init(
        id: Int,
        createdAt: Int,
        action: String,
        newPath: String?,
        oldPath: String?,
        privatePathUserId: Int?,
        fileId: Int,
        userId: Int?
    ) {
        self.id = id
        self.createdAt = createdAt
        self.action = action
        self.newPath = newPath
        self.oldPath = oldPath
        self.privatePathUserId = privatePathUserId
        self.fileId = fileId
        self.userId = userId
    }
}

/// A generated kDrive activity report.
public struct KDriveActivityReport: Codable, Equatable, Sendable {
    /// The unique activity report identifier.
    public let id: Int

    /// The report generation status.
    public let status: String

    /// Report size in octets, as returned by the API.
    public let size: String

    /// The user who generated the report.
    public let generatedBy: KDriveUser

    /// URL used to download the generated report, when available.
    public let downloadUrl: String?

    /// The creation timestamp, when available.
    public let createdAt: Int?

    /// The update timestamp, when available.
    public let updatedAt: Int?

    /// Creates a kDrive activity report value.
    public init(
        id: Int,
        status: String,
        size: String,
        generatedBy: KDriveUser,
        downloadUrl: String?,
        createdAt: Int?,
        updatedAt: Int?
    ) {
        self.id = id
        self.status = status
        self.size = size
        self.generatedBy = generatedBy
        self.downloadUrl = downloadUrl
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

/// An external import configured for a kDrive.
public struct KDriveExternalImport: Codable, Equatable, Sendable {
    /// The unique external import identifier.
    public let id: Int

    /// The source application name.
    public let application: String

    /// The imported account name.
    public let accountName: String

    /// The import status.
    public let status: String

    /// Known error code when the import failed, when available.
    public let errorCode: String?

    /// The destination path.
    public let path: String

    /// The destination directory identifier, when available.
    public let directoryId: Int?

    /// Whether the import application has shared files, as returned by the API.
    public let hasSharedFiles: String

    /// The creation timestamp.
    public let createdAt: Int

    /// The update timestamp.
    public let updatedAt: Int

    /// Number of successfully imported files.
    public let countSuccessFiles: Int

    /// Number of failed imported files.
    public let countFailedFiles: Int

    /// Creates an external import value.
    public init(
        id: Int,
        application: String,
        accountName: String,
        status: String,
        errorCode: String? = nil,
        path: String,
        directoryId: Int?,
        hasSharedFiles: String,
        createdAt: Int,
        updatedAt: Int,
        countSuccessFiles: Int,
        countFailedFiles: Int
    ) {
        self.id = id
        self.application = application
        self.accountName = accountName
        self.status = status
        self.errorCode = errorCode
        self.path = path
        self.directoryId = directoryId
        self.hasSharedFiles = hasSharedFiles
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.countSuccessFiles = countSuccessFiles
        self.countFailedFiles = countFailedFiles
    }
}

/// A file entry reported by an external import, including errored imports.
public struct KDriveExternalImportFile: Codable, Equatable, Sendable {
    /// The unique external file import identifier.
    public let id: Int

    /// The external file name.
    public let name: String

    /// The external file import status.
    public let status: String

    /// Message describing the import result or failure.
    public let message: String

    /// External file creation timestamp.
    public let createdAt: Int

    /// Creates an external import file value.
    public init(id: Int, name: String, status: String, message: String, createdAt: Int) {
        self.id = id
        self.name = name
        self.status = status
        self.message = message
        self.createdAt = createdAt
    }
}

/// Third-party drives eligible for an external import.
public struct KDriveThirdPartyDrivesList: Codable, Equatable, Sendable {
    /// All suitable third-party drives.
    public let drives: [KDriveThirdPartyDrive]

    /// Access token identifier to reuse for future import requests.
    public let accessTokenId: Int

    /// Creates a third-party drives list value.
    public init(drives: [KDriveThirdPartyDrive], accessTokenId: Int) {
        self.drives = drives
        self.accessTokenId = accessTokenId
    }
}

/// A third-party drive eligible for an external import.
public struct KDriveThirdPartyDrive: Codable, Equatable, Sendable {
    /// The third-party drive identifier.
    public let id: String

    /// The third-party drive display name.
    public let name: String

    /// Creates a third-party drive value.
    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

/// A user invitation created for a kDrive.
public struct KDriveUserInvitation: Codable, Equatable, Sendable {
    /// The unique invitation identifier.
    public let id: Int

    /// The invitation type.
    public let type: String

    /// Whether the invitation grants private access.
    public let isPrivate: Bool

    /// Whether the invitation is currently valid.
    public let isValid: Bool

    /// The invitation status.
    public let status: String

    /// The invited email address.
    public let email: String

    /// The granted role.
    public let role: String

    /// The access display name.
    public let accessName: String

    /// The invited user identifier, when available.
    public let userId: Int?

    /// The user identifier that created the invitation, when available.
    public let invitedBy: Int?

    /// The invitation language.
    public let lang: String

    /// The related file identifier.
    public let fileId: Int

    /// The expiration timestamp, when available.
    public let expiredAt: Int?

    /// The creation timestamp, when available.
    public let createdAt: Int?

    /// Creates a kDrive user invitation value.
    public init(
        id: Int,
        type: String,
        isPrivate: Bool,
        isValid: Bool,
        status: String,
        email: String,
        role: String,
        accessName: String,
        userId: Int?,
        invitedBy: Int?,
        lang: String,
        fileId: Int,
        expiredAt: Int?,
        createdAt: Int?
    ) {
        self.id = id
        self.type = type
        self.isPrivate = isPrivate
        self.isValid = isValid
        self.status = status
        self.email = email
        self.role = role
        self.accessName = accessName
        self.userId = userId
        self.invitedBy = invitedBy
        self.lang = lang
        self.fileId = fileId
        self.expiredAt = expiredAt
        self.createdAt = createdAt
    }
}

/// Preferences for the authenticated kDrive user.
public struct KDriveUserPreferences: Codable, Equatable, Sendable {
    /// Layout density of user interface elements.
    public let density: String

    /// Whether recent files should be sorted by recency.
    public let sortRecentFile: Bool

    /// The user's date display format.
    public let dateFormat: String

    /// Whether shortcuts are enabled.
    public let useShortcut: Bool

    /// The default drive identifier, when configured.
    public let defaultDrive: Int?

    /// Tutorial identifiers already seen by the user, when returned by the API.
    public let tutorials: [String]?

    /// Connected application identifiers, when returned by the API.
    public let connectedApp: [String]?

    /// Creates a user preferences value.
    public init(
        density: String,
        sortRecentFile: Bool,
        dateFormat: String,
        useShortcut: Bool,
        defaultDrive: Int?,
        tutorials: [String]? = nil,
        connectedApp: [String]? = nil
    ) {
        self.density = density
        self.sortRecentFile = sortRecentFile
        self.dateFormat = dateFormat
        self.useShortcut = useShortcut
        self.defaultDrive = defaultDrive
        self.tutorials = tutorials
        self.connectedApp = connectedApp
    }
}

/// JSON body accepted by the endpoint that updates authenticated kDrive user preferences.
public struct SetKDriveUserPreferencesOptions: Encodable, Equatable, Sendable {
    /// The user's date display format, such as `d/m/Y`, `m/d/Y`, or `d F Y`.
    public let dateFormat: String?

    /// Default drive identifier for the authenticated user.
    public let defaultDrive: Int?

    /// Layout density of user interface elements: `compact`, `normal`, or `large`.
    public let density: String?

    /// List display and sorting preferences.
    public let list: KDriveUserPreferencesListOptions?

    /// Whether recent files should be sorted by recency.
    public let sortRecentFile: Bool?

    /// Tutorial identifiers already seen by the user.
    public let tutorials: [Int]?

    /// Whether shortcuts are enabled.
    public let useShortcut: Bool?

    public enum CodingKeys: String, CodingKey {
        case dateFormat = "date_format"
        case defaultDrive = "default_drive"
        case density
        case list
        case sortRecentFile = "sort_recent_file"
        case tutorials
        case useShortcut = "use_shortcut"
    }

    /// Creates options for updating authenticated kDrive user preferences.
    public init(
        dateFormat: String? = nil,
        defaultDrive: Int? = nil,
        density: String? = nil,
        list: KDriveUserPreferencesListOptions? = nil,
        sortRecentFile: Bool? = nil,
        tutorials: [Int]? = nil,
        useShortcut: Bool? = nil
    ) {
        self.dateFormat = dateFormat
        self.defaultDrive = defaultDrive
        self.density = density
        self.list = list
        self.sortRecentFile = sortRecentFile
        self.tutorials = tutorials
        self.useShortcut = useShortcut
    }
}

/// Nested list preferences accepted when updating authenticated kDrive user preferences.
public struct KDriveUserPreferencesListOptions: Encodable, Equatable, Sendable {
    /// File list sorting preference.
    public let files: KDriveUserPreferencesListSortOptions?

    /// Largest-file storage list sorting preference.
    public let storageLargest: KDriveUserPreferencesListSortOptions?

    /// Most-versioned storage list sorting preference.
    public let storageVersions: KDriveUserPreferencesListSortOptions?

    /// Trash list sorting preference.
    public let trash: KDriveUserPreferencesListSortOptions?

    /// List view mode: `largeGrid`, `medGrid`, `smallGrid`, or `table`.
    public let view: String?

    public enum CodingKeys: String, CodingKey {
        case files
        case storageLargest = "storage_largest"
        case storageVersions = "storage_versions"
        case trash
        case view
    }

    /// Creates list preferences for the authenticated kDrive user.
    public init(
        files: KDriveUserPreferencesListSortOptions? = nil,
        storageLargest: KDriveUserPreferencesListSortOptions? = nil,
        storageVersions: KDriveUserPreferencesListSortOptions? = nil,
        trash: KDriveUserPreferencesListSortOptions? = nil,
        view: String? = nil
    ) {
        self.files = files
        self.storageLargest = storageLargest
        self.storageVersions = storageVersions
        self.trash = trash
        self.view = view
    }
}

/// A list sorting preference accepted when updating authenticated kDrive user preferences.
public struct KDriveUserPreferencesListSortOptions: Encodable, Equatable, Sendable {
    /// Sort direction: `asc` or `desc`.
    public let direction: String?

    /// Field used for sorting.
    public let property: String?

    /// Creates a list sorting preference.
    public init(direction: String? = nil, property: String? = nil) {
        self.direction = direction
        self.property = property
    }
}

/// Settings for a kDrive.
public struct KDriveSettings: Codable, Equatable, Sendable {
    /// Artificial-intelligence scan settings.
    public let aiScan: KDriveAISettings

    /// Share-link customization settings.
    public let sharedLink: KDriveSharedLinkSettings

    /// Trash retention settings.
    public let trash: KDriveTrashSettings

    /// Office document integration settings.
    public let office: KDriveOfficeSettings

    /// Version retention settings.
    public let versioning: KDriveVersioningSettings

    /// How long deleted users' files are retained.
    public let maxKeepDeletedUser: String

    /// Creates kDrive settings.
    public init(
        aiScan: KDriveAISettings,
        sharedLink: KDriveSharedLinkSettings,
        trash: KDriveTrashSettings,
        office: KDriveOfficeSettings,
        versioning: KDriveVersioningSettings,
        maxKeepDeletedUser: String
    ) {
        self.aiScan = aiScan
        self.sharedLink = sharedLink
        self.trash = trash
        self.office = office
        self.versioning = versioning
        self.maxKeepDeletedUser = maxKeepDeletedUser
    }
}

/// Artificial-intelligence scan settings for a kDrive.
public struct KDriveAISettings: Codable, Equatable, Sendable {
    /// Whether AI file scanning has been approved.
    public let hasApproved: Bool

    /// Whether automatic AI categories have been approved.
    public let hasApprovedAiCategories: Bool

    /// Whether content search has been approved.
    public let hasApprovedContentSearch: Bool

    /// Approval update timestamp, when available.
    public let updatedAt: Int?

    /// Creates AI scan settings.
    public init(hasApproved: Bool, hasApprovedAiCategories: Bool, hasApprovedContentSearch: Bool, updatedAt: Int? = nil) {
        self.hasApproved = hasApproved
        self.hasApprovedAiCategories = hasApprovedAiCategories
        self.hasApprovedContentSearch = hasApprovedContentSearch
        self.updatedAt = updatedAt
    }
}

/// Share-link customization settings for a kDrive.
public struct KDriveSharedLinkSettings: Codable, Equatable, Sendable {
    /// Whether custom share-link styling is active.
    public let activate: Bool

    /// Share-link text color, when configured.
    public let txtColor: String?

    /// Share-link background color, when configured.
    public let bgColor: String?

    /// Configured public image assets.
    public let images: [KDrivePublicImage]

    /// Creates share-link settings.
    public init(activate: Bool, txtColor: String? = nil, bgColor: String? = nil, images: [KDrivePublicImage] = []) {
        self.activate = activate
        self.txtColor = txtColor
        self.bgColor = bgColor
        self.images = images
    }
}

/// A public image used by kDrive share-link customization.
public struct KDrivePublicImage: Codable, Equatable, Sendable {
    /// The image identifier, when returned by the API.
    public let id: Int?

    /// The image URL, when returned by the API.
    public let url: String?

    /// Creates a public image value.
    public init(id: Int? = nil, url: String? = nil) {
        self.id = id
        self.url = url
    }
}

/// Trash retention settings for a kDrive.
public struct KDriveTrashSettings: Codable, Equatable, Sendable {
    /// Number of days files are kept in trash.
    public let maxDuration: Int

    /// Creates trash retention settings.
    public init(maxDuration: Int) {
        self.maxDuration = maxDuration
    }
}

/// Office document integration settings for a kDrive.
public struct KDriveOfficeSettings: Codable, Equatable, Sendable {
    /// Default application for presentations.
    public let presentation: String

    /// Default application for forms.
    public let form: String

    /// Default application for spreadsheets.
    public let spreadsheet: String

    /// Default application for text documents.
    public let text: String

    /// Default application display mode, when configured.
    public let defaultMode: String?

    /// Creates office document integration settings.
    public init(presentation: String, form: String, spreadsheet: String, text: String, defaultMode: String? = nil) {
        self.presentation = presentation
        self.form = form
        self.spreadsheet = spreadsheet
        self.text = text
        self.defaultMode = defaultMode
    }
}

/// Version retention settings for a kDrive.
public struct KDriveVersioningSettings: Codable, Equatable, Sendable {
    /// Maximum number of versions retained.
    public let maxNumbers: Int

    /// Maximum number of days versions are retained.
    public let maxDays: Int

    /// Creates version retention settings.
    public init(maxNumbers: Int, maxDays: Int) {
        self.maxNumbers = maxNumbers
        self.maxDays = maxDays
    }
}

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

/// Query parameters accepted by the kDrive file activity listing endpoint.
public struct ListKDriveFileActivitiesOptions: Equatable, Sendable {
    /// Cursor marker used to fetch the next batch of results.
    public let cursor: String?

    /// The maximum number of items returned.
    public let limit: Int?

    /// Sort fields, such as `created_at`.
    public let orderBy: [String]

    /// Default sorting direction.
    public let order: String?

    /// Per-field sorting directions keyed by order field.
    public let orderFor: [String: String]

    /// Activity action filters.
    public let actions: [String]

    /// Activity depth filter, such as `children`, `file`, `folder`, or `unlimited`.
    public let depth: String?

    /// Start timestamp filter.
    public let from: Int?

    /// Search terms filter.
    public let terms: String?

    /// End timestamp filter.
    public let until: Int?

    /// User id filters.
    public let users: [Int]

    /// Creates options for listing kDrive file activities.
    public init(
        cursor: String? = nil,
        limit: Int? = nil,
        orderBy: [String] = [],
        order: String? = nil,
        orderFor: [String: String] = [:],
        actions: [String] = [],
        depth: String? = nil,
        from: Int? = nil,
        terms: String? = nil,
        until: Int? = nil,
        users: [Int] = []
    ) {
        self.cursor = cursor
        self.limit = limit
        self.orderBy = orderBy
        self.order = order
        self.orderFor = orderFor
        self.actions = actions
        self.depth = depth
        self.from = from
        self.terms = terms
        self.until = until
        self.users = users
    }
}

/// Query parameters accepted by the kDrive root file activity listing endpoint.
public typealias ListKDriveRootFileActivitiesV3Options = ListKDriveFileActivitiesOptions

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

/// Query parameters accepted by the kDrive activity share-links export endpoint.
public struct ExportKDriveActivityShareLinksOptions: Equatable, Sendable {
    /// Maximum views filter.
    public let maxView: Int?

    /// Minimum views filter.
    public let minView: Int?

    /// Link rights to filter by (`inherit`, `password`, or `public`).
    public let rights: [String]

    /// Link expiration timestamp filter.
    public let validUntil: Int?

    /// Creates options for exporting kDrive activity share-link statistics.
    public init(maxView: Int? = nil, minView: Int? = nil, rights: [String] = [], validUntil: Int? = nil) {
        self.maxView = maxView
        self.minView = minView
        self.rights = rights
        self.validUntil = validUntil
    }
}

/// Query parameters accepted by the kDrive activity share-links statistics endpoint.
public struct ListKDriveActivityShareLinksOptions: Equatable, Sendable {
    /// Optional related resources to include.
    public let includedResources: String?

    /// Maximum views filter.
    public let maxView: Int?

    /// Minimum views filter.
    public let minView: Int?

    /// Link rights to filter by (`inherit`, `password`, or `public`).
    public let rights: [String]

    /// Exact share-link filename match.
    public let search: String?

    /// Link expiration timestamp filter.
    public let validUntil: Int?

    /// The page number to request.
    public let page: Int?

    /// The number of items per page to request.
    public let perPage: Int?

    /// Whether the API should return the total item count.
    public let total: Bool?

    /// Fields used for sorting.
    public let orderBy: [String]

    /// Default sort order.
    public let order: String?

    /// Per-field sort orders encoded as order_for[field]=asc|desc.
    public let orderFor: [String: String]

    /// Creates options for listing kDrive activity share-link statistics.
    public init(
        includedResources: String? = nil,
        maxView: Int? = nil,
        minView: Int? = nil,
        rights: [String] = [],
        search: String? = nil,
        validUntil: Int? = nil,
        page: Int? = nil,
        perPage: Int? = nil,
        total: Bool? = nil,
        orderBy: [String] = [],
        order: String? = nil,
        orderFor: [String: String] = [:]
    ) {
        self.includedResources = includedResources
        self.maxView = maxView
        self.minView = minView
        self.rights = rights
        self.search = search
        self.validUntil = validUntil
        self.page = page
        self.perPage = perPage
        self.total = total
        self.orderBy = orderBy
        self.order = order
        self.orderFor = orderFor
    }
}

/// Query parameters accepted by the accessible kDrives endpoint.
public struct ListAccessibleKDrivesOptions: Equatable, Sendable {
    /// Whether to include drives matching the maintenance state.
    public let inMaintenance: Bool?

    /// Maintenance reasons to filter by.
    public let maintenanceReasons: [String]

    /// Tag identifiers to filter by.
    public let tags: [Int]

    /// The page number to request.
    public let page: Int?

    /// The number of items per page to request.
    public let perPage: Int?

    /// Creates options for listing accessible kDrives.
    public init(
        inMaintenance: Bool? = nil,
        maintenanceReasons: [String] = [],
        tags: [Int] = [],
        page: Int? = nil,
        perPage: Int? = nil
    ) {
        self.inMaintenance = inMaintenance
        self.maintenanceReasons = maintenanceReasons
        self.tags = tags
        self.page = page
        self.perPage = perPage
    }
}

/// Query parameters accepted by the kDrive user drives endpoint.
public struct ListKDriveUserDrivesOptions: Equatable, Sendable {
    /// User roles to filter by.
    public let roles: [String]

    /// User statuses to filter by.
    public let statuses: [String]

    /// The page number to request.
    public let page: Int?

    /// The number of items per page to request.
    public let perPage: Int?

    /// Whether the API should return the total item count.
    public let total: Bool?

    /// Creates options for listing kDrives associated with a user.
    public init(roles: [String] = [], statuses: [String] = [], page: Int? = nil, perPage: Int? = nil, total: Bool? = nil) {
        self.roles = roles
        self.statuses = statuses
        self.page = page
        self.perPage = perPage
        self.total = total
    }
}

/// Query parameters accepted by the v2 drive-scoped kDrive users endpoint.
public struct ListKDriveDriveUsersV2Options: Equatable, Sendable {
    /// Search text used to match first name, last name, or email.
    public let search: String?

    /// User statuses to filter by.
    public let statuses: [String]

    /// User types to filter by.
    public let types: [String]

    /// User identifiers to filter by.
    public let userIds: [Int]

    /// The page number to request.
    public let page: Int?

    /// The number of items per page to request.
    public let perPage: Int?

    /// Whether the API should return the total item count.
    public let total: Bool?

    /// Fields used for sorting.
    public let orderBy: [String]

    /// Default sort order.
    public let order: String?

    /// Per-field sort orders encoded as order_for[field]=asc|desc.
    public let orderFor: [String: String]

    /// Creates options for listing users associated with a specific kDrive using v2.
    public init(
        search: String? = nil,
        statuses: [String] = [],
        types: [String] = [],
        userIds: [Int] = [],
        page: Int? = nil,
        perPage: Int? = nil,
        total: Bool? = nil,
        orderBy: [String] = [],
        order: String? = nil,
        orderFor: [String: String] = [:]
    ) {
        self.search = search
        self.statuses = statuses
        self.types = types
        self.userIds = userIds
        self.page = page
        self.perPage = perPage
        self.total = total
        self.orderBy = orderBy
        self.order = order
        self.orderFor = orderFor
    }
}

/// Query parameters accepted by the kDrive users endpoint.
public struct ListKDriveUsersOptions: Equatable, Sendable {
    /// Search text used to match first name, last name, or email.
    public let search: String?

    /// User identifiers to filter by.
    public let userIds: [Int]

    /// The page number to request.
    public let page: Int?

    /// The number of items per page to request.
    public let perPage: Int?

    /// Creates options for listing kDrive users.
    public init(search: String? = nil, userIds: [Int] = [], page: Int? = nil, perPage: Int? = nil) {
        self.search = search
        self.userIds = userIds
        self.page = page
        self.perPage = perPage
    }
}
