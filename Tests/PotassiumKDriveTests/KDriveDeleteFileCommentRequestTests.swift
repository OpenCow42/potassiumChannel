import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKDrive

@Suite("kDrive delete file comment request")
struct KDriveDeleteFileCommentRequestTests {
    @Test("kDrive delete file comment request matches the OpenAPI shape")
    func requestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.deleteFileComment(
            driveId: 100,
            fileId: 42,
            commentId: "comment-7"
        )

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.httpMethod == "DELETE")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/2/drive/100/files/42/comments/comment-7")
        #expect(urlRequest.url?.query?.isEmpty ?? true)
        #expect(urlRequest.httpBody == nil)
    }

    @Test("delete file comment required path parameters are encoded into the URL")
    func requiredPathParametersAreEncoded() async throws {
        let client = InfomaniakAPIClient(configuration: APIClientConfiguration(baseURL: URL(string: "https://api.infomaniak.com")!, bearerToken: "test-token"))
        let request = KDriveRequests.deleteFileComment(driveId: 123, fileId: 456, commentId: "abc-789")

        let urlRequest = try await client.makeURLRequest(for: request)
        let path = try #require(urlRequest.url?.path)

        #expect(path == "/2/drive/123/files/456/comments/abc-789")
        #expect(!path.contains("{drive_id}"))
        #expect(!path.contains("{file_id}"))
        #expect(!path.contains("{comment_id}"))
    }

    @Test("delete file comment response decodes boolean data")
    func responseDecodesBooleanData() throws {
        let data = Data(#"{"result":"success","data":true}"#.utf8)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<Bool>.self, from: data)

        #expect(response.result == "success")
        #expect(response.data == true)
    }
}
