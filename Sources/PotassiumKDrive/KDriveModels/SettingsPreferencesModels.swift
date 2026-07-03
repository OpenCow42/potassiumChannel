import Foundation
import PotassiumChannelCore

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

/// JSON body accepted by the endpoint that updates authenticated kDrive user preferences.
public struct SetKDriveUserPreferencesOptions: Encodable, Equatable, Sendable {
    /// The user's date display format, such as `d/m/Y`, `m/d/Y`, or `d F Y`.
    public let dateFormat: String?

    /// Default drive identifier for the authenticated user.
    public let defaultDrive: Int?

    /// Layout density of user interface elements: `compact`, `normal`, or `large`.
    public let density: String?

    /// List display and sorting preferences.
    public let list: KDriveUserPreferencesListOptions?

    /// Whether recent files should be sorted by recency.
    public let sortRecentFile: Bool?

    /// Tutorial identifiers already seen by the user.
    public let tutorials: [Int]?

    /// Whether shortcuts are enabled.
    public let useShortcut: Bool?

    public enum CodingKeys: String, CodingKey {
        case dateFormat = "date_format"
        case defaultDrive = "default_drive"
        case density
        case list
        case sortRecentFile = "sort_recent_file"
        case tutorials
        case useShortcut = "use_shortcut"
    }

    /// Creates options for updating authenticated kDrive user preferences.
    public init(
        dateFormat: String? = nil,
        defaultDrive: Int? = nil,
        density: String? = nil,
        list: KDriveUserPreferencesListOptions? = nil,
        sortRecentFile: Bool? = nil,
        tutorials: [Int]? = nil,
        useShortcut: Bool? = nil
    ) {
        self.dateFormat = dateFormat
        self.defaultDrive = defaultDrive
        self.density = density
        self.list = list
        self.sortRecentFile = sortRecentFile
        self.tutorials = tutorials
        self.useShortcut = useShortcut
    }
}

/// Nested list preferences accepted when updating authenticated kDrive user preferences.
public struct KDriveUserPreferencesListOptions: Encodable, Equatable, Sendable {
    /// File list sorting preference.
    public let files: KDriveUserPreferencesListSortOptions?

    /// Largest-file storage list sorting preference.
    public let storageLargest: KDriveUserPreferencesListSortOptions?

    /// Most-versioned storage list sorting preference.
    public let storageVersions: KDriveUserPreferencesListSortOptions?

    /// Trash list sorting preference.
    public let trash: KDriveUserPreferencesListSortOptions?

    /// List view mode: `largeGrid`, `medGrid`, `smallGrid`, or `table`.
    public let view: String?

    public enum CodingKeys: String, CodingKey {
        case files
        case storageLargest = "storage_largest"
        case storageVersions = "storage_versions"
        case trash
        case view
    }

    /// Creates list preferences for the authenticated kDrive user.
    public init(
        files: KDriveUserPreferencesListSortOptions? = nil,
        storageLargest: KDriveUserPreferencesListSortOptions? = nil,
        storageVersions: KDriveUserPreferencesListSortOptions? = nil,
        trash: KDriveUserPreferencesListSortOptions? = nil,
        view: String? = nil
    ) {
        self.files = files
        self.storageLargest = storageLargest
        self.storageVersions = storageVersions
        self.trash = trash
        self.view = view
    }
}

/// A list sorting preference accepted when updating authenticated kDrive user preferences.
public struct KDriveUserPreferencesListSortOptions: Encodable, Equatable, Sendable {
    /// Sort direction: `asc` or `desc`.
    public let direction: String?

    /// Field used for sorting.
    public let property: String?

    /// Creates a list sorting preference.
    public init(direction: String? = nil, property: String? = nil) {
        self.direction = direction
        self.property = property
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

/// JSON body accepted by the endpoint that updates kDrive artificial-intelligence scan settings.
public struct UpdateKDriveAISettingsOptions: Encodable, Equatable, Sendable {
    /// Whether AI file scanning has been approved.
    public let hasApproved: Bool?

    /// Whether automatic AI categories have been approved.
    public let hasApprovedAiCategories: Bool?

    /// Whether content search has been approved.
    public let hasApprovedContentSearch: Bool?

    public enum CodingKeys: String, CodingKey {
        case hasApproved = "has_approved"
        case hasApprovedAiCategories = "has_approved_ai_categories"
        case hasApprovedContentSearch = "has_approved_content_search"
    }

    /// Creates options for updating AI scan settings.
    public init(hasApproved: Bool? = nil, hasApprovedAiCategories: Bool? = nil, hasApprovedContentSearch: Bool? = nil) {
        self.hasApproved = hasApproved
        self.hasApprovedAiCategories = hasApprovedAiCategories
        self.hasApprovedContentSearch = hasApprovedContentSearch
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

/// JSON body accepted by the endpoint that updates kDrive share-link customization settings.
public struct UpdateKDriveShareLinkSettingsOptions: Encodable, Equatable, Sendable {
    /// Whether custom share-link styling is active.
    public let activate: Bool

    /// Share-link background color.
    public let bgColor: String

    /// Share-link text color.
    public let txtColor: String

    /// Public image identifiers to keep configured, when supplied.
    public let images: [Int]?

    /// Creates options for updating share-link customization settings.
    public init(activate: Bool, bgColor: String, txtColor: String, images: [Int]? = nil) {
        self.activate = activate
        self.bgColor = bgColor
        self.txtColor = txtColor
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

/// JSON body accepted by the endpoint that updates kDrive trash retention settings.
public struct UpdateKDriveTrashSettingsOptions: Encodable, Equatable, Sendable {
    /// Number of days files are kept in trash.
    public let maxDuration: Int

    public enum CodingKeys: String, CodingKey {
        case maxDuration = "max_duration"
    }

    /// Creates options for updating trash retention settings.
    public init(maxDuration: Int) {
        self.maxDuration = maxDuration
    }
}

/// JSON body accepted by the endpoint that updates kDrive office document integration settings.
public struct UpdateKDriveOfficeSettingsOptions: Encodable, Equatable, Sendable {
    /// Default application for forms.
    public let form: String?

    /// Default application for presentations.
    public let presentation: String?

    /// Default application for spreadsheets.
    public let spreadsheet: String?

    /// Default application for text documents.
    public let text: String?

    /// Creates options for updating office document integration settings.
    public init(form: String? = nil, presentation: String? = nil, spreadsheet: String? = nil, text: String? = nil) {
        self.form = form
        self.presentation = presentation
        self.spreadsheet = spreadsheet
        self.text = text
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
