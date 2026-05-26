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

    /// Gets a requested access entry by id for a kDrive.
    public func getFileAccessRequest(
        driveId: Int,
        requestId: Int,
        with includedResources: String? = nil
    ) async throws -> InfomaniakResponse<KDriveFileAccessRequest> {
        try await client.send(
            KDriveRequests.getFileAccessRequest(driveId: driveId, requestId: requestId, with: includedResources)
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

    /// Checks a proposed access-right change for a kDrive file or directory.
    public func checkFileAccessChange(
        driveId: Int,
        fileId: Int,
        options: CheckKDriveFileAccessChangeOptions
    ) async throws -> InfomaniakResponse<[KDriveFileAccessChangeFeedback]> {
        try await client.send(
            KDriveRequests.checkFileAccessChange(driveId: driveId, fileId: fileId, options: options)
        )
    }

    /// Checks pending invitations for kDrive file access targets.
    public func checkFileAccessInvitations(
        driveId: Int,
        fileId: Int,
        options: CheckKDriveFileAccessInvitationsOptions
    ) async throws -> InfomaniakResponse<[KDriveFileAccessPendingInvitationFeedback]> {
        try await client.send(
            KDriveRequests.checkFileAccessInvitations(driveId: driveId, fileId: fileId, options: options)
        )
    }

    /// Gets share-link metadata for a kDrive file or directory.
    public func getFileShareLink(
        driveId: Int,
        fileId: Int,
        with includedResources: String? = nil
    ) async throws -> InfomaniakResponse<KDriveShareLink> {
        try await client.send(
            KDriveRequests.getFileShareLink(driveId: driveId, fileId: fileId, with: includedResources)
        )
    }

    /// Creates share-link metadata for a kDrive file or directory.
    public func createFileShareLink(
        driveId: Int,
        fileId: Int,
        with includedResources: String? = nil,
        options: CreateKDriveFileShareLinkOptions
    ) async throws -> InfomaniakResponse<KDriveShareLink> {
        try await client.send(
            KDriveRequests.createFileShareLink(
                driveId: driveId,
                fileId: fileId,
                with: includedResources,
                options: options
            )
        )
    }

    /// Updates share-link metadata for a kDrive file or directory.
    public func updateFileShareLink(
        driveId: Int,
        fileId: Int,
        options: UpdateKDriveFileShareLinkOptions
    ) async throws -> InfomaniakResponse<Bool> {
        try await client.send(
            KDriveRequests.updateFileShareLink(driveId: driveId, fileId: fileId, options: options)
        )
    }

    /// Deletes share-link metadata for a kDrive file or directory.
    public func deleteFileShareLink(
        driveId: Int,
        fileId: Int
    ) async throws -> InfomaniakResponse<Bool> {
        try await client.send(
            KDriveRequests.deleteFileShareLink(driveId: driveId, fileId: fileId)
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
