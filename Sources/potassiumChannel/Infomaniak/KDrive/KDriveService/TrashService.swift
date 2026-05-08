import Foundation

extension KDriveService {
    /// Lists files and directories in kDrive trash.
    public func listTrashFiles(
        driveId: Int,
        with includedResources: String? = nil,
        options: ListKDriveTrashOptions = ListKDriveTrashOptions()
    ) async throws -> CursorPaginatedInfomaniakResponse<[KDriveFileItem]> {
        try await client.send(
            KDriveRequests.listTrashFiles(driveId: driveId, with: includedResources, options: options)
        )
    }

    /// Moves a kDrive file or directory to trash using the v2 endpoint.
    public func trashFileV2(
        driveId: Int,
        fileId: Int
    ) async throws -> InfomaniakResponse<KDriveCancelResource> {
        try await client.send(
            KDriveRequests.trashFileV2(driveId: driveId, fileId: fileId)
        )
    }

    /// Permanently removes a kDrive file or directory from trash using the v2 endpoint.
    public func removeTrashedFile(
        driveId: Int,
        fileId: Int
    ) async throws -> InfomaniakResponse<Bool> {
        try await client.send(
            KDriveRequests.removeTrashedFile(driveId: driveId, fileId: fileId)
        )
    }

    /// Restores a kDrive file or directory from trash using the v2 endpoint.
    public func restoreTrashedFile(
        driveId: Int,
        fileId: Int,
        destinationDirectoryId: Int
    ) async throws -> InfomaniakResponse<KDriveRestoreTrashedFileResult> {
        let body = try JSONEncoder().encode(
            RestoreKDriveTrashedFileOptions(destinationDirectoryId: destinationDirectoryId)
        )
        return try await client.send(
            KDriveRequests.restoreTrashedFile(driveId: driveId, fileId: fileId, body: body)
        )
    }

    /// Gets a single file or directory from kDrive trash.
    public func getTrashedFile(
        driveId: Int,
        fileId: Int,
        options: GetKDriveTrashedFileOptions = GetKDriveTrashedFileOptions()
    ) async throws -> InfomaniakResponse<KDriveFileItem> {
        try await client.send(
            KDriveRequests.getTrashedFile(driveId: driveId, fileId: fileId, options: options)
        )
    }

    /// Gets thumbnail data for a trashed kDrive item using the deprecated v2 endpoint.
    public func getV2TrashedItemThumbnail(
        driveId: Int,
        fileId: Int
    ) async throws -> Data {
        try await client.sendData(
            KDriveRequests.getV2TrashedItemThumbnail(driveId: driveId, fileId: fileId)
        )
    }

    /// Counts files and directories inside a trashed kDrive item using the deprecated v2 endpoint.
    public func getV2TrashedItemCount(
        driveId: Int,
        fileId: Int
    ) async throws -> InfomaniakResponse<KDriveV2TrashedItemCount> {
        try await client.send(
            KDriveRequests.getV2TrashedItemCount(driveId: driveId, fileId: fileId)
        )
    }

    /// Counts files and directories inside a trashed kDrive item.
    public func getTrashedItemCount(
        driveId: Int,
        fileId: Int,
        depth: String? = nil
    ) async throws -> InfomaniakResponse<KDriveTrashedItemCount> {
        try await client.send(
            KDriveRequests.getTrashedItemCount(driveId: driveId, fileId: fileId, depth: depth)
        )
    }

    /// Lists files inside a trashed kDrive directory.
    public func listTrashedDirectoryFiles(
        driveId: Int,
        fileId: Int,
        with includedResources: String? = nil,
        options: ListKDriveTrashedDirectoryFilesOptions = ListKDriveTrashedDirectoryFilesOptions()
    ) async throws -> CursorPaginatedInfomaniakResponse<[KDriveFileItem]> {
        try await client.send(
            KDriveRequests.listTrashedDirectoryFiles(
                driveId: driveId,
                fileId: fileId,
                with: includedResources,
                options: options
            )
        )
    }

    /// Searches files and directories in kDrive trash.
    public func searchTrash(
        driveId: Int,
        with includedResources: String? = nil,
        options: SearchKDriveTrashOptions = SearchKDriveTrashOptions()
    ) async throws -> CursorPaginatedInfomaniakResponse<[KDriveFileItem]> {
        try await client.send(
            KDriveRequests.searchTrash(driveId: driveId, with: includedResources, options: options)
        )
    }

    /// Counts files and directories in kDrive trash.
    public func getTrashCount(
        driveId: Int
    ) async throws -> InfomaniakResponse<KDriveTrashCount> {
        try await client.send(
            KDriveRequests.getTrashCount(driveId: driveId)
        )
    }
}
