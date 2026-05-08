import Foundation
import Testing
@testable import potassiumChannel

@Suite("kDrive update AI settings requests")
struct KDriveUpdateAISettingsRequestTests {
    @Test("kDrive update AI settings request matches the OpenAPI method, path, headers, query, and body")
    func requestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = try KDriveRequests.updateAISettings(
            driveId: 100,
            options: UpdateKDriveAISettingsOptions(
                hasApproved: true,
                hasApprovedAiCategories: false,
                hasApprovedContentSearch: true
            )
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems ?? []

        #expect(urlRequest.httpMethod == "PUT")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(urlRequest.url?.path == "/2/drive/100/settings/ai")
        #expect(queryItems.isEmpty)

        let body = try #require(urlRequest.httpBody)
        let object = try #require(JSONSerialization.jsonObject(with: body) as? [String: Any])
        #expect(object["has_approved"] as? Bool == true)
        #expect(object["has_approved_ai_categories"] as? Bool == false)
        #expect(object["has_approved_content_search"] as? Bool == true)
    }

    @Test("kDrive update AI settings required path parameters are not omitted")
    func requiredParametersAreNotOmitted() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(baseURL: URL(string: "https://api.infomaniak.com")!, bearerToken: "test-token")
        )
        let request = try KDriveRequests.updateAISettings(
            driveId: 123,
            options: UpdateKDriveAISettingsOptions(hasApproved: true)
        )

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.url?.path == "/2/drive/123/settings/ai")
    }

    @Test("kDrive update AI settings options omit nil fields")
    func optionsOmitNilFields() throws {
        let data = try JSONEncoder().encode(UpdateKDriveAISettingsOptions(hasApproved: true, hasApprovedContentSearch: false))
        let object = try #require(JSONSerialization.jsonObject(with: data) as? [String: Any])

        #expect(object["has_approved"] as? Bool == true)
        #expect(object["has_approved_content_search"] as? Bool == false)
        #expect(object["has_approved_ai_categories"] == nil)
    }

    @Test("kDrive update AI settings response decodes boolean data")
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
