import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKDrive

@Suite("kDrive file transfer service")
struct KDriveFileTransferServiceTests {
    @Test("binary service methods synchronously return typed lazy operations")
    func binaryMethodsReturnOperations() throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(bearerToken: "test-token")
        )
        let service = KDriveService(client: client)

        let download: APIRequestOperation<Data> = try service.downloadFile(driveId: 100, fileId: 42)
        let thumbnail: APIRequestOperation<Data> = try service.getFileThumbnail(driveId: 100, fileId: 42)
        let preview: APIRequestOperation<Data> = try service.getFilePreview(driveId: 100, fileId: 42)
        let archive: APIRequestOperation<Data> = try service.downloadArchive(
            driveId: 100,
            archiveUUID: "archive-uuid"
        )
        let version: APIRequestOperation<Data> = try service.downloadFileVersionV2(
            driveId: 100,
            fileId: 42,
            versionId: 7
        )
        let upload: APIRequestOperation<InfomaniakResponse<KDriveFileItem>> = try service.uploadFile(
            driveId: 100,
            data: Data("contents".utf8),
            options: UploadKDriveFileOptions(directoryId: 1, fileName: "upload.txt")
        )

        for operation in [download, thumbnail, preview, archive, version] {
            operation.cancel()
        }
        upload.cancel()
    }
}
