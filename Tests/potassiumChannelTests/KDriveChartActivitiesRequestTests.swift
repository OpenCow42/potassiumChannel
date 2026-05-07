import Foundation
import Testing
@testable import potassiumChannel

@Suite("kDrive chart activities requests")
struct KDriveChartActivitiesRequestTests {
    @Test("kDrive chart activities request matches the OpenAPI path and required query parameters")
    func kDriveChartActivitiesRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.chartActivities(
            driveId: 100,
            from: 1_700_000_000,
            interval: 24,
            metric: "users",
            until: 1_700_086_400
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        let queryItems = try #require(components.queryItems, "Required query parameters are missing")

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(components.path == "/2/drive/100/statistics/activities")
        _ = try #require(queryItems.first { $0 == URLQueryItem(name: "from", value: "1700000000") }, "Required from query parameter is missing")
        _ = try #require(queryItems.first { $0 == URLQueryItem(name: "interval", value: "24") }, "Required interval query parameter is missing")
        _ = try #require(queryItems.first { $0 == URLQueryItem(name: "metric", value: "users") }, "Required metric query parameter is missing")
        _ = try #require(queryItems.first { $0 == URLQueryItem(name: "until", value: "1700086400") }, "Required until query parameter is missing")
    }

    @Test("kDrive chart activities response decodes chart data")
    func kDriveChartActivitiesResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": {
            "title": "Activities",
            "labels": {
              "name": "date",
              "unit": "timestamp",
              "data": [1700000000, 1700086400]
            },
            "data": [
              {
                "name": "Users",
                "unit": "count",
                "metric": "users",
                "data": [1, 2]
              }
            ]
          }
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<KDriveChart>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.title == "Activities")
        #expect(response.data.labels.data == .array([.integer(1_700_000_000), .integer(1_700_086_400)]))
        #expect(response.data.data.map(\.metric) == ["users"])
        #expect(response.data.data.first?.data == .array([.integer(1), .integer(2)]))
    }
}
