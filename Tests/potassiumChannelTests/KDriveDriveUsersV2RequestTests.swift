import Foundation
import Testing
@testable import potassiumChannel

@Suite("kDrive v2 drive users requests")
struct KDriveDriveUsersV2RequestTests {
    @Test("v2 drive users request matches the OpenAPI path and query")
    func v2DriveUsersRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.listDriveUsersV2(
            driveId: 100,
            with: "total",
            options: ListKDriveDriveUsersV2Options(
                search: "alice",
                statuses: ["active", "pending"],
                types: ["admin", "user"],
                userIds: [10, 11],
                page: 1,
                perPage: 25,
                total: true,
                orderBy: ["display_name"],
                order: "asc",
                orderFor: ["display_name": "desc"]
            )
        )

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/2/drive/100/users")

        let url = try #require(urlRequest.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        let queryItems = components.queryItems ?? []
        #expect(queryItems.contains(URLQueryItem(name: "with", value: "total")))
        #expect(queryItems.contains(URLQueryItem(name: "search", value: "alice")))
        #expect(queryItems.contains(URLQueryItem(name: "status", value: "active")))
        #expect(queryItems.contains(URLQueryItem(name: "status", value: "pending")))
        #expect(queryItems.contains(URLQueryItem(name: "types", value: "admin")))
        #expect(queryItems.contains(URLQueryItem(name: "types", value: "user")))
        #expect(queryItems.contains(URLQueryItem(name: "user_ids", value: "10")))
        #expect(queryItems.contains(URLQueryItem(name: "user_ids", value: "11")))
        #expect(queryItems.contains(URLQueryItem(name: "page", value: "1")))
        #expect(queryItems.contains(URLQueryItem(name: "per_page", value: "25")))
        #expect(queryItems.contains(URLQueryItem(name: "total", value: "true")))
        #expect(queryItems.contains(URLQueryItem(name: "order_by", value: "display_name")))
        #expect(queryItems.contains(URLQueryItem(name: "order", value: "asc")))
        #expect(queryItems.contains(URLQueryItem(name: "order_for[display_name]", value: "desc")))
    }

    @Test("v2 drive users response decodes using Swift API names")
    func v2DriveUsersResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": [
            {
              "id": 10,
              "display_name": "Alice",
              "first_name": "Alice",
              "last_name": "Example",
              "email": "alice@example.com",
              "is_sso": false,
              "avatar": null,
              "role": "admin",
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

        let response = try decoder.decode(PaginatedInfomaniakResponse<[KDriveDriveUser]>.self, from: json)

        #expect(response.data == [
            KDriveDriveUser(
                id: 10,
                displayName: "Alice",
                firstName: "Alice",
                lastName: "Example",
                email: "alice@example.com",
                isSso: false,
                role: "admin"
            ),
        ])
        #expect(response.total == 1)
    }
}
