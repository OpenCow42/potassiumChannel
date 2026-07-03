import Foundation

/// A generic Infomaniak API response envelope.
public struct InfomaniakResponse<Payload: Decodable & Sendable>: Decodable, Sendable {
    /// The server-side result marker.
    public let result: String

    /// The decoded response payload.
    public let data: Payload

    /// Creates an Infomaniak response envelope.
    public init(result: String, data: Payload) {
        self.result = result
        self.data = data
    }
}

/// A cursor-paginated Infomaniak API response envelope.
public struct CursorPaginatedInfomaniakResponse<Payload: Decodable & Sendable>: Decodable, Sendable {
    /// The server-side result marker.
    public let result: String

    /// The decoded response payload.
    public let data: Payload

    /// The cursor to pass to the next request, when more results are available.
    public let cursor: String?

    /// Whether more results are available after this page.
    public let hasMore: Bool

    /// The server response timestamp.
    public let responseAt: Int

    /// Creates a cursor-paginated Infomaniak response envelope.
    public init(result: String, data: Payload, cursor: String? = nil, hasMore: Bool, responseAt: Int) {
        self.result = result
        self.data = data
        self.cursor = cursor
        self.hasMore = hasMore
        self.responseAt = responseAt
    }
}

/// A paginated Infomaniak API response envelope.
public struct PaginatedInfomaniakResponse<Payload: Decodable & Sendable>: Decodable, Sendable {
    /// The server-side result marker.
    public let result: String

    /// The decoded response payload.
    public let data: Payload

    /// The total number of available items, when returned by the API.
    public let total: Int?

    /// The current page number, when returned by the API.
    public let page: Int?

    /// The total page count, when returned by the API.
    public let pages: Int?

    /// The number of items per page, when returned by the API.
    public let itemsPerPage: Int?

    /// Creates a paginated Infomaniak response envelope.
    public init(result: String, data: Payload, total: Int? = nil, page: Int? = nil, pages: Int? = nil, itemsPerPage: Int? = nil) {
        self.result = result
        self.data = data
        self.total = total
        self.page = page
        self.pages = pages
        self.itemsPerPage = itemsPerPage
    }
}

extension InfomaniakResponse: Encodable where Payload: Encodable {}

extension CursorPaginatedInfomaniakResponse: Encodable where Payload: Encodable {}

extension PaginatedInfomaniakResponse: Encodable where Payload: Encodable {}
