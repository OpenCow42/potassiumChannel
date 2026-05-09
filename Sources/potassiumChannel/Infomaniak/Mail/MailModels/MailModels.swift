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

/// Folder payload returned for a mailbox.
public struct MailFolder: Codable, Equatable, Sendable {
    /// Raw folder payload returned by the API.
    public let values: [String: KDriveJSONValue]

    /// Creates a folder wrapper around a raw JSON payload.
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

/// A thread-listing payload returned for a mailbox folder.
public struct MailThreadList: Codable, Equatable, Sendable {
    /// Raw thread-list payload returned by the API.
    public let values: [String: KDriveJSONValue]

    /// Creates a thread-list wrapper around a raw JSON payload.
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

/// Query options accepted by the Mail folder message listing endpoint.
public struct ListMailThreadsOptions: Equatable, Sendable {
    /// Offset from which to return messages.
    public let offset: Int

    /// Whether the API should group messages into threads.
    public let threadMode: String

    /// Optional server-side filter value.
    public let filter: String?

    /// Additional related resources to include.
    public let includedResources: String?

    public init(
        offset: Int = 0,
        threadMode: String = "on",
        filter: String? = nil,
        includedResources: String? = "emoji_reactions_per_message"
    ) {
        self.offset = offset
        self.threadMode = threadMode
        self.filter = filter
        self.includedResources = includedResources
    }
}

/// A message payload returned for a mailbox folder message resource.
public struct MailMessage: Codable, Equatable, Sendable {
    /// Raw message payload returned by the API.
    public let values: [String: KDriveJSONValue]

    /// Creates a message wrapper around a raw JSON payload.
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

/// Query options accepted when reading a Mail message resource.
public struct GetMailMessageOptions: Equatable, Sendable {
    /// Preferred body format requested from the API.
    public let preferredFormat: String?

    /// Additional related resources to include.
    public let includedResources: String?

    public init(
        preferredFormat: String? = "html",
        includedResources: String? = "auto_uncrypt,recipient_provider_source,emoji_reactions_per_message"
    ) {
        self.preferredFormat = preferredFormat
        self.includedResources = includedResources
    }
}

/// Quota payload returned for a mailbox.
public struct MailboxQuota: Codable, Equatable, Sendable {
    /// Raw quota payload returned by the API.
    public let values: [String: KDriveJSONValue]

    /// Creates a quota wrapper around a raw JSON payload.
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

/// Query options accepted when reading mailbox quota.
public struct GetMailboxQuotaOptions: Equatable, Sendable {
    /// Unit used for quota sizes. The Mail API currently accepts B, kB, or MB.
    public let unit: String?

    public init(unit: String? = "B") {
        self.unit = unit
    }
}

/// A recipient used when creating or updating a Mail draft.
public struct MailDraftRecipient: Codable, Equatable, Sendable {
    /// Recipient email address.
    public let email: String

    /// Display name sent to the Mail API. Empty strings are accepted for address-only recipients.
    public let name: String

    public init(email: String, name: String = "") {
        self.email = email
        self.name = name
    }
}

/// Payload accepted by the Mail draft creation/update endpoints.
public struct MailDraftPayload: Codable, Equatable, Sendable {
    public let body: String
    public let to: [MailDraftRecipient]
    public let cc: [MailDraftRecipient]
    public let bcc: [MailDraftRecipient]
    public let subject: String
    public let ackRequest: Bool
    public let priority: String
    public let attachments: [KDriveJSONValue]
    public let action: String?
    public let mimeType: String

    public init(
        body: String,
        to: [MailDraftRecipient],
        cc: [MailDraftRecipient] = [],
        bcc: [MailDraftRecipient] = [],
        subject: String = "",
        ackRequest: Bool = false,
        priority: String = "normal",
        attachments: [KDriveJSONValue] = [],
        action: String? = "save",
        mimeType: String = "text/html"
    ) {
        self.body = body
        self.to = to
        self.cc = cc
        self.bcc = bcc
        self.subject = subject
        self.ackRequest = ackRequest
        self.priority = priority
        self.attachments = attachments
        self.action = action
        self.mimeType = mimeType
    }
}

/// Draft payload returned by the Mail draft endpoints.
public struct MailDraft: Codable, Equatable, Sendable {
    /// Raw draft payload returned by the API.
    public let values: [String: KDriveJSONValue]

    /// Creates a draft wrapper around a raw JSON payload.
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

/// Payload accepted by the Mail draft schedule endpoint.
public struct MailDraftSchedulePayload: Codable, Equatable, Sendable {
    public let scheduleDate: String

    public enum CodingKeys: String, CodingKey {
        case scheduleDate = "schedule_date"
    }

    public init(scheduleDate: String) {
        self.scheduleDate = scheduleDate
    }
}

/// Schedule payload returned by the Mail schedule endpoint.
public struct MailDraftSchedule: Codable, Equatable, Sendable {
    /// Raw schedule payload returned by the API.
    public let values: [String: KDriveJSONValue]

    /// Creates a schedule wrapper around a raw JSON payload.
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
