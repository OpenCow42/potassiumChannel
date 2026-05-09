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

    /// Creates a request that lists short URLs for the authenticated user using the v2 endpoint.
    public static func listShortURLsV2(options: ListShortURLsV2Options = .init()) throws -> APIRequest<URLShortenerV2ListResponse<[ShortURL]>> {
        let body = try options.encodedBodyIfNeeded()
        return APIRequest(
            method: .get,
            path: "/2/url-shortener",
            body: body
        )
    }

    /// Creates a request that creates one short URL for the authenticated user.
    public static func createShortURL(url: String, expirationDate: Int? = nil) throws -> APIRequest<InfomaniakResponse<ShortURL>> {
        let body = try JSONEncoder().encode(CreateShortURLPayload(url: url, expirationDate: expirationDate))
        return APIRequest(
            method: .post,
            path: "/1/url-shortener",
            body: body
        )
    }
}
