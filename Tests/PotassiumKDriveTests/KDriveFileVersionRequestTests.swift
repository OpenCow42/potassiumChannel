import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKDrive

@Suite("kDrive file version requests")
struct KDriveFileVersionRequestTests {
    @Test("kDrive file versions request matches the OpenAPI path and query")
    func kDriveFileVersionsRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.listFileVersions(
            driveId: 100,
            fileId: 42,
            page: 1,
            perPage: 25,
            total: true,
            orderBy: "created_at",
            order: "desc",
            orderFor: ["created_at": "desc"]
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems ?? []

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/3/drive/100/files/42/versions")
        #expect(queryItems.contains(URLQueryItem(name: "page", value: "1")))
        #expect(queryItems.contains(URLQueryItem(name: "per_page", value: "25")))
        #expect(queryItems.contains(URLQueryItem(name: "total", value: "true")))
        #expect(queryItems.contains(URLQueryItem(name: "order_by", value: "created_at")))
        #expect(queryItems.contains(URLQueryItem(name: "order", value: "desc")))
        #expect(queryItems.contains(URLQueryItem(name: "order_for[created_at]", value: "desc")))
    }

    @Test("kDrive file versions response decodes using Swift API names")
    func kDriveFileVersionsResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": [
            {
              "id": 123,
              "keep_forever": false,
              "mime_type": "application/pdf",
              "extension_type": "pdf",
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
          ],
          "total": 1,
          "page": 1,
          "pages": 1,
          "items_per_page": 25
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(PaginatedInfomaniakResponse<[KDriveFileVersion]>.self, from: json)

        #expect(response.result == "success")
        #expect(response.total == 1)
        #expect(response.data.first?.id == 123)
        #expect(response.data.first?.extensionType == "pdf")
        #expect(response.data.first?.updatedBy.displayName == "Jane Doe")
    }
}
