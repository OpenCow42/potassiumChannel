import Foundation
import Testing
@testable import potassiumChannel

@Suite("kDrive restore trashed file requests")
struct KDriveRestoreTrashedFileRequestTests {
    @Test("kDrive restore trashed file request matches the OpenAPI method, path, headers, query, and body")
    func requestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let body = try JSONEncoder().encode(RestoreKDriveTrashedFileOptions(destinationDirectoryId: 1))
        let request = KDriveRequests.restoreTrashedFile(driveId: 100, fileId: 42, body: body)

        let urlRequest = try await client.makeURLRequest(for: request)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems ?? []

        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(urlRequest.url?.path == "/2/drive/100/trash/42/restore")
        #expect(queryItems.isEmpty)
        #expect(urlRequest.httpBody == body)

        let responseBody = try #require(urlRequest.httpBody)
        let object = try #require(JSONSerialization.jsonObject(with: responseBody) as? [String: Int])
        #expect(object == ["destination_directory_id": 1])
    }

    @Test("restore trashed file options encode required destination directory id")
    func optionsEncodeRequiredDestinationDirectoryId() throws {
        let data = try JSONEncoder().encode(RestoreKDriveTrashedFileOptions(destinationDirectoryId: 123))
        let object = try #require(JSONSerialization.jsonObject(with: data) as? [String: Int])

        #expect(object == ["destination_directory_id": 123])
    }

    @Test("kDrive restore trashed file response decodes boolean data")
    func responseDecodesBooleanData() throws {
        let data = Data(#"{"result":"success","data":true}"#.utf8)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<KDriveRestoreTrashedFileResult>.self, from: data)

        #expect(response.result == "success")
        #expect(response.data == .bool(true))
    }

    @Test("kDrive restore trashed file response decodes cancel resource data")
    func responseDecodesCancelResourceData() throws {
        let data = Data(#"{"result":"success","data":{"cancel_id":"abc","valid_until":1710000100}}"#.utf8)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<KDriveRestoreTrashedFileResult>.self, from: data)

        #expect(response.result == "success")
        #expect(response.data == .cancelResource(KDriveCancelResource(cancelId: "abc", validUntil: 1_710_000_100)))
    }
}
