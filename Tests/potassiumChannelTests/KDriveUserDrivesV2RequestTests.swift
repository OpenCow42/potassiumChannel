import Foundation
import Testing
@testable import potassiumChannel

@Suite("kDrive user drives v2 requests")
struct KDriveUserDrivesV2RequestTests {
    @Test("kDrive user drives v2 request matches the OpenAPI path and query")
    func kDriveUserDrivesV2RequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.listUserDrivesV2(
            userId: 42,
            accountId: 84,
            with: "drive",
            options: ListKDriveUserDrivesOptions(
                roles: ["admin", "user"],
                statuses: ["active", "pending"],
                page: 2,
                perPage: 25,
                total: true
            )
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        let queryItems = components.queryItems ?? []

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(url.path == "/2/drive/users/42/drives")
        #expect(queryItems.contains(URLQueryItem(name: "account_id", value: "84")))
        #expect(queryItems.contains(URLQueryItem(name: "with", value: "drive")))
        #expect(queryItems.contains(URLQueryItem(name: "roles[]", value: "admin")))
        #expect(queryItems.contains(URLQueryItem(name: "roles[]", value: "user")))
        #expect(queryItems.contains(URLQueryItem(name: "status[]", value: "active")))
        #expect(queryItems.contains(URLQueryItem(name: "status[]", value: "pending")))
        #expect(queryItems.contains(URLQueryItem(name: "page", value: "2")))
        #expect(queryItems.contains(URLQueryItem(name: "per_page", value: "25")))
        #expect(queryItems.contains(URLQueryItem(name: "total", value: "true")))
    }

    @Test("kDrive user drives v2 response decodes using Swift API names")
    func kDriveUserDrivesV2ResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": [
            {
              "id": 1,
              "display_name": "Ada Lovelace",
              "first_name": "Ada",
              "last_name": "Lovelace",
              "email": "ada@example.com",
              "is_sso": false,
              "avatar": null,
              "role": "admin",
              "deleted_at": null,
              "drive_id": 100,
              "drive_name": "Engineering",
              "account_id": 84,
              "status": "active"
            }
          ],
          "total": 1,
          "page": 1,
          "pages": 1,
          "items_per_page": 25
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(PaginatedInfomaniakResponse<[KDriveDriveUser]>.self, from: json)

        #expect(response.result == "success")
        #expect(response.total == 1)
        #expect(response.data.first?.displayName == "Ada Lovelace")
        #expect(response.data.first?.email == "ada@example.com")
        #expect(response.data.first?.role == "admin")
    }
}
