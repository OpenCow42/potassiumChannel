import Foundation
import Testing
@testable import potassiumChannel

@Suite("kDrive export file sizes requests")
struct KDriveExportFileSizesRequestTests {
    @Test("kDrive export file sizes request matches the OpenAPI path, CSV accept header, and required query parameters")
    func kDriveExportFileSizesRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.exportFileSizes(
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
        let metrics = queryItems.filter { $0.name == "metrics" }.map(\.value)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "text/csv")
        #expect(components.path == "/2/drive/100/statistics/sizes/export")
        _ = try #require(queryItems.first { $0 == URLQueryItem(name: "from", value: "1700000000") }, "Required from query parameter is missing")
        _ = try #require(queryItems.first { $0 == URLQueryItem(name: "interval", value: "24") }, "Required interval query parameter is missing")
        #expect(metrics == ["files", "trash", "versions"])
        _ = try #require(queryItems.first { $0 == URLQueryItem(name: "until", value: "1700086400") }, "Required until query parameter is missing")
    }
}
