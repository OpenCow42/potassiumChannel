import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKDrive

@Suite("kDrive dropbox search requests")
struct KDriveSearchDropboxRequestTests {
    @Test("kDrive dropbox search request matches the OpenAPI path and query")
    func kDriveDropboxSearchRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.searchDropboxes(
            driveId: 100,
            with: "categories",
            options: SearchKDriveDropboxesOptions(
                cursor: "next",
                limit: 25,
                orderBy: ["relevance", "last_modified_at"],
                order: "desc",
                orderFor: ["last_modified_at": "asc"],
                authorId: 10,
                category: "(1&2)|3",
                createdAfter: 1710000000,
                createdAt: "custom",
                createdBefore: 1710003600,
                expires: "yes",
                hasPassword: "no",
                lastImportAfter: 1710007200,
                lastImportAt: "today",
                lastImportBefore: 1710010800,
                query: "incoming",
                queryScope: "filename"
            )
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems ?? []

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/3/drive/100/files/search/dropboxes")
        #expect(queryItems.contains(URLQueryItem(name: "with", value: "categories")))
        #expect(queryItems.contains(URLQueryItem(name: "cursor", value: "next")))
        #expect(queryItems.contains(URLQueryItem(name: "limit", value: "25")))
        #expect(queryItems.contains(URLQueryItem(name: "order_by", value: "relevance")))
        #expect(queryItems.contains(URLQueryItem(name: "order_by", value: "last_modified_at")))
        #expect(queryItems.contains(URLQueryItem(name: "order", value: "desc")))
        #expect(queryItems.contains(URLQueryItem(name: "order_for[last_modified_at]", value: "asc")))
        #expect(queryItems.contains(URLQueryItem(name: "author_id", value: "10")))
        #expect(queryItems.contains(URLQueryItem(name: "category", value: "(1&2)|3")))
        #expect(queryItems.contains(URLQueryItem(name: "created_after", value: "1710000000")))
        #expect(queryItems.contains(URLQueryItem(name: "created_at", value: "custom")))
        #expect(queryItems.contains(URLQueryItem(name: "created_before", value: "1710003600")))
        #expect(queryItems.contains(URLQueryItem(name: "expires", value: "yes")))
        #expect(queryItems.contains(URLQueryItem(name: "has_password", value: "no")))
        #expect(queryItems.contains(URLQueryItem(name: "last_import_after", value: "1710007200")))
        #expect(queryItems.contains(URLQueryItem(name: "last_import_at", value: "today")))
        #expect(queryItems.contains(URLQueryItem(name: "last_import_before", value: "1710010800")))
        #expect(queryItems.contains(URLQueryItem(name: "query", value: "incoming")))
        #expect(queryItems.contains(URLQueryItem(name: "query_scope", value: "filename")))
    }

    @Test("kDrive dropbox search response decodes cursor metadata and directory items")
    func kDriveDropboxSearchResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": [
            {
              "id": 42,
              "name": "Incoming",
              "path": "/Incoming",
              "type": "dir",
              "status": "ok",
              "visibility": "is_private",
              "drive_id": 100,
              "depth": 1,
              "created_at": 1710000000,
              "added_at": 1710000000,
              "last_modified_at": 1710000400,
              "last_modified_by": 10,
              "revised_at": 1710000400,
              "updated_at": 1710000500,
              "parent_id": 1,
              "is_favorite": false
            }
          ],
          "cursor": "next-cursor",
          "has_more": true,
          "response_at": 1710000600
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(CursorPaginatedInfomaniakResponse<[KDriveFileItem]>.self, from: json)

        #expect(response.result == "success")
        #expect(response.cursor == "next-cursor")
        #expect(response.hasMore)
        #expect(response.responseAt == 1710000600)
        #expect(response.data.first?.name == "Incoming")
        #expect(response.data.first?.type == "dir")
    }
}
