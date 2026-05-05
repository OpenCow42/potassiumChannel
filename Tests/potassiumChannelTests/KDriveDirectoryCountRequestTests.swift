import Foundation
import Testing
@testable import potassiumChannel

@Suite("kDrive directory count requests")
struct KDriveDirectoryCountRequestTests {
    @Test("kDrive directory count request matches the OpenAPI path")
    func kDriveDirectoryCountRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.getDirectoryCount(driveId: 100, fileId: 1)

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/3/drive/100/files/1/count")
        #expect(URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems == [])
    }

    @Test("kDrive directory count request encodes depth")
    func kDriveDirectoryCountRequestEncodesDepth() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.getDirectoryCount(driveId: 100, fileId: 1, depth: "unlimited")

        let urlRequest = try await client.makeURLRequest(for: request)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems

        #expect(queryItems == [URLQueryItem(name: "depth", value: "unlimited")])
    }

    @Test("kDrive directory count response decodes using Swift API names")
    func kDriveDirectoryCountResponseDecodes() throws {
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

        let response = try decoder.decode(InfomaniakResponse<KDriveDirectoryCount>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.count == 10)
        #expect(response.data.files == 6)
        #expect(response.data.directories == 4)
    }
}
