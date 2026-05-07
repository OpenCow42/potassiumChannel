import Foundation

/// Factory methods for kDrive API requests.
public enum KDriveRequests {
    /// Creates a request that lists kDrives accessible to the authenticated user.
    public static func listAccessibleKDrives(
        accountId: Int,
        with includedResources: String? = nil,
        options: ListAccessibleKDrivesOptions = ListAccessibleKDrivesOptions()
    ) -> APIRequest<PaginatedInfomaniakResponse<[KDrive]>> {
        var queryParameters: [QueryParameter] = [
            QueryParameter(name: "account_id", value: .integer(accountId)),
        ]

        if let includedResources {
            queryParameters.append(QueryParameter(name: "with", value: .string(includedResources)))
        }

        if let inMaintenance = options.inMaintenance {
            queryParameters.append(QueryParameter(name: "in_maintenance", value: .bool(inMaintenance)))
        }

        if !options.maintenanceReasons.isEmpty {
            queryParameters.append(QueryParameter(name: "maintenance_reasons", value: .strings(options.maintenanceReasons)))
        }

        if !options.tags.isEmpty {
            queryParameters.append(QueryParameter(name: "tags", value: .integers(options.tags)))
        }

        if let page = options.page {
            queryParameters.append(QueryParameter(name: "page", value: .integer(page)))
        }

        if let perPage = options.perPage {
            queryParameters.append(QueryParameter(name: "per_page", value: .integer(perPage)))
        }

        return APIRequest(
            method: .get,
            path: "/2/drive",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that lists users associated with a specific kDrive.
    public static func listDriveUsers(
        driveId: Int,
        page: Int? = nil,
        perPage: Int? = nil
    ) -> APIRequest<InfomaniakResponse<[KDriveDriveUser]>> {
        var queryParameters: [QueryParameter] = []

        if let page {
            queryParameters.append(QueryParameter(name: "page", value: .integer(page)))
        }

        if let perPage {
            queryParameters.append(QueryParameter(name: "per_page", value: .integer(perPage)))
        }

        return APIRequest(
            method: .get,
            path: "/3/drive/\(driveId)/users",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that lists users associated with a specific kDrive using the v2 endpoint.
    public static func listDriveUsersV2(
        driveId: Int,
        with includedResources: String? = nil,
        options: ListKDriveDriveUsersV2Options = ListKDriveDriveUsersV2Options()
    ) -> APIRequest<PaginatedInfomaniakResponse<[KDriveDriveUser]>> {
        var queryParameters: [QueryParameter] = []

        if let includedResources {
            queryParameters.append(QueryParameter(name: "with", value: .string(includedResources)))
        }

        if let search = options.search {
            queryParameters.append(QueryParameter(name: "search", value: .string(search)))
        }

        if !options.statuses.isEmpty {
            queryParameters.append(QueryParameter(name: "status", value: .strings(options.statuses)))
        }

        if !options.types.isEmpty {
            queryParameters.append(QueryParameter(name: "types", value: .strings(options.types)))
        }

        if !options.userIds.isEmpty {
            queryParameters.append(QueryParameter(name: "user_ids", value: .integers(options.userIds)))
        }

        if let page = options.page {
            queryParameters.append(QueryParameter(name: "page", value: .integer(page)))
        }

        if let perPage = options.perPage {
            queryParameters.append(QueryParameter(name: "per_page", value: .integer(perPage)))
        }

        if let total = options.total {
            queryParameters.append(QueryParameter(name: "total", value: .bool(total)))
        }

        if !options.orderBy.isEmpty {
            queryParameters.append(QueryParameter(name: "order_by", value: .strings(options.orderBy)))
        }

        if let order = options.order {
            queryParameters.append(QueryParameter(name: "order", value: .string(order)))
        }

        for (field, order) in options.orderFor {
            queryParameters.append(QueryParameter(name: "order_for[\(field)]", value: .string(order)))
        }

        return APIRequest(
            method: .get,
            path: "/2/drive/\(driveId)/users",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that lists kDrives associated with a specific user.
    public static func listUserDrivesV2(
        userId: Int,
        accountId: Int,
        with includedResources: String? = nil,
        options: ListKDriveUserDrivesOptions = ListKDriveUserDrivesOptions()
    ) -> APIRequest<PaginatedInfomaniakResponse<[KDriveDriveUser]>> {
        var queryParameters: [QueryParameter] = [
            QueryParameter(name: "account_id", value: .integer(accountId)),
        ]

        if let includedResources {
            queryParameters.append(QueryParameter(name: "with", value: .string(includedResources)))
        }

        if !options.roles.isEmpty {
            queryParameters.append(QueryParameter(name: "roles[]", value: .strings(options.roles)))
        }

        if !options.statuses.isEmpty {
            queryParameters.append(QueryParameter(name: "status[]", value: .strings(options.statuses)))
        }

        if let page = options.page {
            queryParameters.append(QueryParameter(name: "page", value: .integer(page)))
        }

        if let perPage = options.perPage {
            queryParameters.append(QueryParameter(name: "per_page", value: .integer(perPage)))
        }

        if let total = options.total {
            queryParameters.append(QueryParameter(name: "total", value: .bool(total)))
        }

        return APIRequest(
            method: .get,
            path: "/2/drive/users/\(userId)/drives",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that lists recent files and directories on a kDrive.
    public static func listRecentFiles(
        driveId: Int,
        page: Int? = nil,
        perPage: Int? = nil
    ) -> APIRequest<InfomaniakResponse<[KDriveFileItem]>> {
        var queryParameters: [QueryParameter] = []

        if let page {
            queryParameters.append(QueryParameter(name: "page", value: .integer(page)))
        }

        if let perPage {
            queryParameters.append(QueryParameter(name: "per_page", value: .integer(perPage)))
        }

        return APIRequest(
            method: .get,
            path: "/3/drive/\(driveId)/files/recents",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that lists the largest files on a kDrive.
    public static func listLargestFiles(
        driveId: Int,
        cursor: String? = nil,
        limit: Int? = nil
    ) -> APIRequest<InfomaniakResponse<[KDriveFileItem]>> {
        var queryParameters: [QueryParameter] = []

        if let cursor {
            queryParameters.append(QueryParameter(name: "cursor", value: .string(cursor)))
        }

        if let limit {
            queryParameters.append(QueryParameter(name: "limit", value: .integer(limit)))
        }

        return APIRequest(
            method: .get,
            path: "/3/drive/\(driveId)/files/largest",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that lists the last modified files on a kDrive.
    public static func listLastModifiedFiles(
        driveId: Int,
        cursor: String? = nil,
        limit: Int? = nil
    ) -> APIRequest<InfomaniakResponse<[KDriveFileItem]>> {
        var queryParameters: [QueryParameter] = []

        if let cursor {
            queryParameters.append(QueryParameter(name: "cursor", value: .string(cursor)))
        }

        if let limit {
            queryParameters.append(QueryParameter(name: "limit", value: .integer(limit)))
        }

        return APIRequest(
            method: .get,
            path: "/3/drive/\(driveId)/files/last_modified",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that lists the most versioned files on a kDrive.
    public static func listMostVersionedFiles(
        driveId: Int,
        cursor: String? = nil,
        limit: Int? = nil
    ) -> APIRequest<InfomaniakResponse<[KDriveFileItem]>> {
        var queryParameters: [QueryParameter] = []

        if let cursor {
            queryParameters.append(QueryParameter(name: "cursor", value: .string(cursor)))
        }

        if let limit {
            queryParameters.append(QueryParameter(name: "limit", value: .integer(limit)))
        }

        return APIRequest(
            method: .get,
            path: "/3/drive/\(driveId)/files/most_versions",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that lists favorite files and directories on a kDrive.
    public static func listFavoriteFiles(
        driveId: Int,
        cursor: String? = nil,
        limit: Int? = nil
    ) -> APIRequest<InfomaniakResponse<[KDriveFileItem]>> {
        var queryParameters: [QueryParameter] = []

        if let cursor {
            queryParameters.append(QueryParameter(name: "cursor", value: .string(cursor)))
        }

        if let limit {
            queryParameters.append(QueryParameter(name: "limit", value: .integer(limit)))
        }

        return APIRequest(
            method: .get,
            path: "/3/drive/\(driveId)/files/favorites",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that lists drop-box directories on a kDrive.
    public static func listDropboxes(
        driveId: Int,
        cursor: String? = nil,
        limit: Int? = nil
    ) -> APIRequest<InfomaniakResponse<[KDriveFileItem]>> {
        var queryParameters: [QueryParameter] = []

        if let cursor {
            queryParameters.append(QueryParameter(name: "cursor", value: .string(cursor)))
        }

        if let limit {
            queryParameters.append(QueryParameter(name: "limit", value: .integer(limit)))
        }

        return APIRequest(
            method: .get,
            path: "/3/drive/\(driveId)/files/dropboxes",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that lists files and directories shared by the user on a kDrive.
    public static func listMySharedFiles(
        driveId: Int,
        cursor: String? = nil,
        limit: Int? = nil
    ) -> APIRequest<InfomaniakResponse<[KDriveFileItem]>> {
        var queryParameters: [QueryParameter] = []

        if let cursor {
            queryParameters.append(QueryParameter(name: "cursor", value: .string(cursor)))
        }

        if let limit {
            queryParameters.append(QueryParameter(name: "limit", value: .integer(limit)))
        }

        return APIRequest(
            method: .get,
            path: "/3/drive/\(driveId)/files/my_shared",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that lists files and directories shared with the user on a kDrive.
    public static func listSharedWithMeFiles(
        driveId: Int,
        cursor: String? = nil,
        limit: Int? = nil
    ) -> APIRequest<InfomaniakResponse<[KDriveFileItem]>> {
        var queryParameters: [QueryParameter] = []

        if let cursor {
            queryParameters.append(QueryParameter(name: "cursor", value: .string(cursor)))
        }

        if let limit {
            queryParameters.append(QueryParameter(name: "limit", value: .integer(limit)))
        }

        return APIRequest(
            method: .get,
            path: "/3/drive/\(driveId)/files/shared_with_me",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that lists files and directories with share links on a kDrive.
    public static func listShareLinkFiles(
        driveId: Int,
        cursor: String? = nil,
        limit: Int? = nil
    ) -> APIRequest<InfomaniakResponse<[KDriveFileItem]>> {
        var queryParameters: [QueryParameter] = []

        if let cursor {
            queryParameters.append(QueryParameter(name: "cursor", value: .string(cursor)))
        }

        if let limit {
            queryParameters.append(QueryParameter(name: "limit", value: .integer(limit)))
        }

        return APIRequest(
            method: .get,
            path: "/3/drive/\(driveId)/files/links",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that searches files and directories on a kDrive.
    public static func searchFiles(
        driveId: Int,
        with includedResources: String? = nil,
        options: SearchKDriveFilesOptions = SearchKDriveFilesOptions()
    ) -> APIRequest<CursorPaginatedInfomaniakResponse<[KDriveFileItem]>> {
        var queryParameters: [QueryParameter] = []

        if let includedResources {
            queryParameters.append(QueryParameter(name: "with", value: .string(includedResources)))
        }

        if let cursor = options.cursor {
            queryParameters.append(QueryParameter(name: "cursor", value: .string(cursor)))
        }

        if let limit = options.limit {
            queryParameters.append(QueryParameter(name: "limit", value: .integer(limit)))
        }

        if !options.orderBy.isEmpty {
            queryParameters.append(QueryParameter(name: "order_by", value: .strings(options.orderBy)))
        }

        if let order = options.order {
            queryParameters.append(QueryParameter(name: "order", value: .string(order)))
        }

        for (field, direction) in options.orderFor.sorted(by: { $0.key < $1.key }) {
            queryParameters.append(QueryParameter(name: "order_for[\(field)]", value: .string(direction)))
        }

        if let authorId = options.authorId {
            queryParameters.append(QueryParameter(name: "author_id", value: .integer(authorId)))
        }

        if let category = options.category {
            queryParameters.append(QueryParameter(name: "category", value: .string(category)))
        }

        if let depth = options.depth {
            queryParameters.append(QueryParameter(name: "depth", value: .string(depth)))
        }

        if let directoryId = options.directoryId {
            queryParameters.append(QueryParameter(name: "directory_id", value: .integer(directoryId)))
        }

        if !options.extensions.isEmpty {
            queryParameters.append(QueryParameter(name: "extensions", value: .strings(options.extensions)))
        }

        if let modifiedAfter = options.modifiedAfter {
            queryParameters.append(QueryParameter(name: "modified_after", value: .integer(modifiedAfter)))
        }

        if let modifiedAt = options.modifiedAt {
            queryParameters.append(QueryParameter(name: "modified_at", value: .string(modifiedAt)))
        }

        if let modifiedBefore = options.modifiedBefore {
            queryParameters.append(QueryParameter(name: "modified_before", value: .integer(modifiedBefore)))
        }

        if let name = options.name {
            queryParameters.append(QueryParameter(name: "name", value: .string(name)))
        }

        if let query = options.query {
            queryParameters.append(QueryParameter(name: "query", value: .string(query)))
        }

        if let queryScope = options.queryScope {
            queryParameters.append(QueryParameter(name: "query_scope", value: .string(queryScope)))
        }

        if !options.types.isEmpty {
            queryParameters.append(QueryParameter(name: "types", value: .strings(options.types)))
        }

        return APIRequest(
            method: .get,
            path: "/3/drive/\(driveId)/files/search",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that searches favorite files and directories on a kDrive.
    public static func searchFavorites(
        driveId: Int,
        with includedResources: String? = nil,
        options: SearchKDriveFavoritesOptions = SearchKDriveFavoritesOptions()
    ) -> APIRequest<CursorPaginatedInfomaniakResponse<[KDriveFileItem]>> {
        var queryParameters: [QueryParameter] = []

        if let includedResources {
            queryParameters.append(QueryParameter(name: "with", value: .string(includedResources)))
        }

        if let cursor = options.cursor {
            queryParameters.append(QueryParameter(name: "cursor", value: .string(cursor)))
        }

        if let limit = options.limit {
            queryParameters.append(QueryParameter(name: "limit", value: .integer(limit)))
        }

        if !options.orderBy.isEmpty {
            queryParameters.append(QueryParameter(name: "order_by", value: .strings(options.orderBy)))
        }

        if let order = options.order {
            queryParameters.append(QueryParameter(name: "order", value: .string(order)))
        }

        for (field, direction) in options.orderFor.sorted(by: { $0.key < $1.key }) {
            queryParameters.append(QueryParameter(name: "order_for[\(field)]", value: .string(direction)))
        }

        if let authorId = options.authorId {
            queryParameters.append(QueryParameter(name: "author_id", value: .integer(authorId)))
        }

        if let category = options.category {
            queryParameters.append(QueryParameter(name: "category", value: .string(category)))
        }

        if let depth = options.depth {
            queryParameters.append(QueryParameter(name: "depth", value: .string(depth)))
        }

        if let directoryId = options.directoryId {
            queryParameters.append(QueryParameter(name: "directory_id", value: .integer(directoryId)))
        }

        if !options.extensions.isEmpty {
            queryParameters.append(QueryParameter(name: "extensions", value: .strings(options.extensions)))
        }

        if let modifiedAfter = options.modifiedAfter {
            queryParameters.append(QueryParameter(name: "modified_after", value: .integer(modifiedAfter)))
        }

        if let modifiedAt = options.modifiedAt {
            queryParameters.append(QueryParameter(name: "modified_at", value: .string(modifiedAt)))
        }

        if let modifiedBefore = options.modifiedBefore {
            queryParameters.append(QueryParameter(name: "modified_before", value: .integer(modifiedBefore)))
        }

        if let name = options.name {
            queryParameters.append(QueryParameter(name: "name", value: .string(name)))
        }

        if let query = options.query {
            queryParameters.append(QueryParameter(name: "query", value: .string(query)))
        }

        if let queryScope = options.queryScope {
            queryParameters.append(QueryParameter(name: "query_scope", value: .string(queryScope)))
        }

        if !options.types.isEmpty {
            queryParameters.append(QueryParameter(name: "types", value: .strings(options.types)))
        }

        return APIRequest(
            method: .get,
            path: "/3/drive/\(driveId)/files/search/favorites",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that searches files and directories shared by the user on a kDrive.
    public static func searchMyShared(
        driveId: Int,
        with includedResources: String? = nil,
        options: SearchKDriveMySharedOptions = SearchKDriveMySharedOptions()
    ) -> APIRequest<CursorPaginatedInfomaniakResponse<[KDriveFileItem]>> {
        var queryParameters: [QueryParameter] = []

        if let includedResources {
            queryParameters.append(QueryParameter(name: "with", value: .string(includedResources)))
        }

        if let cursor = options.cursor {
            queryParameters.append(QueryParameter(name: "cursor", value: .string(cursor)))
        }

        if let limit = options.limit {
            queryParameters.append(QueryParameter(name: "limit", value: .integer(limit)))
        }

        if !options.orderBy.isEmpty {
            queryParameters.append(QueryParameter(name: "order_by", value: .strings(options.orderBy)))
        }

        if let order = options.order {
            queryParameters.append(QueryParameter(name: "order", value: .string(order)))
        }

        for (field, direction) in options.orderFor.sorted(by: { $0.key < $1.key }) {
            queryParameters.append(QueryParameter(name: "order_for[\(field)]", value: .string(direction)))
        }

        if let authorId = options.authorId {
            queryParameters.append(QueryParameter(name: "author_id", value: .integer(authorId)))
        }

        if let category = options.category {
            queryParameters.append(QueryParameter(name: "category", value: .string(category)))
        }

        if let depth = options.depth {
            queryParameters.append(QueryParameter(name: "depth", value: .string(depth)))
        }

        if let directoryId = options.directoryId {
            queryParameters.append(QueryParameter(name: "directory_id", value: .integer(directoryId)))
        }

        if !options.extensions.isEmpty {
            queryParameters.append(QueryParameter(name: "extensions", value: .strings(options.extensions)))
        }

        if let modifiedAfter = options.modifiedAfter {
            queryParameters.append(QueryParameter(name: "modified_after", value: .integer(modifiedAfter)))
        }

        if let modifiedAt = options.modifiedAt {
            queryParameters.append(QueryParameter(name: "modified_at", value: .string(modifiedAt)))
        }

        if let modifiedBefore = options.modifiedBefore {
            queryParameters.append(QueryParameter(name: "modified_before", value: .integer(modifiedBefore)))
        }

        if let name = options.name {
            queryParameters.append(QueryParameter(name: "name", value: .string(name)))
        }

        if let query = options.query {
            queryParameters.append(QueryParameter(name: "query", value: .string(query)))
        }

        if let queryScope = options.queryScope {
            queryParameters.append(QueryParameter(name: "query_scope", value: .string(queryScope)))
        }

        if !options.types.isEmpty {
            queryParameters.append(QueryParameter(name: "types", value: .strings(options.types)))
        }

        return APIRequest(
            method: .get,
            path: "/3/drive/\(driveId)/files/search/my_shared",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that searches files and directories shared with the user on a kDrive.
    public static func searchSharedWithMe(
        driveId: Int,
        with includedResources: String? = nil,
        options: SearchKDriveSharedWithMeOptions = SearchKDriveSharedWithMeOptions()
    ) -> APIRequest<CursorPaginatedInfomaniakResponse<[KDriveFileItem]>> {
        var queryParameters: [QueryParameter] = []

        if let includedResources {
            queryParameters.append(QueryParameter(name: "with", value: .string(includedResources)))
        }

        if let cursor = options.cursor {
            queryParameters.append(QueryParameter(name: "cursor", value: .string(cursor)))
        }

        if let limit = options.limit {
            queryParameters.append(QueryParameter(name: "limit", value: .integer(limit)))
        }

        if !options.orderBy.isEmpty {
            queryParameters.append(QueryParameter(name: "order_by", value: .strings(options.orderBy)))
        }

        if let order = options.order {
            queryParameters.append(QueryParameter(name: "order", value: .string(order)))
        }

        for (field, direction) in options.orderFor.sorted(by: { $0.key < $1.key }) {
            queryParameters.append(QueryParameter(name: "order_for[\(field)]", value: .string(direction)))
        }

        if let authorId = options.authorId {
            queryParameters.append(QueryParameter(name: "author_id", value: .integer(authorId)))
        }

        if let category = options.category {
            queryParameters.append(QueryParameter(name: "category", value: .string(category)))
        }

        if let depth = options.depth {
            queryParameters.append(QueryParameter(name: "depth", value: .string(depth)))
        }

        if let directoryId = options.directoryId {
            queryParameters.append(QueryParameter(name: "directory_id", value: .integer(directoryId)))
        }

        if !options.extensions.isEmpty {
            queryParameters.append(QueryParameter(name: "extensions", value: .strings(options.extensions)))
        }

        if let modifiedAfter = options.modifiedAfter {
            queryParameters.append(QueryParameter(name: "modified_after", value: .integer(modifiedAfter)))
        }

        if let modifiedAt = options.modifiedAt {
            queryParameters.append(QueryParameter(name: "modified_at", value: .string(modifiedAt)))
        }

        if let modifiedBefore = options.modifiedBefore {
            queryParameters.append(QueryParameter(name: "modified_before", value: .integer(modifiedBefore)))
        }

        if let name = options.name {
            queryParameters.append(QueryParameter(name: "name", value: .string(name)))
        }

        if let query = options.query {
            queryParameters.append(QueryParameter(name: "query", value: .string(query)))
        }

        if let queryScope = options.queryScope {
            queryParameters.append(QueryParameter(name: "query_scope", value: .string(queryScope)))
        }

        if !options.types.isEmpty {
            queryParameters.append(QueryParameter(name: "types", value: .strings(options.types)))
        }

        return APIRequest(
            method: .get,
            path: "/3/drive/\(driveId)/files/search/shared_with_me",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that lists files and directories in kDrive trash.
    public static func listTrashFiles(
        driveId: Int,
        with includedResources: String? = nil,
        options: ListKDriveTrashOptions = ListKDriveTrashOptions()
    ) -> APIRequest<CursorPaginatedInfomaniakResponse<[KDriveFileItem]>> {
        var queryParameters: [QueryParameter] = []

        if let includedResources {
            queryParameters.append(QueryParameter(name: "with", value: .string(includedResources)))
        }

        if let cursor = options.cursor {
            queryParameters.append(QueryParameter(name: "cursor", value: .string(cursor)))
        }

        if let limit = options.limit {
            queryParameters.append(QueryParameter(name: "limit", value: .integer(limit)))
        }

        if !options.orderBy.isEmpty {
            queryParameters.append(QueryParameter(name: "order_by", value: .strings(options.orderBy)))
        }

        if let order = options.order {
            queryParameters.append(QueryParameter(name: "order", value: .string(order)))
        }

        for (field, direction) in options.orderFor.sorted(by: { $0.key < $1.key }) {
            queryParameters.append(QueryParameter(name: "order_for[\(field)]", value: .string(direction)))
        }

        if !options.types.isEmpty {
            queryParameters.append(QueryParameter(name: "type", value: .strings(options.types)))
        }

        return APIRequest(
            method: .get,
            path: "/3/drive/\(driveId)/trash",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that gets a single kDrive file or directory.
    public static func getFile(
        driveId: Int,
        fileId: Int,
        with includedResources: String? = nil
    ) -> APIRequest<InfomaniakResponse<KDriveFileItem>> {
        var queryParameters: [QueryParameter] = []

        if let includedResources {
            queryParameters.append(QueryParameter(name: "with", value: .string(includedResources)))
        }

        return APIRequest(
            method: .get,
            path: "/3/drive/\(driveId)/files/\(fileId)",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that gets a child kDrive file or directory by name.
    public static func getFileByName(
        driveId: Int,
        fileId: Int,
        name: String,
        with includedResources: String? = nil
    ) -> APIRequest<InfomaniakResponse<KDriveFileItem>> {
        var queryParameters: [QueryParameter] = [
            QueryParameter(name: "name", value: .string(name)),
        ]

        if let includedResources {
            queryParameters.append(QueryParameter(name: "with", value: .string(includedResources)))
        }

        return APIRequest(
            method: .get,
            path: "/3/drive/\(driveId)/files/\(fileId)/name",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that lists activities for a kDrive file or directory.
    public static func listFileActivities(
        driveId: Int,
        fileId: Int,
        with includedResources: String? = nil,
        options: ListKDriveFileActivitiesOptions = ListKDriveFileActivitiesOptions()
    ) -> APIRequest<CursorPaginatedInfomaniakResponse<[KDriveDriveActivity]>> {
        var queryParameters: [QueryParameter] = []

        if let includedResources {
            queryParameters.append(QueryParameter(name: "with", value: .string(includedResources)))
        }

        if let cursor = options.cursor {
            queryParameters.append(QueryParameter(name: "cursor", value: .string(cursor)))
        }

        if let limit = options.limit {
            queryParameters.append(QueryParameter(name: "limit", value: .integer(limit)))
        }

        if !options.orderBy.isEmpty {
            queryParameters.append(QueryParameter(name: "order_by", value: .strings(options.orderBy)))
        }

        if let order = options.order {
            queryParameters.append(QueryParameter(name: "order", value: .string(order)))
        }

        for (field, direction) in options.orderFor.sorted(by: { $0.key < $1.key }) {
            queryParameters.append(QueryParameter(name: "order_for[\(field)]", value: .string(direction)))
        }

        if !options.actions.isEmpty {
            queryParameters.append(QueryParameter(name: "actions", value: .strings(options.actions)))
        }

        if let depth = options.depth {
            queryParameters.append(QueryParameter(name: "depth", value: .string(depth)))
        }

        if let from = options.from {
            queryParameters.append(QueryParameter(name: "from", value: .integer(from)))
        }

        if let terms = options.terms {
            queryParameters.append(QueryParameter(name: "terms", value: .string(terms)))
        }

        if let until = options.until {
            queryParameters.append(QueryParameter(name: "until", value: .integer(until)))
        }

        if !options.users.isEmpty {
            queryParameters.append(QueryParameter(name: "users", value: .integers(options.users)))
        }

        return APIRequest(
            method: .get,
            path: "/3/drive/\(driveId)/files/\(fileId)/activities",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that lists files and directories inside a kDrive directory.
    public static func listDirectoryFiles(
        driveId: Int,
        fileId: Int,
        with includedResources: String? = nil,
        options: ListKDriveDirectoryFilesOptions = ListKDriveDirectoryFilesOptions()
    ) -> APIRequest<CursorPaginatedInfomaniakResponse<[KDriveFileItem]>> {
        var queryParameters: [QueryParameter] = []

        if let includedResources {
            queryParameters.append(QueryParameter(name: "with", value: .string(includedResources)))
        }

        if let cursor = options.cursor {
            queryParameters.append(QueryParameter(name: "cursor", value: .string(cursor)))
        }

        if let limit = options.limit {
            queryParameters.append(QueryParameter(name: "limit", value: .integer(limit)))
        }

        if !options.orderBy.isEmpty {
            queryParameters.append(QueryParameter(name: "order_by", value: .strings(options.orderBy)))
        }

        if let order = options.order {
            queryParameters.append(QueryParameter(name: "order", value: .string(order)))
        }

        for (field, direction) in options.orderFor.sorted(by: { $0.key < $1.key }) {
            queryParameters.append(QueryParameter(name: "order_for[\(field)]", value: .string(direction)))
        }

        if let depth = options.depth {
            queryParameters.append(QueryParameter(name: "depth", value: .string(depth)))
        }

        if !options.types.isEmpty {
            queryParameters.append(QueryParameter(name: "type", value: .strings(options.types)))
        }

        return APIRequest(
            method: .get,
            path: "/3/drive/\(driveId)/files/\(fileId)/files",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that gets a single file or directory from kDrive trash.
    public static func getTrashedFile(
        driveId: Int,
        fileId: Int,
        options: GetKDriveTrashedFileOptions = GetKDriveTrashedFileOptions()
    ) -> APIRequest<InfomaniakResponse<KDriveFileItem>> {
        var queryParameters: [QueryParameter] = []

        if !options.orderBy.isEmpty {
            queryParameters.append(QueryParameter(name: "order_by", value: .strings(options.orderBy)))
        }

        if let order = options.order {
            queryParameters.append(QueryParameter(name: "order", value: .string(order)))
        }

        for (field, direction) in options.orderFor.sorted(by: { $0.key < $1.key }) {
            queryParameters.append(QueryParameter(name: "order_for[\(field)]", value: .string(direction)))
        }

        return APIRequest(
            method: .get,
            path: "/3/drive/\(driveId)/trash/\(fileId)",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that downloads a kDrive file.
    public static func downloadFile(
        driveId: Int,
        fileId: Int,
        options: DownloadKDriveFileOptions = DownloadKDriveFileOptions()
    ) -> APIRequest<KDriveBinaryResponse> {
        var queryParameters: [QueryParameter] = []
        var headers: [HTTPHeader] = [HTTPHeader(name: "Accept", value: "application/octet-stream")]

        if let conversionFormat = options.conversionFormat {
            queryParameters.append(QueryParameter(name: "as", value: .string(conversionFormat)))
        }

        if let password = options.password {
            headers.append(HTTPHeader(name: "x-kdrive-file-password", value: password))
        }

        return APIRequest(
            method: .get,
            path: "/2/drive/\(driveId)/files/\(fileId)/download",
            queryParameters: queryParameters,
            headers: headers
        )
    }

    /// Creates a request that uploads a file to kDrive using the v3 single-request endpoint.
    public static func uploadFile(
        driveId: Int,
        data: Data,
        options: UploadKDriveFileOptions
    ) -> APIRequest<InfomaniakResponse<KDriveFileItem>> {
        var queryParameters: [QueryParameter] = [
            QueryParameter(name: "total_size", value: .integer(data.count)),
        ]
        var headers: [HTTPHeader] = [
            HTTPHeader(name: "Accept", value: "application/json"),
            HTTPHeader(name: "Content-Type", value: "application/octet-stream"),
        ]

        if let with = options.with {
            queryParameters.append(QueryParameter(name: "with", value: .string(with)))
        }

        if let ifMatch = options.ifMatch {
            headers.append(HTTPHeader(name: "If-Match", value: ifMatch))
        }

        if let clientToken = options.clientToken {
            queryParameters.append(QueryParameter(name: "client_token", value: .string(clientToken)))
        }

        if let conflict = options.conflict {
            queryParameters.append(QueryParameter(name: "conflict", value: .string(conflict)))
        }

        if let createdAt = options.createdAt {
            queryParameters.append(QueryParameter(name: "created_at", value: .integer(createdAt)))
        }

        if let directoryId = options.directoryId {
            queryParameters.append(QueryParameter(name: "directory_id", value: .integer(directoryId)))
        }

        if let directoryPath = options.directoryPath {
            queryParameters.append(QueryParameter(name: "directory_path", value: .string(directoryPath)))
        }

        if let fileId = options.fileId {
            queryParameters.append(QueryParameter(name: "file_id", value: .integer(fileId)))
        }

        if let fileName = options.fileName {
            queryParameters.append(QueryParameter(name: "file_name", value: .string(fileName)))
        }

        if let lastModifiedAt = options.lastModifiedAt {
            queryParameters.append(QueryParameter(name: "last_modified_at", value: .integer(lastModifiedAt)))
        }

        if let symbolicLink = options.symbolicLink {
            queryParameters.append(QueryParameter(name: "symbolic_link", value: .string(symbolicLink)))
        }

        if let totalChunkHash = options.totalChunkHash {
            queryParameters.append(QueryParameter(name: "total_chunk_hash", value: .string(totalChunkHash)))
        }

        return APIRequest(
            method: .post,
            path: "/3/drive/\(driveId)/upload",
            queryParameters: queryParameters,
            headers: headers,
            body: data
        )
    }

    /// Creates a request that gets a thumbnail for a trashed kDrive item using the deprecated v2 endpoint.
    public static func getV2TrashedItemThumbnail(
        driveId: Int,
        fileId: Int
    ) -> APIRequest<KDriveBinaryResponse> {
        APIRequest(
            method: .get,
            path: "/2/drive/\(driveId)/trash/\(fileId)/thumbnail",
            headers: [HTTPHeader(name: "Accept", value: "image/*")]
        )
    }

    /// Creates a request that counts files and directories inside a trashed kDrive item using the deprecated v2 endpoint.
    public static func getV2TrashedItemCount(
        driveId: Int,
        fileId: Int
    ) -> APIRequest<InfomaniakResponse<KDriveV2TrashedItemCount>> {
        APIRequest(
            method: .get,
            path: "/2/drive/\(driveId)/trash/\(fileId)/count"
        )
    }

    /// Creates a request that counts files and directories inside a trashed kDrive item.
    public static func getTrashedItemCount(
        driveId: Int,
        fileId: Int,
        depth: String? = nil
    ) -> APIRequest<InfomaniakResponse<KDriveTrashedItemCount>> {
        var queryParameters: [QueryParameter] = []

        if let depth {
            queryParameters.append(QueryParameter(name: "depth", value: .string(depth)))
        }

        return APIRequest(
            method: .get,
            path: "/3/drive/\(driveId)/trash/\(fileId)/count",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that lists files inside a trashed kDrive directory.
    public static func listTrashedDirectoryFiles(
        driveId: Int,
        fileId: Int,
        with includedResources: String? = nil,
        options: ListKDriveTrashedDirectoryFilesOptions = ListKDriveTrashedDirectoryFilesOptions()
    ) -> APIRequest<CursorPaginatedInfomaniakResponse<[KDriveFileItem]>> {
        var queryParameters: [QueryParameter] = []

        if let includedResources {
            queryParameters.append(QueryParameter(name: "with", value: .string(includedResources)))
        }

        if let cursor = options.cursor {
            queryParameters.append(QueryParameter(name: "cursor", value: .string(cursor)))
        }

        if let limit = options.limit {
            queryParameters.append(QueryParameter(name: "limit", value: .integer(limit)))
        }

        if !options.orderBy.isEmpty {
            queryParameters.append(QueryParameter(name: "order_by", value: .strings(options.orderBy)))
        }

        if let order = options.order {
            queryParameters.append(QueryParameter(name: "order", value: .string(order)))
        }

        for (field, direction) in options.orderFor.sorted(by: { $0.key < $1.key }) {
            queryParameters.append(QueryParameter(name: "order_for[\(field)]", value: .string(direction)))
        }

        if !options.types.isEmpty {
            queryParameters.append(QueryParameter(name: "type", value: .strings(options.types)))
        }

        return APIRequest(
            method: .get,
            path: "/3/drive/\(driveId)/trash/\(fileId)/files",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that searches files and directories in kDrive trash.
    public static func searchTrash(
        driveId: Int,
        with includedResources: String? = nil,
        options: SearchKDriveTrashOptions = SearchKDriveTrashOptions()
    ) -> APIRequest<CursorPaginatedInfomaniakResponse<[KDriveFileItem]>> {
        var queryParameters: [QueryParameter] = []

        if let includedResources {
            queryParameters.append(QueryParameter(name: "with", value: .string(includedResources)))
        }

        if let cursor = options.cursor {
            queryParameters.append(QueryParameter(name: "cursor", value: .string(cursor)))
        }

        if let limit = options.limit {
            queryParameters.append(QueryParameter(name: "limit", value: .integer(limit)))
        }

        if !options.orderBy.isEmpty {
            queryParameters.append(QueryParameter(name: "order_by", value: .strings(options.orderBy)))
        }

        if let order = options.order {
            queryParameters.append(QueryParameter(name: "order", value: .string(order)))
        }

        for (field, direction) in options.orderFor.sorted(by: { $0.key < $1.key }) {
            queryParameters.append(QueryParameter(name: "order_for[\(field)]", value: .string(direction)))
        }

        if let authorId = options.authorId {
            queryParameters.append(QueryParameter(name: "author_id", value: .integer(authorId)))
        }

        if let category = options.category {
            queryParameters.append(QueryParameter(name: "category", value: .string(category)))
        }

        if let deletedAfter = options.deletedAfter {
            queryParameters.append(QueryParameter(name: "deleted_after", value: .integer(deletedAfter)))
        }

        if let deletedAt = options.deletedAt {
            queryParameters.append(QueryParameter(name: "deleted_at", value: .string(deletedAt)))
        }

        if let deletedBefore = options.deletedBefore {
            queryParameters.append(QueryParameter(name: "deleted_before", value: .integer(deletedBefore)))
        }

        if let deletedBy = options.deletedBy {
            queryParameters.append(QueryParameter(name: "deleted_by", value: .integer(deletedBy)))
        }

        if let query = options.query {
            queryParameters.append(QueryParameter(name: "query", value: .string(query)))
        }

        if let queryScope = options.queryScope {
            queryParameters.append(QueryParameter(name: "query_scope", value: .string(queryScope)))
        }

        if !options.types.isEmpty {
            queryParameters.append(QueryParameter(name: "types", value: .strings(options.types)))
        }

        return APIRequest(
            method: .get,
            path: "/3/drive/\(driveId)/files/search/trash",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that searches dropbox directories on a kDrive.
    public static func searchDropboxes(
        driveId: Int,
        with includedResources: String? = nil,
        options: SearchKDriveDropboxesOptions = SearchKDriveDropboxesOptions()
    ) -> APIRequest<CursorPaginatedInfomaniakResponse<[KDriveFileItem]>> {
        var queryParameters: [QueryParameter] = []

        if let includedResources {
            queryParameters.append(QueryParameter(name: "with", value: .string(includedResources)))
        }

        if let cursor = options.cursor {
            queryParameters.append(QueryParameter(name: "cursor", value: .string(cursor)))
        }

        if let limit = options.limit {
            queryParameters.append(QueryParameter(name: "limit", value: .integer(limit)))
        }

        if !options.orderBy.isEmpty {
            queryParameters.append(QueryParameter(name: "order_by", value: .strings(options.orderBy)))
        }

        if let order = options.order {
            queryParameters.append(QueryParameter(name: "order", value: .string(order)))
        }

        for (field, direction) in options.orderFor.sorted(by: { $0.key < $1.key }) {
            queryParameters.append(QueryParameter(name: "order_for[\(field)]", value: .string(direction)))
        }

        if let authorId = options.authorId {
            queryParameters.append(QueryParameter(name: "author_id", value: .integer(authorId)))
        }

        if let category = options.category {
            queryParameters.append(QueryParameter(name: "category", value: .string(category)))
        }

        if let createdAfter = options.createdAfter {
            queryParameters.append(QueryParameter(name: "created_after", value: .integer(createdAfter)))
        }

        if let createdAt = options.createdAt {
            queryParameters.append(QueryParameter(name: "created_at", value: .string(createdAt)))
        }

        if let createdBefore = options.createdBefore {
            queryParameters.append(QueryParameter(name: "created_before", value: .integer(createdBefore)))
        }

        if let expires = options.expires {
            queryParameters.append(QueryParameter(name: "expires", value: .string(expires)))
        }

        if let hasPassword = options.hasPassword {
            queryParameters.append(QueryParameter(name: "has_password", value: .string(hasPassword)))
        }

        if let lastImportAfter = options.lastImportAfter {
            queryParameters.append(QueryParameter(name: "last_import_after", value: .integer(lastImportAfter)))
        }

        if let lastImportAt = options.lastImportAt {
            queryParameters.append(QueryParameter(name: "last_import_at", value: .string(lastImportAt)))
        }

        if let lastImportBefore = options.lastImportBefore {
            queryParameters.append(QueryParameter(name: "last_import_before", value: .integer(lastImportBefore)))
        }

        if let query = options.query {
            queryParameters.append(QueryParameter(name: "query", value: .string(query)))
        }

        if let queryScope = options.queryScope {
            queryParameters.append(QueryParameter(name: "query_scope", value: .string(queryScope)))
        }

        return APIRequest(
            method: .get,
            path: "/3/drive/\(driveId)/files/search/dropboxes",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that searches files and directories with share links on a kDrive.
    public static func searchShareLinks(
        driveId: Int,
        with includedResources: String? = nil,
        options: SearchKDriveShareLinksOptions = SearchKDriveShareLinksOptions()
    ) -> APIRequest<CursorPaginatedInfomaniakResponse<[KDriveFileItem]>> {
        var queryParameters: [QueryParameter] = []

        if let includedResources {
            queryParameters.append(QueryParameter(name: "with", value: .string(includedResources)))
        }

        if let cursor = options.cursor {
            queryParameters.append(QueryParameter(name: "cursor", value: .string(cursor)))
        }

        if let limit = options.limit {
            queryParameters.append(QueryParameter(name: "limit", value: .integer(limit)))
        }

        if !options.orderBy.isEmpty {
            queryParameters.append(QueryParameter(name: "order_by", value: .strings(options.orderBy)))
        }

        if let order = options.order {
            queryParameters.append(QueryParameter(name: "order", value: .string(order)))
        }

        for (field, direction) in options.orderFor.sorted(by: { $0.key < $1.key }) {
            queryParameters.append(QueryParameter(name: "order_for[\(field)]", value: .string(direction)))
        }

        if let authorId = options.authorId {
            queryParameters.append(QueryParameter(name: "author_id", value: .integer(authorId)))
        }

        if let category = options.category {
            queryParameters.append(QueryParameter(name: "category", value: .string(category)))
        }

        if let createdAfter = options.createdAfter {
            queryParameters.append(QueryParameter(name: "created_after", value: .integer(createdAfter)))
        }

        if let createdAt = options.createdAt {
            queryParameters.append(QueryParameter(name: "created_at", value: .string(createdAt)))
        }

        if let createdBefore = options.createdBefore {
            queryParameters.append(QueryParameter(name: "created_before", value: .integer(createdBefore)))
        }

        if let expires = options.expires {
            queryParameters.append(QueryParameter(name: "expires", value: .string(expires)))
        }

        if let hasPassword = options.hasPassword {
            queryParameters.append(QueryParameter(name: "has_password", value: .string(hasPassword)))
        }

        if let query = options.query {
            queryParameters.append(QueryParameter(name: "query", value: .string(query)))
        }

        if let queryScope = options.queryScope {
            queryParameters.append(QueryParameter(name: "query_scope", value: .string(queryScope)))
        }

        return APIRequest(
            method: .get,
            path: "/3/drive/\(driveId)/files/search/links",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that gets information about a single kDrive.
    public static func getDrive(
        driveId: Int,
        with includedResources: String? = nil
    ) -> APIRequest<InfomaniakResponse<KDrive>> {
        var queryParameters: [QueryParameter] = []

        if let includedResources {
            queryParameters.append(QueryParameter(name: "with", value: .string(includedResources)))
        }

        return APIRequest(
            method: .get,
            path: "/2/drive/\(driveId)",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that gets settings for a single kDrive.
    public static func getDriveSettings(
        driveId: Int
    ) -> APIRequest<InfomaniakResponse<KDriveSettings>> {
        APIRequest(
            method: .get,
            path: "/2/drive/\(driveId)/settings"
        )
    }

    /// Creates a request that lists categories configured on a kDrive.
    public static func listCategories(
        driveId: Int
    ) -> APIRequest<InfomaniakResponse<[KDriveCategory]>> {
        APIRequest(
            method: .get,
            path: "/2/drive/\(driveId)/categories"
        )
    }

    /// Creates a request that gets category rights for a kDrive.
    public static func getCategoryRights(
        driveId: Int
    ) -> APIRequest<InfomaniakResponse<[KDriveCategoryRights]>> {
        APIRequest(
            method: .get,
            path: "/2/drive/\(driveId)/categories/rights"
        )
    }

    /// Creates a request that counts files and directories in kDrive trash.
    public static func getTrashCount(
        driveId: Int
    ) -> APIRequest<InfomaniakResponse<KDriveTrashCount>> {
        APIRequest(
            method: .get,
            path: "/2/drive/\(driveId)/trash/count"
        )
    }

    /// Creates a request that counts files and directories inside a kDrive directory.
    public static func getDirectoryCount(
        driveId: Int,
        fileId: Int,
        depth: String? = nil
    ) -> APIRequest<InfomaniakResponse<KDriveDirectoryCount>> {
        var queryParameters: [QueryParameter] = []

        if let depth {
            queryParameters.append(QueryParameter(name: "depth", value: .string(depth)))
        }

        return APIRequest(
            method: .get,
            path: "/3/drive/\(driveId)/files/\(fileId)/count",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that lists versions for a kDrive file.
    public static func listFileVersions(
        driveId: Int,
        fileId: Int,
        page: Int? = nil,
        perPage: Int? = nil,
        total: Bool? = nil,
        orderBy: String? = nil,
        order: String? = nil,
        orderFor: [String: String] = [:]
    ) -> APIRequest<PaginatedInfomaniakResponse<[KDriveFileVersion]>> {
        var queryParameters: [QueryParameter] = []

        if let page {
            queryParameters.append(QueryParameter(name: "page", value: .integer(page)))
        }

        if let perPage {
            queryParameters.append(QueryParameter(name: "per_page", value: .integer(perPage)))
        }

        if let total {
            queryParameters.append(QueryParameter(name: "total", value: .bool(total)))
        }

        if let orderBy {
            queryParameters.append(QueryParameter(name: "order_by", value: .string(orderBy)))
        }

        if let order {
            queryParameters.append(QueryParameter(name: "order", value: .string(order)))
        }

        for (field, direction) in orderFor.sorted(by: { $0.key < $1.key }) {
            queryParameters.append(QueryParameter(name: "order_for[\(field)]", value: .string(direction)))
        }

        return APIRequest(
            method: .get,
            path: "/3/drive/\(driveId)/files/\(fileId)/versions",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that lists activities recorded on a kDrive.
    public static func listActivities(
        driveId: Int,
        page: Int? = nil,
        perPage: Int? = nil,
        lang: String? = nil
    ) -> APIRequest<PaginatedInfomaniakResponse<[KDriveActivity]>> {
        var queryParameters: [QueryParameter] = []

        if let page {
            queryParameters.append(QueryParameter(name: "page", value: .integer(page)))
        }

        if let perPage {
            queryParameters.append(QueryParameter(name: "per_page", value: .integer(perPage)))
        }

        if let lang {
            queryParameters.append(QueryParameter(name: "lang", value: .string(lang)))
        }

        return APIRequest(
            method: .get,
            path: "/2/drive/\(driveId)/activities",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that lists v3 drive-scoped activities.
    public static func listDriveActivities(
        driveId: Int,
        page: Int? = nil,
        perPage: Int? = nil,
        lang: String? = nil
    ) -> APIRequest<InfomaniakResponse<[KDriveDriveActivity]>> {
        var queryParameters: [QueryParameter] = []

        if let page {
            queryParameters.append(QueryParameter(name: "page", value: .integer(page)))
        }

        if let perPage {
            queryParameters.append(QueryParameter(name: "per_page", value: .integer(perPage)))
        }

        if let lang {
            queryParameters.append(QueryParameter(name: "lang", value: .string(lang)))
        }

        return APIRequest(
            method: .get,
            path: "/3/drive/\(driveId)/activities",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that lists v3 drive-scoped activity totals.
    public static func listDriveActivityTotals(
        driveId: Int
    ) -> APIRequest<InfomaniakResponse<Int>> {
        APIRequest(
            method: .get,
            path: "/3/drive/\(driveId)/activities/total"
        )
    }

    /// Creates a request that returns v2 drive-scoped file size statistics.
    public static func chartFileSizes(
        driveId: Int,
        from: Int,
        interval: Int,
        metrics: [String],
        until: Int
    ) -> APIRequest<InfomaniakResponse<KDriveChart>> {
        APIRequest(
            method: .get,
            path: "/2/drive/\(driveId)/statistics/sizes",
            queryParameters: [
                QueryParameter(name: "from", value: .integer(from)),
                QueryParameter(name: "interval", value: .integer(interval)),
                QueryParameter(name: "metrics", value: .strings(metrics)),
                QueryParameter(name: "until", value: .integer(until)),
            ]
        )
    }

    /// Creates a request that returns v2 drive-scoped activity statistics.
    public static func chartActivities(
        driveId: Int,
        from: Int,
        interval: Int,
        metric: String,
        until: Int
    ) -> APIRequest<InfomaniakResponse<KDriveChart>> {
        APIRequest(
            method: .get,
            path: "/2/drive/\(driveId)/statistics/activities",
            queryParameters: [
                QueryParameter(name: "from", value: .integer(from)),
                QueryParameter(name: "interval", value: .integer(interval)),
                QueryParameter(name: "metric", value: .string(metric)),
                QueryParameter(name: "until", value: .integer(until)),
            ]
        )
    }

    /// Creates a request that exports v2 drive-scoped file size statistics as CSV.
    public static func exportFileSizes(
        driveId: Int,
        from: Int,
        interval: Int,
        metrics: [String],
        until: Int
    ) -> APIRequest<Data> {
        APIRequest(
            method: .get,
            path: "/2/drive/\(driveId)/statistics/sizes/export",
            queryParameters: [
                QueryParameter(name: "from", value: .integer(from)),
                QueryParameter(name: "interval", value: .integer(interval)),
                QueryParameter(name: "metrics", value: .strings(metrics)),
                QueryParameter(name: "until", value: .integer(until)),
            ],
            headers: [HTTPHeader(name: "Accept", value: "text/csv")]
        )
    }

    /// Creates a request that exports v2 drive-scoped activity statistics as CSV.
    public static func exportActivities(
        driveId: Int,
        from: Int,
        interval: Int,
        metric: String,
        until: Int
    ) -> APIRequest<Data> {
        APIRequest(
            method: .get,
            path: "/2/drive/\(driveId)/statistics/activities/export",
            queryParameters: [
                QueryParameter(name: "from", value: .integer(from)),
                QueryParameter(name: "interval", value: .integer(interval)),
                QueryParameter(name: "metric", value: .string(metric)),
                QueryParameter(name: "until", value: .integer(until)),
            ],
            headers: [HTTPHeader(name: "Accept", value: "text/csv")]
        )
    }

    /// Creates a request that lists users active on a kDrive during a statistics period.
    public static func listActivityUsers(
        driveId: Int,
        from: Int,
        until: Int
    ) -> APIRequest<InfomaniakResponse<[KDriveActiveMember]>> {
        APIRequest(
            method: .get,
            path: "/2/drive/\(driveId)/statistics/activities/users",
            queryParameters: [
                QueryParameter(name: "from", value: .integer(from)),
                QueryParameter(name: "until", value: .integer(until)),
            ]
        )
    }

    /// Creates a request that lists files shared on a kDrive during a statistics period.
    public static func listActivitySharedFiles(
        driveId: Int,
        from: Int,
        until: Int
    ) -> APIRequest<InfomaniakResponse<[KDriveSharedFileActivity]>> {
        APIRequest(
            method: .get,
            path: "/2/drive/\(driveId)/statistics/activities/shared_files",
            queryParameters: [
                QueryParameter(name: "from", value: .integer(from)),
                QueryParameter(name: "until", value: .integer(until)),
            ]
        )
    }

    /// Creates a request that lists generated kDrive activity reports.
    public static func listActivityReports(
        driveId: Int,
        page: Int? = nil,
        perPage: Int? = nil
    ) -> APIRequest<PaginatedInfomaniakResponse<[KDriveActivityReport]>> {
        var queryParameters: [QueryParameter] = []

        if let page {
            queryParameters.append(QueryParameter(name: "page", value: .integer(page)))
        }

        if let perPage {
            queryParameters.append(QueryParameter(name: "per_page", value: .integer(perPage)))
        }

        return APIRequest(
            method: .get,
            path: "/2/drive/\(driveId)/activities/reports",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that lists external imports for a kDrive.
    public static func listImports(
        driveId: Int,
        page: Int? = nil,
        perPage: Int? = nil
    ) -> APIRequest<PaginatedInfomaniakResponse<[KDriveExternalImport]>> {
        var queryParameters: [QueryParameter] = []

        if let page {
            queryParameters.append(QueryParameter(name: "page", value: .integer(page)))
        }

        if let perPage {
            queryParameters.append(QueryParameter(name: "per_page", value: .integer(perPage)))
        }

        return APIRequest(
            method: .get,
            path: "/2/drive/\(driveId)/imports",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that lists user invitations for a kDrive.
    public static func listUserInvitations(
        driveId: Int,
        page: Int? = nil,
        perPage: Int? = nil
    ) -> APIRequest<PaginatedInfomaniakResponse<[KDriveUserInvitation]>> {
        var queryParameters: [QueryParameter] = []

        if let page {
            queryParameters.append(QueryParameter(name: "page", value: .integer(page)))
        }

        if let perPage {
            queryParameters.append(QueryParameter(name: "per_page", value: .integer(perPage)))
        }

        return APIRequest(
            method: .get,
            path: "/2/drive/\(driveId)/users/invitation",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that gets preferences for the authenticated kDrive user.
    public static func getUserPreferences(
        with includedResources: String? = nil
    ) -> APIRequest<InfomaniakResponse<KDriveUserPreferences>> {
        var queryParameters: [QueryParameter] = []

        if let includedResources {
            queryParameters.append(QueryParameter(name: "with", value: .string(includedResources)))
        }

        return APIRequest(
            method: .get,
            path: "/2/drive/preferences",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that lists users associated with accessible kDrives.
    public static func listKDriveUsers(
        with includedResources: String? = nil,
        options: ListKDriveUsersOptions = ListKDriveUsersOptions()
    ) -> APIRequest<PaginatedInfomaniakResponse<[KDriveUser]>> {
        var queryParameters: [QueryParameter] = []

        if let includedResources {
            queryParameters.append(QueryParameter(name: "with", value: .string(includedResources)))
        }

        if let search = options.search {
            queryParameters.append(QueryParameter(name: "search", value: .string(search)))
        }

        if !options.userIds.isEmpty {
            queryParameters.append(QueryParameter(name: "user_ids", value: .integers(options.userIds)))
        }

        if let page = options.page {
            queryParameters.append(QueryParameter(name: "page", value: .integer(page)))
        }

        if let perPage = options.perPage {
            queryParameters.append(QueryParameter(name: "per_page", value: .integer(perPage)))
        }

        return APIRequest(
            method: .get,
            path: "/2/drive/users",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that builds a kDrive archive from selected files or a parent directory.
    public static func buildArchive(
        driveId: Int,
        body: Data
    ) -> APIRequest<InfomaniakResponse<KDriveUUIDResource>> {
        APIRequest(
            method: .post,
            path: "/3/drive/\(driveId)/files/archives",
            body: body
        )
    }

    /// Creates a request that downloads a built kDrive archive.
    public static func downloadArchive(
        driveId: Int,
        archiveUUID: String
    ) -> APIRequest<KDriveBinaryResponse> {
        APIRequest(
            method: .get,
            path: "/2/drive/\(driveId)/files/archives/\(archiveUUID)",
            headers: [HTTPHeader(name: "Accept", value: "application/zip")]
        )
    }

    /// Creates a request that renames a kDrive file or directory.
    public static func renameFileV2(
        driveId: Int,
        fileId: Int,
        body: Data
    ) -> APIRequest<InfomaniakResponse<KDriveCancelResource>> {
        APIRequest(
            method: .post,
            path: "/2/drive/\(driveId)/files/\(fileId)/rename",
            body: body
        )
    }

    /// Creates a request that creates an empty default kDrive file in the specified parent directory.
    public static func createDefaultFileV3(
        driveId: Int,
        fileId: Int,
        with includedResources: String? = nil,
        body: Data
    ) -> APIRequest<InfomaniakResponse<KDriveFileItem>> {
        var queryParameters: [QueryParameter] = []

        if let includedResources {
            queryParameters.append(QueryParameter(name: "with", value: .string(includedResources)))
        }

        return APIRequest(
            method: .post,
            path: "/3/drive/\(driveId)/files/\(fileId)/file",
            queryParameters: queryParameters,
            body: body
        )
    }

    /// Creates a request that creates a kDrive directory in the specified parent directory.
    public static func createDirectoryV3(
        driveId: Int,
        fileId: Int,
        with includedResources: String? = nil,
        body: Data
    ) -> APIRequest<InfomaniakResponse<KDriveFileItem>> {
        var queryParameters: [QueryParameter] = []

        if let includedResources {
            queryParameters.append(QueryParameter(name: "with", value: .string(includedResources)))
        }

        return APIRequest(
            method: .post,
            path: "/3/drive/\(driveId)/files/\(fileId)/directory",
            queryParameters: queryParameters,
            body: body
        )
    }

    /// Creates a request that copies a kDrive file to a directory.
    public static func copyFileToDirectoryV3(
        driveId: Int,
        fileId: Int,
        destinationDirectoryId: Int,
        with includedResources: String? = nil,
        body: Data
    ) -> APIRequest<InfomaniakResponse<KDriveFileItem>> {
        var queryParameters: [QueryParameter] = []

        if let includedResources {
            queryParameters.append(QueryParameter(name: "with", value: .string(includedResources)))
        }

        return APIRequest(
            method: .post,
            path: "/3/drive/\(driveId)/files/\(fileId)/copy/\(destinationDirectoryId)",
            queryParameters: queryParameters,
            body: body
        )
    }

    /// Creates a request that moves a kDrive file to trash using the v2 endpoint.
    public static func trashFileV2(
        driveId: Int,
        fileId: Int
    ) -> APIRequest<InfomaniakResponse<KDriveCancelResource>> {
        APIRequest(
            method: .delete,
            path: "/2/drive/\(driveId)/files/\(fileId)"
        )
    }

}
