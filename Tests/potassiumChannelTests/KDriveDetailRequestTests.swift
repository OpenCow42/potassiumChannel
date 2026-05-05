import Foundation
import Testing
@testable import potassiumChannel

@Suite("kDrive detail requests")
struct KDriveDetailRequestTests {
    @Test("kDrive detail request matches the OpenAPI path and query")
    func kDriveDetailRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.getDrive(driveId: 100, with: "account")

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/2/drive/100")

        let url = try #require(urlRequest.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        let queryItems = components.queryItems ?? []
        #expect(queryItems == [URLQueryItem(name: "with", value: "account")])
    }

    @Test("kDrive detail response decodes using Swift API names")
    func kDriveDetailResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": {
            "id": 100,
            "name": "Team Drive",
            "account_id": 42,
            "role": "admin",
            "status": "ok",
            "in_maintenance": false
          }
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<KDrive>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data == KDrive(id: 100, name: "Team Drive", accountId: 42, role: "admin", status: "ok", inMaintenance: false))
    }
}
