import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKDrive

@Suite("kDrive trash count requests")
struct KDriveTrashCountRequestTests {
    @Test("kDrive trash count request matches the OpenAPI path")
    func kDriveTrashCountRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.getTrashCount(driveId: 100)

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/2/drive/100/trash/count")
        #expect(URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems == [])
    }

    @Test("kDrive trash count response decodes using Swift API names")
    func kDriveTrashCountResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": {
            "count": 10,
            "files": 6,
            "directories": 4
          }
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<KDriveTrashCount>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.count == 10)
        #expect(response.data.files == 6)
        #expect(response.data.directories == 4)
    }
}
