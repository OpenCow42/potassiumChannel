import Foundation
import Testing
@testable import potassiumChannel

@Suite("URL shortener v2 list short URLs request")
struct URLShortenerListShortURLsV2RequestTests {
    @Test("v2 list short URLs request matches the OpenAPI path and explicitly has no required parameters")
    func listShortURLsV2RequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = try URLShortenerRequests.listShortURLsV2()

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == nil)
        #expect(urlRequest.httpBody == nil, "GET /2/url-shortener has no required request body parameters")
        #expect(urlRequest.url?.path == "/2/url-shortener")

        let url = try #require(urlRequest.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        #expect((components.queryItems ?? []).isEmpty, "GET /2/url-shortener has no required query parameters")
    }

    @Test("v2 list short URLs encodes optional OpenAPI request body filters")
    func listShortURLsV2EncodesOptionalBodyFilters() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = try URLShortenerRequests.listShortURLsV2(
            options: ListShortURLsV2Options(
                orderBy: .createdAt,
                orderDirection: .descending,
                search: "infomaniak",
                perPage: 25
            )
        )

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        let body = try #require(urlRequest.httpBody, "GET /2/url-shortener must send a JSON body when optional filters are provided")
        let object = try #require(JSONSerialization.jsonObject(with: body) as? [String: Any])
        #expect(object["order_by"] as? String == "created_at")
        #expect(object["order_direction"] as? String == "DESC")
        #expect(object["search"] as? String == "infomaniak")
        #expect(object["per_page"] as? Int == 25)
    }

    @Test("v2 list short URLs response decodes using Swift API names")
    func listShortURLsV2ResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "total": 1,
          "page": 1,
          "pages": 1,
          "items_per_page": 50,
          "data": [
            {
              "code": "czhS2Gn",
              "url": "https://www.infomaniak.com",
              "created_at": 1633435186,
              "expiration_date": 1733435186
            }
          ]
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(URLShortenerV2ListResponse<[ShortURL]>.self, from: json)

        #expect(response.result == "success")
        #expect(response.total == 1)
        #expect(response.page == 1)
        #expect(response.pages == 1)
        #expect(response.itemsPerPage == 50)
        #expect(response.data == [
            ShortURL(
                code: "czhS2Gn",
                url: "https://www.infomaniak.com",
                createdAt: 1633435186,
                expirationDate: 1733435186
            ),
        ])
    }
}
