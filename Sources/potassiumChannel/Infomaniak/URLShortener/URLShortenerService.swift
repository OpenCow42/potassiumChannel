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

    /// Lists short URLs for the authenticated user using the v2 endpoint.
    public func listShortURLsV2(options: ListShortURLsV2Options = .init()) async throws -> URLShortenerV2ListResponse<[ShortURL]> {
        try await client.send(URLShortenerRequests.listShortURLsV2(options: options))
    }

    /// Fetches URL shortener quota for the authenticated user.
    public func quota() async throws -> URLShortenerQuotaResponse {
        try await client.send(URLShortenerRequests.quota())
    }

    /// Fetches URL shortener quota for the authenticated user using the v2 endpoint.
    public func quotaV2() async throws -> InfomaniakResponse<URLShortenerQuota> {
        try await client.send(URLShortenerRequests.quotaV2())
    }

    /// Creates one short URL for the authenticated user.
    public func createShortURL(url: String, expirationDate: Int? = nil) async throws -> InfomaniakResponse<ShortURL> {
        try await client.send(URLShortenerRequests.createShortURL(url: url, expirationDate: expirationDate))
    }

    /// Creates one short URL for the authenticated user using the v2 endpoint.
    public func createShortURLV2(url: String, expirationDate: Int? = nil) async throws -> InfomaniakResponse<ShortURL> {
        try await client.send(URLShortenerRequests.createShortURLV2(url: url, expirationDate: expirationDate))
    }

    /// Updates one short URL for the authenticated user.
    public func updateShortURL(shortURLCode: String, expirationDate: Int) async throws -> InfomaniakResponse<ShortURL> {
        try await client.send(URLShortenerRequests.updateShortURL(shortURLCode: shortURLCode, expirationDate: expirationDate))
    }
}
