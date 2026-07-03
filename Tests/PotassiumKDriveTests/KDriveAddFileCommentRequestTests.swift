import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKDrive

@Suite("kDrive add file comment request")
struct KDriveAddFileCommentRequestTests {
    @Test("kDrive add file comment request matches the OpenAPI shape")
    func requestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let body = Data(#"{"body":"Looks good"}"#.utf8)
        let request = KDriveRequests.addFileComment(
            driveId: 100,
            fileId: 42,
            with: "author",
            body: body
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let components = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)

        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/2/drive/100/files/42/comments")
        #expect(components?.queryItems == [URLQueryItem(name: "with", value: "author")])
        #expect(urlRequest.httpBody == body)
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
    }

    @Test("add file comment options encode required body")
    func optionsEncodeRequiredBody() throws {
        let options = AddKDriveFileCommentOptions(body: "Looks good")
        let data = try JSONEncoder().encode(options)
        let object = try #require(JSONSerialization.jsonObject(with: data) as? [String: String])

        #expect(object == ["body": "Looks good"])
    }

    @Test("add file comment response decodes variable comment payload")
    func responseDecodesVariableCommentPayload() throws {
        let data = Data(#"{"result":"success","data":{"id":42,"body":"Looks good","created_at":1710000000,"author":{"id":7}}}"#.utf8)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<KDriveFileComment>.self, from: data)

        #expect(response.result == "success")
        #expect(response.data.values["id"] == .number(42))
        #expect(response.data.values["body"] == .string("Looks good"))
        #expect(response.data.values["created_at"] == .number(1_710_000_000))
        #expect(response.data.values["author"] == .object(["id": .number(7)]))
    }
}
