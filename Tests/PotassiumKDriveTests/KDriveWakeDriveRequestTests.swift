import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKDrive

@Suite("kDrive wake-drive request")
struct KDriveWakeDriveRequestTests {
    @Test("kDrive wake-drive request matches the OpenAPI path and headers")
    func requestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.wakeDrive(driveId: 100)

        let urlRequest = try await client.makeURLRequest(for: request)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems ?? []

        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == nil)
        #expect(urlRequest.url?.path == "/3/drive/100/wake")
        #expect(queryItems.isEmpty)
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kDrive wake-drive response decodes boolean data")
    func responseDecodesBooleanData() throws {
        let data = Data(#"{"result":"success","data":true}"#.utf8)

        let response = try JSONDecoder().decode(InfomaniakResponse<Bool>.self, from: data)

        #expect(response.result == "success")
        #expect(response.data == true)
    }
}
