import Foundation
import Testing
@testable import potassiumChannel

@Suite("kDrive category rights requests")
struct KDriveCategoryRightsRequestTests {
    @Test("kDrive category rights request matches the OpenAPI path")
    func kDriveCategoryRightsRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.getCategoryRights(driveId: 100)

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/2/drive/100/categories/rights")
        #expect(URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems == [])
    }

    @Test("kDrive category rights response decodes using Swift API names")
    func kDriveCategoryRightsResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": [
            {
              "can_create": true,
              "can_edit": true,
              "can_delete": false,
              "can_read_on_file": true,
              "can_put_on_file": false
            }
          ]
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<[KDriveCategoryRights]>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.first?.canCreate == true)
        #expect(response.data.first?.canDelete == false)
        #expect(response.data.first?.canReadOnFile == true)
    }
}
