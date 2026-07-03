import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumURLShortener

@Suite("URL shortener update short URL request")
struct URLShortenerUpdateShortURLRequestTests {
    @Test("update short URL request matches the OpenAPI path and encodes required body")
    func updateShortURLRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = try URLShortenerRequests.updateShortURL(
            shortURLCode: "czhS2Gn",
            expirationDate: 1_733_435_186
        )

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.httpMethod == "PUT")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(urlRequest.url?.path == "/1/url-shortener/czhS2Gn")

        let url = try #require(urlRequest.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        #expect((components.queryItems ?? []).isEmpty, "PUT /1/url-shortener/{short_url_code} has no required query parameters")

        let body = try #require(urlRequest.httpBody, "PUT /1/url-shortener/{short_url_code} must send the required JSON body")
        let object = try #require(JSONSerialization.jsonObject(with: body) as? [String: Any])
        #expect(object["expiration_date"] as? Int == 1_733_435_186)
    }

    @Test("update short URL request percent-encodes the required path code")
    func updateShortURLRequestEncodesRequiredPathCode() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = try URLShortenerRequests.updateShortURL(
            shortURLCode: "code/with spaces",
            expirationDate: 1_733_435_186
        )

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.url?.path == "/1/url-shortener/code/with spaces", "Foundation exposes the decoded path")
        #expect(urlRequest.url?.absoluteString.contains("/1/url-shortener/code%2Fwith%20spaces") == true)
    }

    @Test("update short URL request keeps required expiration date in body")
    func updateShortURLRequestKeepsRequiredExpirationDate() throws {
        let request = try URLShortenerRequests.updateShortURL(shortURLCode: "czhS2Gn", expirationDate: 1_733_435_186)
        let body = try #require(request.body, "PUT /1/url-shortener/{short_url_code} must fail test coverage if the required expiration_date body is missing")
        let object = try #require(JSONSerialization.jsonObject(with: body) as? [String: Any])

        #expect(object["expiration_date"] as? Int == 1_733_435_186)
    }

    @Test("update short URL response decodes using Swift API names")
    func updateShortURLResponseDecodes() throws {
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
