import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKDrive

@Suite("kDrive rename-file request")
struct KDriveRenameFileRequestTests {
    @Test("kDrive rename-file request matches the OpenAPI v2 shape")
    func requestMatchesRequestedV3Shape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let body = Data(#"{"name":"Renamed.txt"}"#.utf8)
        let request = KDriveRequests.renameFileV2(driveId: 100, fileId: 42, body: body)

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/2/drive/100/files/42/rename")
        #expect(urlRequest.httpBody == request.body)
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
    }

    @Test("rename file options encode the required name parameter")
    func optionsEncodeOpenAPIBody() throws {
        let options = RenameKDriveFileOptions(name: "Renamed.txt")

        let object = try JSONSerialization.jsonObject(with: JSONEncoder().encode(options)) as? [String: Any]

        #expect(object?["name"] as? String == "Renamed.txt")
    }
}
