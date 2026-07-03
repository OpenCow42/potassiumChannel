import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKDrive

@Suite("kDrive chart file sizes requests")
struct KDriveChartFileSizesRequestTests {
    @Test("kDrive chart file sizes request matches the OpenAPI path and required query parameters")
    func kDriveChartFileSizesRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.chartFileSizes(
            driveId: 100,
            from: 1_700_000_000,
            interval: 24,
            metrics: ["files", "trash", "versions"],
            until: 1_700_086_400
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        let queryItems = try #require(components.queryItems, "Required query parameters are missing")

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(components.path == "/2/drive/100/statistics/sizes")
        #expect(queryItems.contains(URLQueryItem(name: "from", value: "1700000000")))
        #expect(queryItems.contains(URLQueryItem(name: "interval", value: "24")))
        #expect(queryItems.contains(URLQueryItem(name: "metrics", value: "files")))
        #expect(queryItems.contains(URLQueryItem(name: "metrics", value: "trash")))
        #expect(queryItems.contains(URLQueryItem(name: "metrics", value: "versions")))
        #expect(queryItems.contains(URLQueryItem(name: "until", value: "1700086400")))
    }

    @Test("kDrive chart file sizes response decodes chart data")
    func kDriveChartFileSizesResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": {
            "title": "File sizes",
            "labels": {
              "name": "date",
              "unit": "timestamp",
              "data": [1700000000, 1700086400]
            },
            "data": [
              {
                "name": "Files",
                "unit": "bytes",
                "metric": "files",
                "data": [10, 20]
              },
              {
                "name": "Trash",
                "unit": "bytes",
                "metric": "trash",
                "data": ["0", "1"]
              }
            ]
          }
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<KDriveChart>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.title == "File sizes")
        #expect(response.data.labels.data == .array([.integer(1_700_000_000), .integer(1_700_086_400)]))
        #expect(response.data.data.map(\.metric) == ["files", "trash"])
        #expect(response.data.data[1].data == .array([.string("0"), .string("1")]))
    }
}
