import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKDrive

@Suite("kDrive OAuth import drive requests")
struct KDriveOAuthImportDrivesRequestTests {
    @Test("kDrive OAuth import drives request matches the OpenAPI path and required query parameters")
    func kDriveOAuthImportDrivesRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.listOAuthImportDrives(
            driveId: 100,
            application: "dropbox",
            accessTokenId: 123,
            authCode: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMN1234"
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems ?? []

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/2/drive/100/imports/oauth/drives")
        #expect(queryItems.contains(URLQueryItem(name: "application", value: "dropbox")))
        #expect(queryItems.contains(URLQueryItem(name: "access_token_id", value: "123")))
        #expect(queryItems.contains(URLQueryItem(name: "auth_code", value: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMN1234")))
    }

    @Test("kDrive OAuth import drives request keeps required application query when optional parameters are missing")
    func kDriveOAuthImportDrivesRequestRequiresApplicationOnly() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.listOAuthImportDrives(driveId: 100, application: "onedrive")

        let urlRequest = try await client.makeURLRequest(for: request)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems ?? []

        #expect(queryItems.contains(URLQueryItem(name: "application", value: "onedrive")))
        #expect(!queryItems.contains { $0.name == "access_token_id" })
        #expect(!queryItems.contains { $0.name == "auth_code" })
    }

    @Test("kDrive OAuth import drives response decodes using Swift API names")
    func kDriveOAuthImportDrivesResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": {
            "access_token_id": 123,
            "drives": [
              {
                "id": "dbx-drive-1",
                "name": "Dropbox Team Drive"
              }
            ]
          }
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<KDriveThirdPartyDrivesList>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.accessTokenId == 123)
        #expect(response.data.drives.first?.id == "dbx-drive-1")
        #expect(response.data.drives.first?.name == "Dropbox Team Drive")
    }
}
