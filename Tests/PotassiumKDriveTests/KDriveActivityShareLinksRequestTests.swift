import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKDrive

@Suite("kDrive activity share links requests")
struct KDriveActivityShareLinksRequestTests {
    @Test("kDrive activity share links request matches the OpenAPI path and required query parameters")
    func kDriveActivityShareLinksRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.listActivityShareLinks(
            driveId: 100,
            from: 1_700_000_000,
            until: 1_700_086_400,
            options: ListKDriveActivityShareLinksOptions(
                includedResources: "file",
                maxView: 20,
                minView: 2,
                rights: ["password", "public"],
                search: "Roadmap.pdf",
                validUntil: 1_700_172_800,
                page: 2,
                perPage: 50,
                total: true,
                orderBy: ["views"],
                order: "desc",
                orderFor: ["unique_views": "asc"]
            )
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        let queryItems = try #require(components.queryItems, "Required query parameters are missing")

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(components.path == "/2/drive/100/statistics/activities/links")
        _ = try #require(queryItems.first { $0 == URLQueryItem(name: "from", value: "1700000000") }, "Required from query parameter is missing")
        _ = try #require(queryItems.first { $0 == URLQueryItem(name: "until", value: "1700086400") }, "Required until query parameter is missing")
        _ = try #require(queryItems.first { $0 == URLQueryItem(name: "with", value: "file") })
        _ = try #require(queryItems.first { $0 == URLQueryItem(name: "max_view", value: "20") })
        _ = try #require(queryItems.first { $0 == URLQueryItem(name: "min_view", value: "2") })
        _ = try #require(queryItems.first { $0 == URLQueryItem(name: "rights[]", value: "password") })
        _ = try #require(queryItems.first { $0 == URLQueryItem(name: "rights[]", value: "public") })
        _ = try #require(queryItems.first { $0 == URLQueryItem(name: "search", value: "Roadmap.pdf") })
        _ = try #require(queryItems.first { $0 == URLQueryItem(name: "valid_until", value: "1700172800") })
        _ = try #require(queryItems.first { $0 == URLQueryItem(name: "page", value: "2") })
        _ = try #require(queryItems.first { $0 == URLQueryItem(name: "per_page", value: "50") })
        _ = try #require(queryItems.first { $0 == URLQueryItem(name: "total", value: "true") })
        _ = try #require(queryItems.first { $0 == URLQueryItem(name: "order_by", value: "views") })
        _ = try #require(queryItems.first { $0 == URLQueryItem(name: "order", value: "desc") })
        _ = try #require(queryItems.first { $0 == URLQueryItem(name: "order_for[unique_views]", value: "asc") })
    }

    @Test("kDrive activity share links response decodes share links and pagination")
    func kDriveActivityShareLinksResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": [
            {
              "url": "https://kdrive.infomaniak.com/app/share/xxxx/link",
              "file_id": 123,
              "right": "public",
              "valid_until": null,
              "created_by": 42,
              "created_at": 1700000000,
              "updated_at": 1700000100,
              "capabilities": {
                "can_edit": false,
                "can_see_stats": true,
                "can_see_info": true,
                "can_download": true,
                "can_comment": false,
                "can_request_access": false
              },
              "access_blocked": false,
              "views": 12,
              "file": {
                "id": 123,
                "name": "Roadmap.pdf",
                "type": "file",
                "status": "ok",
                "visibility": "",
                "drive_id": 100,
                "parent_id": 1,
                "path": "/Roadmap.pdf",
                "depth": 1,
                "created_at": 1700000000,
                "last_modified_at": 1700000000,
                "updated_at": 1700000100,
                "size": 2048,
                "mime_type": "application/pdf"
              },
              "unique_views": 7
            }
          ],
          "page": 1,
          "pages": 1,
          "items_per_page": 10,
          "total": 1
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(PaginatedInfomaniakResponse<[KDriveStatisticShareLink]>.self, from: json)
        let link = try #require(response.data.first)

        #expect(response.result == "success")
        #expect(response.total == 1)
        #expect(link.fileId == 123)
        #expect(link.right == "public")
        #expect(link.validUntil == nil)
        #expect(link.createdBy == 42)
        #expect(link.capabilities.canSeeStats == true)
        #expect(link.accessBlocked == false)
        #expect(link.views == 12)
        #expect(link.uniqueViews == 7)
        #expect(link.file?.name == "Roadmap.pdf")
    }
}
