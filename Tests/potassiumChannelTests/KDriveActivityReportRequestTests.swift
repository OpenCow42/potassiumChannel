import Foundation
import Testing
@testable import potassiumChannel

@Suite("kDrive activity report requests")
struct KDriveActivityReportRequestTests {
    @Test("kDrive activity reports request matches the OpenAPI path and query")
    func kDriveActivityReportsRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.listActivityReports(driveId: 100, page: 1, perPage: 25)

        let urlRequest = try await client.makeURLRequest(for: request)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems ?? []

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/2/drive/100/activities/reports")
        #expect(queryItems.contains(URLQueryItem(name: "page", value: "1")))
        #expect(queryItems.contains(URLQueryItem(name: "per_page", value: "25")))
    }

    @Test("kDrive activity reports response decodes using Swift API names")
    func kDriveActivityReportsResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": [
            {
              "id": 1,
              "status": "done",
              "size": "2048",
              "generated_by": {
                "id": 42,
                "display_name": "Ada Lovelace",
                "first_name": "Ada",
                "last_name": "Lovelace",
                "email": "ada@example.com",
                "is_sso": false,
                "avatar": null,
                "deleted_at": null
              },
              "download_url": "https://example.com/report.csv",
              "created_at": 1710000000,
              "updated_at": 1710000100
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

        let response = try decoder.decode(PaginatedInfomaniakResponse<[KDriveActivityReport]>.self, from: json)

        #expect(response.result == "success")
        #expect(response.total == 1)
        #expect(response.data.first?.status == "done")
        #expect(response.data.first?.generatedBy.displayName == "Ada Lovelace")
        #expect(response.data.first?.downloadUrl == "https://example.com/report.csv")
    }
}
