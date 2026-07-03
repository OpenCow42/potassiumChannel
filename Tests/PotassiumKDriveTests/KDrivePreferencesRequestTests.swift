import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKDrive

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

    @Test("kDrive set preferences request encodes patch body")
    func kDriveSetPreferencesRequestEncodesPatchBody() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = try KDriveRequests.setUserPreferences(options: SetKDriveUserPreferencesOptions(
            dateFormat: "d/m/Y",
            defaultDrive: 100,
            density: "compact"
        ))

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.httpMethod == "PATCH")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(urlRequest.url?.path == "/2/drive/preferences")

        let body = try #require(urlRequest.httpBody)
        let object = try #require(JSONSerialization.jsonObject(with: body) as? [String: Any])
        #expect(object["density"] as? String == "compact")
        #expect(object["date_format"] as? String == "d/m/Y")
        #expect(object["default_drive"] as? Int == 100)
        #expect(object["sort_recent_file"] == nil)
    }

    @Test("kDrive set preferences request encodes nested list preferences")
    func kDriveSetPreferencesRequestEncodesNestedListPreferences() throws {
        let body = try JSONEncoder().encode(SetKDriveUserPreferencesOptions(
            list: KDriveUserPreferencesListOptions(
                files: KDriveUserPreferencesListSortOptions(direction: "asc", property: "name"),
                storageLargest: KDriveUserPreferencesListSortOptions(direction: "desc", property: "size"),
                view: "table"
            ),
            useShortcut: true
        ))

        let object = try #require(JSONSerialization.jsonObject(with: body) as? [String: Any])
        let list = try #require(object["list"] as? [String: Any])
        let files = try #require(list["files"] as? [String: Any])
        let storageLargest = try #require(list["storage_largest"] as? [String: Any])
        #expect(files["direction"] as? String == "asc")
        #expect(files["property"] as? String == "name")
        #expect(storageLargest["direction"] as? String == "desc")
        #expect(storageLargest["property"] as? String == "size")
        #expect(list["view"] as? String == "table")
        #expect(object["use_shortcut"] as? Bool == true)
    }

    @Test("kDrive set preferences response decodes boolean result")
    func kDriveSetPreferencesResponseDecodesBooleanResult() throws {
        let json = """
        {
          "result": "success",
          "data": true
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<Bool>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data == true)
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
