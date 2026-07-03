import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKDrive

@Suite("kDrive remove trashed file requests")
struct KDriveRemoveTrashedFileRequestTests {
    @Test("kDrive remove trashed file request matches the OpenAPI method, path, headers, query, and body")
    func requestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.removeTrashedFile(driveId: 100, fileId: 42)

        let urlRequest = try await client.makeURLRequest(for: request)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems ?? []

        #expect(urlRequest.httpMethod == "DELETE")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == nil)
        #expect(urlRequest.url?.path == "/2/drive/100/trash/42")
        #expect(queryItems.isEmpty)
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kDrive remove trashed file response decodes boolean data")
    func responseDecodesBooleanData() throws {
        let data = Data("""
        {
          "result": "success",
          "data": true
        }
        """.utf8)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<Bool>.self, from: data)

        #expect(response.result == "success")
        #expect(response.data == true)
    }
}
