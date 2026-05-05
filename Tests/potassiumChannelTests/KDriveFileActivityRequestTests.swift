import Foundation
import Testing
@testable import potassiumChannel

@Suite("kDrive file activity requests")
struct KDriveFileActivityRequestTests {
    @Test("kDrive file activities request matches the OpenAPI path and query")
    func kDriveFileActivitiesRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.listFileActivities(
            driveId: 100,
            fileId: 42,
            with: "file",
            options: ListKDriveFileActivitiesOptions(
                cursor: "next",
                limit: 25,
                orderBy: ["created_at"],
                order: "desc",
                orderFor: ["created_at": "asc"],
                actions: ["file_update"],
                depth: "file",
                from: 1710000000,
                terms: "doc",
                until: 1710000100,
                users: [10]
            )
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems ?? []

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/3/drive/100/files/42/activities")
        #expect(queryItems.contains(URLQueryItem(name: "with", value: "file")))
        #expect(queryItems.contains(URLQueryItem(name: "cursor", value: "next")))
        #expect(queryItems.contains(URLQueryItem(name: "limit", value: "25")))
        #expect(queryItems.contains(URLQueryItem(name: "order_by", value: "created_at")))
        #expect(queryItems.contains(URLQueryItem(name: "order", value: "desc")))
        #expect(queryItems.contains(URLQueryItem(name: "order_for[created_at]", value: "asc")))
        #expect(queryItems.contains(URLQueryItem(name: "actions", value: "file_update")))
        #expect(queryItems.contains(URLQueryItem(name: "depth", value: "file")))
        #expect(queryItems.contains(URLQueryItem(name: "from", value: "1710000000")))
        #expect(queryItems.contains(URLQueryItem(name: "terms", value: "doc")))
        #expect(queryItems.contains(URLQueryItem(name: "until", value: "1710000100")))
        #expect(queryItems.contains(URLQueryItem(name: "users", value: "10")))
    }

    @Test("kDrive file activities response decodes using Swift API names")
    func kDriveFileActivitiesResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": [
            {
              "id": 1,
              "created_at": 1710000000,
              "action": "file_update",
              "new_path": "/new",
              "old_path": "/old",
              "private_path_user_id": null,
              "file_id": 42,
              "user_id": 10
            }
          ],
          "cursor": null,
          "has_more": false,
          "response_at": 1710000100
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(CursorPaginatedInfomaniakResponse<[KDriveDriveActivity]>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.first?.action == "file_update")
        #expect(response.data.first?.fileId == 42)
        #expect(response.data.first?.newPath == "/new")
    }
}
