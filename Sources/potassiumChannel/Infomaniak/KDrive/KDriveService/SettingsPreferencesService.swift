import Foundation

extension KDriveService {
    /// Gets settings for a single kDrive.
    public func getDriveSettings(
        driveId: Int
    ) async throws -> InfomaniakResponse<KDriveSettings> {
        try await client.send(
            KDriveRequests.getDriveSettings(driveId: driveId)
        )
    }

    /// Updates trash settings for a single kDrive.
    public func updateTrashSettings(
        driveId: Int,
        maxDuration: Int
    ) async throws -> InfomaniakResponse<Bool> {
        try await client.send(
            KDriveRequests.updateTrashSettings(
                driveId: driveId,
                options: UpdateKDriveTrashSettingsOptions(maxDuration: maxDuration)
            )
        )
    }

    /// Updates artificial-intelligence scan settings for a single kDrive.
    public func updateAISettings(
        driveId: Int,
        options: UpdateKDriveAISettingsOptions
    ) async throws -> InfomaniakResponse<Bool> {
        try await client.send(
            KDriveRequests.updateAISettings(
                driveId: driveId,
                options: options
            )
        )
    }

    /// Updates share-link customization settings for a single kDrive.
    public func updateShareLinkSettings(
        driveId: Int,
        options: UpdateKDriveShareLinkSettingsOptions
    ) async throws -> InfomaniakResponse<Bool> {
        try await client.send(
            KDriveRequests.updateShareLinkSettings(
                driveId: driveId,
                options: options
            )
        )
    }

    /// Updates office document integration settings for a single kDrive.
    public func updateOfficeSettings(
        driveId: Int,
        options: UpdateKDriveOfficeSettingsOptions
    ) async throws -> InfomaniakResponse<Bool> {
        try await client.send(
            KDriveRequests.updateOfficeSettings(
                driveId: driveId,
                options: options
            )
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

    /// Updates preferences for the authenticated kDrive user.
    public func setUserPreferences(
        options: SetKDriveUserPreferencesOptions
    ) async throws -> InfomaniakResponse<Bool> {
        try await client.send(
            try KDriveRequests.setUserPreferences(options: options)
        )
    }
}
