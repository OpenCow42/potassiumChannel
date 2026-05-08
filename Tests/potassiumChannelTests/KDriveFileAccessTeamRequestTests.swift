import Foundation
import Testing
@testable import potassiumChannel

@Suite("kDrive file access team listing requests")
struct KDriveFileAccessTeamRequestTests {
    @Test("kDrive file access teams request matches the OpenAPI path")
    func kDriveFileAccessTeamsRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.listFileAccessTeams(driveId: 100, fileId: 42)

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/2/drive/100/files/42/access/teams")
        #expect(URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems == [])
    }

    @Test("kDrive file access teams required path parameters are encoded into the URL")
    func kDriveFileAccessTeamsRequiredParametersAreNotOmitted() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.listFileAccessTeams(driveId: 123, fileId: 456)

        let urlRequest = try await client.makeURLRequest(for: request)
        let path = try #require(urlRequest.url?.path)

        #expect(path == "/2/drive/123/files/456/access/teams")
        #expect(!path.contains("{drive_id}"))
        #expect(!path.contains("{file_id}"))
        #expect(urlRequest.url?.pathComponents.contains("123") == true)
        #expect(urlRequest.url?.pathComponents.contains("456") == true)
    }

    @Test("kDrive file access teams response decodes empty arrays")
    func kDriveFileAccessTeamsResponseDecodesEmptyArray() throws {
        let json = #"{"result":"success","data":[]}"#.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<[KDriveFileAccessTeam]>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.isEmpty)
    }

    @Test("kDrive file access teams response decodes variable team payloads")
    func kDriveFileAccessTeamsResponseDecodesVariablePayloads() throws {
        let json = """
        {
          "result": "success",
          "data": [
            {
              "id": 42,
              "name": "Engineering",
              "right": "read",
              "users_count": 7,
              "is_default": false,
              "description": null
            }
          ]
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<[KDriveFileAccessTeam]>.self, from: json)
        let entry = try #require(response.data.first)

        #expect(response.result == "success")
        #expect(entry.values["id"] == .number(42))
        #expect(entry.values["name"] == .string("Engineering"))
        #expect(entry.values["right"] == .string("read"))
        #expect(entry.values["users_count"] == .number(7))
        #expect(entry.values["is_default"] == .bool(false))
        #expect(entry.values["description"] == .null)
    }
}
