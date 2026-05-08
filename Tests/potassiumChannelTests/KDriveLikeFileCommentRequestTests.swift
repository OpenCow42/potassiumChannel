import Foundation
import Testing
@testable import potassiumChannel

@Suite("kDrive like file comment request")
struct KDriveLikeFileCommentRequestTests {
    @Test("kDrive like file comment request matches the OpenAPI shape")
    func requestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.likeFileComment(
            driveId: 100,
            fileId: 42,
            commentId: "comment-7"
        )

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/2/drive/100/files/42/comments/comment-7/like")
        #expect(urlRequest.url?.query?.isEmpty ?? true)
        #expect(urlRequest.httpBody == nil)
    }

    @Test("like file comment required path parameters are encoded into the URL")
    func requiredPathParametersAreEncoded() async throws {
        let client = InfomaniakAPIClient(configuration: APIClientConfiguration(baseURL: URL(string: "https://api.infomaniak.com")!, bearerToken: "test-token"))
        let request = KDriveRequests.likeFileComment(driveId: 123, fileId: 456, commentId: "abc-789")

        let urlRequest = try await client.makeURLRequest(for: request)
        let path = try #require(urlRequest.url?.path)

        #expect(path == "/2/drive/123/files/456/comments/abc-789/like")
        #expect(!path.contains("{drive_id}"))
        #expect(!path.contains("{file_id}"))
        #expect(!path.contains("{comment_id}"))
    }

    @Test("like file comment response decodes boolean data")
    func responseDecodesBooleanData() throws {
        let data = Data(#"{"result":"success","data":true}"#.utf8)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<Bool>.self, from: data)

        #expect(response.result == "success")
        #expect(response.data == true)
    }
}
