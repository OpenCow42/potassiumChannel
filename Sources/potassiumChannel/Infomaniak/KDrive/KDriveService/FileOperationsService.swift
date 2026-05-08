import Foundation

extension KDriveService {
    /// Gets a single kDrive file or directory.
    public func getFile(
        driveId: Int,
        fileId: Int,
        with includedResources: String? = nil
    ) async throws -> InfomaniakResponse<KDriveFileItem> {
        try await client.send(
            KDriveRequests.getFile(driveId: driveId, fileId: fileId, with: includedResources)
        )
    }

    /// Gets dropbox metadata for a kDrive file or directory.
    public func getFileDropbox(
        driveId: Int,
        fileId: Int
    ) async throws -> InfomaniakResponse<KDriveFileDropbox?> {
        try await client.send(
            KDriveRequests.getFileDropbox(driveId: driveId, fileId: fileId)
        )
    }

    /// Gets a child kDrive file or directory by name.
    public func getFileByName(
        driveId: Int,
        fileId: Int,
        name: String,
        with includedResources: String? = nil
    ) async throws -> InfomaniakResponse<KDriveFileItem> {
        try await client.send(
            KDriveRequests.getFileByName(driveId: driveId, fileId: fileId, name: name, with: includedResources)
        )
    }

    /// Undoes a cancellable kDrive action using the v2 endpoint.
    public func undoAction(
        driveId: Int,
        cancelId: String
    ) async throws -> InfomaniakResponse<KDriveUndoActionResult> {
        try await undoAction(driveId: driveId, cancelIds: [cancelId])
    }

    /// Undoes one or more cancellable kDrive actions using the v2 endpoint.
    public func undoAction(
        driveId: Int,
        cancelIds: [String]
    ) async throws -> InfomaniakResponse<KDriveUndoActionResult> {
        let body = try JSONEncoder().encode(
            cancelIds.count == 1
                ? UndoKDriveActionOptions(cancelId: cancelIds[0])
                : UndoKDriveActionOptions(cancelIds: cancelIds)
        )
        return try await client.send(
            KDriveRequests.undoAction(driveId: driveId, body: body)
        )
    }

    /// Marks a kDrive file or directory as favorite using the v2 endpoint.
    public func favoriteFile(
        driveId: Int,
        fileId: Int
    ) async throws -> InfomaniakResponse<Bool> {
        try await client.send(
            KDriveRequests.favoriteFile(driveId: driveId, fileId: fileId)
        )
    }

    /// Removes a kDrive file or directory from favorites using the v2 endpoint.
    public func unfavoriteFile(
        driveId: Int,
        fileId: Int
    ) async throws -> InfomaniakResponse<Bool> {
        try await client.send(
            KDriveRequests.unfavoriteFile(driveId: driveId, fileId: fileId)
        )
    }

    /// Builds a kDrive archive from selected files or a parent directory.
    public func buildArchive(
        driveId: Int,
        options: BuildKDriveArchiveOptions
    ) async throws -> InfomaniakResponse<KDriveUUIDResource> {
        let body = try JSONEncoder().encode(options)
        return try await client.send(
            KDriveRequests.buildArchive(driveId: driveId, body: body)
        )
    }

    /// Checks whether kDrive file or directory identifiers still exist.
    public func checkFilesExistence(
        driveId: Int,
        fileIds: [Int]
    ) async throws -> InfomaniakResponse<[KDriveFilesExistenceResult]> {
        try await client.send(KDriveRequests.checkFilesExistence(driveId: driveId, fileIds: fileIds))
    }

    /// Renames a kDrive file or directory.
    public func renameFile(
        driveId: Int,
        fileId: Int,
        options: RenameKDriveFileOptions
    ) async throws -> InfomaniakResponse<KDriveCancelResource> {
        let body = try JSONEncoder().encode(options)
        return try await client.send(
            KDriveRequests.renameFileV2(
                driveId: driveId,
                fileId: fileId,
                body: body
            )
        )
    }

    /// Creates an empty default kDrive file inside the specified parent directory.
    public func createDefaultFile(
        driveId: Int,
        fileId: Int,
        with includedResources: String? = nil,
        options: CreateKDriveDefaultFileOptions
    ) async throws -> InfomaniakResponse<KDriveFileItem> {
        let body = try JSONEncoder().encode(options)
        return try await client.send(
            KDriveRequests.createDefaultFileV3(
                driveId: driveId,
                fileId: fileId,
                with: includedResources,
                body: body
            )
        )
    }

    /// Creates a kDrive directory inside the specified parent directory.
    public func createDirectory(
        driveId: Int,
        fileId: Int,
        with includedResources: String? = nil,
        options: CreateKDriveDirectoryOptions
    ) async throws -> InfomaniakResponse<KDriveFileItem> {
        let body = try JSONEncoder().encode(options)
        return try await client.send(
            KDriveRequests.createDirectoryV3(
                driveId: driveId,
                fileId: fileId,
                with: includedResources,
                body: body
            )
        )
    }

    /// Copies a kDrive file or directory into another directory.
    public func copyFileToDirectory(
        driveId: Int,
        fileId: Int,
        destinationDirectoryId: Int,
        with includedResources: String? = nil,
        options: CopyKDriveFileOptions = CopyKDriveFileOptions()
    ) async throws -> InfomaniakResponse<KDriveFileItem> {
        let body = try JSONEncoder().encode(options)
        return try await client.send(
            KDriveRequests.copyFileToDirectoryV3(
                driveId: driveId,
                fileId: fileId,
                destinationDirectoryId: destinationDirectoryId,
                with: includedResources,
                body: body
            )
        )
    }

    /// Moves a kDrive file or directory into another directory.
    public func moveFile(
        driveId: Int,
        fileId: Int,
        destinationDirectoryId: Int,
        options: MoveKDriveFileOptions = MoveKDriveFileOptions()
    ) async throws -> InfomaniakResponse<KDriveCancelResource> {
        let body = try JSONEncoder().encode(options)
        return try await client.send(
            KDriveRequests.moveFileV3(
                driveId: driveId,
                fileId: fileId,
                destinationDirectoryId: destinationDirectoryId,
                body: body
            )
        )
    }

    /// Duplicates a kDrive file or directory in place.
    public func duplicateFile(
        driveId: Int,
        fileId: Int,
        with includedResources: String? = nil,
        options: DuplicateKDriveFileOptions = DuplicateKDriveFileOptions()
    ) async throws -> InfomaniakResponse<KDriveFileItem> {
        let body = try JSONEncoder().encode(options)
        return try await client.send(
            KDriveRequests.duplicateFileV3(
                driveId: driveId,
                fileId: fileId,
                with: includedResources,
                body: body
            )
        )
    }

    /// Updates the modification date of a kDrive file.
    public func updateFileLastModified(
        driveId: Int,
        fileId: Int,
        lastModifiedAt: Int
    ) async throws -> InfomaniakResponse<Bool> {
        let body = try JSONEncoder().encode(UpdateKDriveFileLastModifiedOptions(lastModifiedAt: lastModifiedAt))
        return try await client.send(
            KDriveRequests.updateFileLastModified(
                driveId: driveId,
                fileId: fileId,
                body: body
            )
        )
    }
}
