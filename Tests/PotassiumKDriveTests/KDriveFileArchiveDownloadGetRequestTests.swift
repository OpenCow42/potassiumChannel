import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKDrive

@Suite("kDrive file-archive-download-get request")
struct KDriveFileArchiveDownloadGetRequestTests {
    @Test("kDrive file-archive-download-get request matches the OpenAPI shape")
    func requestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.downloadArchive(driveId: 100, archiveUUID: "archive-uuid")

        let urlRequest = try await client.makeURLRequest(for: request)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems ?? []

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/zip")
        #expect(urlRequest.url?.path == "/2/drive/100/files/archives/archive-uuid")
        #expect(queryItems.isEmpty)
        #expect(urlRequest.httpBody == nil)
    }
}
