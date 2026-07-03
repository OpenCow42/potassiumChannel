import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKDrive

@Suite("kDrive file-copy-post request")
struct KDriveFileCopyPostRequestTests {
    @Test("kDrive file-copy-post request matches the OpenAPI shape")
    func requestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.copyFileToDirectoryV3(driveId: 100, fileId: 42, destinationDirectoryId: 1, with: "capabilities", body: Data(#"{\"name\":\"Copy.txt\",\"conflict\":\"rename\"}"#.utf8))

        let urlRequest = try await client.makeURLRequest(for: request)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems ?? []

        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/3/drive/100/files/42/copy/1")
        #expect(queryItems.contains(URLQueryItem(name: "with", value: "capabilities")))
        #expect(urlRequest.httpBody == request.body)
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
    }
}
