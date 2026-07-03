import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKDrive

@Suite("kDrive v2 file version requests")
struct KDriveFileVersionV2RequestTests {
    @Test("kDrive v2 file versions request matches the OpenAPI path and query")
    func kDriveFileVersionsV2RequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.listFileVersionsV2(
            driveId: 100,
            fileId: 42,
            orderBy: "created_at",
            order: "desc",
            orderFor: ["created_at": "desc"]
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems ?? []

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/2/drive/100/files/42/versions")
        #expect(queryItems.contains(URLQueryItem(name: "order_by", value: "created_at")))
        #expect(queryItems.contains(URLQueryItem(name: "order", value: "desc")))
        #expect(queryItems.contains(URLQueryItem(name: "order_for[created_at]", value: "desc")))
    }

    @Test("kDrive v2 file versions required path parameters are not omitted")
    func kDriveFileVersionsV2RequiredParametersAreNotOmitted() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.listFileVersionsV2(driveId: 123, fileId: 456)

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.url?.path == "/2/drive/123/files/456/versions")
        #expect(urlRequest.url?.path.contains("{drive_id}") == false)
        #expect(urlRequest.url?.path.contains("{file_id}") == false)
    }

    @Test("kDrive v2 file versions request omits absent optional query parameters")
    func kDriveFileVersionsV2RequestOmitsAbsentOptionalQueryParameters() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.listFileVersionsV2(driveId: 100, fileId: 42)

        let urlRequest = try await client.makeURLRequest(for: request)

        let query = try #require(urlRequest.url?.query)
        #expect(query.isEmpty)
    }

    @Test("kDrive v2 file versions response decodes using Swift API names")
    func kDriveFileVersionsV2ResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": [
            {
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
          ]
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<[KDriveFileVersionV2]>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.first?.id == 123)
        #expect(response.data.first?.convertedType == "pdf")
        #expect(response.data.first?.name == "document.pdf")
        #expect(response.data.first?.updatedBy.displayName == "Jane Doe")
    }
}
