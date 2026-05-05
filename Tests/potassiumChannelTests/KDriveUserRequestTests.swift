import Foundation
import Testing
@testable import potassiumChannel

@Suite("kDrive user requests")
struct KDriveUserRequestTests {
    @Test("kDrive users request matches the OpenAPI path and query")
    func kDriveUsersRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.listKDriveUsers(
            options: ListKDriveUsersOptions(search: "adrien", userIds: [10, 11], page: 1, perPage: 25)
        )

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/2/drive/users")

        let url = try #require(urlRequest.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        let queryItems = components.queryItems ?? []
        #expect(queryItems.contains(URLQueryItem(name: "search", value: "adrien")))
        #expect(queryItems.contains(URLQueryItem(name: "user_ids", value: "10")))
        #expect(queryItems.contains(URLQueryItem(name: "user_ids", value: "11")))
        #expect(queryItems.contains(URLQueryItem(name: "page", value: "1")))
        #expect(queryItems.contains(URLQueryItem(name: "per_page", value: "25")))
    }

    @Test("kDrive users response decodes using Swift API names")
    func kDriveUsersResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": [
            {
              "id": 10,
              "display_name": "Adrien",
              "first_name": "Adrien",
              "last_name": "Example",
              "email": "adrien@example.com",
              "is_sso": false,
              "avatar": null,
              "deleted_at": null
            }
          ],
          "total": 1,
          "page": 1,
          "pages": 1,
          "items_per_page": 10
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(PaginatedInfomaniakResponse<[KDriveUser]>.self, from: json)

        #expect(response.data == [
            KDriveUser(
                id: 10,
                displayName: "Adrien",
                firstName: "Adrien",
                lastName: "Example",
                email: "adrien@example.com",
                isSso: false
            ),
        ])
        #expect(response.total == 1)
    }
}
