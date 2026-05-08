import Foundation

/// Lossless mailbox payload returned by the Infomaniak Mail API.
public struct MailMailbox: Codable, Equatable, Sendable {
    /// Raw mailbox payload returned by the API.
    public let values: [String: KDriveJSONValue]

    /// Creates a mailbox wrapper around a raw JSON payload.
    public init(values: [String: KDriveJSONValue]) {
        self.values = values
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.values = try container.decode([String: KDriveJSONValue].self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(values)
    }
}

/// Query options accepted by the Mail mailbox listing endpoint.
public struct ListMailboxesOptions: Equatable, Sendable {
    /// Text searched by the API.
    public let search: String?

    /// Server-side filter name.
    public let filterBy: String?

    /// Additional related resources to include.
    public let includedResources: String?

    /// Return projection requested from the API.
    public let returnedFields: String?

    /// Maximum number of records to return.
    public let limit: Int?

    /// Number of records to skip.
    public let skip: Int?

    /// Page number to fetch.
    public let page: Int?

    /// Number of records per page.
    public let perPage: Int?

    /// Field used for ordering.
    public let orderBy: String?

    /// Sort direction.
    public let order: String?

    /// Field-specific ordering values, encoded as `order_for[field]=direction`.
    public let orderFor: [String: String]

    /// Boolean/integer/string filter values, encoded as `filter[field]=value`.
    public let filters: [String: String]

    public init(
        search: String? = nil,
        filterBy: String? = nil,
        includedResources: String? = nil,
        returnedFields: String? = nil,
        limit: Int? = nil,
        skip: Int? = nil,
        page: Int? = nil,
        perPage: Int? = nil,
        orderBy: String? = nil,
        order: String? = nil,
        orderFor: [String: String] = [:],
        filters: [String: String] = [:]
    ) {
        self.search = search
        self.filterBy = filterBy
        self.includedResources = includedResources
        self.returnedFields = returnedFields
        self.limit = limit
        self.skip = skip
        self.page = page
        self.perPage = perPage
        self.orderBy = orderBy
        self.order = order
        self.orderFor = orderFor
        self.filters = filters
    }
}

/// A mailbox available to the authenticated user.
public struct UserMailbox: Codable, Equatable, Sendable {
    /// Raw mailbox payload returned by the API.
    public let values: [String: KDriveJSONValue]

    /// Creates a mailbox wrapper around a raw JSON payload.
    public init(values: [String: KDriveJSONValue]) {
        self.values = values
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.values = try container.decode([String: KDriveJSONValue].self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(values)
    }
}

/// Current my kSuite information with optional mailbox details.
public struct CurrentMyKSuite: Codable, Equatable, Sendable {
    /// Raw my kSuite payload returned by the API.
    public let values: [String: KDriveJSONValue]

    /// Creates a my kSuite wrapper around a raw JSON payload.
    public init(values: [String: KDriveJSONValue]) {
        self.values = values
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.values = try container.decode([String: KDriveJSONValue].self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(values)
    }
}
