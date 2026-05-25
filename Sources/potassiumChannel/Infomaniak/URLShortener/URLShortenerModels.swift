import Foundation

/// A payload that creates a short URL.
public struct CreateShortURLPayload: Codable, Equatable, Sendable {
    /// The target URL to shorten.
    public let url: String

    /// Optional expiration date as a Unix timestamp.
    public let expirationDate: Int?

    /// Creates a short URL creation payload.
    public init(url: String, expirationDate: Int? = nil) {
        self.url = url
        self.expirationDate = expirationDate
    }

    private enum CodingKeys: String, CodingKey {
        case url
        case expirationDate = "expiration_date"
    }
}

/// A payload that updates a short URL.
public struct UpdateShortURLPayload: Codable, Equatable, Sendable {
    /// Expiration date as a Unix timestamp.
    public let expirationDate: Int

    /// Creates a short URL update payload.
    public init(expirationDate: Int) {
        self.expirationDate = expirationDate
    }

    private enum CodingKeys: String, CodingKey {
        case expirationDate = "expiration_date"
    }
}

/// URL shortener quota usage returned by Infomaniak.
public struct URLShortenerQuota: Codable, Equatable, Sendable {
    /// Number of short URLs currently used.
    public let quota: Int

    /// Maximum number of short URLs allowed.
    public let limit: Int

    /// Creates a URL shortener quota value.
    public init(quota: Int, limit: Int) {
        self.quota = quota
        self.limit = limit
    }
}

/// A URL shortener quota response that accepts both direct and enveloped payloads.
public struct URLShortenerQuotaResponse: Codable, Equatable, Sendable {
    /// The server-side result marker when the API returns an envelope.
    public let result: String?

    /// Decoded quota payload.
    public let data: URLShortenerQuota

    /// Creates a URL shortener quota response.
    public init(result: String? = nil, data: URLShortenerQuota) {
        self.result = result
        self.data = data
    }

    private enum CodingKeys: String, CodingKey {
        case result
        case data
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if container.contains(.data) {
            result = try container.decodeIfPresent(String.self, forKey: .result)
            data = try container.decode(URLShortenerQuota.self, forKey: .data)
        } else {
            result = nil
            data = try URLShortenerQuota(from: decoder)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let result {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(result, forKey: .result)
            try container.encode(data, forKey: .data)
        } else {
            try data.encode(to: encoder)
        }
    }
}

/// Optional filters and pagination controls for the v2 URL shortener list route.
public struct ListShortURLsV2Options: Codable, Equatable, Sendable {
    /// Field used to order returned short URLs.
    public enum OrderBy: String, Codable, Sendable {
        case code
        case url
        case createdAt = "created_at"
        case expirationDate = "expiration_date"
    }

    /// Sort direction used by the API.
    public enum OrderDirection: String, Codable, Sendable {
        case ascending = "ASC"
        case descending = "DESC"
    }

    /// Field used to order returned short URLs.
    public let orderBy: OrderBy?

    /// Sort direction used by the API.
    public let orderDirection: OrderDirection?

    /// Search text used by the API.
    public let search: String?

    /// Number of items per page, constrained by Infomaniak to 1...500.
    public let perPage: Int?

    /// Creates v2 URL shortener list options.
    public init(orderBy: OrderBy? = nil, orderDirection: OrderDirection? = nil, search: String? = nil, perPage: Int? = nil) {
        self.orderBy = orderBy
        self.orderDirection = orderDirection
        self.search = search
        self.perPage = perPage
    }

    private enum CodingKeys: String, CodingKey {
        case orderBy = "order_by"
        case orderDirection = "order_direction"
        case search
        case perPage = "per_page"
    }

    func encodedBodyIfNeeded() throws -> Data? {
        guard orderBy != nil || orderDirection != nil || search != nil || perPage != nil else {
            return nil
        }

        return try JSONEncoder().encode(self)
    }
}

/// A short URL returned by Infomaniak URL shortener APIs.
public struct ShortURL: Codable, Equatable, Sendable {
    /// The short URL code.
    public let code: String

    /// The target URL.
    public let url: String

    /// Creation date as a Unix timestamp.
    public let createdAt: Int

    /// Expiration date as a Unix timestamp.
    public let expirationDate: Int

    /// Creates a short URL value.
    public init(code: String, url: String, createdAt: Int, expirationDate: Int) {
        self.code = code
        self.url = url
        self.createdAt = createdAt
        self.expirationDate = expirationDate
    }
}

/// A Laravel-style paginated response returned by the URL shortener list route.
public struct URLShortenerListResponse<Payload: Codable & Sendable>: Sendable {
    /// Current page number.
    public let currentPage: Int

    /// Decoded page payload.
    public let data: Payload

    /// First page URL.
    public let firstPageUrl: String?

    /// First item index on this page.
    public let from: Int?

    /// Next page URL.
    public let nextPageUrl: String?

    /// Collection path URL.
    public let path: String?

    /// Items per page.
    public let perPage: Int

    /// Previous page URL.
    public let prevPageUrl: String?

    /// Last item index on this page.
    public let to: Int?

    /// Total item count when returned by the API.
    public let total: Int?

    /// Creates a URL shortener list response.
    public init(
        currentPage: Int,
        data: Payload,
        firstPageUrl: String? = nil,
        from: Int? = nil,
        nextPageUrl: String? = nil,
        path: String? = nil,
        perPage: Int,
        prevPageUrl: String? = nil,
        to: Int? = nil,
        total: Int? = nil
    ) {
        self.currentPage = currentPage
        self.data = data
        self.firstPageUrl = firstPageUrl
        self.from = from
        self.nextPageUrl = nextPageUrl
        self.path = path
        self.perPage = perPage
        self.prevPageUrl = prevPageUrl
        self.to = to
        self.total = total
    }
}

extension URLShortenerListResponse: Decodable {
    private enum CodingKeys: String, CodingKey {
        case currentPage
        case data
        case firstPageUrl
        case from
        case nextPageUrl
        case path
        case perPage
        case prevPageUrl
        case to
        case total
        case links
        case meta
    }

    private enum LinksCodingKeys: String, CodingKey {
        case first
        case next
        case prev
    }

    private enum MetaCodingKeys: String, CodingKey {
        case currentPage
        case from
        case path
        case perPage
        case to
        case total
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode(Payload.self, forKey: .data)

        if container.contains(.meta) {
            let meta = try container.nestedContainer(keyedBy: MetaCodingKeys.self, forKey: .meta)
            currentPage = try meta.decode(Int.self, forKey: .currentPage)
            from = try meta.decodeIfPresent(Int.self, forKey: .from)
            path = try meta.decodeIfPresent(String.self, forKey: .path)
            perPage = try meta.decode(Int.self, forKey: .perPage)
            to = try meta.decodeIfPresent(Int.self, forKey: .to)
            total = try meta.decodeIfPresent(Int.self, forKey: .total)

            if let links = try? container.nestedContainer(keyedBy: LinksCodingKeys.self, forKey: .links) {
                firstPageUrl = try links.decodeIfPresent(String.self, forKey: .first)
                nextPageUrl = try links.decodeIfPresent(String.self, forKey: .next)
                prevPageUrl = try links.decodeIfPresent(String.self, forKey: .prev)
            } else {
                firstPageUrl = nil
                nextPageUrl = nil
                prevPageUrl = nil
            }
        } else {
            currentPage = try container.decode(Int.self, forKey: .currentPage)
            firstPageUrl = try container.decodeIfPresent(String.self, forKey: .firstPageUrl)
            from = try container.decodeIfPresent(Int.self, forKey: .from)
            nextPageUrl = try container.decodeIfPresent(String.self, forKey: .nextPageUrl)
            path = try container.decodeIfPresent(String.self, forKey: .path)
            perPage = try container.decode(Int.self, forKey: .perPage)
            prevPageUrl = try container.decodeIfPresent(String.self, forKey: .prevPageUrl)
            to = try container.decodeIfPresent(Int.self, forKey: .to)
            total = try container.decodeIfPresent(Int.self, forKey: .total)
        }
    }
}

extension URLShortenerListResponse: Encodable {
    private enum EncodedCodingKeys: String, CodingKey {
        case currentPage
        case data
        case firstPageUrl
        case from
        case nextPageUrl
        case path
        case perPage
        case prevPageUrl
        case to
        case total
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: EncodedCodingKeys.self)
        try container.encode(currentPage, forKey: .currentPage)
        try container.encode(data, forKey: .data)
        try container.encodeIfPresent(firstPageUrl, forKey: .firstPageUrl)
        try container.encodeIfPresent(from, forKey: .from)
        try container.encodeIfPresent(nextPageUrl, forKey: .nextPageUrl)
        try container.encodeIfPresent(path, forKey: .path)
        try container.encode(perPage, forKey: .perPage)
        try container.encodeIfPresent(prevPageUrl, forKey: .prevPageUrl)
        try container.encodeIfPresent(to, forKey: .to)
        try container.encodeIfPresent(total, forKey: .total)
    }
}

extension URLShortenerListResponse: Equatable where Payload: Equatable {}

/// The v2 URL shortener list response returned by Infomaniak.
public struct URLShortenerV2ListResponse<Payload: Codable & Sendable>: Codable, Sendable {
    /// Result of the HTTP request.
    public let result: String

    /// Total number of matching short URLs.
    public let total: Int

    /// Current page number.
    public let page: Int

    /// Number of returned pages.
    public let pages: Int

    /// Number of items per page.
    public let itemsPerPage: Int

    /// Decoded page payload.
    public let data: Payload

    /// Creates a v2 URL shortener list response.
    public init(result: String, total: Int, page: Int, pages: Int, itemsPerPage: Int, data: Payload) {
        self.result = result
        self.total = total
        self.page = page
        self.pages = pages
        self.itemsPerPage = itemsPerPage
        self.data = data
    }
}

extension URLShortenerV2ListResponse: Equatable where Payload: Equatable {}
