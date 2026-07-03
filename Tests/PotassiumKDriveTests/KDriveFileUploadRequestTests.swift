import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKDrive

@Suite("kDrive file upload requests")
struct KDriveFileUploadRequestTests {
    @Test("kDrive file upload request matches the OpenAPI path, query, headers, and body")
    func kDriveFileUploadRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let data = Data("hello".utf8)
        let request = KDriveRequests.uploadFile(
            driveId: 100,
            data: data,
            options: UploadKDriveFileOptions(
                with: "capabilities",
                ifMatch: "9e22d98e554fe8df",
                clientToken: "29a46444-cdd4-42ad-88af-be63e06403bc",
                conflict: "rename",
                createdAt: 1_700_000_000,
                directoryId: 123,
                directoryPath: "/Uploads",
                fileName: "hello.txt",
                lastModifiedAt: 1_700_000_001,
                symbolicLink: nil,
                totalChunkHash: "sha256:abcd"
            )
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems ?? []

        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/octet-stream")
        #expect(urlRequest.value(forHTTPHeaderField: "If-Match") == "9e22d98e554fe8df")
        #expect(urlRequest.url?.path == "/3/drive/100/upload")
        #expect(urlRequest.httpBody == data)
        #expect(queryItems.contains(URLQueryItem(name: "total_size", value: "5")))
        #expect(queryItems.contains(URLQueryItem(name: "with", value: "capabilities")))
        #expect(queryItems.contains(URLQueryItem(name: "client_token", value: "29a46444-cdd4-42ad-88af-be63e06403bc")))
        #expect(queryItems.contains(URLQueryItem(name: "conflict", value: "rename")))
        #expect(queryItems.contains(URLQueryItem(name: "created_at", value: "1700000000")))
        #expect(queryItems.contains(URLQueryItem(name: "directory_id", value: "123")))
        #expect(queryItems.contains(URLQueryItem(name: "directory_path", value: "/Uploads")))
        #expect(queryItems.contains(URLQueryItem(name: "file_name", value: "hello.txt")))
        #expect(queryItems.contains(URLQueryItem(name: "last_modified_at", value: "1700000001")))
        #expect(queryItems.contains(URLQueryItem(name: "total_chunk_hash", value: "sha256:abcd")))
    }
}
