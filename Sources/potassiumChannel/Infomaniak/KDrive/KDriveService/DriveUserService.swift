import Foundation

extension KDriveService {
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

    /// Wakes a sleeping kDrive up.
    public func wakeDrive(
        driveId: Int
    ) async throws -> InfomaniakResponse<Bool> {
        try await client.send(KDriveRequests.wakeDrive(driveId: driveId))
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

    /// Fetches a single user associated with a specific kDrive using the v2 endpoint.
    public func getDriveUserV2(
        driveId: Int,
        userId: Int
    ) async throws -> InfomaniakResponse<KDriveDriveUser?> {
        try await client.send(
            KDriveRequests.getDriveUserV2(driveId: driveId, userId: userId)
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

    /// Gets information about a single kDrive.
    public func getDrive(
        driveId: Int,
        with includedResources: String? = nil
    ) async throws -> InfomaniakResponse<KDrive> {
        try await client.send(
            KDriveRequests.getDrive(driveId: driveId, with: includedResources)
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
