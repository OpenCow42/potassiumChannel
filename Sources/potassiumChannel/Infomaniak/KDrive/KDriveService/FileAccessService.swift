import Foundation

extension KDriveService {
    /// Gets multi-access information for a kDrive file or directory.
    public func getFileMultiAccess(
        driveId: Int,
        fileId: Int
    ) async throws -> InfomaniakResponse<KDriveFileMultiAccess> {
        try await client.send(
            KDriveRequests.getFileMultiAccess(driveId: driveId, fileId: fileId)
        )
    }

    /// Lists requested access entries for a kDrive file or directory.
    public func listFileAccessRequests(
        driveId: Int,
        fileId: Int
    ) async throws -> InfomaniakResponse<[KDriveFileAccessRequest]> {
        try await client.send(
            KDriveRequests.listFileAccessRequests(driveId: driveId, fileId: fileId)
        )
    }

    /// Lists invitation access entries for a kDrive file or directory.
    public func listFileAccessInvitations(
        driveId: Int,
        fileId: Int
    ) async throws -> InfomaniakResponse<[KDriveFileAccessInvitation]> {
        try await client.send(
            KDriveRequests.listFileAccessInvitations(driveId: driveId, fileId: fileId)
        )
    }

    /// Lists user access entries for a kDrive file or directory.
    public func listFileAccessUsers(
        driveId: Int,
        fileId: Int
    ) async throws -> InfomaniakResponse<[KDriveFileAccessUser]> {
        try await client.send(
            KDriveRequests.listFileAccessUsers(driveId: driveId, fileId: fileId)
        )
    }

    /// Lists team access entries for a kDrive file or directory.
    public func listFileAccessTeams(
        driveId: Int,
        fileId: Int
    ) async throws -> InfomaniakResponse<[KDriveFileAccessTeam]> {
        try await client.send(
            KDriveRequests.listFileAccessTeams(driveId: driveId, fileId: fileId)
        )
    }
}
