import Foundation

extension KDriveService {
    /// Downloads raw file data from kDrive.
    public func downloadFile(
        driveId: Int,
        fileId: Int,
        options: DownloadKDriveFileOptions = DownloadKDriveFileOptions()
    ) async throws -> Data {
        try await client.sendData(
            KDriveRequests.downloadFile(driveId: driveId, fileId: fileId, options: options)
        )
    }

    /// Gets thumbnail data for a kDrive file.
    public func getFileThumbnail(
        driveId: Int,
        fileId: Int,
        options: GetKDriveFileThumbnailOptions = GetKDriveFileThumbnailOptions()
    ) async throws -> Data {
        try await client.sendData(
            KDriveRequests.getFileThumbnail(driveId: driveId, fileId: fileId, options: options)
        )
    }

    /// Gets preview image data for a kDrive file.
    public func getFilePreview(
        driveId: Int,
        fileId: Int,
        options: GetKDriveFilePreviewOptions = GetKDriveFilePreviewOptions()
    ) async throws -> Data {
        try await client.sendData(
            KDriveRequests.getFilePreview(driveId: driveId, fileId: fileId, options: options)
        )
    }

    /// Downloads a built kDrive archive as ZIP data.
    public func downloadArchive(
        driveId: Int,
        archiveUUID: String
    ) async throws -> Data {
        try await client.sendData(
            KDriveRequests.downloadArchive(driveId: driveId, archiveUUID: archiveUUID)
        )
    }

    /// Uploads raw file data to kDrive using the v3 single-request endpoint.
    public func uploadFile(
        driveId: Int,
        data: Data,
        options: UploadKDriveFileOptions
    ) async throws -> InfomaniakResponse<KDriveFileItem> {
        try await client.send(KDriveRequests.uploadFile(driveId: driveId, data: data, options: options))
    }
}
