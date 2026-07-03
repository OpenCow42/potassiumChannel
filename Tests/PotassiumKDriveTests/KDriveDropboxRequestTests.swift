import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKDrive

@Suite("kDrive dropbox requests")
struct KDriveDropboxRequestTests {
    @Test("kDrive dropboxes request matches the OpenAPI path and query")
    func kDriveDropboxesRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.listDropboxes(driveId: 100, cursor: "next", limit: 25)

        let urlRequest = try await client.makeURLRequest(for: request)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems ?? []

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/3/drive/100/files/dropboxes")
        #expect(queryItems.contains(URLQueryItem(name: "cursor", value: "next")))
        #expect(queryItems.contains(URLQueryItem(name: "limit", value: "25")))
    }

    @Test("kDrive create dropbox request matches the OpenAPI method, path, and body")
    func kDriveCreateDropboxRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = try KDriveRequests.createDropbox(
            driveId: 100,
            options: CreateKDriveDropboxOptions(name: "Incoming", parentDirectoryId: 42)
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let body = try #require(urlRequest.httpBody)
        let json = try #require(JSONSerialization.jsonObject(with: body) as? [String: Any])

        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(urlRequest.url?.path == "/3/drive/100/files/dropboxes")
        #expect(json["name"] as? String == "Incoming")
        #expect(json["parent_directory_id"] as? Int == 42)
    }

    @Test("kDrive dropboxes response decodes using Swift API names")
    func kDriveDropboxesResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": [
            {
              "id": 42,
              "name": "Incoming",
              "path": "/Incoming",
              "type": "dir",
              "status": "ok",
              "visibility": "is_private",
              "drive_id": 100,
              "depth": 1,
              "created_at": 1710000000,
              "added_at": 1710000000,
              "last_modified_at": 1710000400,
              "last_modified_by": 10,
              "revised_at": 1710000400,
              "updated_at": 1710000500,
              "parent_id": 1,
              "is_favorite": false
            }
          ],
          "cursor": null,
          "has_more": false,
          "response_at": 1710000600
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<[KDriveFileItem]>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.first?.name == "Incoming")
        #expect(response.data.first?.type == "dir")
        #expect(response.data.first?.path == "/Incoming")
    }

    @Test("kDrive create dropbox response decodes variable payloads")
    func kDriveCreateDropboxResponseDecodesVariablePayloads() throws {
        let json = """
        {
          "result": "success",
          "data": {
            "id": 91,
            "uuid": "dropbox-uuid",
            "name": "Incoming",
            "url": "https://example.invalid/dropbox",
            "directory": {
              "id": 42,
              "name": "Incoming"
            }
          }
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<KDriveFileDropbox>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.values["id"] == .number(91))
        #expect(response.data.values["name"] == .string("Incoming"))
        #expect(response.data.values["directory"] == .object([
            "id": .number(42),
            "name": .string("Incoming"),
        ]))
    }
}
