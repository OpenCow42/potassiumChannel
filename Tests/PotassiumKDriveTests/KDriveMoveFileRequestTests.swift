import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKDrive

@Suite("kDrive move-file request")
struct KDriveMoveFileRequestTests {
    @Test("kDrive move-file request matches the OpenAPI shape")
    func requestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.moveFileV3(
            driveId: 100,
            fileId: 42,
            destinationDirectoryId: 1,
            body: Data(#"{\"name\":\"Moved.txt\",\"conflict\":\"rename\"}"#.utf8)
        )

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/3/drive/100/files/42/move/1")
        #expect(urlRequest.httpBody == request.body)
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
    }

    @Test("move file options encode optional fields")
    func moveFileOptionsEncodeOptionalFields() throws {
        let options = MoveKDriveFileOptions(conflict: "rename", name: "Moved.txt")
        let data = try JSONEncoder().encode(options)
        let object = try #require(JSONSerialization.jsonObject(with: data) as? [String: String])

        #expect(object["conflict"] == "rename")
        #expect(object["name"] == "Moved.txt")
    }

    @Test("move-file response decodes cancel resource")
    func responseDecodesCancelResource() throws {
        let data = Data(#"{"result":"success","data":{"cancel_id":"abc","valid_until":1710000100}}"#.utf8)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<KDriveCancelResource>.self, from: data)

        #expect(response.data.cancelId == "abc")
        #expect(response.data.validUntil == 1_710_000_100)
    }
}
