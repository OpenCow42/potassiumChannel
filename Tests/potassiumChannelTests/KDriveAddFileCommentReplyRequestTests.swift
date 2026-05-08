import Foundation
import Testing
@testable import potassiumChannel

@Suite("kDrive add file comment reply request")
struct KDriveAddFileCommentReplyRequestTests {
    @Test("kDrive add file comment reply request matches the OpenAPI shape")
    func requestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let body = Data(#"{"body":"Reply body"}"#.utf8)
        let request = KDriveRequests.addFileCommentReply(
            driveId: 100,
            fileId: 42,
            commentId: 7,
            with: "author",
            body: body
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let components = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)

        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/2/drive/100/files/42/comments/7")
        #expect(components?.queryItems == [URLQueryItem(name: "with", value: "author")])
        #expect(urlRequest.httpBody == body)
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
    }

    @Test("add file comment reply options encode required body")
    func optionsEncodeRequiredBody() throws {
        let options = AddKDriveFileCommentReplyOptions(body: "Reply body")
        let data = try JSONEncoder().encode(options)
        let object = try #require(JSONSerialization.jsonObject(with: data) as? [String: String])

        #expect(object == ["body": "Reply body"])
    }

    @Test("add file comment reply response decodes variable comment payload")
    func responseDecodesVariableCommentPayload() throws {
        let data = Data(#"{"result":"success","data":{"id":43,"body":"Reply body","parent_id":7,"created_at":1710000001,"author":{"id":8}}}"#.utf8)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<KDriveFileComment>.self, from: data)

        #expect(response.result == "success")
        #expect(response.data.values["id"] == .number(43))
        #expect(response.data.values["body"] == .string("Reply body"))
        #expect(response.data.values["parent_id"] == .number(7))
        #expect(response.data.values["created_at"] == .number(1_710_000_001))
        #expect(response.data.values["author"] == .object(["id": .number(8)]))
    }
}
