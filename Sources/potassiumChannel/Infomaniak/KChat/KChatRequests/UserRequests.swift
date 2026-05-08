import Foundation

extension KChatRequests {
    /// Creates a request that searches kChat users.
    public static func searchUsers(body: Data) -> APIRequest<[KChatUser]> {
        APIRequest(
            method: .post,
            path: "/api/v4/users/search",
            body: body
        )
    }

    /// Creates a request that autocompletes kChat users.
    public static func autocompleteUsers(options: KChatUserAutocompleteOptions) -> APIRequest<KChatUserAutocomplete> {
        var queryParameters: [QueryParameter] = [
            QueryParameter(name: "name", value: .string(options.name)),
        ]

        if let teamId = options.teamId {
            queryParameters.append(QueryParameter(name: "team_id", value: .string(teamId)))
        }

        if let channelId = options.channelId {
            queryParameters.append(QueryParameter(name: "channel_id", value: .string(channelId)))
        }

        if let limit = options.limit {
            queryParameters.append(QueryParameter(name: "limit", value: .integer(limit)))
        }

        return APIRequest(
            method: .get,
            path: "/api/v4/users/autocomplete",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that lists kChat users.
    public static func listUsers(options: KChatListUsersOptions = KChatListUsersOptions()) -> APIRequest<[KChatUser]> {
        var queryParameters: [QueryParameter] = []

        if let page = options.page {
            queryParameters.append(QueryParameter(name: "page", value: .integer(page)))
        }

        if let perPage = options.perPage {
            queryParameters.append(QueryParameter(name: "per_page", value: .integer(perPage)))
        }

        if let inTeam = options.inTeam {
            queryParameters.append(QueryParameter(name: "in_team", value: .string(inTeam)))
        }

        if let notInTeam = options.notInTeam {
            queryParameters.append(QueryParameter(name: "not_in_team", value: .string(notInTeam)))
        }

        if let inChannel = options.inChannel {
            queryParameters.append(QueryParameter(name: "in_channel", value: .string(inChannel)))
        }

        if let notInChannel = options.notInChannel {
            queryParameters.append(QueryParameter(name: "not_in_channel", value: .string(notInChannel)))
        }

        if let inGroup = options.inGroup {
            queryParameters.append(QueryParameter(name: "in_group", value: .string(inGroup)))
        }

        if let groupConstrained = options.groupConstrained {
            queryParameters.append(QueryParameter(name: "group_constrained", value: .bool(groupConstrained)))
        }

        if let withoutTeam = options.withoutTeam {
            queryParameters.append(QueryParameter(name: "without_team", value: .bool(withoutTeam)))
        }

        if let active = options.active {
            queryParameters.append(QueryParameter(name: "active", value: .bool(active)))
        }

        if let inactive = options.inactive {
            queryParameters.append(QueryParameter(name: "inactive", value: .bool(inactive)))
        }

        if let role = options.role {
            queryParameters.append(QueryParameter(name: "role", value: .string(role)))
        }

        if let sort = options.sort {
            queryParameters.append(QueryParameter(name: "sort", value: .string(sort)))
        }

        if let roles = options.roles {
            queryParameters.append(QueryParameter(name: "roles", value: .string(roles)))
        }

        if let channelRoles = options.channelRoles {
            queryParameters.append(QueryParameter(name: "channel_roles", value: .string(channelRoles)))
        }

        if let teamRoles = options.teamRoles {
            queryParameters.append(QueryParameter(name: "team_roles", value: .string(teamRoles)))
        }

        return APIRequest(
            method: .get,
            path: "/api/v4/users",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that gets a kChat user by id, or `me` for the authenticated user.
    public static func getUser(userId: String) -> APIRequest<KChatUser> {
        APIRequest(
            method: .get,
            path: "/api/v4/users/\(userId)"
        )
    }

    /// Creates a request that gets a kChat user by username.
    public static func getUserByUsername(username: String) -> APIRequest<KChatUser> {
        APIRequest(
            method: .get,
            path: "/api/v4/users/username/\(percentEncodePathSegment(username))"
        )
    }

    /// Creates a request that gets a kChat user by email.
    public static func getUserByEmail(email: String) -> APIRequest<KChatUser> {
        APIRequest(
            method: .get,
            path: "/api/v4/users/email/\(percentEncodePathSegment(email))"
        )
    }

    /// Creates a request that gets kChat users by user ids.
    public static func getUsersByIds(body: Data) -> APIRequest<[KChatUser]> {
        APIRequest(
            method: .post,
            path: "/api/v4/users/ids",
            body: body
        )
    }

    /// Creates a request that gets kChat users by usernames.
    public static func getUsersByUsernames(body: Data) -> APIRequest<[KChatUser]> {
        APIRequest(
            method: .post,
            path: "/api/v4/users/usernames",
            body: body
        )
    }

    /// Creates a request that gets kChat users grouped by group-channel id.
    public static func getUsersByGroupChannels(body: Data) -> APIRequest<[String: [KChatUser]]> {
        APIRequest(
            method: .post,
            path: "/api/v4/users/group_channels",
            body: body
        )
    }

    /// Creates a request that gets a kChat user's profile image by id, or `me` for the authenticated user.
    public static func getUserImage(userId: String) -> APIRequest<Data> {
        APIRequest(
            method: .get,
            path: "/api/v4/users/\(userId)/image"
        )
    }

    /// Creates a request that gets a kChat user's generated default profile image.
    public static func getUserDefaultImage(userId: String) -> APIRequest<Data> {
        APIRequest(
            method: .get,
            path: "/api/v4/users/\(userId)/image/default"
        )
    }

    /// Creates a request that gets a kChat user's status by id, or `me` for the authenticated user.
    public static func getUserStatus(userId: String) -> APIRequest<KChatUserStatus> {
        APIRequest(
            method: .get,
            path: "/api/v4/users/\(userId)/status"
        )
    }

    /// Creates a request that gets kChat user statuses by user ids.
    public static func getUserStatusesByIds(body: Data) -> APIRequest<[KChatUserStatus]> {
        APIRequest(
            method: .post,
            path: "/api/v4/users/status/ids",
            body: body
        )
    }
}
