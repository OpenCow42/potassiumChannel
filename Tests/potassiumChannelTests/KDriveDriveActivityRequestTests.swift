import Foundation
import Testing
@testable import potassiumChannel

@Suite("kDrive drive activity requests")
struct KDriveDriveActivityRequestTests {
    @Test("kDrive drive activities request matches the OpenAPI path and query")
    func kDriveDriveActivitiesRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.listDriveActivities(driveId: 100, page: 1, perPage: 25)

        let urlRequest = try await client.makeURLRequest(for: request)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems ?? []

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/3/drive/100/activities")
        #expect(queryItems.contains(URLQueryItem(name: "page", value: "1")))
        #expect(queryItems.contains(URLQueryItem(name: "per_page", value: "25")))
    }

    @Test("kDrive drive activities response decodes using Swift API names")
    func kDriveDriveActivitiesResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": [
            {
              "id": 1,
              "created_at": 1710000000,
              "action": "file_rename",
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

        let response = try decoder.decode(InfomaniakResponse<[KDriveDriveActivity]>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.first?.action == "file_rename")
        #expect(response.data.first?.fileId == 42)
        #expect(response.data.first?.newPath == "/new")
    }
}
