import Foundation
import PotassiumChannelCore

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
