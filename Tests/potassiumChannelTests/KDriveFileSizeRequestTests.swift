import Foundation
import Testing
@testable import potassiumChannel

@Suite("kDrive file size requests")
struct KDriveFileSizeRequestTests {
    @Test("kDrive file size request matches the OpenAPI path")
    func kDriveFileSizeRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.getFileSize(driveId: 100, fileId: 42)

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/2/drive/100/files/42/sizes")
        #expect(URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems == [])
    }

    @Test("kDrive file size request encodes depth")
    func kDriveFileSizeRequestEncodesDepth() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.getFileSize(driveId: 100, fileId: 42, depth: "unlimited")

        let urlRequest = try await client.makeURLRequest(for: request)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems

        #expect(queryItems == [URLQueryItem(name: "depth", value: "unlimited")])
    }

    @Test("kDrive file size required path parameters are encoded into the URL")
    func kDriveFileSizeRequiredParametersAreNotOmitted() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.getFileSize(driveId: 123, fileId: 456)

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.url?.path == "/2/drive/123/files/456/sizes")
        #expect(urlRequest.url?.pathComponents.contains("123") == true)
        #expect(urlRequest.url?.pathComponents.contains("456") == true)
    }

    @Test("kDrive file size response decodes using Swift API names")
    func kDriveFileSizeResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": {
            "size": 1000,
            "storage_size": 1500
          }
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<KDriveFileSize>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.size == 1000)
        #expect(response.data.storageSize == 1500)
    }
}
