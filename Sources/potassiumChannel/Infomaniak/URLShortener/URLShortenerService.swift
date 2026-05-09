import Foundation

/// A high-level service for Infomaniak URL shortener API operations.
public struct URLShortenerService: Sendable {
    private let client: InfomaniakAPIClient

    /// Creates a URL shortener service backed by an API client.
    public init(client: InfomaniakAPIClient) {
        self.client = client
    }

    /// Creates a URL shortener service for the default Infomaniak API host.
    public init(bearerToken: String) {
        self.client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(bearerToken: bearerToken)
        )
    }

    /// Lists short URLs for the authenticated user.
    public func listShortURLs() async throws -> URLShortenerListResponse<[ShortURL]> {
        try await client.send(URLShortenerRequests.listShortURLs())
    }

    /// Creates one short URL for the authenticated user.
    public func createShortURL(url: String, expirationDate: Int? = nil) async throws -> InfomaniakResponse<ShortURL> {
        try await client.send(URLShortenerRequests.createShortURL(url: url, expirationDate: expirationDate))
    }
}
