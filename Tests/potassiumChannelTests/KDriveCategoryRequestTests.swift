import Foundation
import Testing
@testable import potassiumChannel

@Suite("kDrive category requests")
struct KDriveCategoryRequestTests {
    @Test("kDrive categories request matches the OpenAPI path")
    func kDriveCategoriesRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.listCategories(driveId: 100)

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/2/drive/100/categories")
        #expect(URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems == [])
    }

    @Test("kDrive categories response decodes using Swift API names")
    func kDriveCategoriesResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": [
            {
              "id": 1,
              "name": "Important",
              "color": "#FF1493",
              "is_predefined": false,
              "created_by": 10,
              "created_at": 1710000000,
              "user_uses": 2
            }
          ]
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<[KDriveCategory]>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.first?.name == "Important")
        #expect(response.data.first?.isPredefined == false)
        #expect(response.data.first?.userUses == 2)
    }
}
