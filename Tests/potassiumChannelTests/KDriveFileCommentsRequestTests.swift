import Foundation
import Testing
@testable import potassiumChannel

@Suite("kDrive file comment listing requests")
struct KDriveFileCommentsRequestTests {
    @Test("kDrive file comments request matches the OpenAPI path")
    func kDriveFileCommentsRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.listFileComments(driveId: 100, fileId: 42)

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/2/drive/100/files/42/comments")
        #expect(URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems == [])
    }

    @Test("kDrive file comments required path parameters are encoded into the URL")
    func kDriveFileCommentsRequiredParametersAreNotOmitted() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.listFileComments(driveId: 123, fileId: 456)

        let urlRequest = try await client.makeURLRequest(for: request)
        let path = try #require(urlRequest.url?.path)

        #expect(path == "/2/drive/123/files/456/comments")
        #expect(!path.contains("{drive_id}"))
        #expect(!path.contains("{file_id}"))
        #expect(urlRequest.url?.pathComponents.contains("123") == true)
        #expect(urlRequest.url?.pathComponents.contains("456") == true)
    }

    @Test("kDrive file comments response decodes empty arrays")
    func kDriveFileCommentsResponseDecodesEmptyArray() throws {
        let json = #"{"result":"success","data":[]}"#.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<[KDriveFileComment]>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.isEmpty)
    }

    @Test("kDrive file comments response decodes variable comment payloads")
    func kDriveFileCommentsResponseDecodesVariablePayloads() throws {
        let json = """
        {
          "result": "success",
          "data": [
            {
              "id": 42,
              "body": "Looks good",
              "created_at": 1710000000,
              "is_resolved": false,
              "author": {
                "id": 7,
                "display_name": "Example User"
              },
              "replies": []
            }
          ]
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<[KDriveFileComment]>.self, from: json)
        let comment = try #require(response.data.first)

        #expect(response.result == "success")
        #expect(comment.values["id"] == .number(42))
        #expect(comment.values["body"] == .string("Looks good"))
        #expect(comment.values["created_at"] == .number(1710000000))
        #expect(comment.values["is_resolved"] == .bool(false))
        #expect(comment.values["replies"] == .array([]))
        #expect(comment.values["author"] == .object([
            "id": .number(7),
            "display_name": .string("Example User"),
        ]))
    }
}
