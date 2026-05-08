import Foundation
import Testing
@testable import potassiumChannel

@Suite("kDrive file access invitation listing requests")
struct KDriveFileAccessInvitationRequestTests {
    @Test("kDrive file access invitations request matches the OpenAPI path")
    func kDriveFileAccessInvitationsRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.listFileAccessInvitations(driveId: 100, fileId: 42)

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/2/drive/100/files/42/access/invitations")
        #expect(URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems == [])
    }

    @Test("kDrive file access invitations required path parameters are encoded into the URL")
    func kDriveFileAccessInvitationsRequiredParametersAreNotOmitted() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.listFileAccessInvitations(driveId: 123, fileId: 456)

        let urlRequest = try await client.makeURLRequest(for: request)
        let path = try #require(urlRequest.url?.path)

        #expect(path == "/2/drive/123/files/456/access/invitations")
        #expect(!path.contains("{drive_id}"))
        #expect(!path.contains("{file_id}"))
        #expect(urlRequest.url?.pathComponents.contains("123") == true)
        #expect(urlRequest.url?.pathComponents.contains("456") == true)
    }

    @Test("kDrive file access invitations response decodes empty arrays")
    func kDriveFileAccessInvitationsResponseDecodesEmptyArray() throws {
        let json = #"{"result":"success","data":[]}"#.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<[KDriveFileAccessInvitation]>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.isEmpty)
    }

    @Test("kDrive file access invitations response decodes variable invitation payloads")
    func kDriveFileAccessInvitationsResponseDecodesVariablePayloads() throws {
        let json = """
        {
          "result": "success",
          "data": [
            {
              "id": 42,
              "email": "person@example.com",
              "right": "read",
              "created_at": 1710000000,
              "message": null
            }
          ]
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<[KDriveFileAccessInvitation]>.self, from: json)
        let entry = try #require(response.data.first)

        #expect(response.result == "success")
        #expect(entry.values["id"] == .number(42))
        #expect(entry.values["email"] == .string("person@example.com"))
        #expect(entry.values["right"] == .string("read"))
        #expect(entry.values["created_at"] == .number(1710000000))
        #expect(entry.values["message"] == .null)
    }
}
