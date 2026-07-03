import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKDrive

@Suite("kDrive category requests")
struct KDriveCategoryRequestTests {
    @Test("kDrive categories request matches the OpenAPI path")
    func kDriveCategoriesRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.listCategories(driveId: 100)

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/2/drive/100/categories")
        #expect(URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems == [])
    }

    @Test("kDrive create category request matches the OpenAPI path and body")
    func kDriveCreateCategoryRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = try KDriveRequests.createCategory(
            driveId: 100,
            options: CreateKDriveCategoryOptions(name: "Important", color: "#FF1493")
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let body = try #require(urlRequest.httpBody)
        let object = try #require(JSONSerialization.jsonObject(with: body) as? [String: Any])

        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(urlRequest.url?.path == "/2/drive/100/categories")
        #expect(object["name"] as? String == "Important")
        #expect(object["color"] as? String == "#FF1493")
    }

    @Test("kDrive update category request matches the OpenAPI path and body")
    func kDriveUpdateCategoryRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = try KDriveRequests.updateCategory(
            driveId: 100,
            categoryId: 42,
            options: UpdateKDriveCategoryOptions(name: "Updated", color: "#00FFAA")
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let body = try #require(urlRequest.httpBody)
        let object = try #require(JSONSerialization.jsonObject(with: body) as? [String: Any])

        #expect(urlRequest.httpMethod == "PUT")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(urlRequest.url?.path == "/2/drive/100/categories/42")
        #expect(object["name"] as? String == "Updated")
        #expect(object["color"] as? String == "#00FFAA")
    }

    @Test("kDrive delete category request matches the OpenAPI path")
    func kDriveDeleteCategoryRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.deleteCategory(driveId: 100, categoryId: 42)

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.httpMethod == "DELETE")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/2/drive/100/categories/42")
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kDrive add category to file request matches the OpenAPI path")
    func kDriveAddCategoryToFileRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.addCategoryToFile(driveId: 100, fileId: 456, categoryId: 42)

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/2/drive/100/files/456/categories/42")
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kDrive add category to files request matches the OpenAPI path and body")
    func kDriveAddCategoryToFilesRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = try KDriveRequests.addCategoryToFiles(
            driveId: 100,
            categoryId: 42,
            options: KDriveFileCategoryBulkOptions(fileIds: [456, 789])
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let body = try #require(urlRequest.httpBody)
        let object = try #require(JSONSerialization.jsonObject(with: body) as? [String: Any])

        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(urlRequest.url?.path == "/2/drive/100/files/categories/42")
        #expect(object["file_ids"] as? [Int] == [456, 789])
        #expect(object["fileIds"] == nil)
    }

    @Test("kDrive remove category from file request matches the OpenAPI path")
    func kDriveRemoveCategoryFromFileRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.removeCategoryFromFile(driveId: 100, fileId: 456, categoryId: 42)

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.httpMethod == "DELETE")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/2/drive/100/files/456/categories/42")
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kDrive remove category from files request matches the OpenAPI path and body")
    func kDriveRemoveCategoryFromFilesRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = try KDriveRequests.removeCategoryFromFiles(
            driveId: 100,
            categoryId: 42,
            options: KDriveFileCategoryBulkOptions(fileIds: [456, 789])
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let body = try #require(urlRequest.httpBody)
        let object = try #require(JSONSerialization.jsonObject(with: body) as? [String: Any])

        #expect(urlRequest.httpMethod == "DELETE")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(urlRequest.url?.path == "/2/drive/100/files/categories/42")
        #expect(object["file_ids"] as? [Int] == [456, 789])
        #expect(object["fileIds"] == nil)
    }

    @Test("kDrive remove all categories from file request matches the OpenAPI path")
    func kDriveRemoveCategoriesFromFileRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.removeCategoriesFromFile(driveId: 100, fileId: 456)

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.httpMethod == "DELETE")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/2/drive/100/files/456/categories")
        #expect(urlRequest.httpBody == nil)
    }

    @Test("kDrive categories response decodes using Swift API names")
    func kDriveCategoriesResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": [
            {
              "id": 1,
              "name": "Important",
              "color": "#FF1493",
              "is_predefined": false,
              "created_by": 10,
              "created_at": 1710000000,
              "user_uses": 2
            }
          ]
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<[KDriveCategory]>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.first?.name == "Important")
        #expect(response.data.first?.isPredefined == false)
        #expect(response.data.first?.userUses == 2)
    }

    @Test("kDrive category response decodes using Swift API names")
    func kDriveCategoryResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": {
            "id": 1,
            "name": "Important",
            "color": "#FF1493",
            "is_predefined": false,
            "created_by": 10,
            "created_at": 1710000000,
            "user_uses": 2
          }
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<KDriveCategory>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.id == 1)
        #expect(response.data.name == "Important")
        #expect(response.data.color == "#FF1493")
        #expect(response.data.isPredefined == false)
        #expect(response.data.userUses == 2)
    }

    @Test("kDrive file category feedback decodes")
    func kDriveFileCategoryFeedbackDecodes() throws {
        let json = #"{"result":"success","data":{"id":456,"result":true}}"#.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<KDriveFileCategoryFeedback>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data == KDriveFileCategoryFeedback(id: 456, result: true))
    }

    @Test("kDrive file category feedback array decodes")
    func kDriveFileCategoryFeedbackArrayDecodes() throws {
        let json = #"{"result":"success","data":[{"id":456,"result":true},{"id":789,"result":false,"message":"access_denied"}]}"#.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<[KDriveFileCategoryFeedback]>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data == [
            KDriveFileCategoryFeedback(id: 456, result: true),
            KDriveFileCategoryFeedback(id: 789, result: false, message: "access_denied"),
        ])
    }

    @Test("kDrive boolean category mutation responses decode")
    func kDriveBooleanCategoryMutationResponsesDecode() throws {
        let json = #"{"result":"success","data":true}"#.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<Bool>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data == true)
    }
}
