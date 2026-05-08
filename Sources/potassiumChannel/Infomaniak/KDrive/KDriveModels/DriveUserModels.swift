import Foundation

/// A kDrive visible to the authenticated Infomaniak user.
public struct KDrive: Codable, Equatable, Sendable {
    /// The unique kDrive identifier.
    public let id: Int

    /// The display name of the kDrive.
    public let name: String

    /// The account identifier that owns the kDrive.
    public let accountId: Int

    /// The user's role in the kDrive.
    public let role: String

    /// The product status reported by the API.
    public let status: String

    /// Whether the kDrive is currently in maintenance.
    public let inMaintenance: Bool

    /// Creates a kDrive value.
    public init(id: Int, name: String, accountId: Int, role: String, status: String, inMaintenance: Bool) {
        self.id = id
        self.name = name
        self.accountId = accountId
        self.role = role
        self.status = status
        self.inMaintenance = inMaintenance
    }
}

/// A user associated with the authenticated user's accessible kDrives.
public struct KDriveUser: Codable, Equatable, Sendable {
    /// The unique user identifier.
    public let id: Int

    /// The display name of the user.
    public let displayName: String?

    /// The user's first name.
    public let firstName: String?

    /// The user's last name.
    public let lastName: String?

    /// The user's email address.
    public let email: String?

    /// Whether the user is provided by an external identity provider.
    public let isSso: Bool?

    /// The user's avatar URL, when available.
    public let avatar: String?

    /// The timestamp at which the user was deleted, when applicable.
    public let deletedAt: Int?

    /// Creates a kDrive user value.
    public init(
        id: Int,
        displayName: String? = nil,
        firstName: String? = nil,
        lastName: String? = nil,
        email: String? = nil,
        isSso: Bool? = nil,
        avatar: String? = nil,
        deletedAt: Int? = nil
    ) {
        self.id = id
        self.displayName = displayName
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.isSso = isSso
        self.avatar = avatar
        self.deletedAt = deletedAt
    }
}

/// A user associated with a specific kDrive.
public struct KDriveDriveUser: Codable, Equatable, Sendable {
    /// The unique user identifier.
    public let id: Int

    /// The display name of the user.
    public let displayName: String?

    /// The user's first name.
    public let firstName: String?

    /// The user's last name.
    public let lastName: String?

    /// The user's email address.
    public let email: String?

    /// Whether the user is provided by an external identity provider.
    public let isSso: Bool?

    /// The user's avatar URL, when available.
    public let avatar: String?

    /// The user's role on the kDrive, when available.
    public let role: String?

    /// The timestamp at which the user was deleted, when applicable.
    public let deletedAt: Int?

    /// Creates a kDrive-scoped user value.
    public init(
        id: Int,
        displayName: String? = nil,
        firstName: String? = nil,
        lastName: String? = nil,
        email: String? = nil,
        isSso: Bool? = nil,
        avatar: String? = nil,
        role: String? = nil,
        deletedAt: Int? = nil
    ) {
        self.id = id
        self.displayName = displayName
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.isSso = isSso
        self.avatar = avatar
        self.role = role
        self.deletedAt = deletedAt
    }
}

/// A user invitation created for a kDrive.
public struct KDriveUserInvitation: Codable, Equatable, Sendable {
    /// The unique invitation identifier.
    public let id: Int

    /// The invitation type.
    public let type: String

    /// Whether the invitation grants private access.
    public let isPrivate: Bool

    /// Whether the invitation is currently valid.
    public let isValid: Bool

    /// The invitation status.
    public let status: String

    /// The invited email address.
    public let email: String

    /// The granted role.
    public let role: String

    /// The access display name.
    public let accessName: String

    /// The invited user identifier, when available.
    public let userId: Int?

    /// The user identifier that created the invitation, when available.
    public let invitedBy: Int?

    /// The invitation language.
    public let lang: String

    /// The related file identifier.
    public let fileId: Int

    /// The expiration timestamp, when available.
    public let expiredAt: Int?

    /// The creation timestamp, when available.
    public let createdAt: Int?

    /// Creates a kDrive user invitation value.
    public init(
        id: Int,
        type: String,
        isPrivate: Bool,
        isValid: Bool,
        status: String,
        email: String,
        role: String,
        accessName: String,
        userId: Int?,
        invitedBy: Int?,
        lang: String,
        fileId: Int,
        expiredAt: Int?,
        createdAt: Int?
    ) {
        self.id = id
        self.type = type
        self.isPrivate = isPrivate
        self.isValid = isValid
        self.status = status
        self.email = email
        self.role = role
        self.accessName = accessName
        self.userId = userId
        self.invitedBy = invitedBy
        self.lang = lang
        self.fileId = fileId
        self.expiredAt = expiredAt
        self.createdAt = createdAt
    }
}

/// Query parameters accepted by the accessible kDrives endpoint.
public struct ListAccessibleKDrivesOptions: Equatable, Sendable {
    /// Whether to include drives matching the maintenance state.
    public let inMaintenance: Bool?

    /// Maintenance reasons to filter by.
    public let maintenanceReasons: [String]

    /// Tag identifiers to filter by.
    public let tags: [Int]

    /// The page number to request.
    public let page: Int?

    /// The number of items per page to request.
    public let perPage: Int?

    /// Creates options for listing accessible kDrives.
    public init(
        inMaintenance: Bool? = nil,
        maintenanceReasons: [String] = [],
        tags: [Int] = [],
        page: Int? = nil,
        perPage: Int? = nil
    ) {
        self.inMaintenance = inMaintenance
        self.maintenanceReasons = maintenanceReasons
        self.tags = tags
        self.page = page
        self.perPage = perPage
    }
}

/// Query parameters accepted by the kDrive user drives endpoint.
public struct ListKDriveUserDrivesOptions: Equatable, Sendable {
    /// User roles to filter by.
    public let roles: [String]

    /// User statuses to filter by.
    public let statuses: [String]

    /// The page number to request.
    public let page: Int?

    /// The number of items per page to request.
    public let perPage: Int?

    /// Whether the API should return the total item count.
    public let total: Bool?

    /// Creates options for listing kDrives associated with a user.
    public init(roles: [String] = [], statuses: [String] = [], page: Int? = nil, perPage: Int? = nil, total: Bool? = nil) {
        self.roles = roles
        self.statuses = statuses
        self.page = page
        self.perPage = perPage
        self.total = total
    }
}

/// Query parameters accepted by the v2 drive-scoped kDrive users endpoint.
public struct ListKDriveDriveUsersV2Options: Equatable, Sendable {
    /// Search text used to match first name, last name, or email.
    public let search: String?

    /// User statuses to filter by.
    public let statuses: [String]

    /// User types to filter by.
    public let types: [String]

    /// User identifiers to filter by.
    public let userIds: [Int]

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

    /// Creates options for listing users associated with a specific kDrive using v2.
    public init(
        search: String? = nil,
        statuses: [String] = [],
        types: [String] = [],
        userIds: [Int] = [],
        page: Int? = nil,
        perPage: Int? = nil,
        total: Bool? = nil,
        orderBy: [String] = [],
        order: String? = nil,
        orderFor: [String: String] = [:]
    ) {
        self.search = search
        self.statuses = statuses
        self.types = types
        self.userIds = userIds
        self.page = page
        self.perPage = perPage
        self.total = total
        self.orderBy = orderBy
        self.order = order
        self.orderFor = orderFor
    }
}

/// Query parameters accepted by the kDrive users endpoint.
public struct ListKDriveUsersOptions: Equatable, Sendable {
    /// Search text used to match first name, last name, or email.
    public let search: String?

    /// User identifiers to filter by.
    public let userIds: [Int]

    /// The page number to request.
    public let page: Int?

    /// The number of items per page to request.
    public let perPage: Int?

    /// Creates options for listing kDrive users.
    public init(search: String? = nil, userIds: [Int] = [], page: Int? = nil, perPage: Int? = nil) {
        self.search = search
        self.userIds = userIds
        self.page = page
        self.perPage = perPage
    }
}
