import Foundation
import PotassiumChannelCore

/// A file activity recorded on a kDrive.
public struct KDriveActivity: Codable, Equatable, Sendable {
    /// The unique activity identifier.
    public let id: Int

    /// The timestamp at which the activity was created.
    public let createdAt: Int

    /// The activity action name.
    public let action: String

    /// The current file or directory path, when available.
    public let newPath: String?

    /// The previous file or directory path, when available.
    public let oldPath: String?

    /// The logged file identifier.
    public let fileId: Int

    /// The user identifier responsible for the action, when available.
    public let userId: Int?

    /// Creates a kDrive activity value.
    public init(id: Int, createdAt: Int, action: String, newPath: String?, oldPath: String?, fileId: Int, userId: Int?) {
        self.id = id
        self.createdAt = createdAt
        self.action = action
        self.newPath = newPath
        self.oldPath = oldPath
        self.fileId = fileId
        self.userId = userId
    }
}

/// A chart returned by kDrive statistics endpoints.
public struct KDriveChart: Codable, Equatable, Sendable {
    /// Chart title.
    public let title: String

    /// X-axis labels for the chart.
    public let labels: KDriveChartData

    /// Chart data series.
    public let data: [KDriveChartData]

    /// Creates a kDrive chart value.
    public init(title: String, labels: KDriveChartData, data: [KDriveChartData]) {
        self.title = title
        self.labels = labels
        self.data = data
    }
}

/// A labels or metric data series in a kDrive chart.
public struct KDriveChartData: Codable, Equatable, Sendable {
    /// Data coordinate or series name.
    public let name: String

    /// Data unit.
    public let unit: String

    /// Data points. The API schema allows timestamp arrays, string arrays, and object-shaped values.
    public let data: KDriveChartDataValue

    /// Requested metric associated with this series, when present.
    public let metric: String?

    /// Creates a kDrive chart data value.
    public init(name: String, unit: String, data: KDriveChartDataValue, metric: String? = nil) {
        self.name = name
        self.unit = unit
        self.data = data
        self.metric = metric
    }
}

/// A flexible JSON value for kDrive chart data points.
public enum KDriveChartDataValue: Codable, Equatable, Sendable {
    /// Null value.
    case null

    /// Boolean value.
    case bool(Bool)

    /// Integer value.
    case integer(Int)

    /// Floating-point value.
    case double(Double)

    /// String value.
    case string(String)

    /// Array value.
    case array([KDriveChartDataValue])

    /// Object value.
    case object([String: KDriveChartDataValue])

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            self = .null
        } else if let value = try? container.decode(Bool.self) {
            self = .bool(value)
        } else if let value = try? container.decode(Int.self) {
            self = .integer(value)
        } else if let value = try? container.decode(Double.self) {
            self = .double(value)
        } else if let value = try? container.decode(String.self) {
            self = .string(value)
        } else if let value = try? container.decode([KDriveChartDataValue].self) {
            self = .array(value)
        } else {
            self = .object(try container.decode([String: KDriveChartDataValue].self))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .null:
            try container.encodeNil()
        case let .bool(value):
            try container.encode(value)
        case let .integer(value):
            try container.encode(value)
        case let .double(value):
            try container.encode(value)
        case let .string(value):
            try container.encode(value)
        case let .array(value):
            try container.encode(value)
        case let .object(value):
            try container.encode(value)
        }
    }
}

/// A user active on a kDrive during a statistics period.
public struct KDriveActiveMember: Codable, Equatable, Sendable {
    /// User identifier, when Infomaniak can associate the activity with a user.
    public let userId: Int?

    /// Connected user display name, when available.
    public let name: String?

    /// User agent used on connection.
    public let agent: String

    /// IP address used on connection.
    public let ip: String

    /// Last login timestamp.
    public let lastLoginAt: Int

    /// Creates an active-member statistics value.
    public init(userId: Int?, name: String?, agent: String, ip: String, lastLoginAt: Int) {
        self.userId = userId
        self.name = name
        self.agent = agent
        self.ip = ip
        self.lastLoginAt = lastLoginAt
    }
}

/// A file shared during a kDrive statistics period.
public struct KDriveSharedFileActivity: Codable, Equatable, Sendable {
    /// Shared file identifier.
    public let id: Int

    /// File name.
    public let name: String

    /// Last update timestamp.
    public let updateAt: Int

    /// Number of active users on the file.
    public let users: Int

    /// Creates a shared-file activity statistics value.
    public init(id: Int, name: String, updateAt: Int, users: Int) {
        self.id = id
        self.name = name
        self.updateAt = updateAt
        self.users = users
    }
}

/// A share link returned by kDrive activity statistics.
public struct KDriveStatisticShareLink: Codable, Equatable, Sendable {
    /// Share link URL.
    public let url: String

    /// Shared file identifier.
    public let fileId: Int

    /// Access right required to view the link (`inherit`, `password`, or `public`).
    public let right: String

    /// Timestamp until which the share link is valid, when limited.
    public let validUntil: Int?

    /// User identifier of the link creator.
    public let createdBy: Int

    /// Link creation timestamp, when returned.
    public let createdAt: Int?

    /// Link update timestamp, when returned.
    public let updatedAt: Int?

    /// Share link capabilities.
    public let capabilities: KDriveStatisticShareLinkCapabilities

    /// Whether link access is blocked.
    public let accessBlocked: Bool

    /// Total number of views on the share link.
    public let views: Int

    /// File information, when the authenticated user can see it.
    public let file: KDriveFileItem?

    /// Number of unique views on the share link.
    public let uniqueViews: Int

    /// Creates a kDrive statistic share link value.
    public init(
        url: String,
        fileId: Int,
        right: String,
        validUntil: Int?,
        createdBy: Int,
        createdAt: Int?,
        updatedAt: Int?,
        capabilities: KDriveStatisticShareLinkCapabilities,
        accessBlocked: Bool,
        views: Int,
        file: KDriveFileItem? = nil,
        uniqueViews: Int
    ) {
        self.url = url
        self.fileId = fileId
        self.right = right
        self.validUntil = validUntil
        self.createdBy = createdBy
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.capabilities = capabilities
        self.accessBlocked = accessBlocked
        self.views = views
        self.file = file
        self.uniqueViews = uniqueViews
    }
}

/// Capability flags attached to a kDrive statistic share link.
public struct KDriveStatisticShareLinkCapabilities: Codable, Equatable, Sendable {
    public let canEdit: Bool
    public let canSeeStats: Bool
    public let canSeeInfo: Bool
    public let canDownload: Bool
    public let canComment: Bool
    public let canRequestAccess: Bool

    public init(canEdit: Bool, canSeeStats: Bool, canSeeInfo: Bool, canDownload: Bool, canComment: Bool, canRequestAccess: Bool) {
        self.canEdit = canEdit
        self.canSeeStats = canSeeStats
        self.canSeeInfo = canSeeInfo
        self.canDownload = canDownload
        self.canComment = canComment
        self.canRequestAccess = canRequestAccess
    }
}

/// A drive-scoped file activity returned by the kDrive v3 API.
public struct KDriveDriveActivity: Codable, Equatable, Sendable {
    /// The unique activity identifier.
    public let id: Int

    /// The timestamp at which the activity was created.
    public let createdAt: Int

    /// The activity action name.
    public let action: String

    /// The current file or directory path, when available.
    public let newPath: String?

    /// The previous file or directory path, when available.
    public let oldPath: String?

    /// The private path user identifier, when available.
    public let privatePathUserId: Int?

    /// The logged file identifier.
    public let fileId: Int

    /// The user identifier responsible for the action, when available.
    public let userId: Int?

    /// Creates a drive-scoped activity value.
    public init(
        id: Int,
        createdAt: Int,
        action: String,
        newPath: String?,
        oldPath: String?,
        privatePathUserId: Int?,
        fileId: Int,
        userId: Int?
    ) {
        self.id = id
        self.createdAt = createdAt
        self.action = action
        self.newPath = newPath
        self.oldPath = oldPath
        self.privatePathUserId = privatePathUserId
        self.fileId = fileId
        self.userId = userId
    }
}

/// A generated kDrive activity report.
public struct KDriveActivityReport: Codable, Equatable, Sendable {
    /// The unique activity report identifier.
    public let id: Int

    /// The report generation status.
    public let status: String

    /// Report size in octets, as returned by the API.
    public let size: String

    /// The user who generated the report.
    public let generatedBy: KDriveUser

    /// URL used to download the generated report, when available.
    public let downloadUrl: String?

    /// The creation timestamp, when available.
    public let createdAt: Int?

    /// The update timestamp, when available.
    public let updatedAt: Int?

    /// Creates a kDrive activity report value.
    public init(
        id: Int,
        status: String,
        size: String,
        generatedBy: KDriveUser,
        downloadUrl: String?,
        createdAt: Int?,
        updatedAt: Int?
    ) {
        self.id = id
        self.status = status
        self.size = size
        self.generatedBy = generatedBy
        self.downloadUrl = downloadUrl
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

/// Options used to create a generated kDrive activity report.
public struct CreateKDriveActivityReportOptions: Encodable, Equatable, Sendable {
    /// Activity action filters included in the report.
    public let actions: [String]

    /// Depth filter for the reported activity scope.
    public let depth: String?

    /// File or directory identifiers included in the report.
    public let files: [Int]

    /// Start timestamp for the report period.
    public let from: Int?

    /// Language fallback used by the report generation.
    public let language: String?

    /// Text search terms included in the report.
    public let terms: String?

    /// End timestamp for the report period.
    public let until: Int?

    /// Single user identifier included in the report.
    public let userId: Int?

    /// User identifiers included in the report.
    public let users: [Int]

    public enum CodingKeys: String, CodingKey {
        case actions
        case depth
        case files
        case from
        case language = "lang"
        case terms
        case until
        case userId = "user_id"
        case users
    }

    /// Creates options for a generated kDrive activity report.
    public init(
        actions: [String] = [],
        depth: String? = nil,
        files: [Int] = [],
        from: Int? = nil,
        language: String? = nil,
        terms: String? = nil,
        until: Int? = nil,
        userId: Int? = nil,
        users: [Int] = []
    ) {
        self.actions = actions
        self.depth = depth
        self.files = files
        self.from = from
        self.language = language
        self.terms = terms
        self.until = until
        self.userId = userId
        self.users = users
    }
}

/// Query parameters accepted by the kDrive file activity listing endpoint.
public struct ListKDriveFileActivitiesOptions: Equatable, Sendable {
    /// Cursor marker used to fetch the next batch of results.
    public let cursor: String?

    /// The maximum number of items returned.
    public let limit: Int?

    /// Sort fields, such as `created_at`.
    public let orderBy: [String]

    /// Default sorting direction.
    public let order: String?

    /// Per-field sorting directions keyed by order field.
    public let orderFor: [String: String]

    /// Activity action filters.
    public let actions: [String]

    /// Activity depth filter, such as `children`, `file`, `folder`, or `unlimited`.
    public let depth: String?

    /// Start timestamp filter.
    public let from: Int?

    /// Search terms filter.
    public let terms: String?

    /// End timestamp filter.
    public let until: Int?

    /// User id filters.
    public let users: [Int]

    /// Creates options for listing kDrive file activities.
    public init(
        cursor: String? = nil,
        limit: Int? = nil,
        orderBy: [String] = [],
        order: String? = nil,
        orderFor: [String: String] = [:],
        actions: [String] = [],
        depth: String? = nil,
        from: Int? = nil,
        terms: String? = nil,
        until: Int? = nil,
        users: [Int] = []
    ) {
        self.cursor = cursor
        self.limit = limit
        self.orderBy = orderBy
        self.order = order
        self.orderFor = orderFor
        self.actions = actions
        self.depth = depth
        self.from = from
        self.terms = terms
        self.until = until
        self.users = users
    }
}

/// Query parameters accepted by the kDrive root file activity listing endpoint.
public typealias ListKDriveRootFileActivitiesV3Options = ListKDriveFileActivitiesOptions

/// Query parameters accepted by the kDrive activity share-links export endpoint.
public struct ExportKDriveActivityShareLinksOptions: Equatable, Sendable {
    /// Maximum views filter.
    public let maxView: Int?

    /// Minimum views filter.
    public let minView: Int?

    /// Link rights to filter by (`inherit`, `password`, or `public`).
    public let rights: [String]

    /// Link expiration timestamp filter.
    public let validUntil: Int?

    /// Creates options for exporting kDrive activity share-link statistics.
    public init(maxView: Int? = nil, minView: Int? = nil, rights: [String] = [], validUntil: Int? = nil) {
        self.maxView = maxView
        self.minView = minView
        self.rights = rights
        self.validUntil = validUntil
    }
}

/// Query parameters accepted by the kDrive activity share-links statistics endpoint.
public struct ListKDriveActivityShareLinksOptions: Equatable, Sendable {
    /// Optional related resources to include.
    public let includedResources: String?

    /// Maximum views filter.
    public let maxView: Int?

    /// Minimum views filter.
    public let minView: Int?

    /// Link rights to filter by (`inherit`, `password`, or `public`).
    public let rights: [String]

    /// Exact share-link filename match.
    public let search: String?

    /// Link expiration timestamp filter.
    public let validUntil: Int?

    /// The page number to request.
    public let page: Int?

    /// The number of items per page to request.
    public let perPage: Int?

    /// Whether the API should return the total item count.
    public let total: Bool?

    /// Fields used for sorting.
    public let orderBy: [String]

    /// Default sort order.
    public let order: String?

    /// Per-field sort orders encoded as order_for[field]=asc|desc.
    public let orderFor: [String: String]

    /// Creates options for listing kDrive activity share-link statistics.
    public init(
        includedResources: String? = nil,
        maxView: Int? = nil,
        minView: Int? = nil,
        rights: [String] = [],
        search: String? = nil,
        validUntil: Int? = nil,
        page: Int? = nil,
        perPage: Int? = nil,
        total: Bool? = nil,
        orderBy: [String] = [],
        order: String? = nil,
        orderFor: [String: String] = [:]
    ) {
        self.includedResources = includedResources
        self.maxView = maxView
        self.minView = minView
        self.rights = rights
        self.search = search
        self.validUntil = validUntil
        self.page = page
        self.perPage = perPage
        self.total = total
        self.orderBy = orderBy
        self.order = order
        self.orderFor = orderFor
    }
}
