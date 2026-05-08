import Foundation

extension KChatRequests {
    /// Creates a request that autocompletes public kChat channels for a team.
    public static func autocompleteChannelsForTeam(
        teamId: String,
        options: KChatChannelsForTeamAutocompleteOptions
    ) -> APIRequest<[KChatChannel]> {
        APIRequest(
            method: .get,
            path: "/api/v4/teams/\(percentEncodePathSegment(teamId))/channels/autocomplete",
            queryParameters: [
                QueryParameter(name: "name", value: .string(options.name)),
            ]
        )
    }

    /// Creates a request that autocompletes kChat channels for team search.
    public static func autocompleteChannelsForTeamForSearch(
        teamId: String,
        options: KChatChannelsForTeamSearchAutocompleteOptions
    ) -> APIRequest<[KChatChannel]> {
        APIRequest(
            method: .get,
            path: "/api/v4/teams/\(percentEncodePathSegment(teamId))/channels/search_autocomplete",
            queryParameters: [
                QueryParameter(name: "name", value: .string(options.name)),
            ]
        )
    }

    /// Creates a request that searches public kChat channels for a team.
    public static func searchChannels(
        teamId: String,
        options: KChatChannelSearchOptions
    ) throws -> APIRequest<[KChatChannel]> {
        APIRequest(
            method: .post,
            path: "/api/v4/teams/\(percentEncodePathSegment(teamId))/channels/search",
            body: try JSONEncoder().encode(options)
        )
    }

    /// Creates a request that searches archived kChat channels for a team.
    public static func searchArchivedChannels(
        teamId: String,
        options: KChatChannelSearchOptions
    ) throws -> APIRequest<[KChatChannel]> {
        APIRequest(
            method: .post,
            path: "/api/v4/teams/\(percentEncodePathSegment(teamId))/channels/search_archived",
            body: try JSONEncoder().encode(options)
        )
    }

    /// Creates a request that searches all private and open kChat channels visible to the token.
    public static func searchAllChannels(options: KChatSearchAllChannelsOptions) throws -> APIRequest<KChatSearchAllChannelsResponse> {
        var queryParameters: [QueryParameter] = []

        if let systemConsole = options.systemConsole {
            queryParameters.append(QueryParameter(name: "system_console", value: .bool(systemConsole)))
        }

        return APIRequest(
            method: .post,
            path: "/api/v4/channels/search",
            queryParameters: queryParameters,
            body: try JSONEncoder().encode(options)
        )
    }
}
