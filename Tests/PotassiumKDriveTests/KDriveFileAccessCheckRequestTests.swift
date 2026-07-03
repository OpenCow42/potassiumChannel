import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumKDrive

@Suite("kDrive file access check requests")
struct KDriveFileAccessCheckRequestTests {
    @Test("kDrive file access change check request matches the OpenAPI path and body")
    func kDriveFileAccessChangeCheckRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = try KDriveRequests.checkFileAccessChange(
            driveId: 100,
            fileId: 42,
            options: CheckKDriveFileAccessChangeOptions(
                emails: ["person@example.com"],
                userIds: [7],
                teamIds: [9],
                right: "read",
                language: "fr"
            )
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let body = try #require(urlRequest.httpBody)
        let object = try #require(JSONSerialization.jsonObject(with: body) as? [String: Any])

        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(urlRequest.url?.path == "/2/drive/100/files/42/access/check")
        #expect(object["emails"] as? [String] == ["person@example.com"])
        #expect(object["user_ids"] as? [Int] == [7])
        #expect(object["team_ids"] as? [Int] == [9])
        #expect(object["right"] as? String == "read")
        #expect(object["lang"] as? String == "fr")
    }

    @Test("kDrive file access change check required path parameters are encoded into the URL")
    func kDriveFileAccessChangeCheckRequiredParametersAreNotOmitted() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = try KDriveRequests.checkFileAccessChange(
            driveId: 123,
            fileId: 456,
            options: CheckKDriveFileAccessChangeOptions(userIds: [7], right: "write")
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let path = try #require(urlRequest.url?.path)

        #expect(path == "/2/drive/123/files/456/access/check")
        #expect(!path.contains("{drive_id}"))
        #expect(!path.contains("{file_id}"))
        #expect(urlRequest.url?.pathComponents.contains("123") == true)
        #expect(urlRequest.url?.pathComponents.contains("456") == true)
    }

    @Test("kDrive file access invitation check request matches the OpenAPI path and body")
    func kDriveFileAccessInvitationCheckRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = try KDriveRequests.checkFileAccessInvitations(
            driveId: 100,
            fileId: 42,
            options: CheckKDriveFileAccessInvitationsOptions(
                emails: ["person@example.com"],
                userIds: [7]
            )
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let body = try #require(urlRequest.httpBody)
        let object = try #require(JSONSerialization.jsonObject(with: body) as? [String: Any])

        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(urlRequest.url?.path == "/2/drive/100/files/42/access/invitations/check")
        #expect(object["emails"] as? [String] == ["person@example.com"])
        #expect(object["user_ids"] as? [Int] == [7])
    }

    @Test("kDrive file access invitation check required path parameters are encoded into the URL")
    func kDriveFileAccessInvitationCheckRequiredParametersAreNotOmitted() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = try KDriveRequests.checkFileAccessInvitations(
            driveId: 123,
            fileId: 456,
            options: CheckKDriveFileAccessInvitationsOptions(userIds: [7])
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let path = try #require(urlRequest.url?.path)

        #expect(path == "/2/drive/123/files/456/access/invitations/check")
        #expect(!path.contains("{drive_id}"))
        #expect(!path.contains("{file_id}"))
        #expect(urlRequest.url?.pathComponents.contains("123") == true)
        #expect(urlRequest.url?.pathComponents.contains("456") == true)
    }

    @Test("kDrive file access change feedback decodes")
    func kDriveFileAccessChangeFeedbackDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": [
            {
              "user_id": 7,
              "current_right": "read",
              "need_change": false,
              "message": "user_right_is_same_level"
            }
          ]
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<[KDriveFileAccessChangeFeedback]>.self, from: json)
        let feedback = try #require(response.data.first)

        #expect(response.result == "success")
        #expect(feedback.userId == 7)
        #expect(feedback.currentRight == "read")
        #expect(feedback.needChange == false)
        #expect(feedback.message == "user_right_is_same_level")
    }

    @Test("kDrive file access pending invitation feedback decodes nullable identifiers")
    func kDriveFileAccessPendingInvitationFeedbackDecodes() throws {
        let json = """
        {
          "result": "success",
          "data": [
            {
              "invitation_id": null,
              "drive_invitation_id": 42,
              "has_invitation": "drive",
              "user_id": 7,
              "email": "person@example.com"
            }
          ]
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<[KDriveFileAccessPendingInvitationFeedback]>.self, from: json)
        let feedback = try #require(response.data.first)

        #expect(response.result == "success")
        #expect(feedback.invitationId == nil)
        #expect(feedback.driveInvitationId == 42)
        #expect(feedback.hasInvitation == "drive")
        #expect(feedback.userId == 7)
        #expect(feedback.email == "person@example.com")
    }

    @Test("kDrive file access pending invitation feedback decodes boolean invitation state")
    func kDriveFileAccessPendingInvitationFeedbackDecodesBooleanState() throws {
        let json = """
        {
          "result": "success",
          "data": [
            {
              "invitation_id": null,
              "drive_invitation_id": null,
              "has_invitation": false,
              "user_id": 7
            }
          ]
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<[KDriveFileAccessPendingInvitationFeedback]>.self, from: json)
        let feedback = try #require(response.data.first)

        #expect(response.result == "success")
        #expect(feedback.invitationId == nil)
        #expect(feedback.driveInvitationId == nil)
        #expect(feedback.hasInvitation == "false")
        #expect(feedback.userId == 7)
        #expect(feedback.email == nil)
    }
}
