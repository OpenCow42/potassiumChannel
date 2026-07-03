import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKDrive

@Suite("kDrive file temporary URL requests")
struct KDriveFileTemporaryURLRequestTests {
    @Test("kDrive file temporary URL request matches the OpenAPI path")
    func kDriveFileTemporaryURLRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.getFileTemporaryURL(driveId: 100, fileId: 42, duration: 3600)

        let urlRequest = try await client.makeURLRequest(for: request)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/2/drive/100/files/42/temporary_url")
        #expect(queryItems == [URLQueryItem(name: "duration", value: "3600")])
    }

    @Test("kDrive file temporary URL required path parameters are encoded into the URL")
    func kDriveFileTemporaryURLRequiredParametersAreNotOmitted() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.getFileTemporaryURL(driveId: 123, fileId: 456)

        let urlRequest = try await client.makeURLRequest(for: request)
        let path = try #require(urlRequest.url?.path)

        #expect(path == "/2/drive/123/files/456/temporary_url")
        #expect(!path.contains("{drive_id}"))
        #expect(!path.contains("{file_id}"))
        #expect(urlRequest.url?.pathComponents.contains("123") == true)
        #expect(urlRequest.url?.pathComponents.contains("456") == true)
        #expect(URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems == [])
    }

    @Test("kDrive file temporary URL response decodes using Swift API names")
    func kDriveFileTemporaryURLResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": {
            "temporary_url": "https://kdrive.infomaniak.com/drive/XXX/public/d/XXX"
          }
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<KDriveFileTemporaryURL>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.temporaryUrl == "https://kdrive.infomaniak.com/drive/XXX/public/d/XXX")
    }
}
