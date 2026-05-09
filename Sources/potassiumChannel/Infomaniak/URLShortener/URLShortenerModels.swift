import Foundation

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
