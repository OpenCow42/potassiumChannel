import Foundation
import Testing
@testable import potassiumChannel

@Suite("kChat get post files info requests")
struct KChatGetPostFilesInfoRequestTests {
    @Test("kChat get post files info request matches the OpenAPI path and headers")
    func kChatGetPostFilesInfoRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.getPostFilesInfo(postId: "post-id")

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == nil)
        #expect(url.path == "/api/v4/posts/post-id/files/info")
        #expect(url.query?.isEmpty ?? true)
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kChat get post files info request includes include_deleted when requested")
    func kChatGetPostFilesInfoRequestIncludesDeletedQuery() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KChatRequests.getPostFilesInfo(
            postId: "post-id",
            options: KChatPostFilesInfoOptions(includeDeleted: true)
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))

        #expect(url.path == "/api/v4/posts/post-id/files/info")
        #expect(components.queryItems == [URLQueryItem(name: "include_deleted", value: "true")])
    }

    @Test("kChat get post files info decodes Mattermost-compatible snake-case file info fields")
    func kChatGetPostFilesInfoDecodesSnakeCaseFields() throws {
        let json = #"[{"id":"file-id","user_id":"user-id","post_id":"post-id","create_at":1,"update_at":2,"delete_at":0,"name":"hello.txt","extension":"txt","size":5,"mime_type":"text/plain","width":0,"height":0,"has_preview_image":false}]"#.data(using: .utf8)!

        let files = try JSONDecoder.kChat.decode([KChatFileInfo].self, from: json)
        let file = try #require(files.first)

        #expect(files.count == 1)
        #expect(file.id == "file-id")
        #expect(file.userId == "user-id")
        #expect(file.postId == "post-id")
        #expect(file.createAt == 1)
        #expect(file.updateAt == 2)
        #expect(file.name == "hello.txt")
        #expect(file.extension == "txt")
        #expect(file.size == 5)
        #expect(file.mimeType == "text/plain")
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
