import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumMail

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

    @Test("Mail threads request uses the mailbox UUID and folder path")
    func mailThreadsRequestMatchesAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: APIClientConfiguration.defaultMailBaseURL,
                bearerToken: "test-token"
            )
        )
        let request = MailRequests.listThreads(
            mailboxUUID: "904443a9-fb09-3b09-b05a-6062dac0cbb6",
            folderId: "inbox",
            options: ListMailThreadsOptions(offset: 10, threadMode: "off", filter: "unseen")
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)
        let queryItems = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems)
        let pairs = Set(queryItems.map { "\($0.name)=\($0.value ?? "")" })

        #expect(urlRequest.httpMethod == "GET")
        #expect(url.host == "mail.infomaniak.com")
        #expect(url.path == "/api/mail/904443a9-fb09-3b09-b05a-6062dac0cbb6/folder/inbox/message")
        #expect(pairs.contains("offset=10"))
        #expect(pairs.contains("thread=off"))
        #expect(pairs.contains("filters=unseen"))
        #expect(pairs.contains("with=emoji_reactions_per_message"))
    }

    @Test("Mail threads response decodes flexible thread payloads")
    func mailThreadsResponseDecodesFlexiblePayloads() throws {
        let json = """
        {
          "result": "success",
          "data": {
            "threads": [
              {
                "uid": "42",
                "subject": "Hello",
                "messages_count": 1,
                "unseen_messages": 0,
                "has_attachments": false
              }
            ],
            "total_messages_count": 1,
            "messages_count": 1,
            "current_offset": 0,
            "thread_mode": "on",
            "folder_unseen_messages": 0,
            "resource_next": null
          }
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<MailThreadList>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.values["total_messages_count"] == .number(1))
        #expect(response.data.values["messages_count"] == .number(1))
        #expect(response.data.values["current_offset"] == .number(0))
        #expect(response.data.values["thread_mode"] == .string("on"))
        #expect(response.data.values["resource_next"] == .null)
        #expect(response.data.values["threads"] != nil)
    }

    @Test("Mailbox quota request encodes discovered mailbox fields")
    func mailboxQuotaRequestEncodesDiscoveredFields() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: APIClientConfiguration.defaultMailBaseURL,
                bearerToken: "test-token"
            )
        )
        let request = MailRequests.getMailboxQuota(
            mailbox: "user@example.com",
            productId: 123456,
            options: GetMailboxQuotaOptions(unit: "MB")
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)
        let queryItems = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems)
        let pairs = Set(queryItems.map { "\($0.name)=\($0.value ?? "")" })

        #expect(urlRequest.httpMethod == "GET")
        #expect(url.host == "mail.infomaniak.com")
        #expect(url.path == "/api/mailbox/quotas")
        #expect(pairs.contains("mailbox=user@example.com"))
        #expect(pairs.contains("product_id=123456"))
        #expect(pairs.contains("unit=MB"))
    }

    @Test("Mailbox quota response decodes flexible quota payload")
    func mailboxQuotaResponseDecodesFlexiblePayload() throws {
        let json = """
        {
          "result": "success",
          "data": {
            "size": 6341993,
            "size_checked_at": 1778277659
          }
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<MailboxQuota>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.values["size"] == .number(6341993))
        #expect(response.data.values["size_checked_at"] == .number(1778277659))
    }


    @Test("Create draft request encodes mailbox path and JSON payload")
    func createDraftRequestEncodesMailboxPathAndPayload() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: APIClientConfiguration.defaultMailBaseURL,
                bearerToken: "test-token"
            )
        )
        let payload = MailDraftPayload(
            body: "<p>Hello from tests</p>",
            to: [MailDraftRecipient(email: "recipient@example.com", name: "Recipient")],
            subject: "Draft subject"
        )
        let request = try MailRequests.createDraft(
            mailboxUUID: "904443a9-fb09-3b09-b05a-6062dac0cbb6",
            payload: payload
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)
        let body = try #require(urlRequest.httpBody)
        let object = try #require(JSONSerialization.jsonObject(with: body) as? [String: Any])
        let to = try #require(object["to"] as? [[String: Any]])
        let firstRecipient = try #require(to.first)

        #expect(urlRequest.httpMethod == "POST")
        #expect(url.host == "mail.infomaniak.com")
        #expect(url.path == "/api/mail/904443a9-fb09-3b09-b05a-6062dac0cbb6/draft")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(object["body"] as? String == "<p>Hello from tests</p>")
        #expect(object["subject"] as? String == "Draft subject")
        #expect(object["action"] as? String == "save")
        #expect(object["mime_type"] as? String == "text/html")
        #expect(firstRecipient["email"] as? String == "recipient@example.com")
        #expect(firstRecipient["name"] as? String == "Recipient")
    }


    @Test("Draft follow-up requests use draft UUID path and expected methods")
    func draftFollowUpRequestsUseDraftUUIDPathAndMethods() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: APIClientConfiguration.defaultMailBaseURL,
                bearerToken: "test-token"
            )
        )
        let payload = MailDraftPayload(
            body: "<p>Updated</p>",
            to: [MailDraftRecipient(email: "recipient@example.com")],
            subject: "Updated subject"
        )

        let update = try await client.makeURLRequest(for: MailRequests.updateDraft(
            mailboxUUID: "mailbox-uuid",
            draftUUID: "draft-uuid",
            payload: payload
        ))
        let get = try await client.makeURLRequest(for: MailRequests.getDraft(mailboxUUID: "mailbox-uuid", draftUUID: "draft-uuid"))
        let delete = try await client.makeURLRequest(for: MailRequests.deleteDraft(mailboxUUID: "mailbox-uuid", draftUUID: "draft-uuid"))

        #expect(update.httpMethod == "PUT")
        #expect(get.httpMethod == "GET")
        #expect(delete.httpMethod == "DELETE")
        #expect(update.url?.path == "/api/mail/mailbox-uuid/draft/draft-uuid")
        #expect(get.url?.path == "/api/mail/mailbox-uuid/draft/draft-uuid")
        #expect(delete.url?.path == "/api/mail/mailbox-uuid/draft/draft-uuid")
        #expect(update.httpBody != nil)
        #expect(get.httpBody == nil)
        #expect(delete.httpBody == nil)
    }


    @Test("Draft schedule requests use resource actions and expected methods")
    func draftScheduleRequestsUseResourceActionsAndExpectedMethods() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: APIClientConfiguration.defaultMailBaseURL,
                bearerToken: "test-token"
            )
        )

        let schedule = try await client.makeURLRequest(for: MailRequests.scheduleDraft(
            draftResource: "/api/mail/mailbox-uuid/draft/draft-uuid",
            scheduleDate: "2026-05-10T08:00:00+02:00"
        ))
        let delete = try await client.makeURLRequest(for: MailRequests.deleteSchedule(
            scheduleAction: "/api/mail/mailbox-uuid/draft/draft-uuid/schedule"
        ))
        let cancel = try await client.makeURLRequest(for: MailRequests.cancelSend(
            cancelSendResource: "/api/mail/mailbox-uuid/draft/draft-uuid/cancel"
        ))

        #expect(schedule.httpMethod == "PUT")
        #expect(delete.httpMethod == "DELETE")
        #expect(cancel.httpMethod == "PUT")
        #expect(schedule.url?.path == "/api/mail/mailbox-uuid/draft/draft-uuid/schedule")
        #expect(delete.url?.path == "/api/mail/mailbox-uuid/draft/draft-uuid/schedule")
        #expect(cancel.url?.path == "/api/mail/mailbox-uuid/draft/draft-uuid/cancel")
        #expect(schedule.httpBody != nil)
        #expect(delete.httpBody == nil)
        #expect(cancel.httpBody == nil)

        let decoded = try JSONDecoder().decode(MailDraftSchedulePayload.self, from: try #require(schedule.httpBody))
        #expect(decoded.scheduleDate == "2026-05-10T08:00:00+02:00")
    }

    @Test("Draft schedule response decodes flexible payload")
    func draftScheduleResponseDecodesFlexiblePayload() throws {
        let json = """
        {
          "result": "success",
          "data": {
            "uuid": "schedule-uuid",
            "uid": "123",
            "schedule_action": "/api/mail/mailbox-uuid/draft/draft-uuid/schedule"
          }
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<MailDraftSchedule>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.values["uuid"] == .string("schedule-uuid"))
        #expect(response.data.values["schedule_action"] == .string("/api/mail/mailbox-uuid/draft/draft-uuid/schedule"))
    }

    @Test("Create draft response decodes flexible draft payload")
    func createDraftResponseDecodesFlexiblePayload() throws {
        let json = """
        {
          "result": "success",
          "data": {
            "uuid": "draft-uuid",
            "uid": "123",
            "resource": "/api/mail/mailbox-uuid/draft/draft-uuid",
            "subject": "Draft subject"
          }
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<MailDraft>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.values["uuid"] == .string("draft-uuid"))
        #expect(response.data.values["resource"] == .string("/api/mail/mailbox-uuid/draft/draft-uuid"))
        #expect(response.data.values["subject"] == .string("Draft subject"))
    }

    @Test("Mail message request uses returned resource path")
    func mailMessageRequestMatchesAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: APIClientConfiguration.defaultMailBaseURL,
                bearerToken: "test-token"
            )
        )
        let request = MailRequests.getMessage(
            resource: "/api/mail/904443a9-fb09-3b09-b05a-6062dac0cbb6/folder/inbox/message/42"
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)
        let queryItems = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems)
        let pairs = Set(queryItems.map { "\($0.name)=\($0.value ?? "")" })

        #expect(urlRequest.httpMethod == "GET")
        #expect(url.host == "mail.infomaniak.com")
        #expect(url.path == "/api/mail/904443a9-fb09-3b09-b05a-6062dac0cbb6/folder/inbox/message/42")
        #expect(pairs.contains("prefered_format=html"))
        #expect(pairs.contains("with=auto_uncrypt,recipient_provider_source,emoji_reactions_per_message"))
    }

    @Test("Mail message response decodes flexible message payloads")
    func mailMessageResponseDecodesFlexiblePayloads() throws {
        let json = """
        {
          "result": "success",
          "data": {
            "uid": "42",
            "subject": "Hello",
            "seen": true,
            "has_attachments": false,
            "body": {
              "type": "html",
              "value": "<p>Hello</p>"
            },
            "from": [{ "email": "sender@example.com", "name": "Sender" }]
          }
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<MailMessage>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.values["uid"] == .string("42"))
        #expect(response.data.values["subject"] == .string("Hello"))
        #expect(response.data.values["seen"] == .bool(true))
        #expect(response.data.values["has_attachments"] == .bool(false))
        #expect(response.data.values["body"] != nil)
        #expect(response.data.values["from"] != nil)
    }

    @Test("Mail message move request uses mailbox path and JSON payload")
    func mailMoveMessagesRequestMatchesAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: APIClientConfiguration.defaultMailBaseURL,
                bearerToken: "test-token"
            )
        )
        let request = try MailRequests.moveMessages(
            mailboxUUID: "904443a9-fb09-3b09-b05a-6062dac0cbb6",
            payload: MailMoveMessagesPayload(
                uids: ["31@inbox", "32@inbox"],
                to: "archive"
            )
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)
        let body = try #require(urlRequest.httpBody)
        let object = try #require(JSONSerialization.jsonObject(with: body) as? [String: Any])
        let uids = try #require(object["uids"] as? [String])

        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(url.host == "mail.infomaniak.com")
        #expect(url.path == "/api/mail/904443a9-fb09-3b09-b05a-6062dac0cbb6/message/move")
        #expect(uids == ["31@inbox", "32@inbox"])
        #expect(object["to"] as? String == "archive")
    }

    @Test("Mail message move response decodes undo resource")
    func mailMoveMessagesResponseDecodesUndoResource() throws {
        let json = """
        {
          "result": "success",
          "data": {
            "moved": 2,
            "undo_resource": "/api/mail/mailbox-uuid/undo/move/request-id"
          }
        }
        """.data(using: .utf8)!

        let response = try JSONDecoder().decode(InfomaniakResponse<MailMoveResult>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.moved == 2)
        #expect(response.data.undoResource == "/api/mail/mailbox-uuid/undo/move/request-id")
    }

    @Test("Mail message move response allows missing undo resource")
    func mailMoveMessagesResponseAllowsMissingUndoResource() throws {
        let json = """
        {
          "result": "success",
          "data": {
            "moved": 1
          }
        }
        """.data(using: .utf8)!

        let response = try JSONDecoder().decode(InfomaniakResponse<MailMoveResult>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.moved == 1)
        #expect(response.data.undoResource == nil)
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
