import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKDrive

@Suite("kDrive largest file requests")
struct KDriveLargestFileRequestTests {
    @Test("kDrive largest files request matches the OpenAPI path and query")
    func kDriveLargestFilesRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.listLargestFiles(driveId: 100, cursor: "next", limit: 25)

        let urlRequest = try await client.makeURLRequest(for: request)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems ?? []

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/3/drive/100/files/largest")
        #expect(queryItems.contains(URLQueryItem(name: "cursor", value: "next")))
        #expect(queryItems.contains(URLQueryItem(name: "limit", value: "25")))
    }

    @Test("kDrive largest files response decodes using Swift API names")
    func kDriveLargestFilesResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": [
            {
              "id": 42,
              "name": "Archive.zip",
              "path": "/Archives/Archive.zip",
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
              "size": 1048576,
              "mime_type": "application/zip",
              "extension_type": "zip",
              "scan_status": "done",
              "is_favorite": false
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
        #expect(response.data.first?.name == "Archive.zip")
        #expect(response.data.first?.size == 1048576)
        #expect(response.data.first?.mimeType == "application/zip")
    }
}
