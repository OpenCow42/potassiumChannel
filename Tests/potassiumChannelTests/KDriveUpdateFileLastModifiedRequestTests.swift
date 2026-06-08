import Foundation
import Testing
@testable import potassiumChannel

@Suite("kDrive update-file-last-modified request")
struct KDriveUpdateFileLastModifiedRequestTests {
    @Test("kDrive update-file-last-modified request matches the OpenAPI shape")
    func requestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let body = try JSONEncoder().encode(UpdateKDriveFileLastModifiedOptions(lastModifiedAt: 1_710_000_100))
        let request = KDriveRequests.updateFileLastModified(
            driveId: 100,
            fileId: 42,
            body: body
        )

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(urlRequest.url?.path == "/3/drive/100/files/42/last-modified")

        let httpBody = try #require(urlRequest.httpBody)
        let object = try #require(JSONSerialization.jsonObject(with: httpBody) as? [String: Any])
        #expect(object["last_modified_at"] as? Int == 1_710_000_100)
    }

    @Test("kDrive update-file-last-modified response decodes updated file")
    func responseDecodesUpdatedFile() throws {
        let data = """
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
            "updated_at": 1710000200,
            "size": 1024,
            "mime_type": "application/pdf",
            "is_favorite": false
          }
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<KDriveFileItem>.self, from: data)

        #expect(response.result == "success")
        #expect(response.data.id == 42)
        #expect(response.data.lastModifiedAt == 1710000100)
    }
}
