import Foundation
import Testing
@testable import potassiumChannel

@Suite("kDrive file share-link requests")
struct KDriveFileShareLinkRequestTests {
    @Test("kDrive file share-link request matches the OpenAPI path and query")
    func kDriveFileShareLinkRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.getFileShareLink(driveId: 100, fileId: 42, with: "file")

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        let queryItems = components.queryItems ?? []

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == nil)
        #expect(urlRequest.httpBody == nil)
        #expect(url.path == "/2/drive/100/files/42/link")
        #expect(queryItems == [URLQueryItem(name: "with", value: "file")])
    }

    @Test("kDrive file share-link response decodes using Swift API names")
    func kDriveFileShareLinkResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": {
            "url": "https://kdrive.infomaniak.com/app/share/xxxx/link",
            "file_id": 42,
            "right": "public",
            "valid_until": null,
            "created_by": 12,
            "created_at": 1710000000,
            "updated_at": 1710000500,
            "capabilities": {
              "can_edit": false,
              "can_see_stats": true,
              "can_see_info": true,
              "can_download": true,
              "can_comment": false,
              "can_request_access": false
            },
            "access_blocked": false,
            "views": null
          }
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<KDriveShareLink>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.fileId == 42)
        #expect(response.data.right == "public")
        #expect(response.data.validUntil == nil)
        #expect(response.data.capabilities.canDownload == true)
        #expect(response.data.accessBlocked == false)
        #expect(response.data.views == nil)
    }
}
