import Foundation
import Testing
@testable import potassiumChannel

@Suite("kDrive trashed item count requests")
struct KDriveTrashedItemCountRequestTests {
    @Test("kDrive trashed item count request matches the OpenAPI path")
    func kDriveTrashedItemCountRequestMatchesOpenAPIPath() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.getTrashedItemCount(driveId: 100, fileId: 42, depth: "unlimited")

        let urlRequest = try await client.makeURLRequest(for: request)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems ?? []

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/3/drive/100/trash/42/count")
        #expect(queryItems.contains(URLQueryItem(name: "depth", value: "unlimited")))
    }

    @Test("kDrive trashed item count response decodes using Swift API names")
    func kDriveTrashedItemCountResponseDecodes() throws {
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

        let response = try decoder.decode(InfomaniakResponse<KDriveTrashedItemCount>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.count == 3)
        #expect(response.data.files == 2)
        #expect(response.data.directories == 1)
    }
}
