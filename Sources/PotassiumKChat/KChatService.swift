import Foundation
import PotassiumChannelCore

/// A high-level service for kChat API operations.
public struct KChatService: Sendable {
    /// Errors raised while building kChat service URLs.
    public enum BaseURLError: Error, Equatable, Sendable {
        case invalidTeamName(String)
    }

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

    /// Creates a kChat service for a validated Infomaniak kChat team subdomain.
    public init(validatingTeamName teamName: String, bearerToken: String) throws {
        self.client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: try Self.validatedBaseURL(teamName: teamName),
                bearerToken: bearerToken
            )
        )
    }

    /// Builds the Mattermost-compatible kChat base URL for a team name.
    public static func baseURL(teamName: String) -> URL {
        guard let url = try? validatedBaseURL(teamName: teamName) else {
            preconditionFailure("Invalid kChat team name: \(teamName)")
        }
        return url
    }

    /// Builds the Mattermost-compatible kChat base URL for a validated team name.
    public static func validatedBaseURL(teamName: String) throws -> URL {
        guard isValidTeamNameLabel(teamName) else {
            throw BaseURLError.invalidTeamName(teamName)
        }

        let expectedHost = "\(teamName).kchat.infomaniak.com"
        var components = URLComponents()
        components.scheme = "https"
        components.host = expectedHost

        guard
            let url = components.url,
            url.scheme == "https",
            url.host?.lowercased() == expectedHost.lowercased(),
            url.user == nil,
            url.password == nil,
            url.port == nil,
            url.path.isEmpty
        else {
            throw BaseURLError.invalidTeamName(teamName)
        }

        return url
    }

    private static func isValidTeamNameLabel(_ teamName: String) -> Bool {
        guard !teamName.isEmpty, teamName.utf8.count <= 63 else {
            return false
        }
        guard teamName.first != "-", teamName.last != "-" else {
            return false
        }

        return teamName.utf8.allSatisfy { character in
            (48...57).contains(character)
                || (65...90).contains(character)
                || (97...122).contains(character)
                || character == 45
        }
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

    /// Creates a kChat channel.
    public func createChannel(_ request: KChatChannelCreateRequest) async throws -> KChatChannel {
        let body = try JSONEncoder().encode(request)
        return try await client.send(KChatRequests.createChannel(body: body))
    }

    /// Gets a kChat channel by id.
    public func getChannel(channelId: String) async throws -> KChatChannel {
        try await client.send(KChatRequests.getChannel(channelId: channelId))
    }

    /// Gets statistics for a kChat channel.
    public func getChannelStats(channelId: String) async throws -> KChatChannelStats {
        try await client.send(KChatRequests.getChannelStats(channelId: channelId))
    }

    /// Gets moderation information for a kChat channel.
    public func getChannelModerations(channelId: String) async throws -> [KChatChannelModeration] {
        try await client.send(KChatRequests.getChannelModerations(channelId: channelId))
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

    /// Gets kChat team members by user ids.
    public func getTeamMembersByIds(teamId: String, userIds: [String]) async throws -> [KChatTeamMember] {
        try await client.send(try KChatRequests.getTeamMembersByIds(teamId: teamId, userIds: userIds))
    }

    /// Lists members in a kChat channel.
    public func getChannelMembers(
        channelId: String,
        options: KChatChannelMembersOptions = KChatChannelMembersOptions()
    ) async throws -> [KChatChannelMember] {
        try await client.send(KChatRequests.getChannelMembers(channelId: channelId, options: options))
    }

    /// Gets a member in a kChat channel.
    public func getChannelMember(channelId: String, userId: String) async throws -> KChatChannelMember {
        try await client.send(KChatRequests.getChannelMember(channelId: channelId, userId: userId))
    }

    /// Gets kChat channel members by user ids.
    public func getChannelMembersByIds(channelId: String, userIds: [String]) async throws -> [KChatChannelMember] {
        try await client.send(try KChatRequests.getChannelMembersByIds(channelId: channelId, userIds: userIds))
    }

    /// Lists public channels in a kChat team.
    public func getPublicChannelsForTeam(
        teamId: String,
        options: KChatPublicChannelsForTeamOptions = KChatPublicChannelsForTeamOptions()
    ) async throws -> [KChatChannel] {
        try await client.send(KChatRequests.getPublicChannelsForTeam(teamId: teamId, options: options))
    }

    /// Gets a channel in a kChat team by channel name.
    public func getChannelByName(teamId: String, channelName: String) async throws -> KChatChannel {
        try await client.send(KChatRequests.getChannelByName(teamId: teamId, channelName: channelName))
    }

    /// Gets a channel by kChat team name and channel name.
    public func getChannelByNameForTeamName(teamName: String, channelName: String) async throws -> KChatChannel {
        try await client.send(KChatRequests.getChannelByNameForTeamName(teamName: teamName, channelName: channelName))
    }

    /// Autocompletes public channels in a kChat team.
    public func autocompleteChannelsForTeam(
        teamId: String,
        options: KChatChannelsForTeamAutocompleteOptions
    ) async throws -> [KChatChannel] {
        try await client.send(KChatRequests.autocompleteChannelsForTeam(teamId: teamId, options: options))
    }

    /// Autocompletes channels for search in a kChat team.
    public func autocompleteChannelsForTeamForSearch(
        teamId: String,
        options: KChatChannelsForTeamSearchAutocompleteOptions
    ) async throws -> [KChatChannel] {
        try await client.send(KChatRequests.autocompleteChannelsForTeamForSearch(teamId: teamId, options: options))
    }

    /// Searches public channels in a kChat team.
    public func searchChannels(
        teamId: String,
        options: KChatChannelSearchOptions
    ) async throws -> [KChatChannel] {
        try await client.send(try KChatRequests.searchChannels(teamId: teamId, options: options))
    }

    /// Searches archived channels in a kChat team.
    public func searchArchivedChannels(
        teamId: String,
        options: KChatChannelSearchOptions
    ) async throws -> [KChatChannel] {
        try await client.send(try KChatRequests.searchArchivedChannels(teamId: teamId, options: options))
    }

    /// Searches all private and open kChat channels visible to the token.
    public func searchAllChannels(options: KChatSearchAllChannelsOptions) async throws -> KChatSearchAllChannelsResponse {
        try await client.send(try KChatRequests.searchAllChannels(options: options))
    }

    /// Lists private channels in a kChat team.
    public func getPrivateChannelsForTeam(
        teamId: String,
        options: KChatPrivateChannelsForTeamOptions = KChatPrivateChannelsForTeamOptions()
    ) async throws -> [KChatChannel] {
        try await client.send(KChatRequests.getPrivateChannelsForTeam(teamId: teamId, options: options))
    }

    /// Lists deleted channels in a kChat team.
    public func getDeletedChannelsForTeam(
        teamId: String,
        options: KChatDeletedChannelsForTeamOptions = KChatDeletedChannelsForTeamOptions()
    ) async throws -> [KChatChannel] {
        try await client.send(KChatRequests.getDeletedChannelsForTeam(teamId: teamId, options: options))
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

    /// Gets a kChat user's preferences.
    public func getPreferences(userId: String) async throws -> [KChatPreference] {
        try await client.send(KChatRequests.getPreferences(userId: userId))
    }

    /// Gets a kChat user's preferences by category.
    public func getPreferencesByCategory(userId: String, category: String) async throws -> [KChatPreference] {
        try await client.send(KChatRequests.getPreferencesByCategory(userId: userId, category: category))
    }

    /// Gets one kChat user preference.
    public func getPreference(userId: String, category: String, preferenceName: String) async throws -> KChatPreference {
        try await client.send(KChatRequests.getPreference(userId: userId, category: category, preferenceName: preferenceName))
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

    /// Lists kChat channels for a user across teams.
    public func getUserChannels(
        userId: String,
        options: KChatUserChannelsOptions = KChatUserChannelsOptions()
    ) async throws -> [KChatChannel] {
        try await client.send(KChatRequests.getUserChannels(userId: userId, options: options))
    }

    /// Gets unread counters for a kChat user channel.
    public func getChannelUnread(userId: String, channelId: String) async throws -> KChatChannelUnread {
        try await client.send(KChatRequests.getChannelUnread(userId: userId, channelId: channelId))
    }

    /// Gets a user's sidebar categories for a kChat team.
    public func getSidebarCategoriesForTeamForUser(userId: String, teamId: String) async throws -> KChatSidebarCategories {
        try await client.send(KChatRequests.getSidebarCategoriesForTeamForUser(userId: userId, teamId: teamId))
    }

    /// Gets a user's sidebar category order for a kChat team.
    public func getSidebarCategoryOrderForTeamForUser(userId: String, teamId: String) async throws -> [String] {
        try await client.send(KChatRequests.getSidebarCategoryOrderForTeamForUser(userId: userId, teamId: teamId))
    }

    /// Gets one user's sidebar category for a kChat team.
    public func getSidebarCategoryForTeamForUser(userId: String, teamId: String, categoryId: String) async throws -> KChatSidebarCategory {
        try await client.send(KChatRequests.getSidebarCategoryForTeamForUser(userId: userId, teamId: teamId, categoryId: categoryId))
    }

    /// Lists posts for a kChat channel.
    public func getChannelPosts(
        channelId: String,
        options: KChatChannelPostsOptions = KChatChannelPostsOptions()
    ) async throws -> KChatPostList {
        try await client.send(KChatRequests.getChannelPosts(channelId: channelId, options: options))
    }

    /// Gets pinned posts for a kChat channel.
    public func getPinnedPosts(channelId: String) async throws -> KChatPostList {
        try await client.send(KChatRequests.getPinnedPosts(channelId: channelId))
    }

    /// Gets posts around the oldest unread kChat channel post.
    public func getPostsAroundLastUnread(
        userId: String,
        channelId: String,
        options: KChatPostsAroundLastUnreadOptions = KChatPostsAroundLastUnreadOptions()
    ) async throws -> KChatPostList {
        try await client.send(KChatRequests.getPostsAroundLastUnread(userId: userId, channelId: channelId, options: options))
    }

    /// Gets flagged posts for a kChat user.
    public func getFlaggedPostsForUser(
        userId: String,
        options: KChatFlaggedPostsOptions = KChatFlaggedPostsOptions()
    ) async throws -> KChatFlaggedPosts {
        try await client.send(KChatRequests.getFlaggedPostsForUser(userId: userId, options: options))
    }

    /// Gets all followed kChat threads for a user in a team.
    public func getUserThreads(
        userId: String,
        teamId: String,
        options: KChatUserThreadsOptions = KChatUserThreadsOptions()
    ) async throws -> KChatUserThreads {
        try await client.send(KChatRequests.getUserThreads(userId: userId, teamId: teamId, options: options))
    }

    /// Gets one followed kChat thread for a user in a team.
    public func getUserThread(userId: String, teamId: String, threadId: String) async throws -> KChatUserThread {
        try await client.send(KChatRequests.getUserThread(userId: userId, teamId: teamId, threadId: threadId))
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

    /// Gets a previously uploaded kChat file preview.
    public func getFilePreview(fileId: String) async throws -> Data {
        try await client.sendData(KChatRequests.getFilePreview(fileId: fileId))
    }

    /// Gets a previously uploaded kChat file thumbnail.
    public func getFileThumbnail(fileId: String) async throws -> Data {
        try await client.sendData(KChatRequests.getFileThumbnail(fileId: fileId))
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
