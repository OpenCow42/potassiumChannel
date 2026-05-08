import Foundation
import Testing
@testable import potassiumChannel

@Suite("kDrive update-file-last-modified request")
struct KDriveUpdateFileLastModifiedRequestTests {
    @Test("kDrive update-file-last-modified request matches the OpenAPI shape")
    func requestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let body = try JSONEncoder().encode(UpdateKDriveFileLastModifiedOptions(lastModifiedAt: 1_710_000_100))
        let request = KDriveRequests.updateFileLastModified(
            driveId: 100,
            fileId: 42,
            body: body
        )

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(urlRequest.url?.path == "/3/drive/100/files/42/last-modified")

        let httpBody = try #require(urlRequest.httpBody)
        let object = try #require(JSONSerialization.jsonObject(with: httpBody) as? [String: Any])
        #expect(object["last_modified_at"] as? Int == 1_710_000_100)
    }

    @Test("kDrive update-file-last-modified response decodes boolean result")
    func responseDecodesBooleanResult() throws {
        let data = #"{"result":"success","data":true}"#.data(using: .utf8)!

        let response = try JSONDecoder().decode(InfomaniakResponse<Bool>.self, from: data)

        #expect(response.result == "success")
        #expect(response.data == true)
    }
}
