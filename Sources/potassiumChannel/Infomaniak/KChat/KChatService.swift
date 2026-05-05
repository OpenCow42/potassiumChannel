import Foundation

/// A high-level service for kChat API operations.
public struct KChatService: Sendable {
    private let client: InfomaniakAPIClient

    /// Creates a kChat service backed by an API client.
    public init(client: InfomaniakAPIClient) {
        self.client = client
    }

    /// Creates a kChat service for an Infomaniak kChat team subdomain.
    public init(teamName: String, bearerToken: String) {
        self.client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: Self.baseURL(teamName: teamName),
                bearerToken: bearerToken
            )
        )
    }

    /// Builds the Mattermost-compatible kChat base URL for a team name.
    public static func baseURL(teamName: String) -> URL {
        URL(string: "https://\(teamName).kchat.infomaniak.com")!
    }

    /// Fetches the client configuration required by kChat clients.
    public func getClientConfig(format: String) async throws -> KChatClientConfig {
        try await client.send(KChatRequests.getClientConfig(format: format))
    }

    /// Searches users in kChat.
    public func searchUsers(options: KChatUserSearchOptions) async throws -> [KChatUser] {
        let body = try JSONEncoder().encode(options)
        return try await client.send(KChatRequests.searchUsers(body: body))
    }

    /// Gets a kChat user by id, or `me` for the authenticated user.
    public func getUser(userId: String) async throws -> KChatUser {
        try await client.send(KChatRequests.getUser(userId: userId))
    }

    /// Lists kChat teams for a user.
    public func getUserTeams(userId: String) async throws -> [KChatTeam] {
        try await client.send(KChatRequests.getUserTeams(userId: userId))
    }

    /// Lists kChat channels for a user in a team.
    public func getUserTeamChannels(
        userId: String,
        teamId: String,
        options: KChatUserTeamChannelsOptions = KChatUserTeamChannelsOptions()
    ) async throws -> [KChatChannel] {
        try await client.send(KChatRequests.getUserTeamChannels(userId: userId, teamId: teamId, options: options))
    }

    /// Creates a kChat post.
    public func createPost(_ request: KChatPostCreateRequest) async throws -> KChatPost {
        let body = try JSONEncoder().encode(request)
        return try await client.send(KChatRequests.createPost(body: body))
    }

    /// Deletes a kChat post.
    public func deletePost(postId: String) async throws -> KChatStatusOK {
        try await client.send(KChatRequests.deletePost(postId: postId))
    }
}
