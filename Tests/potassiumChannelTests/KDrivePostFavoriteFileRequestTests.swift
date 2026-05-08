import Foundation
import Testing
@testable import potassiumChannel

@Suite("kDrive post favorite-file request")
struct KDrivePostFavoriteFileRequestTests {
    @Test("kDrive post favorite-file request matches the OpenAPI method, path, headers, query, and body")
    func requestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.favoriteFile(driveId: 100, fileId: 42)

        let urlRequest = try await client.makeURLRequest(for: request)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems ?? []

        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == nil)
        #expect(urlRequest.url?.path == "/2/drive/100/files/42/favorite")
        #expect(queryItems.isEmpty)
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kDrive post favorite-file response decodes boolean success data")
    func responseDecodesBooleanSuccessData() throws {
        let data = Data("""
        {
          "result": "success",
          "data": true
        }
        """.utf8)

        let response = try JSONDecoder().decode(InfomaniakResponse<Bool>.self, from: data)

        #expect(response.result == "success")
        #expect(response.data == true)
    }
}
