import Foundation

/// A high-level service for kDrive API operations.
public struct KDriveService: Sendable {
    private let client: InfomaniakAPIClient

    /// Creates a kDrive service backed by an API client.
    public init(client: InfomaniakAPIClient) {
        self.client = client
    }

    /// Lists kDrives accessible to the authenticated user.
    public func listAccessibleKDrives(
        accountId: Int,
        with includedResources: String? = nil,
        options: ListAccessibleKDrivesOptions = ListAccessibleKDrivesOptions()
    ) async throws -> PaginatedInfomaniakResponse<[KDrive]> {
        try await client.send(
            KDriveRequests.listAccessibleKDrives(
                accountId: accountId,
                with: includedResources,
                options: options
            )
        )
    }

    /// Lists users associated with a specific kDrive.
    public func listDriveUsers(
        driveId: Int,
        page: Int? = nil,
        perPage: Int? = nil
    ) async throws -> InfomaniakResponse<[KDriveDriveUser]> {
        try await client.send(
            KDriveRequests.listDriveUsers(driveId: driveId, page: page, perPage: perPage)
        )
    }

    /// Lists users associated with a specific kDrive using the v2 endpoint.
    public func listDriveUsersV2(
        driveId: Int,
        with includedResources: String? = nil,
        options: ListKDriveDriveUsersV2Options = ListKDriveDriveUsersV2Options()
    ) async throws -> PaginatedInfomaniakResponse<[KDriveDriveUser]> {
        try await client.send(
            KDriveRequests.listDriveUsersV2(
                driveId: driveId,
                with: includedResources,
                options: options
            )
        )
    }

    /// Lists kDrives associated with a specific user.
    public func listUserDrivesV2(
        userId: Int,
        accountId: Int,
        with includedResources: String? = nil,
        options: ListKDriveUserDrivesOptions = ListKDriveUserDrivesOptions()
    ) async throws -> PaginatedInfomaniakResponse<[KDriveDriveUser]> {
        try await client.send(
            KDriveRequests.listUserDrivesV2(
                userId: userId,
                accountId: accountId,
                with: includedResources,
                options: options
            )
        )
    }

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

    /// Lists activities for a kDrive file or directory.
    public func listFileActivities(
        driveId: Int,
        fileId: Int,
        with includedResources: String? = nil,
        options: ListKDriveFileActivitiesOptions = ListKDriveFileActivitiesOptions()
    ) async throws -> CursorPaginatedInfomaniakResponse<[KDriveDriveActivity]> {
        try await client.send(
            KDriveRequests.listFileActivities(
                driveId: driveId,
                fileId: fileId,
                with: includedResources,
                options: options
            )
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

    /// Moves a kDrive file or directory to trash using the v2 endpoint.
    public func trashFileV2(
        driveId: Int,
        fileId: Int
    ) async throws -> InfomaniakResponse<KDriveCancelResource> {
        try await client.send(
            KDriveRequests.trashFileV2(driveId: driveId, fileId: fileId)
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

    /// Gets information about a single kDrive.
    public func getDrive(
        driveId: Int,
        with includedResources: String? = nil
    ) async throws -> InfomaniakResponse<KDrive> {
        try await client.send(
            KDriveRequests.getDrive(driveId: driveId, with: includedResources)
        )
    }

    /// Gets settings for a single kDrive.
    public func getDriveSettings(
        driveId: Int
    ) async throws -> InfomaniakResponse<KDriveSettings> {
        try await client.send(
            KDriveRequests.getDriveSettings(driveId: driveId)
        )
    }

    /// Lists categories configured on a kDrive.
    public func listCategories(
        driveId: Int
    ) async throws -> InfomaniakResponse<[KDriveCategory]> {
        try await client.send(
            KDriveRequests.listCategories(driveId: driveId)
        )
    }

    /// Gets category rights for a kDrive.
    public func getCategoryRights(
        driveId: Int
    ) async throws -> InfomaniakResponse<[KDriveCategoryRights]> {
        try await client.send(
            KDriveRequests.getCategoryRights(driveId: driveId)
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

    /// Counts files and directories inside a kDrive directory.
    public func getDirectoryCount(
        driveId: Int,
        fileId: Int,
        depth: String? = nil
    ) async throws -> InfomaniakResponse<KDriveDirectoryCount> {
        try await client.send(
            KDriveRequests.getDirectoryCount(driveId: driveId, fileId: fileId, depth: depth)
        )
    }

    /// Lists versions for a kDrive file.
    public func listFileVersions(
        driveId: Int,
        fileId: Int,
        page: Int? = nil,
        perPage: Int? = nil,
        total: Bool? = nil,
        orderBy: String? = nil,
        order: String? = nil,
        orderFor: [String: String] = [:]
    ) async throws -> PaginatedInfomaniakResponse<[KDriveFileVersion]> {
        try await client.send(
            KDriveRequests.listFileVersions(
                driveId: driveId,
                fileId: fileId,
                page: page,
                perPage: perPage,
                total: total,
                orderBy: orderBy,
                order: order,
                orderFor: orderFor
            )
        )
    }

    /// Lists activities recorded on a kDrive.
    public func listActivities(
        driveId: Int,
        page: Int? = nil,
        perPage: Int? = nil,
        lang: String? = nil
    ) async throws -> PaginatedInfomaniakResponse<[KDriveActivity]> {
        try await client.send(
            KDriveRequests.listActivities(driveId: driveId, page: page, perPage: perPage, lang: lang)
        )
    }

    /// Lists v3 drive-scoped activities.
    public func listDriveActivities(
        driveId: Int,
        page: Int? = nil,
        perPage: Int? = nil,
        lang: String? = nil
    ) async throws -> InfomaniakResponse<[KDriveDriveActivity]> {
        try await client.send(
            KDriveRequests.listDriveActivities(driveId: driveId, page: page, perPage: perPage, lang: lang)
        )
    }

    /// Lists v3 drive-scoped activity totals.
    public func listDriveActivityTotals(
        driveId: Int
    ) async throws -> InfomaniakResponse<Int> {
        try await client.send(
            KDriveRequests.listDriveActivityTotals(driveId: driveId)
        )
    }

    /// Returns v2 drive-scoped file size statistics.
    public func chartFileSizes(
        driveId: Int,
        from: Int,
        interval: Int,
        metrics: [String],
        until: Int
    ) async throws -> InfomaniakResponse<KDriveChart> {
        try await client.send(
            KDriveRequests.chartFileSizes(
                driveId: driveId,
                from: from,
                interval: interval,
                metrics: metrics,
                until: until
            )
        )
    }

    /// Returns v2 drive-scoped activity statistics.
    public func chartActivities(
        driveId: Int,
        from: Int,
        interval: Int,
        metric: String,
        until: Int
    ) async throws -> InfomaniakResponse<KDriveChart> {
        try await client.send(
            KDriveRequests.chartActivities(
                driveId: driveId,
                from: from,
                interval: interval,
                metric: metric,
                until: until
            )
        )
    }

    /// Exports v2 drive-scoped file size statistics as CSV data.
    public func exportFileSizes(
        driveId: Int,
        from: Int,
        interval: Int,
        metrics: [String],
        until: Int
    ) async throws -> Data {
        try await client.sendData(
            KDriveRequests.exportFileSizes(
                driveId: driveId,
                from: from,
                interval: interval,
                metrics: metrics,
                until: until
            )
        )
    }

    /// Lists users active on a kDrive during a statistics period.
    public func listActivityUsers(
        driveId: Int,
        from: Int,
        until: Int
    ) async throws -> InfomaniakResponse<[KDriveActiveMember]> {
        try await client.send(
            KDriveRequests.listActivityUsers(driveId: driveId, from: from, until: until)
        )
    }

    /// Lists files shared on a kDrive during a statistics period.
    public func listActivitySharedFiles(
        driveId: Int,
        from: Int,
        until: Int
    ) async throws -> InfomaniakResponse<[KDriveSharedFileActivity]> {
        try await client.send(
            KDriveRequests.listActivitySharedFiles(driveId: driveId, from: from, until: until)
        )
    }

    /// Lists generated kDrive activity reports.
    public func listActivityReports(
        driveId: Int,
        page: Int? = nil,
        perPage: Int? = nil
    ) async throws -> PaginatedInfomaniakResponse<[KDriveActivityReport]> {
        try await client.send(
            KDriveRequests.listActivityReports(driveId: driveId, page: page, perPage: perPage)
        )
    }

    /// Lists external imports for a kDrive.
    public func listImports(
        driveId: Int,
        page: Int? = nil,
        perPage: Int? = nil
    ) async throws -> PaginatedInfomaniakResponse<[KDriveExternalImport]> {
        try await client.send(
            KDriveRequests.listImports(driveId: driveId, page: page, perPage: perPage)
        )
    }

    /// Lists user invitations for a kDrive.
    public func listUserInvitations(
        driveId: Int,
        page: Int? = nil,
        perPage: Int? = nil
    ) async throws -> PaginatedInfomaniakResponse<[KDriveUserInvitation]> {
        try await client.send(
            KDriveRequests.listUserInvitations(driveId: driveId, page: page, perPage: perPage)
        )
    }

    /// Gets preferences for the authenticated kDrive user.
    public func getUserPreferences(
        with includedResources: String? = nil
    ) async throws -> InfomaniakResponse<KDriveUserPreferences> {
        try await client.send(
            KDriveRequests.getUserPreferences(with: includedResources)
        )
    }

    /// Lists users associated with the authenticated user's accessible kDrives.
    public func listKDriveUsers(
        with includedResources: String? = nil,
        options: ListKDriveUsersOptions = ListKDriveUsersOptions()
    ) async throws -> PaginatedInfomaniakResponse<[KDriveUser]> {
        try await client.send(
            KDriveRequests.listKDriveUsers(
                with: includedResources,
                options: options
            )
        )
    }
}
