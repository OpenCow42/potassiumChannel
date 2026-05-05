import Foundation

/// Placeholder response type for kDrive endpoints that return binary data.
public struct KDriveBinaryResponse: Decodable, Sendable {
    public init() {}
}

/// A cancellation token returned after a file is moved to kDrive trash.
public struct KDriveCancelResource: Codable, Equatable, Sendable {
    /// Identifier that can be used by Infomaniak APIs to cancel the action while it remains valid.
    public let cancelId: String

    /// Unix timestamp until which the cancellation identifier remains valid.
    public let validUntil: Int

    /// Creates a cancellation resource value.
    public init(cancelId: String, validUntil: Int) {
        self.cancelId = cancelId
        self.validUntil = validUntil
    }
}

/// Query parameters and headers accepted by the kDrive file download endpoint.
public struct DownloadKDriveFileOptions: Equatable, Sendable {
    /// Optional conversion format before download, such as `pdf` or `text`.
    public let conversionFormat: String?

    /// Password for protected files when conversion needs it.
    public let password: String?

    /// Creates options for downloading a kDrive file.
    public init(conversionFormat: String? = nil, password: String? = nil) {
        self.conversionFormat = conversionFormat
        self.password = password
    }
}

/// Query parameters and headers accepted by the kDrive single-request upload endpoint.
public struct UploadKDriveFileOptions: Equatable, Sendable {
    /// Optional related resources to include in the response.
    public let with: String?

    /// ETag used when replacing a specific existing file version.
    public let ifMatch: String?

    /// Client-generated idempotency token.
    public let clientToken: String?

    /// Conflict behavior: `error`, `rename`, or `version`.
    public let conflict: String?

    /// Creation timestamp override.
    public let createdAt: Int?

    /// Destination directory identifier. Required unless `directoryPath` or `fileId` is provided.
    public let directoryId: Int?

    /// Destination directory path. Required unless `directoryId` or `fileId` is provided.
    public let directoryPath: String?

    /// Existing file identifier to replace.
    public let fileId: Int?

    /// Uploaded file name. Required when uploading a new file.
    public let fileName: String?

    /// Last modification timestamp override.
    public let lastModifiedAt: Int?

    /// Symbolic link target, when uploading a symbolic link.
    public let symbolicLink: String?

    /// Expected hash of the uploaded content.
    public let totalChunkHash: String?

    /// Creates options for uploading a kDrive file.
    public init(
        with: String? = nil,
        ifMatch: String? = nil,
        clientToken: String? = nil,
        conflict: String? = nil,
        createdAt: Int? = nil,
        directoryId: Int? = nil,
        directoryPath: String? = nil,
        fileId: Int? = nil,
        fileName: String? = nil,
        lastModifiedAt: Int? = nil,
        symbolicLink: String? = nil,
        totalChunkHash: String? = nil
    ) {
        self.with = with
        self.ifMatch = ifMatch
        self.clientToken = clientToken
        self.conflict = conflict
        self.createdAt = createdAt
        self.directoryId = directoryId
        self.directoryPath = directoryPath
        self.fileId = fileId
        self.fileName = fileName
        self.lastModifiedAt = lastModifiedAt
        self.symbolicLink = symbolicLink
        self.totalChunkHash = totalChunkHash
    }
}

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

/// A kDrive file or directory item returned by the v3 file-list APIs.
public struct KDriveFileItem: Codable, Equatable, Sendable {
    /// The unique file or directory identifier.
    public let id: Int

    /// The display name.
    public let name: String

    /// The item type, when available.
    public let type: String?

    /// The item status.
    public let status: String

    /// The item visibility.
    public let visibility: String

    /// The owning drive identifier.
    public let driveId: Int

    /// The parent directory identifier.
    public let parentId: Int

    /// The full item path, when returned.
    public let path: String?

    /// The item depth in the drive tree.
    public let depth: Int

    /// The creation timestamp, when available.
    public let createdAt: Int?

    /// The last modification timestamp.
    public let lastModifiedAt: Int

    /// The update timestamp.
    public let updatedAt: Int

    /// File size in bytes, when the item is a file.
    public let size: Int?

    /// MIME type, when the item is a file.
    public let mimeType: String?

    /// Whether the item is marked as favorite, when returned.
    public let isFavorite: Bool?

    /// Creates a kDrive file item value.
    public init(
        id: Int,
        name: String,
        type: String?,
        status: String,
        visibility: String,
        driveId: Int,
        parentId: Int,
        path: String?,
        depth: Int,
        createdAt: Int?,
        lastModifiedAt: Int,
        updatedAt: Int,
        size: Int? = nil,
        mimeType: String? = nil,
        isFavorite: Bool? = nil
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.status = status
        self.visibility = visibility
        self.driveId = driveId
        self.parentId = parentId
        self.path = path
        self.depth = depth
        self.createdAt = createdAt
        self.lastModifiedAt = lastModifiedAt
        self.updatedAt = updatedAt
        self.size = size
        self.mimeType = mimeType
        self.isFavorite = isFavorite
    }
}

/// A category configured on a kDrive.
public struct KDriveCategory: Codable, Equatable, Sendable {
    /// The unique category identifier.
    public let id: Int

    /// The category display name.
    public let name: String

    /// The display color as a hexadecimal string.
    public let color: String

    /// Whether this category is predefined by the system.
    public let isPredefined: Bool

    /// The user identifier that created the category.
    public let createdBy: Int

    /// The creation timestamp.
    public let createdAt: Int

    /// The number of times the authenticated user uses this category, when returned.
    public let userUses: Int?

    /// Creates a kDrive category value.
    public init(id: Int, name: String, color: String, isPredefined: Bool, createdBy: Int, createdAt: Int, userUses: Int? = nil) {
        self.id = id
        self.name = name
        self.color = color
        self.isPredefined = isPredefined
        self.createdBy = createdBy
        self.createdAt = createdAt
        self.userUses = userUses
    }
}

/// Category permissions for the authenticated user on a kDrive.
public struct KDriveCategoryRights: Codable, Equatable, Sendable {
    /// Whether the user can create categories.
    public let canCreate: Bool

    /// Whether the user can edit categories.
    public let canEdit: Bool

    /// Whether the user can delete categories.
    public let canDelete: Bool

    /// Whether the user can read categories present on files.
    public let canReadOnFile: Bool

    /// Whether the user can add categories to files.
    public let canPutOnFile: Bool

    /// Creates a category rights value.
    public init(canCreate: Bool, canEdit: Bool, canDelete: Bool, canReadOnFile: Bool, canPutOnFile: Bool) {
        self.canCreate = canCreate
        self.canEdit = canEdit
        self.canDelete = canDelete
        self.canReadOnFile = canReadOnFile
        self.canPutOnFile = canPutOnFile
    }
}

/// Counts files and directories in a kDrive trash.
public struct KDriveTrashCount: Codable, Equatable, Sendable {
    /// Total number of items in trash.
    public let count: Int

    /// Number of files in trash.
    public let files: Int

    /// Number of directories in trash.
    public let directories: Int

    /// Creates a kDrive trash count value.
    public init(count: Int, files: Int, directories: Int) {
        self.count = count
        self.files = files
        self.directories = directories
    }
}

/// Counts files and directories inside a trashed kDrive item.
public typealias KDriveTrashedItemCount = KDriveDirectoryCount

/// Counts files and directories inside a trashed kDrive item using the deprecated v2 endpoint.
public typealias KDriveV2TrashedItemCount = KDriveDirectoryCount

/// Counts files and directories inside a kDrive directory.
public struct KDriveDirectoryCount: Codable, Equatable, Sendable {
    /// Total number of items in the directory.
    public let count: Int

    /// Number of files in the directory.
    public let files: Int

    /// Number of directories in the directory.
    public let directories: Int

    /// Creates a kDrive directory count value.
    public init(count: Int, files: Int, directories: Int) {
        self.count = count
        self.files = files
        self.directories = directories
    }
}

/// A version of a kDrive file.
public struct KDriveFileVersion: Codable, Equatable, Sendable {
    /// The unique file version identifier.
    public let id: Int

    /// Whether this version should be kept forever.
    public let keepForever: Bool

    /// MIME type for the version, when known.
    public let mimeType: String?

    /// Generic file extension type.
    public let extensionType: String

    /// Version size in bytes.
    public let size: Int

    /// The user that updated this file version.
    public let updatedBy: KDriveUser

    /// The creation timestamp.
    public let createdAt: Int

    /// The update timestamp, when known.
    public let updatedAt: Int?

    /// The last modified timestamp, when known.
    public let lastModifiedAt: Int?

    /// Creates a kDrive file version value.
    public init(
        id: Int,
        keepForever: Bool,
        mimeType: String?,
        extensionType: String,
        size: Int,
        updatedBy: KDriveUser,
        createdAt: Int,
        updatedAt: Int?,
        lastModifiedAt: Int?
    ) {
        self.id = id
        self.keepForever = keepForever
        self.mimeType = mimeType
        self.extensionType = extensionType
        self.size = size
        self.updatedBy = updatedBy
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.lastModifiedAt = lastModifiedAt
    }
}

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

/// An external import configured for a kDrive.
public struct KDriveExternalImport: Codable, Equatable, Sendable {
    /// The unique external import identifier.
    public let id: Int

    /// The source application name.
    public let application: String

    /// The imported account name.
    public let accountName: String

    /// The import status.
    public let status: String

    /// Known error code when the import failed, when available.
    public let errorCode: String?

    /// The destination path.
    public let path: String

    /// The destination directory identifier, when available.
    public let directoryId: Int?

    /// Whether the import application has shared files, as returned by the API.
    public let hasSharedFiles: String

    /// The creation timestamp.
    public let createdAt: Int

    /// The update timestamp.
    public let updatedAt: Int

    /// Number of successfully imported files.
    public let countSuccessFiles: Int

    /// Number of failed imported files.
    public let countFailedFiles: Int

    /// Creates an external import value.
    public init(
        id: Int,
        application: String,
        accountName: String,
        status: String,
        errorCode: String? = nil,
        path: String,
        directoryId: Int?,
        hasSharedFiles: String,
        createdAt: Int,
        updatedAt: Int,
        countSuccessFiles: Int,
        countFailedFiles: Int
    ) {
        self.id = id
        self.application = application
        self.accountName = accountName
        self.status = status
        self.errorCode = errorCode
        self.path = path
        self.directoryId = directoryId
        self.hasSharedFiles = hasSharedFiles
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.countSuccessFiles = countSuccessFiles
        self.countFailedFiles = countFailedFiles
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

/// Preferences for the authenticated kDrive user.
public struct KDriveUserPreferences: Codable, Equatable, Sendable {
    /// Layout density of user interface elements.
    public let density: String

    /// Whether recent files should be sorted by recency.
    public let sortRecentFile: Bool

    /// The user's date display format.
    public let dateFormat: String

    /// Whether shortcuts are enabled.
    public let useShortcut: Bool

    /// The default drive identifier, when configured.
    public let defaultDrive: Int?

    /// Tutorial identifiers already seen by the user, when returned by the API.
    public let tutorials: [String]?

    /// Connected application identifiers, when returned by the API.
    public let connectedApp: [String]?

    /// Creates a user preferences value.
    public init(
        density: String,
        sortRecentFile: Bool,
        dateFormat: String,
        useShortcut: Bool,
        defaultDrive: Int?,
        tutorials: [String]? = nil,
        connectedApp: [String]? = nil
    ) {
        self.density = density
        self.sortRecentFile = sortRecentFile
        self.dateFormat = dateFormat
        self.useShortcut = useShortcut
        self.defaultDrive = defaultDrive
        self.tutorials = tutorials
        self.connectedApp = connectedApp
    }
}

/// Settings for a kDrive.
public struct KDriveSettings: Codable, Equatable, Sendable {
    /// Artificial-intelligence scan settings.
    public let aiScan: KDriveAISettings

    /// Share-link customization settings.
    public let sharedLink: KDriveSharedLinkSettings

    /// Trash retention settings.
    public let trash: KDriveTrashSettings

    /// Office document integration settings.
    public let office: KDriveOfficeSettings

    /// Version retention settings.
    public let versioning: KDriveVersioningSettings

    /// How long deleted users' files are retained.
    public let maxKeepDeletedUser: String

    /// Creates kDrive settings.
    public init(
        aiScan: KDriveAISettings,
        sharedLink: KDriveSharedLinkSettings,
        trash: KDriveTrashSettings,
        office: KDriveOfficeSettings,
        versioning: KDriveVersioningSettings,
        maxKeepDeletedUser: String
    ) {
        self.aiScan = aiScan
        self.sharedLink = sharedLink
        self.trash = trash
        self.office = office
        self.versioning = versioning
        self.maxKeepDeletedUser = maxKeepDeletedUser
    }
}

/// Artificial-intelligence scan settings for a kDrive.
public struct KDriveAISettings: Codable, Equatable, Sendable {
    /// Whether AI file scanning has been approved.
    public let hasApproved: Bool

    /// Whether automatic AI categories have been approved.
    public let hasApprovedAiCategories: Bool

    /// Whether content search has been approved.
    public let hasApprovedContentSearch: Bool

    /// Approval update timestamp, when available.
    public let updatedAt: Int?

    /// Creates AI scan settings.
    public init(hasApproved: Bool, hasApprovedAiCategories: Bool, hasApprovedContentSearch: Bool, updatedAt: Int? = nil) {
        self.hasApproved = hasApproved
        self.hasApprovedAiCategories = hasApprovedAiCategories
        self.hasApprovedContentSearch = hasApprovedContentSearch
        self.updatedAt = updatedAt
    }
}

/// Share-link customization settings for a kDrive.
public struct KDriveSharedLinkSettings: Codable, Equatable, Sendable {
    /// Whether custom share-link styling is active.
    public let activate: Bool

    /// Share-link text color, when configured.
    public let txtColor: String?

    /// Share-link background color, when configured.
    public let bgColor: String?

    /// Configured public image assets.
    public let images: [KDrivePublicImage]

    /// Creates share-link settings.
    public init(activate: Bool, txtColor: String? = nil, bgColor: String? = nil, images: [KDrivePublicImage] = []) {
        self.activate = activate
        self.txtColor = txtColor
        self.bgColor = bgColor
        self.images = images
    }
}

/// A public image used by kDrive share-link customization.
public struct KDrivePublicImage: Codable, Equatable, Sendable {
    /// The image identifier, when returned by the API.
    public let id: Int?

    /// The image URL, when returned by the API.
    public let url: String?

    /// Creates a public image value.
    public init(id: Int? = nil, url: String? = nil) {
        self.id = id
        self.url = url
    }
}

/// Trash retention settings for a kDrive.
public struct KDriveTrashSettings: Codable, Equatable, Sendable {
    /// Number of days files are kept in trash.
    public let maxDuration: Int

    /// Creates trash retention settings.
    public init(maxDuration: Int) {
        self.maxDuration = maxDuration
    }
}

/// Office document integration settings for a kDrive.
public struct KDriveOfficeSettings: Codable, Equatable, Sendable {
    /// Default application for presentations.
    public let presentation: String

    /// Default application for forms.
    public let form: String

    /// Default application for spreadsheets.
    public let spreadsheet: String

    /// Default application for text documents.
    public let text: String

    /// Default application display mode, when configured.
    public let defaultMode: String?

    /// Creates office document integration settings.
    public init(presentation: String, form: String, spreadsheet: String, text: String, defaultMode: String? = nil) {
        self.presentation = presentation
        self.form = form
        self.spreadsheet = spreadsheet
        self.text = text
        self.defaultMode = defaultMode
    }
}

/// Version retention settings for a kDrive.
public struct KDriveVersioningSettings: Codable, Equatable, Sendable {
    /// Maximum number of versions retained.
    public let maxNumbers: Int

    /// Maximum number of days versions are retained.
    public let maxDays: Int

    /// Creates version retention settings.
    public init(maxNumbers: Int, maxDays: Int) {
        self.maxNumbers = maxNumbers
        self.maxDays = maxDays
    }
}

/// Query parameters accepted by the kDrive file search endpoint.
public struct SearchKDriveFilesOptions: Equatable, Sendable {
    /// Cursor marker used to fetch the next batch of results.
    public let cursor: String?

    /// The maximum number of items returned.
    public let limit: Int?

    /// Sort fields, such as `last_modified_at` or `relevance`.
    public let orderBy: [String]

    /// Default sorting direction.
    public let order: String?

    /// Per-field sorting directions keyed by order field.
    public let orderFor: [String: String]

    /// Author identifier to filter by.
    public let authorId: Int?

    /// Category pattern to filter by.
    public let category: String?

    /// Search depth, such as `child` or `unlimited`.
    public let depth: String?

    /// Directory identifier to search within.
    public let directoryId: Int?

    /// File extensions to include.
    public let extensions: [String]

    /// Lower bound for last modification timestamp.
    public let modifiedAfter: Int?

    /// Relative last modification period.
    public let modifiedAt: String?

    /// Upper bound for last modification timestamp.
    public let modifiedBefore: Int?

    /// Name filter.
    public let name: String?

    /// Search query.
    public let query: String?

    /// Query scope, such as `all`, `content`, or `filename`.
    public let queryScope: String?

    /// File types to include.
    public let types: [String]

    /// Creates options for searching kDrive files and directories.
    public init(
        cursor: String? = nil,
        limit: Int? = nil,
        orderBy: [String] = [],
        order: String? = nil,
        orderFor: [String: String] = [:],
        authorId: Int? = nil,
        category: String? = nil,
        depth: String? = nil,
        directoryId: Int? = nil,
        extensions: [String] = [],
        modifiedAfter: Int? = nil,
        modifiedAt: String? = nil,
        modifiedBefore: Int? = nil,
        name: String? = nil,
        query: String? = nil,
        queryScope: String? = nil,
        types: [String] = []
    ) {
        self.cursor = cursor
        self.limit = limit
        self.orderBy = orderBy
        self.order = order
        self.orderFor = orderFor
        self.authorId = authorId
        self.category = category
        self.depth = depth
        self.directoryId = directoryId
        self.extensions = extensions
        self.modifiedAfter = modifiedAfter
        self.modifiedAt = modifiedAt
        self.modifiedBefore = modifiedBefore
        self.name = name
        self.query = query
        self.queryScope = queryScope
        self.types = types
    }
}

/// Query parameters accepted by the kDrive favorite file search endpoint.
public struct SearchKDriveFavoritesOptions: Equatable, Sendable {
    /// Cursor marker used to fetch the next batch of results.
    public let cursor: String?

    /// The maximum number of items returned.
    public let limit: Int?

    /// Sort fields, such as `last_modified_at` or `relevance`.
    public let orderBy: [String]

    /// Default sorting direction.
    public let order: String?

    /// Per-field sorting directions keyed by order field.
    public let orderFor: [String: String]

    /// Author identifier to filter by.
    public let authorId: Int?

    /// Category pattern to filter by.
    public let category: String?

    /// Search depth, such as `child` or `unlimited`.
    public let depth: String?

    /// Directory identifier to search within.
    public let directoryId: Int?

    /// File extensions to include.
    public let extensions: [String]

    /// Lower bound for last modification timestamp.
    public let modifiedAfter: Int?

    /// Relative last modification period.
    public let modifiedAt: String?

    /// Upper bound for last modification timestamp.
    public let modifiedBefore: Int?

    /// Name filter.
    public let name: String?

    /// Search query.
    public let query: String?

    /// Query scope, such as `all`, `content`, or `filename`.
    public let queryScope: String?

    /// File types to include.
    public let types: [String]

    /// Creates options for searching favorite kDrive files and directories.
    public init(
        cursor: String? = nil,
        limit: Int? = nil,
        orderBy: [String] = [],
        order: String? = nil,
        orderFor: [String: String] = [:],
        authorId: Int? = nil,
        category: String? = nil,
        depth: String? = nil,
        directoryId: Int? = nil,
        extensions: [String] = [],
        modifiedAfter: Int? = nil,
        modifiedAt: String? = nil,
        modifiedBefore: Int? = nil,
        name: String? = nil,
        query: String? = nil,
        queryScope: String? = nil,
        types: [String] = []
    ) {
        self.cursor = cursor
        self.limit = limit
        self.orderBy = orderBy
        self.order = order
        self.orderFor = orderFor
        self.authorId = authorId
        self.category = category
        self.depth = depth
        self.directoryId = directoryId
        self.extensions = extensions
        self.modifiedAfter = modifiedAfter
        self.modifiedAt = modifiedAt
        self.modifiedBefore = modifiedBefore
        self.name = name
        self.query = query
        self.queryScope = queryScope
        self.types = types
    }
}

/// Query parameters accepted by the kDrive my-shared file search endpoint.
public struct SearchKDriveMySharedOptions: Equatable, Sendable {
    /// Cursor marker used to fetch the next batch of results.
    public let cursor: String?

    /// The maximum number of items returned.
    public let limit: Int?

    /// Sort fields, such as `last_modified_at` or `relevance`.
    public let orderBy: [String]

    /// Default sorting direction.
    public let order: String?

    /// Per-field sorting directions keyed by order field.
    public let orderFor: [String: String]

    /// Author identifier to filter by.
    public let authorId: Int?

    /// Category pattern to filter by.
    public let category: String?

    /// Search depth, such as `child` or `unlimited`.
    public let depth: String?

    /// Directory identifier to search within.
    public let directoryId: Int?

    /// File extensions to include.
    public let extensions: [String]

    /// Lower bound for last modification timestamp.
    public let modifiedAfter: Int?

    /// Relative last modification period.
    public let modifiedAt: String?

    /// Upper bound for last modification timestamp.
    public let modifiedBefore: Int?

    /// Name filter.
    public let name: String?

    /// Search query.
    public let query: String?

    /// Query scope, such as `all`, `content`, or `filename`.
    public let queryScope: String?

    /// File types to include.
    public let types: [String]

    /// Creates options for searching kDrive files and directories shared by the user.
    public init(
        cursor: String? = nil,
        limit: Int? = nil,
        orderBy: [String] = [],
        order: String? = nil,
        orderFor: [String: String] = [:],
        authorId: Int? = nil,
        category: String? = nil,
        depth: String? = nil,
        directoryId: Int? = nil,
        extensions: [String] = [],
        modifiedAfter: Int? = nil,
        modifiedAt: String? = nil,
        modifiedBefore: Int? = nil,
        name: String? = nil,
        query: String? = nil,
        queryScope: String? = nil,
        types: [String] = []
    ) {
        self.cursor = cursor
        self.limit = limit
        self.orderBy = orderBy
        self.order = order
        self.orderFor = orderFor
        self.authorId = authorId
        self.category = category
        self.depth = depth
        self.directoryId = directoryId
        self.extensions = extensions
        self.modifiedAfter = modifiedAfter
        self.modifiedAt = modifiedAt
        self.modifiedBefore = modifiedBefore
        self.name = name
        self.query = query
        self.queryScope = queryScope
        self.types = types
    }
}

/// Query parameters accepted by the kDrive shared-with-me file search endpoint.
public struct SearchKDriveSharedWithMeOptions: Equatable, Sendable {
    /// Cursor marker used to fetch the next batch of results.
    public let cursor: String?

    /// The maximum number of items returned.
    public let limit: Int?

    /// Sort fields, such as `last_modified_at` or `relevance`.
    public let orderBy: [String]

    /// Default sorting direction.
    public let order: String?

    /// Per-field sorting directions keyed by order field.
    public let orderFor: [String: String]

    /// Author identifier to filter by.
    public let authorId: Int?

    /// Category pattern to filter by.
    public let category: String?

    /// Search depth, such as `child` or `unlimited`.
    public let depth: String?

    /// Directory identifier to search within.
    public let directoryId: Int?

    /// File extensions to include.
    public let extensions: [String]

    /// Lower bound for last modification timestamp.
    public let modifiedAfter: Int?

    /// Relative last modification period.
    public let modifiedAt: String?

    /// Upper bound for last modification timestamp.
    public let modifiedBefore: Int?

    /// Name filter.
    public let name: String?

    /// Search query.
    public let query: String?

    /// Query scope, such as `all`, `content`, or `filename`.
    public let queryScope: String?

    /// File types to include.
    public let types: [String]

    /// Creates options for searching kDrive files and directories shared with the user.
    public init(
        cursor: String? = nil,
        limit: Int? = nil,
        orderBy: [String] = [],
        order: String? = nil,
        orderFor: [String: String] = [:],
        authorId: Int? = nil,
        category: String? = nil,
        depth: String? = nil,
        directoryId: Int? = nil,
        extensions: [String] = [],
        modifiedAfter: Int? = nil,
        modifiedAt: String? = nil,
        modifiedBefore: Int? = nil,
        name: String? = nil,
        query: String? = nil,
        queryScope: String? = nil,
        types: [String] = []
    ) {
        self.cursor = cursor
        self.limit = limit
        self.orderBy = orderBy
        self.order = order
        self.orderFor = orderFor
        self.authorId = authorId
        self.category = category
        self.depth = depth
        self.directoryId = directoryId
        self.extensions = extensions
        self.modifiedAfter = modifiedAfter
        self.modifiedAt = modifiedAt
        self.modifiedBefore = modifiedBefore
        self.name = name
        self.query = query
        self.queryScope = queryScope
        self.types = types
    }
}

/// JSON body accepted by the kDrive create default file endpoint.
public struct CreateKDriveDefaultFileOptions: Encodable, Equatable, Sendable {
    /// Name of the default file to create.
    public let name: String

    /// Extension/type of file to create, such as `docx`, `drawio`, `pptx`, `txt`, or `xlsx`.
    public let type: String

    /// Creates options for creating a default kDrive file.
    public init(name: String, type: String) {
        self.name = name
        self.type = type
    }
}

/// JSON body accepted by the kDrive create directory endpoint.
public struct CreateKDriveDirectoryOptions: Encodable, Equatable, Sendable {
    /// Name of the directory to create.
    public let name: String

    /// Optional color of the directory for the user creating it, such as `#0098ff`.
    public let color: String?

    /// Whether to create the directory only for the authenticated user.
    public let onlyForMe: Bool?

    /// Optional relative path to create from the destination directory.
    public let relativePath: String?

    public enum CodingKeys: String, CodingKey {
        case name
        case color
        case onlyForMe = "only_for_me"
        case relativePath = "relative_path"
    }

    /// Creates options for creating a kDrive directory.
    public init(
        name: String,
        color: String? = nil,
        onlyForMe: Bool? = nil,
        relativePath: String? = nil
    ) {
        self.name = name
        self.color = color
        self.onlyForMe = onlyForMe
        self.relativePath = relativePath
    }
}

/// JSON body accepted by the kDrive file copy endpoint.
public struct CopyKDriveFileOptions: Encodable, Equatable, Sendable {
    /// Conflict behavior: `error`, `rename`, or `version`.
    public let conflict: String?

    /// Optional name for the copied file or directory.
    public let name: String?

    /// Creates options for copying a kDrive file or directory.
    public init(conflict: String? = nil, name: String? = nil) {
        self.conflict = conflict
        self.name = name
    }
}

/// Query parameters accepted by the kDrive trash listing endpoint.
public struct ListKDriveTrashOptions: Equatable, Sendable {
    /// Cursor marker used to fetch the next batch of results.
    public let cursor: String?

    /// The maximum number of items returned.
    public let limit: Int?

    /// Sort fields, such as `deleted_at`, `name`, or `updated_at`.
    public let orderBy: [String]

    /// Default sorting direction.
    public let order: String?

    /// Per-field sorting directions keyed by order field.
    public let orderFor: [String: String]

    /// File structure types to include, such as `dir`, `file`, or `vault`.
    public let types: [String]

    /// Creates options for listing kDrive trash.
    public init(
        cursor: String? = nil,
        limit: Int? = nil,
        orderBy: [String] = [],
        order: String? = nil,
        orderFor: [String: String] = [:],
        types: [String] = []
    ) {
        self.cursor = cursor
        self.limit = limit
        self.orderBy = orderBy
        self.order = order
        self.orderFor = orderFor
        self.types = types
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

/// Query parameters accepted by the kDrive directory file listing endpoint.
public struct ListKDriveDirectoryFilesOptions: Equatable, Sendable {
    /// Cursor marker used to fetch the next batch of results.
    public let cursor: String?

    /// The maximum number of items returned.
    public let limit: Int?

    /// Sort fields, such as `added_at`, `name`, or `updated_at`.
    public let orderBy: [String]

    /// Default sorting direction.
    public let order: String?

    /// Per-field sorting directions keyed by order field.
    public let orderFor: [String: String]

    /// Listing depth. The API disallows this on file identifier `1`.
    public let depth: String?

    /// File structure types to include, such as `dir`, `file`, or `vault`.
    public let types: [String]

    /// Creates options for listing files in a kDrive directory.
    public init(
        cursor: String? = nil,
        limit: Int? = nil,
        orderBy: [String] = [],
        order: String? = nil,
        orderFor: [String: String] = [:],
        depth: String? = nil,
        types: [String] = []
    ) {
        self.cursor = cursor
        self.limit = limit
        self.orderBy = orderBy
        self.order = order
        self.orderFor = orderFor
        self.depth = depth
        self.types = types
    }
}

/// Query parameters accepted by the kDrive trashed file endpoint.
public struct GetKDriveTrashedFileOptions: Equatable, Sendable {
    /// Sort fields, such as `deleted_at`, `name`, or `path`.
    public let orderBy: [String]

    /// Default sorting direction.
    public let order: String?

    /// Per-field sorting directions keyed by order field.
    public let orderFor: [String: String]

    /// Creates options for getting a kDrive trashed file.
    public init(
        orderBy: [String] = [],
        order: String? = nil,
        orderFor: [String: String] = [:]
    ) {
        self.orderBy = orderBy
        self.order = order
        self.orderFor = orderFor
    }
}

/// Query parameters accepted by the kDrive trashed directory files endpoint.
public struct ListKDriveTrashedDirectoryFilesOptions: Equatable, Sendable {
    /// Cursor marker used to fetch the next batch of results.
    public let cursor: String?

    /// The maximum number of items returned.
    public let limit: Int?

    /// Sort fields, such as `deleted_at`, `name`, or `updated_at`.
    public let orderBy: [String]

    /// Default sorting direction.
    public let order: String?

    /// Per-field sorting directions keyed by order field.
    public let orderFor: [String: String]

    /// File structure types to include, such as `dir`, `file`, or `vault`.
    public let types: [String]

    /// Creates options for listing files in a kDrive trashed directory.
    public init(
        cursor: String? = nil,
        limit: Int? = nil,
        orderBy: [String] = [],
        order: String? = nil,
        orderFor: [String: String] = [:],
        types: [String] = []
    ) {
        self.cursor = cursor
        self.limit = limit
        self.orderBy = orderBy
        self.order = order
        self.orderFor = orderFor
        self.types = types
    }
}

/// Query parameters accepted by the kDrive trash search endpoint.
public struct SearchKDriveTrashOptions: Equatable, Sendable {
    /// Cursor marker used to fetch the next batch of results.
    public let cursor: String?

    /// The maximum number of items returned.
    public let limit: Int?

    /// Sort fields, such as `last_modified_at` or `relevance`.
    public let orderBy: [String]

    /// Default sorting direction.
    public let order: String?

    /// Per-field sorting directions keyed by order field.
    public let orderFor: [String: String]

    /// Author identifier to filter by.
    public let authorId: Int?

    /// Category pattern to filter by.
    public let category: String?

    /// Lower bound for deletion timestamp.
    public let deletedAfter: Int?

    /// Relative deletion period.
    public let deletedAt: String?

    /// Upper bound for deletion timestamp.
    public let deletedBefore: Int?

    /// User identifier that deleted the file.
    public let deletedBy: Int?

    /// Search query.
    public let query: String?

    /// Query scope, such as `all`, `content`, or `filename`.
    public let queryScope: String?

    /// File types to include.
    public let types: [String]

    /// Creates options for searching kDrive trash.
    public init(
        cursor: String? = nil,
        limit: Int? = nil,
        orderBy: [String] = [],
        order: String? = nil,
        orderFor: [String: String] = [:],
        authorId: Int? = nil,
        category: String? = nil,
        deletedAfter: Int? = nil,
        deletedAt: String? = nil,
        deletedBefore: Int? = nil,
        deletedBy: Int? = nil,
        query: String? = nil,
        queryScope: String? = nil,
        types: [String] = []
    ) {
        self.cursor = cursor
        self.limit = limit
        self.orderBy = orderBy
        self.order = order
        self.orderFor = orderFor
        self.authorId = authorId
        self.category = category
        self.deletedAfter = deletedAfter
        self.deletedAt = deletedAt
        self.deletedBefore = deletedBefore
        self.deletedBy = deletedBy
        self.query = query
        self.queryScope = queryScope
        self.types = types
    }
}

/// Query parameters accepted by the kDrive dropbox search endpoint.
public struct SearchKDriveDropboxesOptions: Equatable, Sendable {
    /// Cursor marker used to fetch the next batch of results.
    public let cursor: String?

    /// The maximum number of items returned.
    public let limit: Int?

    /// Sort fields, such as `last_modified_at` or `relevance`.
    public let orderBy: [String]

    /// Default sorting direction.
    public let order: String?

    /// Per-field sorting directions keyed by order field.
    public let orderFor: [String: String]

    /// Author identifier to filter by.
    public let authorId: Int?

    /// Category pattern to filter by.
    public let category: String?

    /// Lower bound for creation timestamp.
    public let createdAfter: Int?

    /// Relative creation period.
    public let createdAt: String?

    /// Upper bound for creation timestamp.
    public let createdBefore: Int?

    /// Expiration filter, such as `any`, `yes`, or `no`.
    public let expires: String?

    /// Password filter, such as `any`, `yes`, or `no`.
    public let hasPassword: String?

    /// Lower bound for last import timestamp.
    public let lastImportAfter: Int?

    /// Relative last import period.
    public let lastImportAt: String?

    /// Upper bound for last import timestamp.
    public let lastImportBefore: Int?

    /// Search query.
    public let query: String?

    /// Query scope, such as `all`, `content`, or `filename`.
    public let queryScope: String?

    /// Creates options for searching kDrive dropbox directories.
    public init(
        cursor: String? = nil,
        limit: Int? = nil,
        orderBy: [String] = [],
        order: String? = nil,
        orderFor: [String: String] = [:],
        authorId: Int? = nil,
        category: String? = nil,
        createdAfter: Int? = nil,
        createdAt: String? = nil,
        createdBefore: Int? = nil,
        expires: String? = nil,
        hasPassword: String? = nil,
        lastImportAfter: Int? = nil,
        lastImportAt: String? = nil,
        lastImportBefore: Int? = nil,
        query: String? = nil,
        queryScope: String? = nil
    ) {
        self.cursor = cursor
        self.limit = limit
        self.orderBy = orderBy
        self.order = order
        self.orderFor = orderFor
        self.authorId = authorId
        self.category = category
        self.createdAfter = createdAfter
        self.createdAt = createdAt
        self.createdBefore = createdBefore
        self.expires = expires
        self.hasPassword = hasPassword
        self.lastImportAfter = lastImportAfter
        self.lastImportAt = lastImportAt
        self.lastImportBefore = lastImportBefore
        self.query = query
        self.queryScope = queryScope
    }
}

/// Query parameters accepted by the kDrive share-link search endpoint.
public struct SearchKDriveShareLinksOptions: Equatable, Sendable {
    /// Cursor marker used to fetch the next batch of results.
    public let cursor: String?

    /// The maximum number of items returned.
    public let limit: Int?

    /// Sort fields, such as `last_modified_at` or `relevance`.
    public let orderBy: [String]

    /// Default sorting direction.
    public let order: String?

    /// Per-field sorting directions keyed by order field.
    public let orderFor: [String: String]

    /// Author identifier to filter by.
    public let authorId: Int?

    /// Category pattern to filter by.
    public let category: String?

    /// Lower bound for creation timestamp.
    public let createdAfter: Int?

    /// Relative creation period.
    public let createdAt: String?

    /// Upper bound for creation timestamp.
    public let createdBefore: Int?

    /// Expiration filter, such as `any`, `yes`, or `no`.
    public let expires: String?

    /// Password filter, such as `any`, `yes`, or `no`.
    public let hasPassword: String?

    /// Search query.
    public let query: String?

    /// Query scope, such as `all`, `content`, or `filename`.
    public let queryScope: String?

    /// Creates options for searching kDrive files and directories with share links.
    public init(
        cursor: String? = nil,
        limit: Int? = nil,
        orderBy: [String] = [],
        order: String? = nil,
        orderFor: [String: String] = [:],
        authorId: Int? = nil,
        category: String? = nil,
        createdAfter: Int? = nil,
        createdAt: String? = nil,
        createdBefore: Int? = nil,
        expires: String? = nil,
        hasPassword: String? = nil,
        query: String? = nil,
        queryScope: String? = nil
    ) {
        self.cursor = cursor
        self.limit = limit
        self.orderBy = orderBy
        self.order = order
        self.orderFor = orderFor
        self.authorId = authorId
        self.category = category
        self.createdAfter = createdAfter
        self.createdAt = createdAt
        self.createdBefore = createdBefore
        self.expires = expires
        self.hasPassword = hasPassword
        self.query = query
        self.queryScope = queryScope
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
