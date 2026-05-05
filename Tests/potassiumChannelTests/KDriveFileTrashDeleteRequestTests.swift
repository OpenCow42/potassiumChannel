import Foundation
import Testing
@testable import potassiumChannel

@Suite("kDrive file-trash-delete request")
struct KDriveFileTrashDeleteRequestTests {
    @Test("kDrive file-trash-delete request matches the OpenAPI method, path, headers, query, and body")
    func requestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.trashFileV2(driveId: 100, fileId: 42)

        let urlRequest = try await client.makeURLRequest(for: request)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems ?? []

        #expect(urlRequest.httpMethod == "DELETE")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == nil)
        #expect(urlRequest.url?.path == "/2/drive/100/files/42")
        #expect(queryItems.isEmpty)
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kDrive file-trash-delete response decodes cancellation resource")
    func responseDecodesCancellationResource() throws {
        let data = Data("""
        {
          "result": "success",
          "data": {
            "cancel_id": "00000000-e89b-12d3-a456-000000000000",
            "valid_until": 1710000000
          }
        }
        """.utf8)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<KDriveCancelResource>.self, from: data)

        #expect(response.result == "success")
        #expect(response.data.cancelId == "00000000-e89b-12d3-a456-000000000000")
        #expect(response.data.validUntil == 1710000000)
    }
}
