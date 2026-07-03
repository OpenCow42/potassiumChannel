import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKDrive

@Suite("kDrive file thumbnail requests")
struct KDriveFileThumbnailRequestTests {
    @Test("kDrive file thumbnail request matches the OpenAPI path, query, and headers")
    func kDriveFileThumbnailRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.getFileThumbnail(
            driveId: 100,
            fileId: 42,
            options: GetKDriveFileThumbnailOptions(height: 120, width: 160)
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems ?? []

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "image/*")
        #expect(urlRequest.url?.path == "/2/drive/100/files/42/thumbnail")
        #expect(queryItems.contains(URLQueryItem(name: "height", value: "120")))
        #expect(queryItems.contains(URLQueryItem(name: "width", value: "160")))
    }
}
