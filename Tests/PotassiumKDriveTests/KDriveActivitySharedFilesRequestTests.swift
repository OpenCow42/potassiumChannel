import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKDrive

@Suite("kDrive activity shared files requests")
struct KDriveActivitySharedFilesRequestTests {
    @Test("kDrive activity shared files request matches the OpenAPI path and required query parameters")
    func kDriveActivitySharedFilesRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.listActivitySharedFiles(
            driveId: 100,
            from: 1_700_000_000,
            until: 1_700_086_400
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        let queryItems = try #require(components.queryItems, "Required query parameters are missing")

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(components.path == "/2/drive/100/statistics/activities/shared_files")
        _ = try #require(queryItems.first { $0 == URLQueryItem(name: "from", value: "1700000000") }, "Required from query parameter is missing")
        _ = try #require(queryItems.first { $0 == URLQueryItem(name: "until", value: "1700086400") }, "Required until query parameter is missing")
    }

    @Test("kDrive activity shared files response decodes shared files")
    func kDriveActivitySharedFilesResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": [
            {
              "id": 123,
              "name": "Roadmap.pdf",
              "update_at": 1700000000,
              "users": 5
            }
          ]
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<[KDriveSharedFileActivity]>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.first?.id == 123)
        #expect(response.data.first?.name == "Roadmap.pdf")
        #expect(response.data.first?.updateAt == 1_700_000_000)
        #expect(response.data.first?.users == 5)
    }
}
