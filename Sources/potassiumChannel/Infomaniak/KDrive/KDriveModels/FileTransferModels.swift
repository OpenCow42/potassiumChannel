import Foundation

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
