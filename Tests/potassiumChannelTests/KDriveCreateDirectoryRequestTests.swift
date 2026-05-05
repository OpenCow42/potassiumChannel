import Foundation
import Testing
@testable import potassiumChannel

@Suite("kDrive create-directory request")
struct KDriveCreateDirectoryRequestTests {
    @Test("kDrive create-directory request matches the OpenAPI shape")
    func requestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let body = Data(##"{"name":"New folder","color":"#0098ff","only_for_me":true,"relative_path":"Nested"}"##.utf8)
        let request = KDriveRequests.createDirectoryV3(
            driveId: 100,
            fileId: 42,
            with: "capabilities",
            body: body
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems ?? []

        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/3/drive/100/files/42/directory")
        #expect(queryItems.contains(URLQueryItem(name: "with", value: "capabilities")))
        #expect(urlRequest.httpBody == request.body)
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
    }

    @Test("create directory options encode the required name and optional snake-case parameters")
    func optionsEncodeOpenAPIBody() throws {
        let options = CreateKDriveDirectoryOptions(
            name: "New folder",
            color: "#0098ff",
            onlyForMe: true,
            relativePath: "Nested"
        )

        let object = try JSONSerialization.jsonObject(with: JSONEncoder().encode(options)) as? [String: Any]

        #expect(object?["name"] as? String == "New folder")
        #expect(object?["color"] as? String == "#0098ff")
        #expect(object?["only_for_me"] as? Bool == true)
        #expect(object?["relative_path"] as? String == "Nested")
        #expect(object?["onlyForMe"] == nil)
        #expect(object?["relativePath"] == nil)
    }
}
