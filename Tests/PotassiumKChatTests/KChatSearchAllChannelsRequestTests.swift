import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKChat

@Suite("kChat all channels search requests")
struct KChatSearchAllChannelsRequestTests {
    @Test("kChat all channels search request matches the OpenAPI path and JSON body")
    func kChatSearchAllChannelsRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = try KChatRequests.searchAllChannels(options: KChatSearchAllChannelsOptions(term: "town"))

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        let body = try #require(urlRequest.httpBody)
        let object = try JSONSerialization.jsonObject(with: body) as? [String: Any]

        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(url.path == "/api/v4/channels/search")
        #expect((components.queryItems ?? []).isEmpty)
        #expect(object?["term"] as? String == "town")
        #expect(object?.count == 1)
    }

    @Test("kChat all channels search request encodes exact OpenAPI body and query options")
    func kChatSearchAllChannelsRequestEncodesOpenAPIOptions() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = try KChatRequests.searchAllChannels(
            options: KChatSearchAllChannelsOptions(
                term: "town",
                systemConsole: false,
                notAssociatedToGroup: "group-id",
                excludeDefaultChannels: true,
                teamIds: ["team-a", "team-b"],
                groupConstrained: false,
                excludeGroupConstrained: true,
                public: true,
                private: false,
                deleted: false,
                page: 2,
                perPage: 50,
                excludePolicyConstrained: true,
                includeSearchById: true
            )
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        let body = try #require(urlRequest.httpBody)
        let object = try JSONSerialization.jsonObject(with: body) as? [String: Any]

        #expect(url.path == "/api/v4/channels/search")
        #expect(components.queryItems == [URLQueryItem(name: "system_console", value: "false")])
        #expect(object?["term"] as? String == "town")
        #expect(object?["not_associated_to_group"] as? String == "group-id")
        #expect(object?["exclude_default_channels"] as? Bool == true)
        #expect(object?["team_ids"] as? [String] == ["team-a", "team-b"])
        #expect(object?["group_constrained"] as? Bool == false)
        #expect(object?["exclude_group_constrained"] as? Bool == true)
        #expect(object?["public"] as? Bool == true)
        #expect(object?["private"] as? Bool == false)
        #expect(object?["deleted"] as? Bool == false)
        #expect(object?["page"] as? Int == 2)
        #expect(object?["per_page"] as? Int == 50)
        #expect(object?["exclude_policy_constrained"] as? Bool == true)
        #expect(object?["include_search_by_id"] as? Bool == true)
        #expect(object?["system_console"] == nil)
        #expect(object?.count == 13)
    }

    @Test("kChat all channels search request keeps required term when empty")
    func kChatSearchAllChannelsRequestKeepsRequiredTermWhenEmpty() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = try KChatRequests.searchAllChannels(options: KChatSearchAllChannelsOptions(term: ""))

        let urlRequest = try await client.makeURLRequest(for: request)
        let body = try #require(urlRequest.httpBody)
        let object = try JSONSerialization.jsonObject(with: body) as? [String: Any]

        #expect(object?["term"] as? String == "")
        #expect(object?.count == 1)
    }

    @Test("kChat all channels search decodes paginated response object")
    func kChatSearchAllChannelsDecodesPaginatedResponseObject() throws {
        let json = #"{"channels":[{"id":"channel-id","team_id":"team-id","type":"O","display_name":"Town Square","name":"town-square","purpose":"General chat","policy_id":"policy-id"}],"total_count":1}"#.data(using: .utf8)!

        let response = try JSONDecoder.kChat.decode(KChatSearchAllChannelsResponse.self, from: json)
        let channel = try #require(response.channels.first)

        #expect(response.totalCount == 1)
        #expect(channel.id == "channel-id")
        #expect(channel.teamId == "team-id")
        #expect(channel.displayName == "Town Square")
        #expect(channel.name == "town-square")
        #expect(channel.policyId == "policy-id")
    }

    @Test("kChat all channels search decodes non-paginated channel arrays")
    func kChatSearchAllChannelsDecodesNonPaginatedArray() throws {
        let json = #"[{"id":"channel-id","team_id":"team-id","type":"O","display_name":"Town Square","name":"town-square"}]"#.data(using: .utf8)!

        let response = try JSONDecoder.kChat.decode(KChatSearchAllChannelsResponse.self, from: json)
        let channel = try #require(response.channels.first)

        #expect(response.totalCount == nil)
        #expect(channel.id == "channel-id")
        #expect(channel.teamId == "team-id")
        #expect(channel.displayName == "Town Square")
    }
}

private extension JSONDecoder {
    static var kChat: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
