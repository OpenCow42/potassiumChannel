import Foundation
import Testing
@testable import potassiumChannel

@Suite("kDrive drive activity total requests")
struct KDriveDriveActivityTotalRequestTests {
    @Test("kDrive drive activity totals request matches the OpenAPI path")
    func kDriveDriveActivityTotalsRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.listDriveActivityTotals(driveId: 100)

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/3/drive/100/activities/total")
        #expect(urlRequest.url?.query?.isEmpty != false)
    }

    @Test("kDrive drive activity totals response decodes using Swift API names")
    func kDriveDriveActivityTotalsResponseDecodes() throws {
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
          ]
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<[KDriveDriveActivity]>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.first?.action == "file_rename")
        #expect(response.data.first?.fileId == 42)
        #expect(response.data.first?.createdAt == 1710000000)
    }
}
