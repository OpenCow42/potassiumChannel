import Foundation
import PotassiumChannelCore

extension KDriveService {
    /// Downloads raw file data from kDrive.
    public func downloadFile(
        driveId: Int,
        fileId: Int,
        options: DownloadKDriveFileOptions = DownloadKDriveFileOptions()
    ) throws -> APIRequestOperation<Data> {
        try client.dataOperation(
            for: KDriveRequests.downloadFile(driveId: driveId, fileId: fileId, options: options)
        )
    }

    /// Gets thumbnail data for a kDrive file.
    public func getFileThumbnail(
        driveId: Int,
        fileId: Int,
        options: GetKDriveFileThumbnailOptions = GetKDriveFileThumbnailOptions()
    ) throws -> APIRequestOperation<Data> {
        try client.dataOperation(
            for: KDriveRequests.getFileThumbnail(driveId: driveId, fileId: fileId, options: options)
        )
    }

    /// Gets preview image data for a kDrive file.
    public func getFilePreview(
        driveId: Int,
        fileId: Int,
        options: GetKDriveFilePreviewOptions = GetKDriveFilePreviewOptions()
    ) throws -> APIRequestOperation<Data> {
        try client.dataOperation(
            for: KDriveRequests.getFilePreview(driveId: driveId, fileId: fileId, options: options)
        )
    }

    /// Downloads a built kDrive archive as ZIP data.
    public func downloadArchive(
        driveId: Int,
        archiveUUID: String
    ) throws -> APIRequestOperation<Data> {
        try client.dataOperation(
            for: KDriveRequests.downloadArchive(driveId: driveId, archiveUUID: archiveUUID)
        )
    }

    /// Downloads raw data for a kDrive file version using the deprecated v2 endpoint.
    public func downloadFileVersionV2(
        driveId: Int,
        fileId: Int,
        versionId: Int
    ) throws -> APIRequestOperation<Data> {
        try client.dataOperation(
            for: KDriveRequests.downloadFileVersionV2(driveId: driveId, fileId: fileId, versionId: versionId)
        )
    }

    /// Uploads raw file data to kDrive using the v3 single-request endpoint.
    public func uploadFile(
        driveId: Int,
        data: Data,
        options: UploadKDriveFileOptions
    ) throws -> APIRequestOperation<InfomaniakResponse<KDriveFileItem>> {
        try client.operation(for: KDriveRequests.uploadFile(driveId: driveId, data: data, options: options))
    }
}
