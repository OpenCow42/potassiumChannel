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

    /// Lists teams in kChat.
    public func listTeams(options: KChatListTeamsOptions = KChatListTeamsOptions()) async throws -> [KChatTeam] {
        try await client.send(KChatRequests.listTeams(options: options))
    }

    /// Lists all kChat channels visible to the token.
    public func listChannels(options: KChatListChannelsOptions = KChatListChannelsOptions()) async throws -> [KChatChannel] {
        try await client.send(KChatRequests.listChannels(options: options))
    }

    /// Gets a kChat channel by id.
    public func getChannel(channelId: String) async throws -> KChatChannel {
        try await client.send(KChatRequests.getChannel(channelId: channelId))
    }

    /// Gets a team in kChat by id.
    public func getTeam(teamId: String) async throws -> KChatTeam {
        try await client.send(KChatRequests.getTeam(teamId: teamId))
    }

    /// Gets a team in kChat by name.
    public func getTeamByName(name: String) async throws -> KChatTeam {
        try await client.send(KChatRequests.getTeamByName(name: name))
    }

    /// Gets statistics for a kChat team.
    public func getTeamStats(teamId: String) async throws -> KChatTeamStats {
        try await client.send(KChatRequests.getTeamStats(teamId: teamId))
    }

    /// Lists members in a kChat team.
    public func getTeamMembers(
        teamId: String,
        options: KChatTeamMembersOptions = KChatTeamMembersOptions()
    ) async throws -> [KChatTeamMember] {
        try await client.send(KChatRequests.getTeamMembers(teamId: teamId, options: options))
    }

    /// Gets a member in a kChat team.
    public func getTeamMember(teamId: String, userId: String) async throws -> KChatTeamMember {
        try await client.send(KChatRequests.getTeamMember(teamId: teamId, userId: userId))
    }

    /// Searches users in kChat.
    public func searchUsers(options: KChatUserSearchOptions) async throws -> [KChatUser] {
        let body = try JSONEncoder().encode(options)
        return try await client.send(KChatRequests.searchUsers(body: body))
    }

    /// Lists users in kChat.
    public func listUsers(options: KChatListUsersOptions = KChatListUsersOptions()) async throws -> [KChatUser] {
        try await client.send(KChatRequests.listUsers(options: options))
    }

    /// Autocompletes users in kChat.
    public func autocompleteUsers(options: KChatUserAutocompleteOptions) async throws -> KChatUserAutocomplete {
        try await client.send(KChatRequests.autocompleteUsers(options: options))
    }

    /// Gets a kChat user by id, or `me` for the authenticated user.
    public func getUser(userId: String) async throws -> KChatUser {
        try await client.send(KChatRequests.getUser(userId: userId))
    }

    /// Gets a kChat user by username.
    public func getUserByUsername(username: String) async throws -> KChatUser {
        try await client.send(KChatRequests.getUserByUsername(username: username))
    }

    /// Gets a kChat user by email.
    public func getUserByEmail(email: String) async throws -> KChatUser {
        try await client.send(KChatRequests.getUserByEmail(email: email))
    }

    /// Gets kChat users by user ids.
    public func getUsersByIds(userIds: [String]) async throws -> [KChatUser] {
        let body = try JSONEncoder().encode(userIds)
        return try await client.send(KChatRequests.getUsersByIds(body: body))
    }

    /// Gets kChat users by usernames.
    public func getUsersByUsernames(usernames: [String]) async throws -> [KChatUser] {
        let body = try JSONEncoder().encode(usernames)
        return try await client.send(KChatRequests.getUsersByUsernames(body: body))
    }

    /// Gets kChat users grouped by group-channel id.
    public func getUsersByGroupChannels(channelIds: [String]) async throws -> [String: [KChatUser]] {
        let body = try JSONEncoder().encode(channelIds)
        return try await client.send(KChatRequests.getUsersByGroupChannels(body: body))
    }

    /// Gets a kChat user's profile image by id, or `me` for the authenticated user.
    public func getUserImage(userId: String) async throws -> Data {
        try await client.sendData(KChatRequests.getUserImage(userId: userId))
    }

    /// Gets a kChat user's generated default profile image.
    public func getUserDefaultImage(userId: String) async throws -> Data {
        try await client.sendData(KChatRequests.getUserDefaultImage(userId: userId))
    }

    /// Gets a kChat user's status by id, or `me` for the authenticated user.
    public func getUserStatus(userId: String) async throws -> KChatUserStatus {
        try await client.send(KChatRequests.getUserStatus(userId: userId))
    }

    /// Gets kChat user statuses by user ids.
    public func getUserStatusesByIds(userIds: [String]) async throws -> [KChatUserStatus] {
        let body = try JSONEncoder().encode(userIds)
        return try await client.send(KChatRequests.getUserStatusesByIds(body: body))
    }

    /// Lists kChat teams for a user.
    public func getUserTeams(userId: String) async throws -> [KChatTeam] {
        try await client.send(KChatRequests.getUserTeams(userId: userId))
    }

    /// Lists kChat team memberships for a user, or `me` for the authenticated user.
    public func getUserTeamMembers(userId: String) async throws -> [KChatTeamMember] {
        try await client.send(KChatRequests.getUserTeamMembers(userId: userId))
    }

    /// Lists kChat team unread counts for a user, or `me` for the authenticated user.
    public func getUserTeamsUnread(userId: String) async throws -> [KChatTeamUnread] {
        try await client.send(KChatRequests.getUserTeamsUnread(userId: userId))
    }

    /// Gets unread counts for a specific kChat team for a user, or `me` for the authenticated user.
    public func getUserTeamUnread(userId: String, teamId: String) async throws -> KChatTeamUnread {
        try await client.send(KChatRequests.getUserTeamUnread(userId: userId, teamId: teamId))
    }

    /// Lists kChat channels for a user in a team.
    public func getUserTeamChannels(
        userId: String,
        teamId: String,
        options: KChatUserTeamChannelsOptions = KChatUserTeamChannelsOptions()
    ) async throws -> [KChatChannel] {
        try await client.send(KChatRequests.getUserTeamChannels(userId: userId, teamId: teamId, options: options))
    }

    /// Lists kChat channel memberships for a user, or `me` for the authenticated user.
    public func getUserChannelMembers(
        userId: String,
        options: KChatUserChannelMembersOptions = KChatUserChannelMembersOptions()
    ) async throws -> [KChatChannelMember] {
        try await client.send(KChatRequests.getUserChannelMembers(userId: userId, options: options))
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

    /// Gets metadata for a previously uploaded kChat file.
    public func getFileInfo(fileId: String) async throws -> KChatFileInfo {
        try await client.send(KChatRequests.getFileInfo(fileId: fileId))
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
