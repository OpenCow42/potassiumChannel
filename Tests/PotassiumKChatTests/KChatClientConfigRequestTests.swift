import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKChat

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
    func kChatServiceBuildsTeamBaseURL() throws {
        #expect(KChatService.baseURL(teamName: "example-team").absoluteString == "https://example-team.kchat.infomaniak.com")
        #expect(try KChatService.validatedBaseURL(teamName: "example-team").absoluteString == "https://example-team.kchat.infomaniak.com")
        #expect(try KChatService.validatedBaseURL(teamName: "team123").absoluteString == "https://team123.kchat.infomaniak.com")
    }

    @Test("kChat service rejects invalid team names")
    func kChatServiceRejectsInvalidTeamNames() {
        let invalidTeamNames = [
            "",
            "evil.com/path",
            "evil.com",
            "evil/path",
            "evil:path",
            "user@evil",
            "evil team",
            "evil%2Fpath",
            "https://evil.com",
            "-evil",
            "evil-",
            ".",
            "evil.",
            ".evil",
            "evil..team",
        ]

        for teamName in invalidTeamNames {
            #expect(throws: KChatService.BaseURLError.invalidTeamName(teamName)) {
                try KChatService.validatedBaseURL(teamName: teamName)
            }
        }
    }

    @Test("kChat client config response decodes values")
    func kChatClientConfigResponseDecodesStatus() throws {
        let json = #"{"AboutLink":"https://www.infomaniak.com","AllowPolls":"true"}"#.data(using: .utf8)!

        let response = try JSONDecoder().decode(KChatClientConfig.self, from: json)

        #expect(response["AboutLink"] == "https://www.infomaniak.com")
        #expect(response["AllowPolls"] == "true")
    }
}
