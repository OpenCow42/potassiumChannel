import Foundation
import PotassiumChannelCore

/// Query options accepted by the Mattermost-compatible kChat team channels autocomplete endpoint.
public struct KChatChannelsForTeamAutocompleteOptions: Equatable, Sendable {
    /// Channel name or display name search term.
    public let name: String

    /// Creates kChat team channels autocomplete query options.
    public init(name: String) {
        self.name = name
    }
}

/// Query options accepted by the Mattermost-compatible kChat team channels search autocomplete endpoint.
public struct KChatChannelsForTeamSearchAutocompleteOptions: Equatable, Sendable {
    /// Channel name or display name search term.
    public let name: String

    /// Creates kChat team channels search autocomplete query options.
    public init(name: String) {
        self.name = name
    }
}

/// Search criteria accepted by the Mattermost-compatible kChat team channels search endpoint.
public struct KChatChannelSearchOptions: Encodable, Equatable, Sendable {
    /// The search term to match against the name or display name of channels.
    public let term: String

    /// Creates kChat team channel search options.
    public init(term: String) {
        self.term = term
    }
}

/// Search criteria accepted by the Mattermost-compatible kChat all channels search endpoint.
public struct KChatSearchAllChannelsOptions: Encodable, Equatable, Sendable {
    /// The string to search in the channel name, display name, and purpose.
    public let term: String

    /// Whether the request is from the system console. Sent as a query parameter.
    public let systemConsole: Bool?

    /// A group id to exclude channels that are associated to that group via GroupChannel records.
    public let notAssociatedToGroup: String?

    /// Excludes default channels from the results when true.
    public let excludeDefaultChannels: Bool?

    /// Filters results to channels belonging to the given team ids.
    public let teamIds: [String]?

    /// Filters results to only return channels constrained to a group.
    public let groupConstrained: Bool?

    /// Filters results to exclude channels constrained to a group.
    public let excludeGroupConstrained: Bool?

    /// Filters results to public/open channels.
    public let `public`: Bool?

    /// Filters results to private channels.
    public let `private`: Bool?

    /// Filters results to deleted/archived channels.
    public let deleted: Bool?

    /// The page number to return, if paginated.
    public let page: Int?

    /// The number of entries to return per page, if paginated.
    public let perPage: Int?

    /// Filters results to channels without granular retention policy when true.
    public let excludePolicyConstrained: Bool?

    /// Includes channels where the search term matches channel id when true.
    public let includeSearchById: Bool?

    public enum CodingKeys: String, CodingKey {
        case term
        case notAssociatedToGroup = "not_associated_to_group"
        case excludeDefaultChannels = "exclude_default_channels"
        case teamIds = "team_ids"
        case groupConstrained = "group_constrained"
        case excludeGroupConstrained = "exclude_group_constrained"
        case `public`
        case `private`
        case deleted
        case page
        case perPage = "per_page"
        case excludePolicyConstrained = "exclude_policy_constrained"
        case includeSearchById = "include_search_by_id"
    }

    /// Creates all-channel search options.
    public init(
        term: String,
        systemConsole: Bool? = nil,
        notAssociatedToGroup: String? = nil,
        excludeDefaultChannels: Bool? = nil,
        teamIds: [String]? = nil,
        groupConstrained: Bool? = nil,
        excludeGroupConstrained: Bool? = nil,
        public: Bool? = nil,
        private: Bool? = nil,
        deleted: Bool? = nil,
        page: Int? = nil,
        perPage: Int? = nil,
        excludePolicyConstrained: Bool? = nil,
        includeSearchById: Bool? = nil
    ) {
        self.term = term
        self.systemConsole = systemConsole
        self.notAssociatedToGroup = notAssociatedToGroup
        self.excludeDefaultChannels = excludeDefaultChannels
        self.teamIds = teamIds
        self.groupConstrained = groupConstrained
        self.excludeGroupConstrained = excludeGroupConstrained
        self.public = `public`
        self.private = `private`
        self.deleted = deleted
        self.page = page
        self.perPage = perPage
        self.excludePolicyConstrained = excludePolicyConstrained
        self.includeSearchById = includeSearchById
    }
}

/// Mattermost-compatible kChat all channels search response.
public struct KChatSearchAllChannelsResponse: Codable, Equatable, Sendable {
    /// The channels that matched the query.
    public let channels: [KChatChannel]

    /// The total number of results, regardless of page and per_page requested.
    public let totalCount: Double?

    public enum CodingKeys: String, CodingKey {
        case channels
        case totalCount
    }

    /// Creates an all channels search response.
    public init(channels: [KChatChannel], totalCount: Double? = nil) {
        self.channels = channels
        self.totalCount = totalCount
    }

    public init(from decoder: Decoder) throws {
        if let channels = try? [KChatChannel](from: decoder) {
            self.channels = channels
            self.totalCount = nil
            return
        }

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.channels = try container.decodeIfPresent([KChatChannel].self, forKey: .channels) ?? []
        self.totalCount = try container.decodeIfPresent(Double.self, forKey: .totalCount)
    }
}
