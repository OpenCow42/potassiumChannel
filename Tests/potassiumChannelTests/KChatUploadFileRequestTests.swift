import Foundation
import Testing
@testable import potassiumChannel

@Suite("kChat upload file requests")
struct KChatUploadFileRequestTests {
    @Test("kChat upload file request matches the OpenAPI path, query, headers, and multipart body")
    func kChatUploadFileRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://example-team.kchat.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let body = Data("--boundary\r\nContent-Disposition: form-data; name=\"files\"; filename=\"hello.txt\"\r\n\r\nhello\r\n--boundary--\r\n".utf8)
        let request = KChatRequests.uploadFile(
            channelId: "channel-id",
            filename: "hello.txt",
            body: body,
            contentType: "multipart/form-data; boundary=boundary"
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))

        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "multipart/form-data; boundary=boundary")
        #expect(url.path == "/api/v4/files")
        #expect(components.queryItems?.contains(URLQueryItem(name: "channel_id", value: "channel-id")) == true)
        #expect(components.queryItems?.contains(URLQueryItem(name: "filename", value: "hello.txt")) == true)
        #expect(urlRequest.httpBody == body)
    }

    @Test("kChat upload file response decodes Mattermost-compatible snake-case fields")
    func kChatUploadFileResponseDecodesSnakeCaseFields() throws {
        let json = #"{"file_infos":[{"id":"file-id","user_id":"user-id","post_id":"post-id","create_at":1,"update_at":2,"delete_at":0,"name":"hello.txt","extension":"txt","size":5,"mime_type":"text/plain","width":0,"height":0,"has_preview_image":false}],"client_ids":["client-id"]}"#.data(using: .utf8)!

        let response = try JSONDecoder.kChat.decode(KChatFileUploadResponse.self, from: json)
        let file = try #require(response.fileInfos?.first)

        #expect(response.clientIds == ["client-id"])
        #expect(file.id == "file-id")
        #expect(file.userId == "user-id")
        #expect(file.postId == "post-id")
        #expect(file.createAt == 1)
        #expect(file.name == "hello.txt")
        #expect(file.extension == "txt")
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
