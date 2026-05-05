import Foundation
import Testing
@testable import potassiumChannel

@Suite("kDrive import requests")
struct KDriveImportRequestTests {
    @Test("kDrive imports request matches the OpenAPI path and query")
    func kDriveImportsRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.listImports(driveId: 100, page: 1, perPage: 25)

        let urlRequest = try await client.makeURLRequest(for: request)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems ?? []

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/2/drive/100/imports")
        #expect(queryItems.contains(URLQueryItem(name: "page", value: "1")))
        #expect(queryItems.contains(URLQueryItem(name: "per_page", value: "25")))
    }

    @Test("kDrive imports response decodes using Swift API names")
    func kDriveImportsResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": [
            {
              "id": 1,
              "application": "dropbox",
              "account_name": "Team Dropbox",
              "status": "done",
              "error_code": null,
              "path": "/Imports",
              "directory_id": 42,
              "has_shared_files": "false",
              "created_at": 1710000000,
              "updated_at": 1710000100,
              "count_success_files": 12,
              "count_failed_files": 0
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

        let response = try decoder.decode(PaginatedInfomaniakResponse<[KDriveExternalImport]>.self, from: json)

        #expect(response.result == "success")
        #expect(response.total == 1)
        #expect(response.data.first?.application == "dropbox")
        #expect(response.data.first?.countSuccessFiles == 12)
    }
}
