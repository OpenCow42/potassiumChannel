import Foundation
import Testing
@testable import potassiumChannel

@Suite("kDrive v2 file version detail requests")
struct KDriveFileVersionV2DetailRequestTests {
    @Test("kDrive v2 file version detail request matches the OpenAPI path")
    func kDriveFileVersionV2DetailRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.getFileVersionV2(driveId: 100, fileId: 42, versionId: 123)

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/2/drive/100/files/42/versions/123")
        #expect(urlRequest.url?.query?.isEmpty == true)
    }

    @Test("kDrive v2 file version detail required path parameters are not omitted")
    func kDriveFileVersionV2DetailRequiredParametersAreNotOmitted() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.getFileVersionV2(driveId: 123, fileId: 456, versionId: 789)

        let urlRequest = try await client.makeURLRequest(for: request)
        let path = try #require(urlRequest.url?.path)

        #expect(path == "/2/drive/123/files/456/versions/789")
        #expect(path.contains("{drive_id}") == false)
        #expect(path.contains("{file_id}") == false)
        #expect(path.contains("{version_id}") == false)
    }

    @Test("kDrive v2 file version detail response decodes using Swift API names")
    func kDriveFileVersionV2DetailResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": {
            "id": 123,
            "keep_forever": false,
            "mime_type": "application/pdf",
            "converted_type": "pdf",
            "name": "document.pdf",
            "size": 2048,
            "updated_by": {
              "id": 10,
              "display_name": "Jane Doe",
              "first_name": "Jane",
              "last_name": "Doe",
              "email": "jane@example.com",
              "is_sso": false,
              "avatar": null,
              "deleted_at": null
            },
            "created_at": 1710000000,
            "updated_at": 1710000100,
            "last_modified_at": 1710000200
          }
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<KDriveFileVersionV2>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.id == 123)
        #expect(response.data.convertedType == "pdf")
        #expect(response.data.name == "document.pdf")
        #expect(response.data.updatedBy.displayName == "Jane Doe")
    }
}
