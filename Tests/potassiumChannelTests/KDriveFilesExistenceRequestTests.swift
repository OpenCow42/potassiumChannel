import Foundation
import Testing
@testable import potassiumChannel

@Suite("kDrive files-exists request")
struct KDriveFilesExistenceRequestTests {
    @Test("kDrive files-exists request matches the OpenAPI path, headers, and JSON body")
    func requestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.checkFilesExistence(driveId: 100, fileIds: [42, 43])

        let urlRequest = try await client.makeURLRequest(for: request)
        let body = try #require(urlRequest.httpBody)
        let decodedBody = try JSONDecoder().decode(KDriveFilesExistenceRequestBody.self, from: body)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems ?? []

        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(urlRequest.url?.path == "/2/drive/100/files/exists")
        #expect(queryItems.isEmpty)
        #expect(decodedBody == KDriveFilesExistenceRequestBody(ids: [42, 43]))
    }

    @Test("kDrive files-exists response decodes feedback resources")
    func responseDecodesFeedbackResources() throws {
        let data = Data(#"{"result":"success","data":[{"id":42,"result":true},{"id":43,"result":false,"message":"not_found"}]}"#.utf8)

        let response = try JSONDecoder().decode(InfomaniakResponse<[KDriveFilesExistenceResult]>.self, from: data)

        #expect(response.result == "success")
        #expect(response.data == [
            KDriveFilesExistenceResult(id: 42, result: true),
            KDriveFilesExistenceResult(id: 43, result: false, message: "not_found"),
        ])
    }
}
