import Foundation
import Testing
@testable import potassiumChannel

@Suite("kDrive undo-action request")
struct KDriveUndoActionRequestTests {
    @Test("kDrive undo-action request matches the OpenAPI method, path, headers, query, and body")
    func requestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let body = try JSONEncoder().encode(UndoKDriveActionOptions(cancelId: "00000000-e89b-12d3-a456-000000000000"))
        let request = KDriveRequests.undoAction(driveId: 100, body: body)

        let urlRequest = try await client.makeURLRequest(for: request)
        let requestBody = try #require(urlRequest.httpBody)
        let decodedBody = try JSONDecoder().decode(UndoKDriveActionOptionsBody.self, from: requestBody)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems ?? []

        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(urlRequest.url?.path == "/2/drive/100/cancel")
        #expect(queryItems.isEmpty)
        #expect(decodedBody.cancelId == "00000000-e89b-12d3-a456-000000000000")
        #expect(decodedBody.cancelIds == nil)
    }

    @Test("kDrive undo-action response decodes single UUID feedback resource")
    func responseDecodesSingleFeedbackResource() throws {
        let data = Data(#"{"result":"success","data":{"id":"00000000-e89b-12d3-a456-000000000000","result":true}}"#.utf8)

        let response = try JSONDecoder().decode(InfomaniakResponse<KDriveUndoActionResult>.self, from: data)

        #expect(response.result == "success")
        #expect(response.data == .feedbackResource(KDriveUUIDFeedbackResource(id: "00000000-e89b-12d3-a456-000000000000", result: true)))
    }

    @Test("kDrive undo-action response decodes UUID feedback resource array")
    func responseDecodesFeedbackResourceArray() throws {
        let data = Data(#"{"result":"success","data":[{"id":"first","result":true},{"id":"second","result":false,"message":"expired"}]}"#.utf8)

        let response = try JSONDecoder().decode(InfomaniakResponse<KDriveUndoActionResult>.self, from: data)

        #expect(response.result == "success")
        #expect(response.data == .feedbackResources([
            KDriveUUIDFeedbackResource(id: "first", result: true),
            KDriveUUIDFeedbackResource(id: "second", result: false, message: "expired"),
        ]))
    }
}

private struct UndoKDriveActionOptionsBody: Decodable {
    let cancelId: String?
    let cancelIds: [String]?

    enum CodingKeys: String, CodingKey {
        case cancelId = "cancel_id"
        case cancelIds = "cancel_ids"
    }
}
