import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKDrive

@Suite("kDrive v2 single drive user requests")
struct KDriveDriveUserV2RequestTests {
    @Test("v2 single drive user request matches the OpenAPI path")
    func v2SingleDriveUserRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.getDriveUserV2(driveId: 100, userId: 42)

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/2/drive/100/users/42")
        #expect(urlRequest.url?.query?.isEmpty ?? true)
    }

    @Test("v2 single drive user response decodes user data")
    func v2SingleDriveUserResponseDecodesUserData() throws {
        let json = """
        {
          "result": "success",
          "data": {
            "id": 42,
            "display_name": "Alice Example",
            "first_name": "Alice",
            "last_name": "Example",
            "email": "alice@example.com",
            "is_sso": false,
            "avatar": null,
            "role": "admin",
            "deleted_at": null
          }
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<KDriveDriveUser?>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data == KDriveDriveUser(
            id: 42,
            displayName: "Alice Example",
            firstName: "Alice",
            lastName: "Example",
            email: "alice@example.com",
            isSso: false,
            role: "admin"
        ))
    }

    @Test("v2 single drive user response decodes empty data")
    func v2SingleDriveUserResponseDecodesEmptyData() throws {
        let json = """
        {
          "result": "success",
          "data": null
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<KDriveDriveUser?>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data == nil)
    }
}
