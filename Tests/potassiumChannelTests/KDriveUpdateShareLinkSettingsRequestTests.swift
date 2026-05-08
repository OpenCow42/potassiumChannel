import Foundation
import Testing
@testable import potassiumChannel

@Suite("kDrive update share-link settings requests")
struct KDriveUpdateShareLinkSettingsRequestTests {
    @Test("kDrive update share-link settings request matches the OpenAPI method, path, headers, query, and body")
    func requestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = try KDriveRequests.updateShareLinkSettings(
            driveId: 100,
            options: UpdateKDriveShareLinkSettingsOptions(
                activate: true,
                bgColor: "#ffffff",
                txtColor: "#000000",
                images: [1, 2]
            )
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems ?? []

        #expect(urlRequest.httpMethod == "PUT")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(urlRequest.url?.path == "/2/drive/100/settings/link")
        #expect(queryItems.isEmpty)

        let body = try #require(urlRequest.httpBody)
        let object = try #require(JSONSerialization.jsonObject(with: body) as? [String: Any])
        #expect(object["activate"] as? Bool == true)
        #expect(object["bgColor"] as? String == "#ffffff")
        #expect(object["txtColor"] as? String == "#000000")
        #expect(object["images"] as? [Int] == [1, 2])
    }

    @Test("kDrive update share-link settings required path parameters are not omitted")
    func requiredParametersAreNotOmitted() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(baseURL: URL(string: "https://api.infomaniak.com")!, bearerToken: "test-token")
        )
        let request = try KDriveRequests.updateShareLinkSettings(
            driveId: 123,
            options: UpdateKDriveShareLinkSettingsOptions(activate: false, bgColor: "#fff", txtColor: "#000")
        )

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.url?.path == "/2/drive/123/settings/link")
    }

    @Test("kDrive update share-link settings options omit nil images")
    func optionsOmitNilImages() throws {
        let data = try JSONEncoder().encode(UpdateKDriveShareLinkSettingsOptions(activate: true, bgColor: "#ffffff", txtColor: "#000000"))
        let object = try #require(JSONSerialization.jsonObject(with: data) as? [String: Any])

        #expect(object["activate"] as? Bool == true)
        #expect(object["bgColor"] as? String == "#ffffff")
        #expect(object["txtColor"] as? String == "#000000")
        #expect(object["images"] == nil)
    }

    @Test("kDrive update share-link settings response decodes boolean data")
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
