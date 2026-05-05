import Foundation
import Testing
@testable import potassiumChannel

@Suite("kDrive v2 trashed item count requests")
struct KDriveV2TrashedItemCountRequestTests {
    @Test("kDrive v2 trashed item count request matches the OpenAPI path")
    func kDriveV2TrashedItemCountRequestMatchesOpenAPIPath() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.getV2TrashedItemCount(driveId: 100, fileId: 42)

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/2/drive/100/trash/42/count")
        #expect(urlRequest.url?.query?.isEmpty != false)
    }

    @Test("kDrive v2 trashed item count response decodes using Swift API names")
    func kDriveV2TrashedItemCountResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": {
            "count": 3,
            "files": 2,
            "directories": 1
          }
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<KDriveV2TrashedItemCount>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.count == 3)
        #expect(response.data.files == 2)
        #expect(response.data.directories == 1)
    }
}
