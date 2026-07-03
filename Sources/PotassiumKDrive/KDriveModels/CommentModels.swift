import Foundation
import PotassiumChannelCore

/// A comment entry for a kDrive file or directory.
public struct KDriveFileComment: Codable, Equatable, Sendable {
    /// Raw comment payload returned by the API.
    public let values: [String: KDriveJSONValue]

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

/// JSON body accepted by the kDrive add file comment endpoint.
public struct AddKDriveFileCommentOptions: Encodable, Equatable, Sendable {
    /// Comment body text.
    public let body: String

    /// Creates options for adding a comment to a kDrive file or directory.
    public init(body: String) {
        self.body = body
    }
}

/// JSON body accepted by the kDrive add file comment reply endpoint.
public struct AddKDriveFileCommentReplyOptions: Encodable, Equatable, Sendable {
    /// Reply body text.
    public let body: String

    /// Creates options for adding a reply to a kDrive file comment.
    public init(body: String) {
        self.body = body
    }
}

/// JSON body and query parameters accepted by the kDrive modify file comment endpoint.
public struct ModifyKDriveFileCommentOptions: Encodable, Equatable, Sendable {
    /// Related resources to include in the API response.
    public let includedResources: String?

    /// Updated comment body text.
    public let body: String?

    /// Updated resolved state for the comment.
    public let isResolved: Bool?

    enum CodingKeys: String, CodingKey {
        case body
        case isResolved = "is_resolved"
    }

    /// Creates options for modifying a kDrive file comment.
    public init(
        includedResources: String? = nil,
        body: String? = nil,
        isResolved: Bool? = nil
    ) {
        self.includedResources = includedResources
        self.body = body
        self.isResolved = isResolved
    }
}

/// Query parameters accepted by the kDrive file comment replies endpoint.
public struct ListKDriveFileCommentRepliesOptions: Equatable, Sendable {
    /// Related resources to include in the API response.
    public let includedResources: String?

    /// The page number to request.
    public let page: Int?

    /// The number of items per page to request.
    public let perPage: Int?

    /// Whether the API should return the total item count.
    public let total: Bool?

    /// Field used for sorting, such as created_at.
    public let orderBy: String?

    /// Default sort order.
    public let order: String?

    /// Per-field sort orders encoded as order_for[field]=asc|desc.
    public let orderFor: [String: String]

    /// Creates options for listing replies to a kDrive file comment.
    public init(
        includedResources: String? = nil,
        page: Int? = nil,
        perPage: Int? = nil,
        total: Bool? = nil,
        orderBy: String? = nil,
        order: String? = nil,
        orderFor: [String: String] = [:]
    ) {
        self.includedResources = includedResources
        self.page = page
        self.perPage = perPage
        self.total = total
        self.orderBy = orderBy
        self.order = order
        self.orderFor = orderFor
    }
}
