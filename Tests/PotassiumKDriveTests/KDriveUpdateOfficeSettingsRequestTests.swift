import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKDrive

@Suite("kDrive update office settings requests")
struct KDriveUpdateOfficeSettingsRequestTests {
    @Test("kDrive update office settings request matches the OpenAPI method, path, headers, query, and body")
    func requestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = try KDriveRequests.updateOfficeSettings(
            driveId: 100,
            options: UpdateKDriveOfficeSettingsOptions(
                form: "onlyoffice",
                presentation: "365",
                spreadsheet: "onlyoffice",
                text: "365"
            )
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems ?? []

        #expect(urlRequest.httpMethod == "PUT")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(urlRequest.url?.path == "/2/drive/100/settings/office")
        #expect(queryItems.isEmpty)

        let body = try #require(urlRequest.httpBody)
        let object = try #require(JSONSerialization.jsonObject(with: body) as? [String: Any])
        #expect(object["form"] as? String == "onlyoffice")
        #expect(object["presentation"] as? String == "365")
        #expect(object["spreadsheet"] as? String == "onlyoffice")
        #expect(object["text"] as? String == "365")
    }

    @Test("kDrive update office settings required path parameters are not omitted")
    func requiredParametersAreNotOmitted() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(baseURL: URL(string: "https://api.infomaniak.com")!, bearerToken: "test-token")
        )
        let request = try KDriveRequests.updateOfficeSettings(
            driveId: 123,
            options: UpdateKDriveOfficeSettingsOptions(text: "onlyoffice")
        )

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.url?.path == "/2/drive/123/settings/office")
    }

    @Test("kDrive update office settings options omit nil fields")
    func optionsOmitNilFields() throws {
        let data = try JSONEncoder().encode(UpdateKDriveOfficeSettingsOptions(form: "365", text: "onlyoffice"))
        let object = try #require(JSONSerialization.jsonObject(with: data) as? [String: Any])

        #expect(object["form"] as? String == "365")
        #expect(object["text"] as? String == "onlyoffice")
        #expect(object["presentation"] == nil)
        #expect(object["spreadsheet"] == nil)
    }

    @Test("kDrive update office settings response decodes boolean data")
    func responseDecodesBooleanData() throws {
        let data = Data("""
        {
          "result": "success",
          "data": true
        }
        """.utf8)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<Bool>.self, from: data)

        #expect(response.result == "success")
        #expect(response.data == true)
    }
}
