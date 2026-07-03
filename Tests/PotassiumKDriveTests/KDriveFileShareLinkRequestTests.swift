import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKDrive

@Suite("kDrive file share-link requests")
struct KDriveFileShareLinkRequestTests {
    @Test("kDrive file share-link request matches the OpenAPI path and query")
    func kDriveFileShareLinkRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.getFileShareLink(driveId: 100, fileId: 42, with: "file")

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        let queryItems = components.queryItems ?? []

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == nil)
        #expect(urlRequest.httpBody == nil)
        #expect(url.path == "/2/drive/100/files/42/link")
        #expect(queryItems == [URLQueryItem(name: "with", value: "file")])
    }

    @Test("kDrive create file share-link request matches the OpenAPI method, path, query, and body")
    func kDriveCreateFileShareLinkRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = try KDriveRequests.createFileShareLink(
            driveId: 100,
            fileId: 42,
            with: "file",
            options: CreateKDriveFileShareLinkOptions(
                right: "public",
                canComment: false,
                canDownload: true,
                canEdit: false,
                canRequestAccess: false,
                canSeeInfo: true,
                canSeeStats: true,
                validUntil: 1_720_000_000
            )
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        let queryItems = components.queryItems ?? []
        let body = try #require(urlRequest.httpBody)
        let json = try #require(JSONSerialization.jsonObject(with: body) as? [String: Any])

        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(url.path == "/2/drive/100/files/42/link")
        #expect(queryItems == [URLQueryItem(name: "with", value: "file")])
        #expect(json["right"] as? String == "public")
        #expect(json["can_comment"] as? Bool == false)
        #expect(json["can_download"] as? Bool == true)
        #expect(json["can_edit"] as? Bool == false)
        #expect(json["can_request_access"] as? Bool == false)
        #expect(json["can_see_info"] as? Bool == true)
        #expect(json["can_see_stats"] as? Bool == true)
        #expect(json["valid_until"] as? Int == 1_720_000_000)
    }

    @Test("kDrive update file share-link request matches the OpenAPI method, path, and body")
    func kDriveUpdateFileShareLinkRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = try KDriveRequests.updateFileShareLink(
            driveId: 100,
            fileId: 42,
            options: UpdateKDriveFileShareLinkOptions(canDownload: false, right: "inherit")
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let body = try #require(urlRequest.httpBody)
        let json = try #require(JSONSerialization.jsonObject(with: body) as? [String: Any])

        #expect(urlRequest.httpMethod == "PUT")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(urlRequest.url?.path == "/2/drive/100/files/42/link")
        #expect(json["right"] as? String == "inherit")
        #expect(json["can_download"] as? Bool == false)
        #expect(json["can_edit"] == nil)
    }

    @Test("kDrive delete file share-link request matches the OpenAPI method and path")
    func kDriveDeleteFileShareLinkRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.deleteFileShareLink(driveId: 100, fileId: 42)

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.httpMethod == "DELETE")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == nil)
        #expect(urlRequest.httpBody == nil)
        #expect(urlRequest.url?.path == "/2/drive/100/files/42/link")
    }

    @Test("kDrive file share-link response decodes using Swift API names")
    func kDriveFileShareLinkResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": {
            "url": "https://kdrive.infomaniak.com/app/share/xxxx/link",
            "file_id": 42,
            "right": "public",
            "valid_until": null,
            "created_by": 12,
            "created_at": 1710000000,
            "updated_at": 1710000500,
            "capabilities": {
              "can_edit": false,
              "can_see_stats": true,
              "can_see_info": true,
              "can_download": true,
              "can_comment": false,
              "can_request_access": false
            },
            "access_blocked": false,
            "views": null
          }
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<KDriveShareLink>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.fileId == 42)
        #expect(response.data.right == "public")
        #expect(response.data.validUntil == nil)
        #expect(response.data.capabilities.canDownload == true)
        #expect(response.data.accessBlocked == false)
        #expect(response.data.views == nil)
    }

    @Test("kDrive file share-link boolean response decodes")
    func kDriveFileShareLinkBooleanResponseDecodes() throws {
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
