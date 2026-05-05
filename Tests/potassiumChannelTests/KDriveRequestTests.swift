import Foundation
import Testing
@testable import potassiumChannel

@Suite("kDrive requests")
struct KDriveRequestTests {
    @Test("accessible kDrives request matches the OpenAPI path and query")
    func accessibleKDrivesRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.listAccessibleKDrives(
            accountId: 42,
            options: ListAccessibleKDrivesOptions(
                inMaintenance: false,
                maintenanceReasons: ["technical"],
                tags: [7],
                page: 2,
                perPage: 50
            )
        )

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/2/drive")

        let url = try #require(urlRequest.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        let queryItems = components.queryItems ?? []
        #expect(queryItems.contains(URLQueryItem(name: "account_id", value: "42")))
        #expect(queryItems.contains(URLQueryItem(name: "in_maintenance", value: "false")))
        #expect(queryItems.contains(URLQueryItem(name: "maintenance_reasons", value: "technical")))
        #expect(queryItems.contains(URLQueryItem(name: "tags", value: "7")))
        #expect(queryItems.contains(URLQueryItem(name: "page", value: "2")))
        #expect(queryItems.contains(URLQueryItem(name: "per_page", value: "50")))
    }

    @Test("accessible kDrives response decodes using Swift API names")
    func accessibleKDrivesResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": [
            {
              "id": 100,
              "name": "Team Drive",
              "account_id": 42,
              "role": "admin",
              "status": "ok",
              "in_maintenance": false
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

        let response = try decoder.decode(PaginatedInfomaniakResponse<[KDrive]>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data == [KDrive(id: 100, name: "Team Drive", accountId: 42, role: "admin", status: "ok", inMaintenance: false)])
        #expect(response.total == 1)
        #expect(response.itemsPerPage == 10)
    }
}
