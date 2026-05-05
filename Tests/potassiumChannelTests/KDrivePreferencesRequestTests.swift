import Foundation
import Testing
@testable import potassiumChannel

@Suite("kDrive preferences requests")
struct KDrivePreferencesRequestTests {
    @Test("kDrive preferences request matches the OpenAPI path and query")
    func kDrivePreferencesRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.getUserPreferences(with: "drive")

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/2/drive/preferences")

        let url = try #require(urlRequest.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        let queryItems = components.queryItems ?? []
        #expect(queryItems == [URLQueryItem(name: "with", value: "drive")])
    }

    @Test("kDrive preferences response decodes using Swift API names")
    func kDrivePreferencesResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": {
            "density": "normal",
            "sort_recent_file": true,
            "date_format": "DD/MM/YYYY",
            "use_shortcut": false,
            "default_drive": 100,
            "tutorials": ["welcome"],
            "connected_app": ["desktop"]
          }
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<KDriveUserPreferences>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data == KDriveUserPreferences(
            density: "normal",
            sortRecentFile: true,
            dateFormat: "DD/MM/YYYY",
            useShortcut: false,
            defaultDrive: 100,
            tutorials: ["welcome"],
            connectedApp: ["desktop"]
        ))
    }
}
