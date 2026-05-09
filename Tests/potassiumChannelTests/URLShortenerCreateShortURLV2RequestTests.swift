import Foundation
import Testing
@testable import potassiumChannel

@Suite("URL shortener v2 create short URL request")
struct URLShortenerCreateShortURLV2RequestTests {
    @Test("create short URL v2 request matches the OpenAPI path and encodes required body")
    func createShortURLV2RequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = try URLShortenerRequests.createShortURLV2(
            url: "https://example.com/potassium-short-v2-test",
            expirationDate: 1_733_435_186
        )

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(urlRequest.url?.path == "/2/url-shortener")

        let url = try #require(urlRequest.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        #expect((components.queryItems ?? []).isEmpty)

        let body = try #require(urlRequest.httpBody, "POST /2/url-shortener must send the required JSON body")
        let object = try #require(JSONSerialization.jsonObject(with: body) as? [String: Any])
        #expect(object["url"] as? String == "https://example.com/potassium-short-v2-test")
        #expect(object["expiration_date"] as? Int == 1_733_435_186)
    }

    @Test("create short URL v2 request fails coverage if the required url body is missing")
    func createShortURLV2RequestKeepsRequiredURLWhenExpirationIsMissing() throws {
        let request = try URLShortenerRequests.createShortURLV2(url: "https://example.com/required-v2-url-only")
        let body = try #require(request.body, "POST /2/url-shortener must fail test coverage if the required url body is missing")
        let object = try #require(JSONSerialization.jsonObject(with: body) as? [String: Any])

        #expect(object["url"] as? String == "https://example.com/required-v2-url-only")
        #expect(!object.keys.contains("expiration_date"))
    }

    @Test("create short URL v2 response decodes using Swift API names")
    func createShortURLV2ResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": {
            "code": "czhS2Gn",
            "url": "https://www.infomaniak.com",
            "created_at": 1633435186,
            "expiration_date": 1733435186
          }
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<ShortURL>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data == ShortURL(
            code: "czhS2Gn",
            url: "https://www.infomaniak.com",
            createdAt: 1_633_435_186,
            expirationDate: 1_733_435_186
        ))
    }
}
