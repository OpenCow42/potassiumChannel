import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKChat

@Suite("kChat get file info requests")
struct KChatGetFileInfoRequestTests {
    @Test("kChat get file info request matches the OpenAPI path and headers")
    func kChatGetFileInfoRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.getFileInfo(fileId: "file-id")

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == nil)
        #expect(url.path == "/api/v4/files/file-id/info")
        #expect(url.query?.isEmpty ?? true)
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat get file info decodes Mattermost-compatible snake-case file info fields")
    func kChatGetFileInfoDecodesSnakeCaseFields() throws {
        let json = #"{"id":"file-id","user_id":"user-id","post_id":"post-id","create_at":1,"update_at":2,"delete_at":0,"name":"hello.txt","extension":"txt","size":5,"mime_type":"text/plain","width":0,"height":0,"has_preview_image":false}"#.data(using: .utf8)!

        let file = try JSONDecoder.kChat.decode(KChatFileInfo.self, from: json)

        #expect(file.id == "file-id")
        #expect(file.userId == "user-id")
        #expect(file.postId == "post-id")
        #expect(file.createAt == 1)
        #expect(file.updateAt == 2)
        #expect(file.deleteAt == 0)
        #expect(file.name == "hello.txt")
        #expect(file.extension == "txt")
        #expect(file.size == 5)
        #expect(file.mimeType == "text/plain")
        #expect(file.width == 0)
        #expect(file.height == 0)
        #expect(file.hasPreviewImage == false)
    }
}

private extension JSONDecoder {
    static var kChat: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
