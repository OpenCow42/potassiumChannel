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

    /// Creates a request that gets a kChat user by id, or `me` for the authenticated user.
    public static func getUser(userId: String) -> APIRequest<KChatUser> {
        APIRequest(
            method: .get,
            path: "/api/v4/users/\(userId)"
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

    /// Creates a request that posts a message to kChat.
    public static func createPost(body: Data) -> APIRequest<KChatPost> {
        APIRequest(
            method: .post,
            path: "/api/v4/posts",
            body: body
        )
    }

    /// Creates a request that deletes a kChat post.
    public static func deletePost(postId: String) -> APIRequest<KChatStatusOK> {
        APIRequest(
            method: .delete,
            path: "/api/v4/posts/\(postId)"
        )
    }
}
