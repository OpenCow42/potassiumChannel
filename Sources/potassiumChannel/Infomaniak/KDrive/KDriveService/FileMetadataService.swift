import Foundation

extension KDriveService {
    /// Lists activities for the root of a kDrive.
    public func listRootFileActivitiesV3(
        driveId: Int,
        with includedResources: String? = nil,
        options: ListKDriveRootFileActivitiesV3Options = ListKDriveRootFileActivitiesV3Options()
    ) async throws -> CursorPaginatedInfomaniakResponse<[KDriveDriveActivity]> {
        try await client.send(
            KDriveRequests.listRootFileActivitiesV3(
                driveId: driveId,
                with: includedResources,
                options: options
            )
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

    /// Lists categories configured on a kDrive.
    public func listCategories(
        driveId: Int
    ) async throws -> InfomaniakResponse<[KDriveCategory]> {
        try await client.send(
            KDriveRequests.listCategories(driveId: driveId)
        )
    }

    /// Creates a category on a kDrive.
    public func createCategory(
        driveId: Int,
        options: CreateKDriveCategoryOptions
    ) async throws -> InfomaniakResponse<KDriveCategory> {
        try await client.send(
            KDriveRequests.createCategory(driveId: driveId, options: options)
        )
    }

    /// Updates a category on a kDrive.
    public func updateCategory(
        driveId: Int,
        categoryId: Int,
        options: UpdateKDriveCategoryOptions
    ) async throws -> InfomaniakResponse<KDriveCategory> {
        try await client.send(
            KDriveRequests.updateCategory(driveId: driveId, categoryId: categoryId, options: options)
        )
    }

    /// Deletes a category from a kDrive.
    public func deleteCategory(
        driveId: Int,
        categoryId: Int
    ) async throws -> InfomaniakResponse<Bool> {
        try await client.send(
            KDriveRequests.deleteCategory(driveId: driveId, categoryId: categoryId)
        )
    }

    /// Adds a category to a kDrive file or directory.
    public func addCategoryToFile(
        driveId: Int,
        fileId: Int,
        categoryId: Int
    ) async throws -> InfomaniakResponse<KDriveFileCategoryFeedback> {
        try await client.send(
            KDriveRequests.addCategoryToFile(driveId: driveId, fileId: fileId, categoryId: categoryId)
        )
    }

    /// Adds a category to multiple kDrive files or directories.
    public func addCategoryToFiles(
        driveId: Int,
        categoryId: Int,
        options: KDriveFileCategoryBulkOptions
    ) async throws -> InfomaniakResponse<[KDriveFileCategoryFeedback]> {
        try await client.send(
            KDriveRequests.addCategoryToFiles(driveId: driveId, categoryId: categoryId, options: options)
        )
    }

    /// Removes a category from a kDrive file or directory.
    public func removeCategoryFromFile(
        driveId: Int,
        fileId: Int,
        categoryId: Int
    ) async throws -> InfomaniakResponse<Bool> {
        try await client.send(
            KDriveRequests.removeCategoryFromFile(driveId: driveId, fileId: fileId, categoryId: categoryId)
        )
    }

    /// Removes a category from multiple kDrive files or directories.
    public func removeCategoryFromFiles(
        driveId: Int,
        categoryId: Int,
        options: KDriveFileCategoryBulkOptions
    ) async throws -> InfomaniakResponse<[KDriveFileCategoryFeedback]> {
        try await client.send(
            KDriveRequests.removeCategoryFromFiles(driveId: driveId, categoryId: categoryId, options: options)
        )
    }

    /// Removes every category from a kDrive file or directory.
    public func removeCategoriesFromFile(
        driveId: Int,
        fileId: Int
    ) async throws -> InfomaniakResponse<Bool> {
        try await client.send(
            KDriveRequests.removeCategoriesFromFile(driveId: driveId, fileId: fileId)
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

    /// Gets total file and storage size for a kDrive file or directory.
    public func getFileSize(
        driveId: Int,
        fileId: Int,
        depth: String? = nil
    ) async throws -> InfomaniakResponse<KDriveFileSize> {
        try await client.send(
            KDriveRequests.getFileSize(driveId: driveId, fileId: fileId, depth: depth)
        )
    }

    /// Gets the content hash for a kDrive file.
    public func getFileHash(
        driveId: Int,
        fileId: Int
    ) async throws -> InfomaniakResponse<KDriveFileHash> {
        try await client.send(
            KDriveRequests.getFileHash(driveId: driveId, fileId: fileId)
        )
    }

    /// Gets a temporary URL for a kDrive file.
    public func getFileTemporaryURL(
        driveId: Int,
        fileId: Int,
        duration: Int? = nil
    ) async throws -> InfomaniakResponse<KDriveFileTemporaryURL> {
        try await client.send(
            KDriveRequests.getFileTemporaryURL(driveId: driveId, fileId: fileId, duration: duration)
        )
    }

    /// Lists versions for a kDrive file using the deprecated v2 endpoint.
    public func listFileVersionsV2(
        driveId: Int,
        fileId: Int,
        orderBy: String? = nil,
        order: String? = nil,
        orderFor: [String: String] = [:]
    ) async throws -> InfomaniakResponse<[KDriveFileVersionV2]> {
        try await client.send(
            KDriveRequests.listFileVersionsV2(
                driveId: driveId,
                fileId: fileId,
                orderBy: orderBy,
                order: order,
                orderFor: orderFor
            )
        )
    }

    /// Deletes all versions for a kDrive file using the deprecated v2 endpoint.
    public func deleteFileVersionsV2(
        driveId: Int,
        fileId: Int
    ) async throws -> InfomaniakResponse<Bool> {
        try await client.send(
            KDriveRequests.deleteFileVersionsV2(driveId: driveId, fileId: fileId)
        )
    }

    /// Gets a single version for a kDrive file using the deprecated v2 endpoint.
    public func getFileVersionV2(
        driveId: Int,
        fileId: Int,
        versionId: Int
    ) async throws -> InfomaniakResponse<KDriveFileVersionV2> {
        try await client.send(
            KDriveRequests.getFileVersionV2(driveId: driveId, fileId: fileId, versionId: versionId)
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
}
