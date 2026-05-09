import Foundation
import Testing
@testable import potassiumChannel

@Suite("URL shortener list short URLs request")
struct URLShortenerListShortURLsRequestTests {
    @Test("list short URLs request matches the OpenAPI path and has no required parameters")
    func listShortURLsRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = URLShortenerRequests.listShortURLs()

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == nil)
        #expect(urlRequest.httpBody == nil)
        #expect(urlRequest.url?.path == "/1/url-shortener")

        let url = try #require(urlRequest.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        #expect((components.queryItems ?? []).isEmpty)
    }

    @Test("list short URLs OpenAPI response decodes using Swift API names")
    func listShortURLsOpenAPIResponseDecodes() throws {
        let json = """
        {
          "current_page": 1,
          "data": [
            {
              "code": "czhS2Gn",
              "url": "https://www.infomaniak.com",
              "created_at": 1633435186,
              "expiration_date": 1733435186
            }
          ],
          "first_page_url": "https://api.infomaniak.com/1/url-shortener?page=1",
          "from": 1,
          "next_page_url": null,
          "path": "https://api.infomaniak.com/1/url-shortener",
          "per_page": 50,
          "prev_page_url": null,
          "to": 1,
          "total": 1
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(URLShortenerListResponse<[ShortURL]>.self, from: json)

        #expect(response.currentPage == 1)
        #expect(response.data == [
            ShortURL(
                code: "czhS2Gn",
                url: "https://www.infomaniak.com",
                createdAt: 1633435186,
                expirationDate: 1733435186
            ),
        ])
        #expect(response.perPage == 50)
        #expect(response.total == 1)
    }

    @Test("list short URLs live pagination response decodes using Swift API names")
    func listShortURLsLivePaginationResponseDecodes() throws {
        let json = """
        {
          "data": [],
          "links": {
            "first": "https://api.infomaniak.com/1/url-shortener?page=1",
            "last": "https://api.infomaniak.com/1/url-shortener?page=1",
            "prev": null,
            "next": null
          },
          "meta": {
            "current_page": 1,
            "from": null,
            "last_page": 1,
            "links": [],
            "path": "https://api.infomaniak.com/1/url-shortener",
            "per_page": 50,
            "to": null,
            "total": 0
          }
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(URLShortenerListResponse<[ShortURL]>.self, from: json)

        #expect(response.currentPage == 1)
        #expect(response.data.isEmpty)
        #expect(response.firstPageUrl == "https://api.infomaniak.com/1/url-shortener?page=1")
        #expect(response.perPage == 50)
        #expect(response.total == 0)
    }
}
