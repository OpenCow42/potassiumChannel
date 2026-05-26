import Foundation
import Testing
@testable import potassiumChannel

@Suite("kDrive activity report requests")
struct KDriveActivityReportRequestTests {
    @Test("kDrive activity reports request matches the OpenAPI path and query")
    func kDriveActivityReportsRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.listActivityReports(driveId: 100, page: 1, perPage: 25)

        let urlRequest = try await client.makeURLRequest(for: request)
        let queryItems = URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems ?? []

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/2/drive/100/activities/reports")
        #expect(queryItems.contains(URLQueryItem(name: "page", value: "1")))
        #expect(queryItems.contains(URLQueryItem(name: "per_page", value: "25")))
    }

    @Test("kDrive activity report request matches the OpenAPI path")
    func kDriveActivityReportRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.getActivityReport(driveId: 100, reportId: 42)

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/2/drive/100/activities/reports/42")
        #expect(URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems == [])
    }

    @Test("kDrive create activity report request matches the OpenAPI path and body")
    func kDriveCreateActivityReportRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = try KDriveRequests.createActivityReport(
            driveId: 100,
            options: CreateKDriveActivityReportOptions(
                actions: ["file_create", "file_update"],
                depth: "file",
                files: [123, 456],
                from: 1_710_000_000,
                language: "fr",
                terms: "quarterly",
                until: 1_710_086_400,
                userId: 42,
                users: [42, 43]
            )
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let body = try #require(urlRequest.httpBody)
        let payload = try #require(JSONSerialization.jsonObject(with: body) as? [String: Any])

        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(urlRequest.url?.path == "/2/drive/100/activities/reports")
        #expect(URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems == [])
        #expect(payload["actions"] as? [String] == ["file_create", "file_update"])
        #expect(payload["depth"] as? String == "file")
        #expect(payload["files"] as? [Int] == [123, 456])
        #expect(payload["from"] as? Int == 1_710_000_000)
        #expect(payload["lang"] as? String == "fr")
        #expect(payload["terms"] as? String == "quarterly")
        #expect(payload["until"] as? Int == 1_710_086_400)
        #expect(payload["user_id"] as? Int == 42)
        #expect(payload["users"] as? [Int] == [42, 43])
    }

    @Test("kDrive export activity report request matches the OpenAPI path and CSV accept header")
    func kDriveExportActivityReportRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.exportActivityReport(driveId: 100, reportId: 42)

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "text/csv")
        #expect(urlRequest.url?.path == "/2/drive/100/activities/reports/42/export")
        #expect(URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems == [])
    }

    @Test("kDrive delete activity report request matches the OpenAPI path")
    func kDriveDeleteActivityReportRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.deleteActivityReport(driveId: 100, reportId: 42)

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.httpMethod == "DELETE")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/2/drive/100/activities/reports/42")
        #expect(URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems == [])
    }

    @Test("kDrive activity report required path parameters are encoded into the URL")
    func kDriveActivityReportRequiredParametersAreNotOmitted() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.getActivityReport(driveId: 123, reportId: 456)

        let urlRequest = try await client.makeURLRequest(for: request)
        let path = try #require(urlRequest.url?.path)

        #expect(path == "/2/drive/123/activities/reports/456")
        #expect(!path.contains("{drive_id}"))
        #expect(!path.contains("{report_id}"))
        #expect(urlRequest.url?.pathComponents.contains("123") == true)
        #expect(urlRequest.url?.pathComponents.contains("456") == true)
    }

    @Test("kDrive delete activity report required path parameters are encoded into the URL")
    func kDriveDeleteActivityReportRequiredParametersAreNotOmitted() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.deleteActivityReport(driveId: 123, reportId: 456)

        let urlRequest = try await client.makeURLRequest(for: request)
        let path = try #require(urlRequest.url?.path)

        #expect(path == "/2/drive/123/activities/reports/456")
        #expect(!path.contains("{drive_id}"))
        #expect(!path.contains("{report_id}"))
        #expect(urlRequest.url?.pathComponents.contains("123") == true)
        #expect(urlRequest.url?.pathComponents.contains("456") == true)
    }

    @Test("kDrive export activity report required path parameters are encoded into the URL")
    func kDriveExportActivityReportRequiredParametersAreNotOmitted() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = KDriveRequests.exportActivityReport(driveId: 123, reportId: 456)

        let urlRequest = try await client.makeURLRequest(for: request)
        let path = try #require(urlRequest.url?.path)

        #expect(path == "/2/drive/123/activities/reports/456/export")
        #expect(!path.contains("{drive_id}"))
        #expect(!path.contains("{report_id}"))
        #expect(urlRequest.url?.pathComponents.contains("123") == true)
        #expect(urlRequest.url?.pathComponents.contains("456") == true)
    }

    @Test("kDrive activity reports response decodes using Swift API names")
    func kDriveActivityReportsResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": [
            {
              "id": 1,
              "status": "done",
              "size": "2048",
              "generated_by": {
                "id": 42,
                "display_name": "Ada Lovelace",
                "first_name": "Ada",
                "last_name": "Lovelace",
                "email": "ada@example.com",
                "is_sso": false,
                "avatar": null,
                "deleted_at": null
              },
              "download_url": "https://example.com/report.csv",
              "created_at": 1710000000,
              "updated_at": 1710000100
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

        let response = try decoder.decode(PaginatedInfomaniakResponse<[KDriveActivityReport]>.self, from: json)

        #expect(response.result == "success")
        #expect(response.total == 1)
        #expect(response.data.first?.status == "done")
        #expect(response.data.first?.generatedBy.displayName == "Ada Lovelace")
        #expect(response.data.first?.downloadUrl == "https://example.com/report.csv")
    }

    @Test("kDrive create and delete activity report responses decode")
    func kDriveCreateAndDeleteActivityReportResponsesDecode() throws {
        let createJSON = """
        {
          "result": "success",
          "data": 123
        }
        """.data(using: .utf8)!
        let deleteJSON = """
        {
          "result": "success",
          "data": true
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let createResponse = try decoder.decode(InfomaniakResponse<Int>.self, from: createJSON)
        let deleteResponse = try decoder.decode(InfomaniakResponse<Bool>.self, from: deleteJSON)

        #expect(createResponse.result == "success")
        #expect(createResponse.data == 123)
        #expect(deleteResponse.result == "success")
        #expect(deleteResponse.data == true)
    }

    @Test("kDrive activity report response decodes using Swift API names")
    func kDriveActivityReportResponseDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": {
            "id": 1,
            "status": "done",
            "size": "2048",
            "generated_by": {
              "id": 42,
              "display_name": "Ada Lovelace",
              "first_name": "Ada",
              "last_name": "Lovelace",
              "email": "ada@example.com",
              "is_sso": false,
              "avatar": null,
              "deleted_at": null
            },
            "download_url": "https://example.com/report.csv",
            "created_at": 1710000000,
            "updated_at": 1710000100
          }
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<KDriveActivityReport>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.id == 1)
        #expect(response.data.status == "done")
        #expect(response.data.generatedBy.displayName == "Ada Lovelace")
        #expect(response.data.downloadUrl == "https://example.com/report.csv")
    }
}
