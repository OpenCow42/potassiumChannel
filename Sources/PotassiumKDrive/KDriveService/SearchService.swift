import Foundation
import PotassiumChannelCore

extension KDriveService {
    /// Searches files and directories on a kDrive.
    public func searchFiles(
        driveId: Int,
        with includedResources: String? = nil,
        options: SearchKDriveFilesOptions = SearchKDriveFilesOptions()
    ) async throws -> CursorPaginatedInfomaniakResponse<[KDriveFileItem]> {
        try await client.send(
            KDriveRequests.searchFiles(driveId: driveId, with: includedResources, options: options)
        )
    }

    /// Searches favorite files and directories on a kDrive.
    public func searchFavorites(
        driveId: Int,
        with includedResources: String? = nil,
        options: SearchKDriveFavoritesOptions = SearchKDriveFavoritesOptions()
    ) async throws -> CursorPaginatedInfomaniakResponse<[KDriveFileItem]> {
        try await client.send(
            KDriveRequests.searchFavorites(driveId: driveId, with: includedResources, options: options)
        )
    }

    /// Searches files and directories shared by the user on a kDrive.
    public func searchMyShared(
        driveId: Int,
        with includedResources: String? = nil,
        options: SearchKDriveMySharedOptions = SearchKDriveMySharedOptions()
    ) async throws -> CursorPaginatedInfomaniakResponse<[KDriveFileItem]> {
        try await client.send(
            KDriveRequests.searchMyShared(driveId: driveId, with: includedResources, options: options)
        )
    }

    /// Searches files and directories shared with the user on a kDrive.
    public func searchSharedWithMe(
        driveId: Int,
        with includedResources: String? = nil,
        options: SearchKDriveSharedWithMeOptions = SearchKDriveSharedWithMeOptions()
    ) async throws -> CursorPaginatedInfomaniakResponse<[KDriveFileItem]> {
        try await client.send(
            KDriveRequests.searchSharedWithMe(driveId: driveId, with: includedResources, options: options)
        )
    }

    /// Searches dropbox directories on a kDrive.
    public func searchDropboxes(
        driveId: Int,
        with includedResources: String? = nil,
        options: SearchKDriveDropboxesOptions = SearchKDriveDropboxesOptions()
    ) async throws -> CursorPaginatedInfomaniakResponse<[KDriveFileItem]> {
        try await client.send(
            KDriveRequests.searchDropboxes(driveId: driveId, with: includedResources, options: options)
        )
    }

    /// Searches files and directories with share links on a kDrive.
    public func searchShareLinks(
        driveId: Int,
        with includedResources: String? = nil,
        options: SearchKDriveShareLinksOptions = SearchKDriveShareLinksOptions()
    ) async throws -> CursorPaginatedInfomaniakResponse<[KDriveFileItem]> {
        try await client.send(
            KDriveRequests.searchShareLinks(driveId: driveId, with: includedResources, options: options)
        )
    }
}
