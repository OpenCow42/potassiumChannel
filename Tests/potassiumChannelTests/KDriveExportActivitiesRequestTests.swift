import Foundation
import Testing
@testable import potassiumChannel

@Suite("kDrive export activities requests")
struct KDriveExportActivitiesRequestTests {
    @Test("kDrive export activities request matches the OpenAPI path, CSV accept header, and required query parameters")
    func kDriveExportActivitiesRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.exportActivities(
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
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "text/csv")
        #expect(components.path == "/2/drive/100/statistics/activities/export")
        _ = try #require(queryItems.first { $0 == URLQueryItem(name: "from", value: "1700000000") }, "Required from query parameter is missing")
        _ = try #require(queryItems.first { $0 == URLQueryItem(name: "interval", value: "24") }, "Required interval query parameter is missing")
        _ = try #require(queryItems.first { $0 == URLQueryItem(name: "metric", value: "users") }, "Required metric query parameter is missing")
        _ = try #require(queryItems.first { $0 == URLQueryItem(name: "until", value: "1700086400") }, "Required until query parameter is missing")
    }
}
