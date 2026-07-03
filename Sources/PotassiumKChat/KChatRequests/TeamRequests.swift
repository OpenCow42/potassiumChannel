import Foundation
import PotassiumChannelCore

extension KChatRequests {
    /// Creates a request that lists kChat teams.
    public static func listTeams(options: KChatListTeamsOptions = KChatListTeamsOptions()) -> APIRequest<[KChatTeam]> {
        var queryParameters: [QueryParameter] = []

        if let page = options.page {
            queryParameters.append(QueryParameter(name: "page", value: .integer(page)))
        }

        if let perPage = options.perPage {
            queryParameters.append(QueryParameter(name: "per_page", value: .integer(perPage)))
        }

        if let includeTotalCount = options.includeTotalCount {
            queryParameters.append(QueryParameter(name: "include_total_count", value: .bool(includeTotalCount)))
        }

        if let excludePolicyConstrained = options.excludePolicyConstrained {
            queryParameters.append(QueryParameter(name: "exclude_policy_constrained", value: .bool(excludePolicyConstrained)))
        }

        return APIRequest(
            method: .get,
            path: "/api/v4/teams",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that gets a kChat team by id.
    public static func getTeam(teamId: String) -> APIRequest<KChatTeam> {
        APIRequest(
            method: .get,
            path: "/api/v4/teams/\(percentEncodePathSegment(teamId))"
        )
    }

    /// Creates a request that gets a kChat team by name.
    public static func getTeamByName(name: String) -> APIRequest<KChatTeam> {
        APIRequest(
            method: .get,
            path: "/api/v4/teams/name/\(percentEncodePathSegment(name))"
        )
    }

    /// Creates a request that gets kChat team statistics.
    public static func getTeamStats(teamId: String) -> APIRequest<KChatTeamStats> {
        APIRequest(
            method: .get,
            path: "/api/v4/teams/\(percentEncodePathSegment(teamId))/stats"
        )
    }

    /// Creates a request that lists kChat members for a team.
    public static func getTeamMembers(
        teamId: String,
        options: KChatTeamMembersOptions = KChatTeamMembersOptions()
    ) -> APIRequest<[KChatTeamMember]> {
        var queryParameters: [QueryParameter] = []

        if let page = options.page {
            queryParameters.append(QueryParameter(name: "page", value: .integer(page)))
        }

        if let perPage = options.perPage {
            queryParameters.append(QueryParameter(name: "per_page", value: .integer(perPage)))
        }

        return APIRequest(
            method: .get,
            path: "/api/v4/teams/\(percentEncodePathSegment(teamId))/members",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that gets kChat team members by user ids.
    public static func getTeamMembersByIds(teamId: String, userIds: [String]) throws -> APIRequest<[KChatTeamMember]> {
        APIRequest(
            method: .post,
            path: "/api/v4/teams/\(percentEncodePathSegment(teamId))/members/ids",
            body: try JSONEncoder().encode(userIds)
        )
    }

    /// Creates a request that gets a kChat team member by team id and user id.
    public static func getTeamMember(teamId: String, userId: String) -> APIRequest<KChatTeamMember> {
        APIRequest(
            method: .get,
            path: "/api/v4/teams/\(percentEncodePathSegment(teamId))/members/\(percentEncodePathSegment(userId))"
        )
    }

    /// Creates a request that lists kChat teams for a user.
    public static func getUserTeams(userId: String) -> APIRequest<[KChatTeam]> {
        APIRequest(
            method: .get,
            path: "/api/v4/users/\(userId)/teams"
        )
    }

    /// Creates a request that lists kChat team memberships for a user.
    public static func getUserTeamMembers(userId: String) -> APIRequest<[KChatTeamMember]> {
        APIRequest(
            method: .get,
            path: "/api/v4/users/\(percentEncodePathSegment(userId))/teams/members"
        )
    }

    /// Creates a request that lists team unread counts for a user, or `me` for the authenticated user.
    public static func getUserTeamsUnread(userId: String) -> APIRequest<[KChatTeamUnread]> {
        APIRequest(
            method: .get,
            path: "/api/v4/users/\(percentEncodePathSegment(userId))/teams/unread"
        )
    }

    /// Creates a request that gets unread counts for a specific team for a user, or `me` for the authenticated user.
    public static func getUserTeamUnread(userId: String, teamId: String) -> APIRequest<KChatTeamUnread> {
        APIRequest(
            method: .get,
            path: "/api/v4/users/\(percentEncodePathSegment(userId))/teams/\(percentEncodePathSegment(teamId))/unread"
        )
    }

    /// Creates a request that lists kChat channels for a user in a team.
    public static func getUserTeamChannels(
        userId: String,
        teamId: String,
        options: KChatUserTeamChannelsOptions = KChatUserTeamChannelsOptions()
    ) -> APIRequest<[KChatChannel]> {
        var queryParameters: [QueryParameter] = []

        if let includeDeleted = options.includeDeleted {
            queryParameters.append(QueryParameter(name: "include_deleted", value: .bool(includeDeleted)))
        }

        if let lastDeleteAt = options.lastDeleteAt {
            queryParameters.append(QueryParameter(name: "last_delete_at", value: .integer(lastDeleteAt)))
        }

        return APIRequest(
            method: .get,
            path: "/api/v4/users/\(userId)/teams/\(teamId)/channels",
            queryParameters: queryParameters
        )
    }
}
