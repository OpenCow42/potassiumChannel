import Foundation
import Testing
@testable import potassiumChannel

@Suite("kDrive file comment reply listing requests")
struct KDriveFileCommentRepliesRequestTests {
    @Test("kDrive file comment replies request matches the OpenAPI path and query")
    func requestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.listFileCommentReplies(
            driveId: 100,
            fileId: 42,
            commentId: "7",
            options: ListKDriveFileCommentRepliesOptions(
                includedResources: "author",
                page: 2,
                perPage: 25,
                total: true,
                orderBy: "created_at",
                order: "desc",
                orderFor: ["created_at": "asc"]
            )
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let components = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/2/drive/100/files/42/comments/7")
        #expect(components?.queryItems == [
            URLQueryItem(name: "with", value: "author"),
            URLQueryItem(name: "page", value: "2"),
            URLQueryItem(name: "per_page", value: "25"),
            URLQueryItem(name: "total", value: "true"),
            URLQueryItem(name: "order_by", value: "created_at"),
            URLQueryItem(name: "order", value: "desc"),
            URLQueryItem(name: "order_for[created_at]", value: "asc"),
        ])
    }

    @Test("kDrive file comment replies required path parameters are encoded into the URL")
    func requiredParametersAreNotOmitted() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.listFileCommentReplies(driveId: 123, fileId: 456, commentId: "abc-789")

        let urlRequest = try await client.makeURLRequest(for: request)
        let path = try #require(urlRequest.url?.path)

        #expect(path == "/2/drive/123/files/456/comments/abc-789")
        #expect(!path.contains("{drive_id}"))
        #expect(!path.contains("{file_id}"))
        #expect(!path.contains("{comment_id}"))
        #expect(urlRequest.url?.pathComponents.contains("123") == true)
        #expect(urlRequest.url?.pathComponents.contains("456") == true)
        #expect(urlRequest.url?.pathComponents.contains("abc-789") == true)
    }

    @Test("kDrive file comment replies response decodes pagination metadata")
    func responseDecodesPaginationMetadata() throws {
        let json = #"{"result":"success","data":[],"total":0,"page":1,"pages":1,"items_per_page":20}"#.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(PaginatedInfomaniakResponse<[KDriveFileComment]>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.isEmpty)
        #expect(response.total == 0)
        #expect(response.page == 1)
        #expect(response.pages == 1)
        #expect(response.itemsPerPage == 20)
    }

    @Test("kDrive file comment replies response decodes variable comment payloads")
    func responseDecodesVariablePayloads() throws {
        let json = """
        {
          "result": "success",
          "data": [
            {
              "id": 43,
              "body": "Reply body",
              "parent_id": 7,
              "created_at": 1710000001,
              "author": {
                "id": 8
              }
            }
          ]
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(PaginatedInfomaniakResponse<[KDriveFileComment]>.self, from: json)
        let reply = try #require(response.data.first)

        #expect(response.result == "success")
        #expect(reply.values["id"] == .number(43))
        #expect(reply.values["body"] == .string("Reply body"))
        #expect(reply.values["parent_id"] == .number(7))
        #expect(reply.values["created_at"] == .number(1_710_000_001))
        #expect(reply.values["author"] == .object(["id": .number(8)]))
    }
}
