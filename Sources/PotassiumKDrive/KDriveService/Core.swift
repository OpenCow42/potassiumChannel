import Foundation
import PotassiumChannelCore

/// A high-level service for kDrive API operations.
public struct KDriveService: Sendable {
    let client: InfomaniakAPIClient

    /// Creates a kDrive service backed by an API client.
    public init(client: InfomaniakAPIClient) {
        self.client = client
    }
}
