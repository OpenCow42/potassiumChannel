import Foundation
import Testing
@testable import potassiumChannel

@Suite("kDrive file-copy-to-drive-post request")
struct KDriveFileCopyToDrivePostRequestTests {
    @Test("kDrive file-copy-to-drive-post request matches the OpenAPI shape")
    func requestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let body = CopyKDriveFileToDriveBody(sourceDriveId: 200, sourceFileId: 99)
        let request = KDriveRequests.copyFileToDriveV2(driveId: 100, fileId: 42, body: body)

        let urlRequest = try await client.makeURLRequest(for: request)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems ?? []

        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(urlRequest.url?.path == "/2/drive/100/files/42/copy-to-drive")
        #expect(queryItems.isEmpty)
        #expect(urlRequest.httpBody == Data(#"{"source_drive_id":200,"source_file_id":99}"#.utf8))
    }

    @Test("kDrive file-copy-to-drive-post response decodes external imports")
    func responseDecodesExternalImports() throws {
        let json = """
        {
          "result": "success",
          "data": [
            {
              "id": 1,
              "application": "kdrive",
              "account_name": "Source kDrive",
              "status": "waiting",
              "error_code": null,
              "path": "/Copies",
              "directory_id": 42,
              "has_shared_files": "false",
              "created_at": 1710000000,
              "updated_at": 1710000100,
              "count_success_files": 0,
              "count_failed_files": 0
            }
          ]
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<[KDriveExternalImport]>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.first?.application == "kdrive")
        #expect(response.data.first?.status == "waiting")
        #expect(response.data.first?.directoryId == 42)
    }
}
