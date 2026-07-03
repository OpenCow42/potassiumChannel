import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKDrive

@Suite("kDrive activity users requests")
struct KDriveActivityUsersRequestTests {
    @Test("kDrive activity users request matches the OpenAPI path and required query parameters")
    func kDriveActivityUsersRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.listActivityUsers(
            driveId: 100,
            from: 1_700_000_000,
            until: 1_700_086_400
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        let queryItems = try #require(components.queryItems, "Required query parameters are missing")

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(components.path == "/2/drive/100/statistics/activities/users")
        _ = try #require(queryItems.first { $0 == URLQueryItem(name: "from", value: "1700000000") }, "Required from query parameter is missing")
        _ = try #require(queryItems.first { $0 == URLQueryItem(name: "until", value: "1700086400") }, "Required until query parameter is missing")
    }

    @Test("kDrive activity users response decodes active members")
    func kDriveActivityUsersResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": [
            {
              "user_id": 42,
              "name": "Ada Lovelace",
              "agent": "Mozilla/5.0",
              "ip": "192.0.2.10",
              "last_login_at": 1700000000
            },
            {
              "user_id": null,
              "name": null,
              "agent": "curl/8.0",
              "ip": "198.51.100.4",
              "last_login_at": 1700086400
            }
          ]
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<[KDriveActiveMember]>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.first?.userId == 42)
        #expect(response.data.first?.name == "Ada Lovelace")
        #expect(response.data.first?.agent == "Mozilla/5.0")
        #expect(response.data.first?.ip == "192.0.2.10")
        #expect(response.data.first?.lastLoginAt == 1_700_000_000)
        #expect(response.data.last?.userId == nil)
        #expect(response.data.last?.name == nil)
    }
}
