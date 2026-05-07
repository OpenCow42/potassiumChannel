import Foundation
import Testing
@testable import potassiumChannel

@Suite("kChat get channel stats requests")
struct KChatGetChannelStatsRequestTests {
    @Test("kChat get channel stats request matches the OpenAPI path")
    func kChatGetChannelStatsRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.getChannelStats(channelId: "channel-id")

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == nil)
        #expect(url.path == "/api/v4/channels/channel-id/stats")
        #expect(url.query?.isEmpty ?? true)
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat get channel stats request percent-encodes the channel id path segment")
    func kChatGetChannelStatsRequestPercentEncodesChannelIdPathSegment() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.getChannelStats(channelId: "channel/id with space")

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(url.path == "/api/v4/channels/channel/id with space/stats")
        #expect(url.absoluteString.contains("/api/v4/channels/channel%2Fid%20with%20space/stats"))
        #expect(url.query?.isEmpty ?? true)
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat get channel stats decodes Mattermost-compatible channel stats")
    func kChatGetChannelStatsDecodesChannelStats() throws {
        let json = #"{"channel_id":"channel-id","member_count":42}"#.data(using: .utf8)!

        let stats = try JSONDecoder.kChat.decode(KChatChannelStats.self, from: json)

        #expect(stats.channelId == "channel-id")
        #expect(stats.memberCount == 42)
    }
}

private extension JSONDecoder {
    static var kChat: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
