import Foundation

extension KChatRequests {
    /// Creates a request that lists all kChat channels visible to the token.
    public static func listChannels(options: KChatListChannelsOptions = KChatListChannelsOptions()) -> APIRequest<[KChatChannel]> {
        var queryParameters: [QueryParameter] = []

        if let page = options.page {
            queryParameters.append(QueryParameter(name: "page", value: .integer(page)))
        }

        if let perPage = options.perPage {
            queryParameters.append(QueryParameter(name: "per_page", value: .integer(perPage)))
        }

        if let excludeDefaultChannels = options.excludeDefaultChannels {
            queryParameters.append(QueryParameter(name: "exclude_default_channels", value: .bool(excludeDefaultChannels)))
        }

        if let includeDeleted = options.includeDeleted {
            queryParameters.append(QueryParameter(name: "include_deleted", value: .bool(includeDeleted)))
        }

        if let includeTotalCount = options.includeTotalCount {
            queryParameters.append(QueryParameter(name: "include_total_count", value: .bool(includeTotalCount)))
        }

        if let excludePolicyConstrained = options.excludePolicyConstrained {
            queryParameters.append(QueryParameter(name: "exclude_policy_constrained", value: .bool(excludePolicyConstrained)))
        }

        return APIRequest(
            method: .get,
            path: "/api/v4/channels",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that gets a kChat channel by id.
    public static func getChannel(channelId: String) -> APIRequest<KChatChannel> {
        APIRequest(
            method: .get,
            path: "/api/v4/channels/\(percentEncodePathSegment(channelId))"
        )
    }

    /// Creates a request that gets kChat channel statistics.
    public static func getChannelStats(channelId: String) -> APIRequest<KChatChannelStats> {
        APIRequest(
            method: .get,
            path: "/api/v4/channels/\(percentEncodePathSegment(channelId))/stats"
        )
    }

    /// Creates a request that lists kChat members for a channel.
    public static func getChannelMembers(
        channelId: String,
        options: KChatChannelMembersOptions = KChatChannelMembersOptions()
    ) -> APIRequest<[KChatChannelMember]> {
        var queryParameters: [QueryParameter] = []

        if let page = options.page {
            queryParameters.append(QueryParameter(name: "page", value: .integer(page)))
        }

        if let perPage = options.perPage {
            queryParameters.append(QueryParameter(name: "per_page", value: .integer(perPage)))
        }

        return APIRequest(
            method: .get,
            path: "/api/v4/channels/\(percentEncodePathSegment(channelId))/members",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that gets a kChat channel member by channel id and user id.
    public static func getChannelMember(channelId: String, userId: String) -> APIRequest<KChatChannelMember> {
        APIRequest(
            method: .get,
            path: "/api/v4/channels/\(percentEncodePathSegment(channelId))/members/\(percentEncodePathSegment(userId))"
        )
    }

    /// Creates a request that gets kChat channel members by user ids.
    public static func getChannelMembersByIds(channelId: String, userIds: [String]) throws -> APIRequest<[KChatChannelMember]> {
        APIRequest(
            method: .post,
            path: "/api/v4/channels/\(percentEncodePathSegment(channelId))/members/ids",
            body: try JSONEncoder().encode(userIds)
        )
    }

    /// Creates a request that lists public kChat channels for a team.
    public static func getPublicChannelsForTeam(
        teamId: String,
        options: KChatPublicChannelsForTeamOptions = KChatPublicChannelsForTeamOptions()
    ) -> APIRequest<[KChatChannel]> {
        var queryParameters: [QueryParameter] = []

        if let page = options.page {
            queryParameters.append(QueryParameter(name: "page", value: .integer(page)))
        }

        if let perPage = options.perPage {
            queryParameters.append(QueryParameter(name: "per_page", value: .integer(perPage)))
        }

        return APIRequest(
            method: .get,
            path: "/api/v4/teams/\(percentEncodePathSegment(teamId))/channels",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that gets a kChat channel in a team by channel name.
    public static func getChannelByName(teamId: String, channelName: String) -> APIRequest<KChatChannel> {
        APIRequest(
            method: .get,
            path: "/api/v4/teams/\(percentEncodePathSegment(teamId))/channels/name/\(percentEncodePathSegment(channelName))"
        )
    }

    /// Creates a request that gets a kChat channel by team name and channel name.
    public static func getChannelByNameForTeamName(teamName: String, channelName: String) -> APIRequest<KChatChannel> {
        APIRequest(
            method: .get,
            path: "/api/v4/teams/name/\(percentEncodePathSegment(teamName))/channels/name/\(percentEncodePathSegment(channelName))"
        )
    }

    /// Creates a request that lists private kChat channels for a team.
    public static func getPrivateChannelsForTeam(
        teamId: String,
        options: KChatPrivateChannelsForTeamOptions = KChatPrivateChannelsForTeamOptions()
    ) -> APIRequest<[KChatChannel]> {
        var queryParameters: [QueryParameter] = []

        if let page = options.page {
            queryParameters.append(QueryParameter(name: "page", value: .integer(page)))
        }

        if let perPage = options.perPage {
            queryParameters.append(QueryParameter(name: "per_page", value: .integer(perPage)))
        }

        return APIRequest(
            method: .get,
            path: "/api/v4/teams/\(percentEncodePathSegment(teamId))/channels/private",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that lists deleted kChat channels for a team.
    public static func getDeletedChannelsForTeam(
        teamId: String,
        options: KChatDeletedChannelsForTeamOptions = KChatDeletedChannelsForTeamOptions()
    ) -> APIRequest<[KChatChannel]> {
        var queryParameters: [QueryParameter] = []

        if let page = options.page {
            queryParameters.append(QueryParameter(name: "page", value: .integer(page)))
        }

        if let perPage = options.perPage {
            queryParameters.append(QueryParameter(name: "per_page", value: .integer(perPage)))
        }

        return APIRequest(
            method: .get,
            path: "/api/v4/teams/\(percentEncodePathSegment(teamId))/channels/deleted",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that lists kChat channel memberships for a user, or `me` for the authenticated user.
    public static func getUserChannelMembers(
        userId: String,
        options: KChatUserChannelMembersOptions = KChatUserChannelMembersOptions()
    ) -> APIRequest<[KChatChannelMember]> {
        var queryParameters: [QueryParameter] = []

        if let page = options.page {
            queryParameters.append(QueryParameter(name: "page", value: .integer(page)))
        }

        if let pageSize = options.pageSize {
            queryParameters.append(QueryParameter(name: "pageSize", value: .integer(pageSize)))
        }

        return APIRequest(
            method: .get,
            path: "/api/v4/users/\(percentEncodePathSegment(userId))/channel_members",
            queryParameters: queryParameters
        )
    }
}
