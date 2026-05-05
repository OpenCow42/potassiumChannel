import Foundation
import Testing
@testable import potassiumChannel

@Suite("kDrive user invitation requests")
struct KDriveUserInvitationRequestTests {
    @Test("kDrive user invitations request matches the OpenAPI path and query")
    func kDriveUserInvitationsRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.listUserInvitations(driveId: 100, page: 1, perPage: 25)

        let urlRequest = try await client.makeURLRequest(for: request)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems ?? []

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/2/drive/100/users/invitation")
        #expect(queryItems.contains(URLQueryItem(name: "page", value: "1")))
        #expect(queryItems.contains(URLQueryItem(name: "per_page", value: "25")))
    }

    @Test("kDrive user invitations response decodes using Swift API names")
    func kDriveUserInvitationsResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": [
            {
              "id": 1,
              "type": "share",
              "is_private": true,
              "key": "redacted",
              "file_id": 42,
              "lang": "fr",
              "user_id": null,
              "invited_by": 10,
              "url": "https://example.com/invitation",
              "is_valid": true,
              "status": "waiting",
              "email": "invitee@example.com",
              "message": "Welcome",
              "expired_at": 1710003600,
              "created_at": 1710000000,
              "access_name": "Shared folder",
              "role": "user"
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

        let response = try decoder.decode(PaginatedInfomaniakResponse<[KDriveUserInvitation]>.self, from: json)

        #expect(response.result == "success")
        #expect(response.total == 1)
        #expect(response.data.first?.email == "invitee@example.com")
        #expect(response.data.first?.status == "waiting")
        #expect(response.data.first?.isValid == true)
    }
}
