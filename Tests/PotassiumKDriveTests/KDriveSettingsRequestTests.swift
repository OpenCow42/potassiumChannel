import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKDrive

@Suite("kDrive settings requests")
struct KDriveSettingsRequestTests {
    @Test("kDrive settings request matches the OpenAPI path")
    func kDriveSettingsRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.getDriveSettings(driveId: 100)

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/2/drive/100/settings")
        #expect(URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems == [])
    }

    @Test("kDrive settings response decodes using Swift API names")
    func kDriveSettingsResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": {
            "ai_scan": {
              "has_approved": true,
              "has_approved_ai_categories": false,
              "has_approved_content_search": true,
              "updated_at": null
            },
            "shared_link": {
              "activate": true,
              "txtColor": "#ffffff",
              "bgColor": "#000000",
              "images": []
            },
            "trash": { "max_duration": 30 },
            "office": {
              "presentation": "onlyoffice",
              "form": "onlyoffice",
              "spreadsheet": "onlyoffice",
              "text": "onlyoffice",
              "default_mode": null
            },
            "versioning": { "max_numbers": 10, "max_days": 90 },
            "max_keep_deleted_user": "P30D"
          }
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<KDriveSettings>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.trash.maxDuration == 30)
        #expect(response.data.versioning.maxNumbers == 10)
        #expect(response.data.sharedLink.bgColor == "#000000")
    }
}
