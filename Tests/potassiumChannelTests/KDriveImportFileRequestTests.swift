import Foundation
import Testing
@testable import potassiumChannel

@Suite("kDrive import file requests")
struct KDriveImportFileRequestTests {
    @Test("kDrive import files request matches the OpenAPI path and query")
    func kDriveImportFilesRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.listErroredImportFiles(
            driveId: 100,
            importId: 200,
            with: "created_by",
            page: 1,
            perPage: 25,
            total: true
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems ?? []

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/2/drive/100/imports/200")
        #expect(queryItems.contains(URLQueryItem(name: "with", value: "created_by")))
        #expect(queryItems.contains(URLQueryItem(name: "page", value: "1")))
        #expect(queryItems.contains(URLQueryItem(name: "per_page", value: "25")))
        #expect(queryItems.contains(URLQueryItem(name: "total", value: "true")))
    }

    @Test("kDrive import files required path parameters are encoded into the URL")
    func kDriveImportFilesRequiredParametersAreNotOmitted() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.listErroredImportFiles(driveId: 123, importId: 456)

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.url?.path == "/2/drive/123/imports/456")
        #expect(urlRequest.url?.pathComponents.contains("123") == true)
        #expect(urlRequest.url?.pathComponents.contains("456") == true)
    }

    @Test("kDrive import files response decodes using Swift API names")
    func kDriveImportFilesResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": [
            {
              "id": 10,
              "name": "failed.docx",
              "status": "error",
              "message": "Unsupported file",
              "created_at": 1710000000
            }
          ],
          "total": 1,
          "page": 1,
          "pages": 1,
          "items_per_page": 25
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(PaginatedInfomaniakResponse<[KDriveExternalImportFile]>.self, from: json)

        #expect(response.result == "success")
        #expect(response.total == 1)
        #expect(response.data.first?.id == 10)
        #expect(response.data.first?.name == "failed.docx")
        #expect(response.data.first?.message == "Unsupported file")
        #expect(response.data.first?.createdAt == 1710000000)
    }
}
