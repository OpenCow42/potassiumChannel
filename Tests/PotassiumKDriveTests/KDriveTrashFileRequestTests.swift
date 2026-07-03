import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKDrive

@Suite("kDrive trash file requests")
struct KDriveTrashFileRequestTests {
    @Test("kDrive trash files request matches the OpenAPI path and query")
    func kDriveTrashFilesRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.listTrashFiles(
            driveId: 100,
            with: "categories",
            options: ListKDriveTrashOptions(
                cursor: "next",
                limit: 25,
                orderBy: ["deleted_at", "name"],
                order: "desc",
                orderFor: ["name": "asc"],
                types: ["file", "dir"]
            )
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems ?? []

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/3/drive/100/trash")
        #expect(queryItems.contains(URLQueryItem(name: "with", value: "categories")))
        #expect(queryItems.contains(URLQueryItem(name: "cursor", value: "next")))
        #expect(queryItems.contains(URLQueryItem(name: "limit", value: "25")))
        #expect(queryItems.contains(URLQueryItem(name: "order_by", value: "deleted_at")))
        #expect(queryItems.contains(URLQueryItem(name: "order_by", value: "name")))
        #expect(queryItems.contains(URLQueryItem(name: "order", value: "desc")))
        #expect(queryItems.contains(URLQueryItem(name: "order_for[name]", value: "asc")))
        #expect(queryItems.contains(URLQueryItem(name: "type", value: "file")))
        #expect(queryItems.contains(URLQueryItem(name: "type", value: "dir")))
    }

    @Test("kDrive trash files response decodes cursor metadata and file items")
    func kDriveTrashFilesResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": [
            {
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
        #expect(response.responseAt == 1710000300)
        #expect(response.data.first?.id == 42)
        #expect(response.data.first?.status == "trashed")
    }
}
