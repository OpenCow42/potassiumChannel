import Foundation
import Testing
@testable import potassiumChannel

@Suite("kDrive trashed file requests")
struct KDriveTrashedFileRequestTests {
    @Test("kDrive trashed file request matches the OpenAPI path and query")
    func kDriveTrashedFileRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.getTrashedFile(
            driveId: 100,
            fileId: 42,
            options: GetKDriveTrashedFileOptions(
                orderBy: ["deleted_at", "name"],
                order: "desc",
                orderFor: ["name": "asc"]
            )
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems ?? []

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/3/drive/100/trash/42")
        #expect(queryItems.contains(URLQueryItem(name: "order_by", value: "deleted_at")))
        #expect(queryItems.contains(URLQueryItem(name: "order_by", value: "name")))
        #expect(queryItems.contains(URLQueryItem(name: "order", value: "desc")))
        #expect(queryItems.contains(URLQueryItem(name: "order_for[name]", value: "asc")))
    }

    @Test("kDrive trashed file response decodes file item")
    func kDriveTrashedFileResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": {
            "id": 42,
            "name": "Trashed.pdf",
            "path": "/Documents/Trashed.pdf",
            "type": "file",
            "status": "trashed",
            "visibility": "is_private_space",
            "drive_id": 100,
            "parent_id": 1,
            "depth": 2,
            "created_at": 1710000000,
            "last_modified_at": 1710000100,
            "updated_at": 1710000200,
            "size": 2048,
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
        #expect(response.data.name == "Trashed.pdf")
        #expect(response.data.status == "trashed")
    }
}
