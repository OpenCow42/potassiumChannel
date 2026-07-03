import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKDrive

@Suite("kDrive directory files requests")
struct KDriveDirectoryFilesRequestTests {
    @Test("kDrive directory files request matches the OpenAPI path and query")
    func kDriveDirectoryFilesRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.listDirectoryFiles(
            driveId: 100,
            fileId: 42,
            with: "categories",
            options: ListKDriveDirectoryFilesOptions(
                cursor: "next",
                limit: 25,
                orderBy: ["type", "name"],
                order: "desc",
                orderFor: ["name": "asc"],
                depth: "child",
                types: ["file", "dir"]
            )
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems ?? []

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/3/drive/100/files/42/files")
        #expect(queryItems.contains(URLQueryItem(name: "with", value: "categories")))
        #expect(queryItems.contains(URLQueryItem(name: "cursor", value: "next")))
        #expect(queryItems.contains(URLQueryItem(name: "limit", value: "25")))
        #expect(queryItems.contains(URLQueryItem(name: "order_by", value: "type")))
        #expect(queryItems.contains(URLQueryItem(name: "order_by", value: "name")))
        #expect(queryItems.contains(URLQueryItem(name: "order", value: "desc")))
        #expect(queryItems.contains(URLQueryItem(name: "order_for[name]", value: "asc")))
        #expect(queryItems.contains(URLQueryItem(name: "depth", value: "child")))
        #expect(queryItems.contains(URLQueryItem(name: "type", value: "file")))
        #expect(queryItems.contains(URLQueryItem(name: "type", value: "dir")))
    }

    @Test("kDrive directory files response decodes cursor metadata and file items")
    func kDriveDirectoryFilesResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": [
            {
              "id": 43,
              "name": "Nested.pdf",
              "path": "/Documents/Nested.pdf",
              "type": "file",
              "status": "active",
              "visibility": "is_private_space",
              "drive_id": 100,
              "parent_id": 42,
              "depth": 3,
              "created_at": 1710000000,
              "last_modified_at": 1710000100,
              "updated_at": 1710000200,
              "size": 1024,
              "mime_type": "application/pdf",
              "is_favorite": false
            }
          ],
          "cursor": "next-cursor",
          "has_more": true,
          "response_at": 1710000300
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(CursorPaginatedInfomaniakResponse<[KDriveFileItem]>.self, from: json)

        #expect(response.result == "success")
        #expect(response.cursor == "next-cursor")
        #expect(response.hasMore)
        #expect(response.data.first?.id == 43)
        #expect(response.data.first?.parentId == 42)
    }
}
