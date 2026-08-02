import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKDrive

@Suite("kDrive last modified file requests")
struct KDriveLastModifiedFileRequestTests {
    @Test("kDrive last modified files request matches the OpenAPI path and query")
    func kDriveLastModifiedFilesRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.listLastModifiedFiles(
            driveId: 100,
            with: "etag",
            cursor: "next",
            limit: 25
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems ?? []

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/3/drive/100/files/last_modified")
        #expect(queryItems.contains(URLQueryItem(name: "with", value: "etag")))
        #expect(queryItems.contains(URLQueryItem(name: "cursor", value: "next")))
        #expect(queryItems.contains(URLQueryItem(name: "limit", value: "25")))
    }

    @Test("kDrive last modified files response decodes using Swift API names")
    func kDriveLastModifiedFilesResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": [
            {
              "id": 42,
              "name": "Notes.md",
              "path": "/Documents/Notes.md",
              "type": "file",
              "status": "ok",
              "visibility": "is_private",
              "drive_id": 100,
              "depth": 2,
              "created_at": 1710000000,
              "added_at": 1710000000,
              "last_modified_at": 1710000400,
              "last_modified_by": 10,
              "revised_at": 1710000400,
              "updated_at": 1710000500,
              "parent_id": 1,
              "size": 4096,
              "mime_type": "text/markdown",
              "extension_type": "md",
              "scan_status": "done",
              "is_favorite": true
            }
          ],
          "cursor": null,
          "has_more": false,
          "response_at": 1710000600
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<[KDriveFileItem]>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.first?.name == "Notes.md")
        #expect(response.data.first?.lastModifiedAt == 1710000400)
        #expect(response.data.first?.mimeType == "text/markdown")
    }
}
