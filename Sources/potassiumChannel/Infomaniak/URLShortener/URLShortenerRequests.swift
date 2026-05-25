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

    /// Creates a request that fetches URL shortener quota for the authenticated user.
    public static func quota() -> APIRequest<URLShortenerQuotaResponse> {
        APIRequest(
            method: .get,
            path: "/1/url-shortener/quota"
        )
    }

    /// Creates a request that fetches URL shortener quota for the authenticated user using the v2 endpoint.
    public static func quotaV2() -> APIRequest<InfomaniakResponse<URLShortenerQuota>> {
        APIRequest(
            method: .get,
            path: "/2/url-shortener/quota"
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

    /// Creates a request that creates one short URL for the authenticated user using the v2 endpoint.
    public static func createShortURLV2(url: String, expirationDate: Int? = nil) throws -> APIRequest<InfomaniakResponse<ShortURL>> {
        let body = try JSONEncoder().encode(CreateShortURLPayload(url: url, expirationDate: expirationDate))
        return APIRequest(
            method: .post,
            path: "/2/url-shortener",
            body: body
        )
    }

    /// Creates a request that updates one short URL for the authenticated user.
    public static func updateShortURL(shortURLCode: String, expirationDate: Int) throws -> APIRequest<InfomaniakResponse<ShortURL>> {
        let body = try JSONEncoder().encode(UpdateShortURLPayload(expirationDate: expirationDate))
        return APIRequest(
            method: .put,
            path: "/1/url-shortener/\(percentEncodePathSegment(shortURLCode))",
            body: body
        )
    }

    private static func percentEncodePathSegment(_ segment: String) -> String {
        var allowedCharacters = CharacterSet.urlPathAllowed
        allowedCharacters.remove(charactersIn: "/?#%")

        return segment.addingPercentEncoding(withAllowedCharacters: allowedCharacters) ?? segment
    }
}
