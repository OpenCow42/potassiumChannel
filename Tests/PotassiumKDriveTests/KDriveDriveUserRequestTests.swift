import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKDrive

@Suite("kDrive drive user requests")
struct KDriveDriveUserRequestTests {
    @Test("kDrive drive users request matches the OpenAPI path and query")
    func kDriveDriveUsersRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.listDriveUsers(driveId: 100, page: 1, perPage: 25)

        let urlRequest = try await client.makeURLRequest(for: request)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems ?? []

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/3/drive/100/users")
        #expect(queryItems.contains(URLQueryItem(name: "page", value: "1")))
        #expect(queryItems.contains(URLQueryItem(name: "per_page", value: "25")))
    }

    @Test("kDrive drive users response decodes using Swift API names")
    func kDriveDriveUsersResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": [
            {
              "id": 1,
              "display_name": "Ada Lovelace",
              "first_name": "Ada",
              "last_name": "Lovelace",
              "email": "ada@example.com",
              "is_sso": false,
              "avatar": null,
              "role": "admin",
              "deleted_at": null
            }
          ],
          "cursor": null,
          "has_more": false,
          "response_at": 1710000000
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<[KDriveDriveUser]>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.first?.displayName == "Ada Lovelace")
        #expect(response.data.first?.email == "ada@example.com")
        #expect(response.data.first?.role == "admin")
    }
}
