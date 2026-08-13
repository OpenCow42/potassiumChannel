import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKDrive

@Suite("kDrive advanced directory listing requests")
struct KDriveAdvancedDirectoryListingRequestTests {
    private static let compatibleIncludedResources = [
        "files",
        "files.capabilities",
        "files.categories",
        "files.conversion_capabilities",
        "files.dropbox",
        "files.dropbox.capabilities",
        "files.external_import",
        "files.is_favorite",
        "files.sharelink",
        "files.sorted_name",
        "files.supported_by",
    ].joined(separator: ",")

    @Test("kDrive advanced directory listing defaults exclude unsupported ETag resources")
    func advancedDirectoryListingDefaultsExcludeETagResources() {
        #expect(KDriveAdvancedListingIncludedResources.minimalFiles == Self.compatibleIncludedResources)
        #expect(KDriveAdvancedListingIncludedResources.minimalFiles.split(separator: ",").contains("etag") == false)
        #expect(KDriveAdvancedListingIncludedResources.minimalFiles.split(separator: ",").contains("files.etag") == false)
    }

    @Test("kDrive advanced directory listing request matches the API path and query")
    func advancedDirectoryListingRequestMatchesAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.listAdvancedDirectoryListing(
            driveId: 100,
            fileId: 42,
            options: ListKDriveAdvancedDirectoryListingOptions(
                limit: 50,
                orderBy: ["type", "name"],
                order: "asc",
                orderFor: ["name": "asc", "type": "asc"]
            )
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems ?? []

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/3/drive/100/files/42/listing")
        #expect(queryItems.contains(URLQueryItem(name: "with", value: Self.compatibleIncludedResources)))
        #expect(queryItems.contains(URLQueryItem(name: "limit", value: "50")))
        #expect(queryItems.contains(URLQueryItem(name: "order_by", value: "type")))
        #expect(queryItems.contains(URLQueryItem(name: "order_by", value: "name")))
        #expect(queryItems.contains(URLQueryItem(name: "order", value: "asc")))
        #expect(queryItems.contains(URLQueryItem(name: "order_for[name]", value: "asc")))
        #expect(queryItems.contains(URLQueryItem(name: "order_for[type]", value: "asc")))
    }

    @Test("kDrive advanced directory listing continuation request includes cursor")
    func advancedDirectoryListingContinuationRequestIncludesCursor() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.continueAdvancedDirectoryListing(
            driveId: 100,
            fileId: 42,
            cursor: "listing-cursor",
            options: ContinueKDriveAdvancedDirectoryListingOptions(limit: 50)
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems ?? []

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.url?.path == "/3/drive/100/files/42/listing/continue")
        #expect(queryItems.contains(URLQueryItem(name: "with", value: Self.compatibleIncludedResources)))
        #expect(queryItems.contains(URLQueryItem(name: "cursor", value: "listing-cursor")))
        #expect(queryItems.contains(URLQueryItem(name: "limit", value: "50")))
    }

    @Test("kDrive partial file activities request posts encoded file activity checks")
    func partialFileActivitiesRequestPostsEncodedChecks() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let options = ListKDrivePartialFileActivitiesOptions(
            files: [
                KDrivePartialFileActivityRequestFile(id: 42, fromDate: 1_710_000_000),
            ]
        )
        let body = try JSONEncoder().encode(options)
        let request = KDriveRequests.listPartialFileActivities(driveId: 100, body: body)

        let urlRequest = try await client.makeURLRequest(for: request)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems ?? []
        let object = try #require(JSONSerialization.jsonObject(with: body) as? [String: Any])
        let actions = try #require(object["actions"] as? [String])
        let files = try #require(object["files"] as? [[String: Any]])

        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.url?.path == "/3/drive/100/files/listing/partial")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(queryItems.contains(URLQueryItem(name: "with", value: KDriveAdvancedListingIncludedResources.file)))
        #expect(actions == ["file_delete", "file_trash", "file_update", "file_rename"])
        #expect(files.first?["id"] as? Int == 42)
        #expect(files.first?["from_date"] as? Int == 1_710_000_000)
        #expect(files.first?["fromDate"] == nil)
    }

    @Test("kDrive advanced directory listing response decodes files and actions")
    func advancedDirectoryListingResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": {
            "actions": [
              {
                "action": "file_update",
                "file_id": 43,
                "parent_id": 42
              },
              {
                "action": "file_rename",
                "file_id": 43,
                "parent_id": 42
              }
            ],
            "files": [
              {
                "id": 43,
                "name": "Nested.pdf",
                "path": "/Documents/Nested.pdf",
                "type": "file",
                "status": "active",
                "visibility": "is_private_space",
                "drive_id": 100,
                "parent_id": 42,
                "depth": 3,
                "created_at": 1710000000,
                "last_modified_at": 1710000100,
                "updated_at": 1710000200,
                "size": 1024,
                "mime_type": "application/pdf",
                "is_favorite": false
              }
            ],
            "actions_files": [
              {
                "id": 44,
                "name": "Renamed.txt",
                "path": "/Documents/Renamed.txt",
                "type": "file",
                "status": "active",
                "visibility": "is_private_space",
                "drive_id": 100,
                "parent_id": 42,
                "depth": 3,
                "created_at": 1710000000,
                "last_modified_at": 1710000100,
                "updated_at": 1710000200,
                "size": 128,
                "mime_type": "text/plain",
                "is_favorite": true
              }
            ]
          },
          "cursor": "next-cursor",
          "has_more": true,
          "response_at": 1710000300
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(CursorPaginatedInfomaniakResponse<KDriveAdvancedDirectoryListing>.self, from: json)

        #expect(response.result == "success")
        #expect(response.cursor == "next-cursor")
        #expect(response.hasMore)
        #expect(response.data.actions.first?.action == "file_update")
        #expect(response.data.actions.first?.fileId == 43)
        #expect(response.data.actionsNewestFirst.map(\.action) == ["file_rename", "file_update"])
        #expect(response.data.files.first?.name == "Nested.pdf")
        #expect(response.data.actionsFiles.first?.id == 44)
        #expect(response.data.actionsFiles.first?.isFavorite == true)
    }

    @Test("kDrive partial file activities response decodes")
    func partialFileActivitiesResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": [
            {
              "last_action": "file_update",
              "file_id": 43,
              "last_action_at": 1710000200,
              "file": {
                "id": 43,
                "name": "Nested.pdf",
                "path": "/Documents/Nested.pdf",
                "type": "file",
                "status": "active",
                "visibility": "is_private_space",
                "drive_id": 100,
                "parent_id": 42,
                "depth": 3,
                "created_at": 1710000000,
                "last_modified_at": 1710000100,
                "updated_at": 1710000200,
                "size": 1024,
                "mime_type": "application/pdf",
                "is_favorite": false
              }
            }
          ]
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<[KDrivePartialFileActivity]>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.first?.lastAction == "file_update")
        #expect(response.data.first?.fileId == 43)
        #expect(response.data.first?.lastActionAt == 1_710_000_200)
        #expect(response.data.first?.file?.name == "Nested.pdf")
    }
}
