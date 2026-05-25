import Foundation
import Testing
@testable import potassiumChannel

@Suite("kDrive file access request listing requests")
struct KDriveFileAccessRequestTests {
    @Test("kDrive file access requests request matches the OpenAPI path")
    func kDriveFileAccessRequestsRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.listFileAccessRequests(driveId: 100, fileId: 42)

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/2/drive/100/files/42/access/requests")
        #expect(URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems == [])
    }

    @Test("kDrive file access requests required path parameters are encoded into the URL")
    func kDriveFileAccessRequestsRequiredParametersAreNotOmitted() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.listFileAccessRequests(driveId: 123, fileId: 456)

        let urlRequest = try await client.makeURLRequest(for: request)
        let path = try #require(urlRequest.url?.path)

        #expect(path == "/2/drive/123/files/456/access/requests")
        #expect(!path.contains("{drive_id}"))
        #expect(!path.contains("{file_id}"))
        #expect(urlRequest.url?.pathComponents.contains("123") == true)
        #expect(urlRequest.url?.pathComponents.contains("456") == true)
    }

    @Test("kDrive file access request detail request matches the OpenAPI path and query")
    func kDriveFileAccessRequestDetailRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.getFileAccessRequest(driveId: 100, requestId: 42, with: "file,user")

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/2/drive/100/access/requests/42")
        #expect(components.queryItems == [URLQueryItem(name: "with", value: "file,user")])
    }

    @Test("kDrive file access requests response decodes empty arrays")
    func kDriveFileAccessRequestsResponseDecodesEmptyArray() throws {
        let json = #"{"result":"success","data":[]}"#.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<[KDriveFileAccessRequest]>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.isEmpty)
    }

    @Test("kDrive file access requests response decodes variable request payloads")
    func kDriveFileAccessRequestsResponseDecodesVariablePayloads() throws {
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

        let response = try decoder.decode(InfomaniakResponse<[KDriveFileAccessRequest]>.self, from: json)
        let entry = try #require(response.data.first)

        #expect(response.result == "success")
        #expect(entry.values["id"] == .number(42))
        #expect(entry.values["email"] == .string("person@example.com"))
        #expect(entry.values["right"] == .string("read"))
        #expect(entry.values["created_at"] == .number(1710000000))
        #expect(entry.values["message"] == .null)
    }

    @Test("kDrive file access request detail response decodes variable payloads")
    func kDriveFileAccessRequestDetailResponseDecodesVariablePayloads() throws {
        let json = """
        {
          "result": "success",
          "data": {
            "id": 42,
            "email": "person@example.com",
            "right": "read",
            "created_at": 1710000000,
            "message": null
          }
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<KDriveFileAccessRequest>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.values["id"] == .number(42))
        #expect(response.data.values["email"] == .string("person@example.com"))
        #expect(response.data.values["right"] == .string("read"))
        #expect(response.data.values["created_at"] == .number(1710000000))
        #expect(response.data.values["message"] == .null)
    }
}
