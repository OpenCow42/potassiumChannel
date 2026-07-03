import Foundation
import PotassiumChannelCore

extension KDriveService {
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

    /// Lists files that could not be imported for an external import.
    public func listErroredImportFiles(
        driveId: Int,
        importId: Int,
        with includedResources: String? = nil,
        page: Int? = nil,
        perPage: Int? = nil,
        total: Bool? = nil
    ) async throws -> PaginatedInfomaniakResponse<[KDriveExternalImportFile]> {
        try await client.send(
            KDriveRequests.listErroredImportFiles(
                driveId: driveId,
                importId: importId,
                with: includedResources,
                page: page,
                perPage: perPage,
                total: total
            )
        )
    }

    /// Lists third-party drives eligible for OAuth external import.
    public func listOAuthImportDrives(
        driveId: Int,
        application: String,
        accessTokenId: Int? = nil,
        authCode: String? = nil
    ) async throws -> InfomaniakResponse<KDriveThirdPartyDrivesList> {
        try await client.send(
            KDriveRequests.listOAuthImportDrives(
                driveId: driveId,
                application: application,
                accessTokenId: accessTokenId,
                authCode: authCode
            )
        )
    }
}
