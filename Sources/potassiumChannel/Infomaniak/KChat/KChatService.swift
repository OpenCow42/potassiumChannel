import Foundation

/// A high-level service for kChat API operations.
public struct KChatService: Sendable {
    private let client: InfomaniakAPIClient

    /// Creates a kChat service backed by an API client.
    public init(client: InfomaniakAPIClient) {
        self.client = client
    }

    /// Fetches the client configuration required by kChat clients.
    public func getClientConfig(format: String) async throws -> KChatStatusOK {
        try await client.send(KChatRequests.getClientConfig(format: format))
    }
}
