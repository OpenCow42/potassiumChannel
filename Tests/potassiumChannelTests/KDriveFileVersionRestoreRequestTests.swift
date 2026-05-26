import Foundation
import Testing
@testable import potassiumChannel

@Suite("kDrive file version restore requests")
struct KDriveFileVersionRestoreRequestTests {
    @Test("kDrive v2 restore file version to directory request matches the OpenAPI shape")
    func v2RestoreToDirectoryRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let body = Data(#"{"name":"Restored.png"}"#.utf8)
        let request = KDriveRequests.restoreFileVersionToDirectoryV2(
            driveId: 100,
            fileId: 42,
            versionId: 123,
            destinationDirectoryId: 7,
            with: "capabilities",
            body: body
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems ?? []

        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(urlRequest.url?.path == "/2/drive/100/files/42/versions/123/restore/7")
        #expect(queryItems.contains(URLQueryItem(name: "with", value: "capabilities")))
        #expect(urlRequest.httpBody == body)
    }

    @Test("kDrive restore file version to directory request matches the OpenAPI shape")
    func restoreToDirectoryRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let body = Data(#"{"name":"Restored.png"}"#.utf8)
        let request = KDriveRequests.restoreFileVersionToDirectory(
            driveId: 100,
            fileId: 42,
            versionId: 123,
            destinationDirectoryId: 7,
            with: "capabilities",
            body: body
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems ?? []

        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(urlRequest.url?.path == "/3/drive/100/files/42/versions/123/restore/7")
        #expect(queryItems.contains(URLQueryItem(name: "with", value: "capabilities")))
        #expect(urlRequest.httpBody == body)
    }

    @Test("restore file version options encode the optional destination name")
    func restoreOptionsEncodeOpenAPIBody() throws {
        let options = RestoreKDriveFileVersionToDirectoryOptions(name: "Restored.png")

        let object = try JSONSerialization.jsonObject(with: JSONEncoder().encode(options)) as? [String: Any]

        #expect(object?["name"] as? String == "Restored.png")
    }

    @Test("restore file version response decodes restored file item")
    func restoreResponseDecodesFileItem() throws {
        let json = """
        {
          "result": "success",
          "data": {
            "id": 1234,
            "name": "Restored.png",
            "type": "file",
            "status": "active",
            "visibility": "",
            "drive_id": 100,
            "parent_id": 7,
            "path": "/Tests/Restored.png",
            "depth": 2,
            "created_at": 1710000000,
            "last_modified_at": 1710000100,
            "updated_at": 1710000200,
            "size": 2048,
            "mime_type": "image/png",
            "is_favorite": false
          }
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<KDriveFileVersionRestoreResult>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.id == 1234)
        #expect(response.data.name == "Restored.png")
        #expect(response.data.parentId == 7)
        #expect(response.data.mimeType == "image/png")
    }

    @Test("restore file version response decodes the v2 file shape without updated_at")
    func restoreResponseDecodesV2FileShape() throws {
        let json = """
        {
          "result": "success",
          "data": {
            "id": 1234,
            "name": "Restored.png",
            "type": "file",
            "status": "active",
            "visibility": "",
            "drive_id": 100,
            "parent_id": 7,
            "path": "/Tests/Restored.png",
            "depth": 2,
            "created_at": 1710000000,
            "last_modified_at": 1710000100,
            "size": 2048,
            "mime_type": "image/png"
          }
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<KDriveFileVersionRestoreResult>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.id == 1234)
        #expect(response.data.updatedAt == nil)
    }
}
