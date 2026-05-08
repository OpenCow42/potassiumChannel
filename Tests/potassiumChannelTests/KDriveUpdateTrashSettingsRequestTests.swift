import Foundation
import Testing
@testable import potassiumChannel

@Suite("kDrive update trash settings requests")
struct KDriveUpdateTrashSettingsRequestTests {
    @Test("kDrive update trash settings request matches the OpenAPI method, path, headers, query, and body")
    func requestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = try KDriveRequests.updateTrashSettings(
            driveId: 100,
            options: UpdateKDriveTrashSettingsOptions(maxDuration: 30)
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems ?? []

        #expect(urlRequest.httpMethod == "PUT")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(urlRequest.url?.path == "/2/drive/100/settings/trash")
        #expect(queryItems.isEmpty)

        let body = try #require(urlRequest.httpBody)
        let object = try #require(JSONSerialization.jsonObject(with: body) as? [String: Any])
        #expect(object["max_duration"] as? Int == 30)
        #expect(object["maxDuration"] == nil)
    }

    @Test("kDrive update trash settings required path parameters are not omitted")
    func requiredParametersAreNotOmitted() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(baseURL: URL(string: "https://api.infomaniak.com")!, bearerToken: "test-token")
        )
        let request = try KDriveRequests.updateTrashSettings(
            driveId: 123,
            options: UpdateKDriveTrashSettingsOptions(maxDuration: 365)
        )

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.url?.path == "/2/drive/123/settings/trash")
    }

    @Test("kDrive update trash settings options encode snake-case body")
    func optionsEncodeSnakeCaseBody() throws {
        let data = try JSONEncoder().encode(UpdateKDriveTrashSettingsOptions(maxDuration: 1))
        let object = try #require(JSONSerialization.jsonObject(with: data) as? [String: Any])

        #expect(object["max_duration"] as? Int == 1)
        #expect(object["maxDuration"] == nil)
    }

    @Test("kDrive update trash settings response decodes boolean data")
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
