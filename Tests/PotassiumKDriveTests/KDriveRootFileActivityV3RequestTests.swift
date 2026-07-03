import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKDrive

@Suite("kDrive root file activity v3 requests")
struct KDriveRootFileActivityV3RequestTests {
    @Test("kDrive root file activities request matches the OpenAPI path and query")
    func kDriveRootFileActivitiesRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.listRootFileActivitiesV3(
            driveId: 100,
            with: "file,user",
            options: ListKDriveRootFileActivitiesV3Options(
                cursor: "next",
                limit: 25,
                orderBy: ["created_at", "action"],
                order: "desc",
                orderFor: ["action": "asc", "created_at": "desc"],
                actions: ["file_update", "file_create"],
                depth: "children",
                from: 1_710_000_000,
                terms: "doc",
                until: 1_710_000_100,
                users: [10, 11]
            )
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems ?? []

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/3/drive/100/files/activities")
        #expect(queryItems.contains(URLQueryItem(name: "with", value: "file,user")))
        #expect(queryItems.contains(URLQueryItem(name: "cursor", value: "next")))
        #expect(queryItems.contains(URLQueryItem(name: "limit", value: "25")))
        #expect(queryItems.contains(URLQueryItem(name: "order_by", value: "created_at")))
        #expect(queryItems.contains(URLQueryItem(name: "order_by", value: "action")))
        #expect(queryItems.contains(URLQueryItem(name: "order", value: "desc")))
        #expect(queryItems.contains(URLQueryItem(name: "order_for[action]", value: "asc")))
        #expect(queryItems.contains(URLQueryItem(name: "order_for[created_at]", value: "desc")))
        #expect(queryItems.contains(URLQueryItem(name: "actions", value: "file_update")))
        #expect(queryItems.contains(URLQueryItem(name: "actions", value: "file_create")))
        #expect(queryItems.contains(URLQueryItem(name: "depth", value: "children")))
        #expect(queryItems.contains(URLQueryItem(name: "from", value: "1710000000")))
        #expect(queryItems.contains(URLQueryItem(name: "terms", value: "doc")))
        #expect(queryItems.contains(URLQueryItem(name: "until", value: "1710000100")))
        #expect(queryItems.contains(URLQueryItem(name: "users", value: "10")))
        #expect(queryItems.contains(URLQueryItem(name: "users", value: "11")))
    }

    @Test("kDrive root file activities response decodes using existing activity model")
    func kDriveRootFileActivitiesResponseDecodes() throws {
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
