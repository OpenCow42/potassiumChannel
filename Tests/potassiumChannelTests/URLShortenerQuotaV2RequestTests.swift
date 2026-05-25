import Foundation
import Testing
@testable import potassiumChannel

@Suite("URL shortener v2 quota request")
struct URLShortenerQuotaV2RequestTests {
    @Test("v2 quota request matches the OpenAPI path and has no required parameters")
    func quotaV2RequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = URLShortenerRequests.quotaV2()

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == nil)
        #expect(urlRequest.httpBody == nil)
        #expect(urlRequest.url?.path == "/2/url-shortener/quota")

        let url = try #require(urlRequest.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        #expect((components.queryItems ?? []).isEmpty)
    }

    @Test("v2 quota response decodes using Swift API names")
    func quotaV2ResponseDecodes() throws {
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

        let response = try decoder.decode(InfomaniakResponse<URLShortenerQuota>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data == URLShortenerQuota(quota: 1, limit: 500))
    }
}
