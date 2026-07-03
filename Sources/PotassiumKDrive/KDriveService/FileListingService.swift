import Foundation
import PotassiumChannelCore

extension KDriveService {
    /// Lists recent files and directories on a kDrive.
    public func listRecentFiles(
        driveId: Int,
        page: Int? = nil,
        perPage: Int? = nil
    ) async throws -> InfomaniakResponse<[KDriveFileItem]> {
        try await client.send(
            KDriveRequests.listRecentFiles(driveId: driveId, page: page, perPage: perPage)
        )
    }

    /// Lists the largest files on a kDrive.
    public func listLargestFiles(
        driveId: Int,
        cursor: String? = nil,
        limit: Int? = nil
    ) async throws -> InfomaniakResponse<[KDriveFileItem]> {
        try await client.send(
            KDriveRequests.listLargestFiles(driveId: driveId, cursor: cursor, limit: limit)
        )
    }

    /// Lists the last modified files on a kDrive.
    public func listLastModifiedFiles(
        driveId: Int,
        cursor: String? = nil,
        limit: Int? = nil
    ) async throws -> InfomaniakResponse<[KDriveFileItem]> {
        try await client.send(
            KDriveRequests.listLastModifiedFiles(driveId: driveId, cursor: cursor, limit: limit)
        )
    }

    /// Lists the most versioned files on a kDrive.
    public func listMostVersionedFiles(
        driveId: Int,
        cursor: String? = nil,
        limit: Int? = nil
    ) async throws -> InfomaniakResponse<[KDriveFileItem]> {
        try await client.send(
            KDriveRequests.listMostVersionedFiles(driveId: driveId, cursor: cursor, limit: limit)
        )
    }

    /// Lists favorite files and directories on a kDrive.
    public func listFavoriteFiles(
        driveId: Int,
        cursor: String? = nil,
        limit: Int? = nil
    ) async throws -> InfomaniakResponse<[KDriveFileItem]> {
        try await client.send(
            KDriveRequests.listFavoriteFiles(driveId: driveId, cursor: cursor, limit: limit)
        )
    }

    /// Lists drop-box directories on a kDrive.
    public func listDropboxes(
        driveId: Int,
        cursor: String? = nil,
        limit: Int? = nil
    ) async throws -> InfomaniakResponse<[KDriveFileItem]> {
        try await client.send(
            KDriveRequests.listDropboxes(driveId: driveId, cursor: cursor, limit: limit)
        )
    }

    /// Creates a new Dropbox directory on a kDrive.
    public func createDropbox(
        driveId: Int,
        options: CreateKDriveDropboxOptions
    ) async throws -> InfomaniakResponse<KDriveFileDropbox> {
        try await client.send(
            KDriveRequests.createDropbox(driveId: driveId, options: options)
        )
    }

    /// Lists files and directories shared by the user on a kDrive.
    public func listMySharedFiles(
        driveId: Int,
        cursor: String? = nil,
        limit: Int? = nil
    ) async throws -> InfomaniakResponse<[KDriveFileItem]> {
        try await client.send(
            KDriveRequests.listMySharedFiles(driveId: driveId, cursor: cursor, limit: limit)
        )
    }

    /// Lists files and directories shared with the user on a kDrive.
    public func listSharedWithMeFiles(
        driveId: Int,
        cursor: String? = nil,
        limit: Int? = nil
    ) async throws -> InfomaniakResponse<[KDriveFileItem]> {
        try await client.send(
            KDriveRequests.listSharedWithMeFiles(driveId: driveId, cursor: cursor, limit: limit)
        )
    }

    /// Lists files and directories with share links on a kDrive.
    public func listShareLinkFiles(
        driveId: Int,
        cursor: String? = nil,
        limit: Int? = nil
    ) async throws -> InfomaniakResponse<[KDriveFileItem]> {
        try await client.send(
            KDriveRequests.listShareLinkFiles(driveId: driveId, cursor: cursor, limit: limit)
        )
    }

    /// Lists files and directories inside a kDrive directory.
    public func listDirectoryFiles(
        driveId: Int,
        fileId: Int,
        with includedResources: String? = nil,
        options: ListKDriveDirectoryFilesOptions = ListKDriveDirectoryFilesOptions()
    ) async throws -> CursorPaginatedInfomaniakResponse<[KDriveFileItem]> {
        try await client.send(
            KDriveRequests.listDirectoryFiles(
                driveId: driveId,
                fileId: fileId,
                with: includedResources,
                options: options
            )
        )
    }
}
