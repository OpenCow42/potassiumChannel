import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKDrive

@Suite("kDrive file dropbox requests")
struct KDriveFileDropboxRequestTests {
    @Test("kDrive file dropbox request matches the OpenAPI path")
    func kDriveFileDropboxRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.getFileDropbox(driveId: 100, fileId: 42)

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/2/drive/100/files/42/dropbox")
        #expect(URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems == [])
    }

    @Test("kDrive file dropbox required path parameters are encoded into the URL")
    func kDriveFileDropboxRequiredParametersAreNotOmitted() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.getFileDropbox(driveId: 123, fileId: 456)

        let urlRequest = try await client.makeURLRequest(for: request)
        let path = try #require(urlRequest.url?.path)

        #expect(path == "/2/drive/123/files/456/dropbox")
        #expect(!path.contains("{drive_id}"))
        #expect(!path.contains("{file_id}"))
        #expect(urlRequest.url?.pathComponents.contains("123") == true)
        #expect(urlRequest.url?.pathComponents.contains("456") == true)
    }

    @Test("kDrive create file dropbox request matches the OpenAPI method, path, and body")
    func kDriveCreateFileDropboxRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = try KDriveRequests.createFileDropbox(
            driveId: 100,
            fileId: 42,
            options: KDriveFileDropboxOptions(
                alias: "incoming",
                emailWhenFinished: false,
                limitFileSize: 12_345,
                password: "secret",
                validUntil: 1_720_000_000
            )
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let body = try #require(urlRequest.httpBody)
        let json = try #require(JSONSerialization.jsonObject(with: body) as? [String: Any])

        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(urlRequest.url?.path == "/2/drive/100/files/42/dropbox")
        #expect(json["alias"] as? String == "incoming")
        #expect(json["email_when_finished"] as? Bool == false)
        #expect(json["limit_file_size"] as? Int == 12_345)
        #expect(json["password"] as? String == "secret")
        #expect(json["valid_until"] as? Int == 1_720_000_000)
    }

    @Test("kDrive update file dropbox request matches the OpenAPI method, path, and body")
    func kDriveUpdateFileDropboxRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = try KDriveRequests.updateFileDropbox(
            driveId: 100,
            fileId: 42,
            options: KDriveFileDropboxOptions(alias: "incoming-updated", emailWhenFinished: false)
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let body = try #require(urlRequest.httpBody)
        let json = try #require(JSONSerialization.jsonObject(with: body) as? [String: Any])

        #expect(urlRequest.httpMethod == "PUT")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(urlRequest.url?.path == "/2/drive/100/files/42/dropbox")
        #expect(json["alias"] as? String == "incoming-updated")
        #expect(json["email_when_finished"] as? Bool == false)
        #expect(json["limit_file_size"] == nil)
    }

    @Test("kDrive delete file dropbox request matches the OpenAPI method and path")
    func kDriveDeleteFileDropboxRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.deleteFileDropbox(driveId: 100, fileId: 42)

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.httpMethod == "DELETE")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == nil)
        #expect(urlRequest.httpBody == nil)
        #expect(urlRequest.url?.path == "/2/drive/100/files/42/dropbox")
    }

    @Test("kDrive file dropbox response decodes null data")
    func kDriveFileDropboxResponseDecodesNullData() throws {
        let json = #"{"result":"success","data":null}"#.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<KDriveFileDropbox?>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data == nil)
    }

    @Test("kDrive file dropbox response decodes variable payloads")
    func kDriveFileDropboxResponseDecodesVariablePayloads() throws {
        let json = """
        {
          "result": "success",
          "data": {
            "id": 42,
            "name": "Uploads",
            "url": "https://example.invalid/dropbox",
            "enabled": true,
            "settings": {
              "require_email": false
            },
            "allowed_extensions": ["jpg", "png"]
          }
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<KDriveFileDropbox?>.self, from: json)
        let dropbox = try #require(response.data)

        #expect(response.result == "success")
        #expect(dropbox.values["id"] == .number(42))
        #expect(dropbox.values["name"] == .string("Uploads"))
        #expect(dropbox.values["url"] == .string("https://example.invalid/dropbox"))
        #expect(dropbox.values["enabled"] == .bool(true))
        #expect(dropbox.values["allowed_extensions"] == .array([.string("jpg"), .string("png")]))
        #expect(dropbox.values["settings"] == .object([
            "require_email": .bool(false),
        ]))
    }

    @Test("kDrive file dropbox create response decodes variable payloads")
    func kDriveFileDropboxCreateResponseDecodesVariablePayloads() throws {
        let json = """
        {
          "result": "success",
          "data": {
            "id": 42,
            "uuid": "dropbox-uuid",
            "name": "Uploads",
            "url": "https://example.invalid/dropbox",
            "remaining": null
          }
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<KDriveFileDropbox>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.values["id"] == .number(42))
        #expect(response.data.values["uuid"] == .string("dropbox-uuid"))
        #expect(response.data.values["remaining"] == .null)
    }

    @Test("kDrive file dropbox boolean response decodes")
    func kDriveFileDropboxBooleanResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": true
        }
        """.data(using: .utf8)!

        let response = try JSONDecoder().decode(InfomaniakResponse<Bool>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data == true)
    }
}
