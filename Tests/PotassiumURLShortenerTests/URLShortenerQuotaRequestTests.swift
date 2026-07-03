import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumURLShortener

@Suite("URL shortener quota request")
struct URLShortenerQuotaRequestTests {
    @Test("quota request matches the deprecated OpenAPI path and has no required parameters")
    func quotaRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = URLShortenerRequests.quota()

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == nil)
        #expect(urlRequest.httpBody == nil)
        #expect(urlRequest.url?.path == "/1/url-shortener/quota")

        let url = try #require(urlRequest.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        #expect((components.queryItems ?? []).isEmpty)
    }

    @Test("quota response decodes an enveloped quota payload")
    func quotaResponseDecodesEnvelopedPayload() throws {
        let json = """
        {
          "result": "success",
          "data": {
            "quota": 1,
            "limit": 500
          }
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(URLShortenerQuotaResponse.self, from: json)

        #expect(response.result == "success")
        #expect(response.data == URLShortenerQuota(quota: 1, limit: 500))
    }

    @Test("quota response decodes a direct quota payload")
    func quotaResponseDecodesDirectPayload() throws {
        let json = """
        {
          "quota": 1,
          "limit": 500
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(URLShortenerQuotaResponse.self, from: json)

        #expect(response.result == nil)
        #expect(response.data == URLShortenerQuota(quota: 1, limit: 500))
    }
}
