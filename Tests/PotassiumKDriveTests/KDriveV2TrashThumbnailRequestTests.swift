import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKDrive

@Suite("kDrive v2 trash thumbnail requests")
struct KDriveV2TrashThumbnailRequestTests {
    @Test("kDrive v2 trash thumbnail request matches the OpenAPI path")
    func kDriveV2TrashThumbnailRequestMatchesOpenAPIPath() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.getV2TrashedItemThumbnail(driveId: 100, fileId: 42)

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "image/*")
        #expect(urlRequest.url?.path == "/2/drive/100/trash/42/thumbnail")
        #expect(urlRequest.url?.query?.isEmpty != false)
    }
}
