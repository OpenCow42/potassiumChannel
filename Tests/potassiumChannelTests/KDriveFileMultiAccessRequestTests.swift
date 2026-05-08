import Foundation
import Testing
@testable import potassiumChannel

@Suite("kDrive file multi-access requests")
struct KDriveFileMultiAccessRequestTests {
    @Test("kDrive file multi-access request matches the OpenAPI path")
    func kDriveFileMultiAccessRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.getFileMultiAccess(driveId: 100, fileId: 42)

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/2/drive/100/files/42/access")
        #expect(URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems == [])
    }

    @Test("kDrive file multi-access required path parameters are encoded into the URL")
    func kDriveFileMultiAccessRequiredParametersAreNotOmitted() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.getFileMultiAccess(driveId: 123, fileId: 456)

        let urlRequest = try await client.makeURLRequest(for: request)
        let path = try #require(urlRequest.url?.path)

        #expect(path == "/2/drive/123/files/456/access")
        #expect(!path.contains("{drive_id}"))
        #expect(!path.contains("{file_id}"))
        #expect(urlRequest.url?.pathComponents.contains("123") == true)
        #expect(urlRequest.url?.pathComponents.contains("456") == true)
    }

    @Test("kDrive file multi-access response decodes variable access payloads")
    func kDriveFileMultiAccessResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": {
            "users": [
              {
                "id": 42,
                "right": "read",
                "inherited": false
              }
            ],
            "teams": [],
            "public_share_link": null
          }
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<KDriveFileMultiAccess>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.values["users"] == .array([
            .object([
                "id": .number(42),
                "right": .string("read"),
                "inherited": .bool(false),
            ]),
        ]))
        #expect(response.data.values["teams"] == .array([]))
        #expect(response.data.values["public_share_link"] == .null)
    }
}
