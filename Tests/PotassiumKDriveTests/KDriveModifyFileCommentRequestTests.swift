import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKDrive

@Suite("kDrive modify file comment request")
struct KDriveModifyFileCommentRequestTests {
    @Test("kDrive modify file comment request matches the OpenAPI shape")
    func requestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let options = ModifyKDriveFileCommentOptions(
            includedResources: "author",
            body: "Updated body",
            isResolved: true
        )
        let body = Data(#"{"body":"Updated body","is_resolved":true}"#.utf8)
        let request = KDriveRequests.modifyFileComment(
            driveId: 100,
            fileId: 42,
            commentId: "comment-7",
            options: options,
            body: body
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let components = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)

        #expect(urlRequest.httpMethod == "PUT")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/2/drive/100/files/42/comments/comment-7")
        #expect(components?.queryItems == [URLQueryItem(name: "with", value: "author")])
        #expect(urlRequest.httpBody == body)
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
    }

    @Test("modify file comment options encode optional body and resolved state")
    func optionsEncodeOptionalBodyAndResolvedState() throws {
        let options = ModifyKDriveFileCommentOptions(body: "Updated body", isResolved: false)
        let data = try JSONEncoder().encode(options)
        let object = try #require(JSONSerialization.jsonObject(with: data) as? [String: Any])

        #expect(object["body"] as? String == "Updated body")
        #expect(object["is_resolved"] as? Bool == false)
        #expect(object["with"] == nil)
    }

    @Test("modify file comment options omit nil mutation fields")
    func optionsOmitNilMutationFields() throws {
        let options = ModifyKDriveFileCommentOptions(body: "Body only")
        let data = try JSONEncoder().encode(options)
        let object = try #require(JSONSerialization.jsonObject(with: data) as? [String: Any])

        #expect(object["body"] as? String == "Body only")
        #expect(object["is_resolved"] == nil)
    }

    @Test("modify file comment response decodes boolean data")
    func responseDecodesBooleanData() throws {
        let data = Data(#"{"result":"success","data":true}"#.utf8)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<Bool>.self, from: data)

        #expect(response.result == "success")
        #expect(response.data == true)
    }
}
