import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKDrive

@Suite("kDrive file-archive-build-post request")
struct KDriveFileArchiveBuildPostRequestTests {
    @Test("kDrive file-archive-build-post request matches the OpenAPI shape")
    func requestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let body = Data(#"{"parent_id":42,"except_file_ids":[7]}"#.utf8)
        let request = KDriveRequests.buildArchive(driveId: 100, body: body)

        let urlRequest = try await client.makeURLRequest(for: request)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems ?? []

        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(urlRequest.url?.path == "/3/drive/100/files/archives")
        #expect(queryItems.isEmpty)
        #expect(urlRequest.httpBody == request.body)
    }

    @Test("build archive options encode file ids as snake-case")
    func optionsEncodeFileIdsBody() throws {
        let options = BuildKDriveArchiveOptions(fileIds: [1, 2])

        let object = try JSONSerialization.jsonObject(with: JSONEncoder().encode(options)) as? [String: Any]

        #expect(object?["file_ids"] as? [Int] == [1, 2])
        #expect(object?["parent_id"] == nil)
        #expect(object?["except_file_ids"] == nil)
        #expect(object?["fileIds"] == nil)
    }

    @Test("build archive options encode parent id and exclusions as snake-case")
    func optionsEncodeParentBody() throws {
        let options = BuildKDriveArchiveOptions(parentId: 42, exceptFileIds: [7])

        let object = try JSONSerialization.jsonObject(with: JSONEncoder().encode(options)) as? [String: Any]

        #expect(object?["parent_id"] as? Int == 42)
        #expect(object?["except_file_ids"] as? [Int] == [7])
        #expect(object?["file_ids"] == nil)
        #expect(object?["parentId"] == nil)
        #expect(object?["exceptFileIds"] == nil)
    }

    @Test("kDrive UUID resource decodes archive uuid")
    func uuidResourceDecodesArchiveUUID() throws {
        let json = #"{"uuid":"archive-uuid"}"#.data(using: .utf8)!

        let resource = try JSONDecoder().decode(KDriveUUIDResource.self, from: json)

        #expect(resource.uuid == "archive-uuid")
    }
}
