import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKDrive

@Suite("kDrive file preview requests")
struct KDriveFilePreviewRequestTests {
    @Test("kDrive file preview request matches the OpenAPI path, query, and headers")
    func kDriveFilePreviewRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.getFilePreview(
            driveId: 100,
            fileId: 42,
            options: GetKDriveFilePreviewOptions(
                conversionFormat: "jpg",
                height: 120,
                quality: 80,
                width: 160,
                password: "static-test-password"
            )
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems ?? []

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "image/*")
        #expect(urlRequest.value(forHTTPHeaderField: "x-kdrive-file-password") == "static-test-password")
        #expect(urlRequest.url?.path == "/2/drive/100/files/42/preview")
        #expect(queryItems.contains(URLQueryItem(name: "as", value: "jpg")))
        #expect(queryItems.contains(URLQueryItem(name: "height", value: "120")))
        #expect(queryItems.contains(URLQueryItem(name: "quality", value: "80")))
        #expect(queryItems.contains(URLQueryItem(name: "width", value: "160")))
    }
}
