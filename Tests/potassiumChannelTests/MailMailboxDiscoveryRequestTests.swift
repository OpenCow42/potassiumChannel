import Foundation
import Testing
@testable import potassiumChannel

@Suite("Mail mailbox discovery requests")
struct MailMailboxDiscoveryRequestTests {
    @Test("Mail user mailboxes request uses the Mail host API path")
    func mailUserMailboxesRequestMatchesAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: APIClientConfiguration.defaultMailBaseURL,
                bearerToken: "test-token"
            )
        )
        let request = MailRequests.listUserMailboxes()

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)
        let queryItems = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(url.host == "mail.infomaniak.com")
        #expect(url.path == "/api/mailbox")
        #expect(queryItems == [URLQueryItem(name: "with", value: "unseen,aliases")])
    }

    @Test("Mail folders request uses the mailbox UUID path")
    func mailFoldersRequestMatchesAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: APIClientConfiguration.defaultMailBaseURL,
                bearerToken: "test-token"
            )
        )
        let request = MailRequests.listFolders(mailboxUUID: "904443a9-fb09-3b09-b05a-6062dac0cbb6")

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)
        let queryItems = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems)

        #expect(urlRequest.httpMethod == "GET")
        #expect(url.host == "mail.infomaniak.com")
        #expect(url.path == "/api/mail/904443a9-fb09-3b09-b05a-6062dac0cbb6/folder")
        #expect(queryItems == [URLQueryItem(name: "with", value: "ik-static")])
    }

    @Test("Mail folders response decodes flexible folder payloads")
    func mailFoldersResponseDecodesFlexiblePayloads() throws {
        let json = """
        {
          "result": "success",
          "data": [
            {
              "id": "inbox",
              "name": "Inbox",
              "role": "inbox",
              "path": "INBOX",
              "unread_count": 2,
              "thread_count": 4,
              "children": []
            }
          ]
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<[MailFolder]>.self, from: json)
        let folder = try #require(response.data.first)

        #expect(response.result == "success")
        #expect(folder.values["id"] == .string("inbox"))
        #expect(folder.values["name"] == .string("Inbox"))
        #expect(folder.values["role"] == .string("inbox"))
        #expect(folder.values["path"] == .string("INBOX"))
        #expect(folder.values["unread_count"] == .number(2))
        #expect(folder.values["thread_count"] == .number(4))
        #expect(folder.values["children"] == .array([]))
    }

    @Test("Current my kSuite request includes mailbox details")
    func currentMyKSuiteRequestMatchesAPIShape() async throws {
        let client = InfomaniakAPIClient(configuration: APIClientConfiguration(bearerToken: "test-token"))
        let request = MailRequests.currentMyKSuite()

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)
        let queryItems = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems)

        #expect(urlRequest.httpMethod == "GET")
        #expect(url.host == "api.infomaniak.com")
        #expect(url.path == "/1/my_ksuite/current")
        #expect(queryItems == [URLQueryItem(name: "with", value: "mail")])
    }

    @Test("Mail user mailboxes response decodes flexible mailbox payloads")
    func mailUserMailboxesResponseDecodesFlexiblePayloads() throws {
        let json = """
        {
          "result": "success",
          "data": [
            {
              "uuid": "904443a9-fb09-3b09-b05a-6062dac0cbb6",
              "email": "person@example.com",
              "mailbox": "person",
              "access_id": "u1812064",
              "hosting_id": 497445,
              "is_primary": true
            }
          ]
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<[UserMailbox]>.self, from: json)
        let mailbox = try #require(response.data.first)

        #expect(response.result == "success")
        #expect(mailbox.values["uuid"] == .string("904443a9-fb09-3b09-b05a-6062dac0cbb6"))
        #expect(mailbox.values["email"] == .string("person@example.com"))
        #expect(mailbox.values["mailbox"] == .string("person"))
        #expect(mailbox.values["access_id"] == .string("u1812064"))
        #expect(mailbox.values["hosting_id"] == .number(497445))
        #expect(mailbox.values["is_primary"] == .bool(true))
    }

    @Test("Current my kSuite response decodes mailbox details")
    func currentMyKSuiteResponseDecodesMailboxDetails() throws {
        let json = """
        {
          "result": "success",
          "data": {
            "id": 585542,
            "status": "active",
            "mail": {
              "id": 605905,
              "email": "person@example.com",
              "mailbox_id": 3551996
            }
          }
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<CurrentMyKSuite>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.values["id"] == .number(585542))
        #expect(response.data.values["status"] == .string("active"))
        #expect(response.data.values["mail"] == .object([
            "id": .number(605905),
            "email": .string("person@example.com"),
            "mailbox_id": .number(3551996),
        ]))
    }
}
