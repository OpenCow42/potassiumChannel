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
}
