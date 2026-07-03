import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKDrive

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

    @Test("kDrive drive activity totals response decodes count")
    func kDriveDriveActivityTotalsResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": 115
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<Int>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data == 115)
    }
}
