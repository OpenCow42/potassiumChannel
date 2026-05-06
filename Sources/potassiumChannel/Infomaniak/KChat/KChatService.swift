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

    /// Lists posts for a kChat channel.
    public func getChannelPosts(
        channelId: String,
        options: KChatChannelPostsOptions = KChatChannelPostsOptions()
    ) async throws -> KChatPostList {
        try await client.send(KChatRequests.getChannelPosts(channelId: channelId, options: options))
    }

    /// Creates a kChat post.
    public func createPost(_ request: KChatPostCreateRequest) async throws -> KChatPost {
        let body = try JSONEncoder().encode(request)
        return try await client.send(KChatRequests.createPost(body: body))
    }

    /// Gets a single kChat post.
    public func getPost(postId: String) async throws -> KChatPost {
        try await client.send(KChatRequests.getPost(postId: postId))
    }

    /// Gets a kChat post thread.
    public func getPostThread(postId: String) async throws -> KChatPostList {
        try await client.send(KChatRequests.getPostThread(postId: postId))
    }

    /// Gets file information for files attached to a kChat post.
    public func getPostFilesInfo(
        postId: String,
        options: KChatPostFilesInfoOptions = KChatPostFilesInfoOptions()
    ) async throws -> [KChatFileInfo] {
        try await client.send(KChatRequests.getPostFilesInfo(postId: postId, options: options))
    }

    /// Deletes a kChat post.
    public func deletePost(postId: String) async throws -> KChatStatusOK {
        try await client.send(KChatRequests.deletePost(postId: postId))
    }

    /// Gets a previously uploaded kChat file.
    public func getFile(fileId: String) async throws -> Data {
        try await client.sendData(KChatRequests.getFile(fileId: fileId))
    }

    /// Uploads a file to kChat.
    public func uploadFile(channelId: String? = nil, filename: String? = nil, data: Data) async throws -> KChatFileUploadResponse {
        let boundary = "potassium-\(UUID().uuidString)"
        let uploadFilename = filename ?? "file"
        let body = Self.multipartFileBody(data: data, fieldName: "files", filename: uploadFilename, boundary: boundary)
        return try await client.send(KChatRequests.uploadFile(
            channelId: channelId,
            filename: filename,
            body: body,
            contentType: "multipart/form-data; boundary=\(boundary)"
        ))
    }

    private static func multipartFileBody(data: Data, fieldName: String, filename: String, boundary: String) -> Data {
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: application/octet-stream\r\n\r\n".data(using: .utf8)!)
        body.append(data)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        return body
    }
}
