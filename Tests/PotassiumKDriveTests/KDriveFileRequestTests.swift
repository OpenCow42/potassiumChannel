import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKDrive

@Suite("kDrive file requests")
struct KDriveFileRequestTests {
    @Test("kDrive file request matches the OpenAPI path and query")
    func kDriveFileRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.getFile(driveId: 100, fileId: 42, with: "categories,etag")

        let urlRequest = try await client.makeURLRequest(for: request)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems ?? []

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/3/drive/100/files/42")
        #expect(queryItems == [URLQueryItem(name: "with", value: "categories,etag")])
    }

    @Test("kDrive file response decodes using Swift API names")
    func kDriveFileResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": {
            "id": 42,
            "name": "Document.pdf",
            "path": "/Documents/Document.pdf",
            "type": "file",
            "status": "active",
            "visibility": "is_private_space",
            "drive_id": 100,
            "parent_id": 1,
            "depth": 2,
            "created_at": 1710000000,
            "last_modified_at": 1710000100,
            "revised_at": 1710000150,
            "updated_at": 1710000200,
            "etag": "9e22d98e554fe8df",
            "size": 1024,
            "mime_type": "application/pdf",
            "is_favorite": false
          }
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<KDriveFileItem>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.id == 42)
        #expect(response.data.name == "Document.pdf")
        #expect(response.data.driveId == 100)
        #expect(response.data.parentId == 1)
        #expect(response.data.revisedAt == 1_710_000_150)
        #expect(response.data.etag == "9e22d98e554fe8df")
    }

    @Test("kDrive file response remains compatible when optional revision resources are absent")
    func kDriveFileResponseWithoutRevisionResourcesDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": {
            "id": 42,
            "name": "Document.pdf",
            "type": "file",
            "status": "active",
            "visibility": "is_private_space",
            "drive_id": 100,
            "parent_id": 1,
            "depth": 2,
            "created_at": 1710000000,
            "last_modified_at": 1710000100,
            "updated_at": 1710000200
          }
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<KDriveFileItem>.self, from: json)

        #expect(response.data.revisedAt == nil)
        #expect(response.data.etag == nil)
    }
}
