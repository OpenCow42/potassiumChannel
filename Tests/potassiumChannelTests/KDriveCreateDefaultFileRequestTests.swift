import Foundation
import Testing
@testable import potassiumChannel

@Suite("kDrive create-default-file request")
struct KDriveCreateDefaultFileRequestTests {
    @Test("kDrive create-default-file request matches the OpenAPI shape")
    func requestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let body = Data(#"{"name":"Notes","type":"txt"}"#.utf8)
        let request = KDriveRequests.createDefaultFileV3(
            driveId: 100,
            fileId: 42,
            with: "capabilities",
            body: body
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems ?? []

        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/3/drive/100/files/42/file")
        #expect(queryItems.contains(URLQueryItem(name: "with", value: "capabilities")))
        #expect(urlRequest.httpBody == request.body)
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
    }

    @Test("create default file options encode the required name and type parameters")
    func optionsEncodeOpenAPIBody() throws {
        let options = CreateKDriveDefaultFileOptions(name: "Notes", type: "txt")

        let object = try JSONSerialization.jsonObject(with: JSONEncoder().encode(options)) as? [String: Any]

        #expect(object?["name"] as? String == "Notes")
        #expect(object?["type"] as? String == "txt")
    }
}
