import Foundation
import Testing
@testable import potassiumChannel

@Suite("kDrive file download requests")
struct KDriveFileDownloadRequestTests {
    @Test("kDrive file download request matches the OpenAPI path, query, and headers")
    func kDriveFileDownloadRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.downloadFile(
            driveId: 100,
            fileId: 42,
            options: DownloadKDriveFileOptions(conversionFormat: "pdf", password: "secret-password")
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems ?? []

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/octet-stream")
        #expect(urlRequest.value(forHTTPHeaderField: "x-kdrive-file-password") == "secret-password")
        #expect(urlRequest.url?.path == "/2/drive/100/files/42/download")
        #expect(queryItems.contains(URLQueryItem(name: "as", value: "pdf")))
    }
}
