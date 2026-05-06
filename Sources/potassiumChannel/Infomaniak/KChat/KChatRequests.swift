import Foundation

/// Factory methods for kChat API requests.
public enum KChatRequests {
    /// Creates a request that fetches the client configuration required by kChat clients.
    ///
    /// The current public API only implements the legacy `old` format.
    public static func getClientConfig(format: String) -> APIRequest<KChatClientConfig> {
        APIRequest(
            method: .get,
            path: "/api/v4/config/client",
            queryParameters: [
                QueryParameter(name: "format", value: .string(format)),
            ]
        )
    }

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

    /// Creates a request that lists kChat teams for a user.
    public static func getUserTeams(userId: String) -> APIRequest<[KChatTeam]> {
        APIRequest(
            method: .get,
            path: "/api/v4/users/\(userId)/teams"
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

    /// Creates a request that lists posts for a kChat channel.
    public static func getChannelPosts(
        channelId: String,
        options: KChatChannelPostsOptions = KChatChannelPostsOptions()
    ) -> APIRequest<KChatPostList> {
        var queryParameters: [QueryParameter] = []

        if let page = options.page {
            queryParameters.append(QueryParameter(name: "page", value: .integer(page)))
        }

        if let perPage = options.perPage {
            queryParameters.append(QueryParameter(name: "per_page", value: .integer(perPage)))
        }

        if let since = options.since {
            queryParameters.append(QueryParameter(name: "since", value: .integer(since)))
        }

        if let before = options.before {
            queryParameters.append(QueryParameter(name: "before", value: .string(before)))
        }

        if let after = options.after {
            queryParameters.append(QueryParameter(name: "after", value: .string(after)))
        }

        if let includeDeleted = options.includeDeleted {
            queryParameters.append(QueryParameter(name: "include_deleted", value: .bool(includeDeleted)))
        }

        return APIRequest(
            method: .get,
            path: "/api/v4/channels/\(channelId)/posts",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that posts a message to kChat.
    public static func createPost(body: Data) -> APIRequest<KChatPost> {
        APIRequest(
            method: .post,
            path: "/api/v4/posts",
            body: body
        )
    }

    /// Creates a request that gets a single kChat post.
    public static func getPost(postId: String) -> APIRequest<KChatPost> {
        APIRequest(
            method: .get,
            path: "/api/v4/posts/\(postId)"
        )
    }

    /// Creates a request that gets a kChat post thread.
    public static func getPostThread(postId: String) -> APIRequest<KChatPostList> {
        APIRequest(
            method: .get,
            path: "/api/v4/posts/\(postId)/thread"
        )
    }

    /// Creates a request that gets file information for files attached to a kChat post.
    public static func getPostFilesInfo(
        postId: String,
        options: KChatPostFilesInfoOptions = KChatPostFilesInfoOptions()
    ) -> APIRequest<[KChatFileInfo]> {
        var queryParameters: [QueryParameter] = []

        if let includeDeleted = options.includeDeleted {
            queryParameters.append(QueryParameter(name: "include_deleted", value: .bool(includeDeleted)))
        }

        return APIRequest(
            method: .get,
            path: "/api/v4/posts/\(postId)/files/info",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that deletes a kChat post.
    public static func deletePost(postId: String) -> APIRequest<KChatStatusOK> {
        APIRequest(
            method: .delete,
            path: "/api/v4/posts/\(postId)"
        )
    }

    /// Creates a request that gets a previously uploaded kChat file.
    public static func getFile(fileId: String) -> APIRequest<Data> {
        APIRequest(
            method: .get,
            path: "/api/v4/files/\(fileId)"
        )
    }

    /// Creates a request that gets metadata for a previously uploaded kChat file.
    public static func getFileInfo(fileId: String) -> APIRequest<KChatFileInfo> {
        APIRequest(
            method: .get,
            path: "/api/v4/files/\(fileId)/info"
        )
    }

    /// Creates a request that uploads a file to kChat.
    public static func uploadFile(channelId: String? = nil, filename: String? = nil, body: Data, contentType: String) -> APIRequest<KChatFileUploadResponse> {
        var queryParameters: [QueryParameter] = []

        if let channelId {
            queryParameters.append(QueryParameter(name: "channel_id", value: .string(channelId)))
        }

        if let filename {
            queryParameters.append(QueryParameter(name: "filename", value: .string(filename)))
        }

        return APIRequest(
            method: .post,
            path: "/api/v4/files",
            queryParameters: queryParameters,
            headers: [HTTPHeader(name: "Content-Type", value: contentType)],
            body: body
        )
    }
}
