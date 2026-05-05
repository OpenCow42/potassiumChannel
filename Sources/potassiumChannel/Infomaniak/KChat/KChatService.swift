import Foundation

/// A high-level service for kChat API operations.
public struct KChatService: Sendable {
    private let client: InfomaniakAPIClient

    /// Creates a kChat service backed by an API client.
    public init(client: InfomaniakAPIClient) {
        self.client = client
    }

    /// Creates a kChat service for an Infomaniak kChat team subdomain.
    public init(teamName: String, bearerToken: String) {
        self.client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: Self.baseURL(teamName: teamName),
                bearerToken: bearerToken
            )
        )
    }

    /// Builds the Mattermost-compatible kChat base URL for a team name.
    public static func baseURL(teamName: String) -> URL {
        URL(string: "https://\(teamName).kchat.infomaniak.com")!
    }

    /// Fetches the client configuration required by kChat clients.
    public func getClientConfig(format: String) async throws -> KChatStatusOK {
        try await client.send(KChatRequests.getClientConfig(format: format))
    }
}
