import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKDrive

@Suite("kDrive recent file requests")
struct KDriveRecentFileRequestTests {
    @Test("kDrive recent files request matches the OpenAPI path and query")
    func kDriveRecentFilesRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.listRecentFiles(driveId: 100, page: 1, perPage: 25)

        let urlRequest = try await client.makeURLRequest(for: request)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems ?? []

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/3/drive/100/files/recents")
        #expect(queryItems.contains(URLQueryItem(name: "page", value: "1")))
        #expect(queryItems.contains(URLQueryItem(name: "per_page", value: "25")))
    }

    @Test("kDrive recent files response decodes using Swift API names")
    func kDriveRecentFilesResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": [
            {
              "id": 42,
              "name": "Document.pdf",
              "path": "/Documents/Document.pdf",
              "type": "file",
              "status": "ok",
              "visibility": "is_private",
              "drive_id": 100,
              "depth": 2,
              "created_at": 1710000000,
              "added_at": 1710000000,
              "last_modified_at": 1710000100,
              "last_modified_by": 10,
              "revised_at": 1710000100,
              "updated_at": 1710000200,
              "parent_id": 1,
              "size": 2048,
              "mime_type": "application/pdf",
              "extension_type": "pdf",
              "scan_status": "done",
              "is_favorite": true
            }
          ],
          "cursor": null,
          "has_more": false,
          "response_at": 1710000300
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<[KDriveFileItem]>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.first?.name == "Document.pdf")
        #expect(response.data.first?.size == 2048)
        #expect(response.data.first?.mimeType == "application/pdf")
    }
}
