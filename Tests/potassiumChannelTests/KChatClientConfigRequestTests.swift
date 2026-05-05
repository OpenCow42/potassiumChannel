import Foundation
import Testing
@testable import potassiumChannel

@Suite("kChat client config requests")
struct KChatClientConfigRequestTests {
    @Test("kChat client config request matches the OpenAPI path and required format query")
    func kChatClientConfigRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.getClientConfig(format: "old")

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(url.path == "/api/v4/config/client")
        #expect(components.queryItems == [URLQueryItem(name: "format", value: "old")])
    }

    @Test("kChat service builds the team base URL")
    func kChatServiceBuildsTeamBaseURL() {
        #expect(KChatService.baseURL(teamName: "example-team").absoluteString == "https://example-team.kchat.infomaniak.com")
    }

    @Test("kChat client config response decodes status")
    func kChatClientConfigResponseDecodesStatus() throws {
        let json = #"{"status":"ok"}"#.data(using: .utf8)!

        let response = try JSONDecoder().decode(KChatStatusOK.self, from: json)

        #expect(response.status == "ok")
    }
}
