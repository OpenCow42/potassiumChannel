import Foundation

/// Factory methods for URL shortener API requests.
public enum URLShortenerRequests {
    /// Creates a request that lists short URLs for the authenticated user.
    public static func listShortURLs() -> APIRequest<URLShortenerListResponse<[ShortURL]>> {
        APIRequest(
            method: .get,
            path: "/1/url-shortener"
        )
    }
}
