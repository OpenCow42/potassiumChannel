import Foundation
import Testing
import PotassiumChannelCore
@testable import PotassiumMail

@Suite("Mail mailbox listing requests")
struct MailListMailboxesRequestTests {
    @Test("Mail list mailboxes request matches the OpenAPI path")
    func mailListMailboxesRequestMatchesOpenAPIShape() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(
                baseURL: URL(string: "https://api.infomaniak.com")!,
                bearerToken: "test-token"
            )
        )
        let request = MailRequests.listMailboxes(mailHostingId: 123)

        let urlRequest = try await client.makeURLRequest(for: request)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.url?.path == "/1/mail_hostings/123/mailboxes")
        #expect(URLComponents(url: try #require(urlRequest.url), resolvingAgainstBaseURL: false)?.queryItems == [])
    }

    @Test("Mail list mailboxes encodes optional query parameters")
    func mailListMailboxesEncodesOptionalQueryParameters() async throws {
        let client = InfomaniakAPIClient(configuration: APIClientConfiguration(bearerToken: "test-token"))
        let request = MailRequests.listMailboxes(
            mailHostingId: 123,
            options: ListMailboxesOptions(
                search: "alice",
                filterBy: "active",
                includedResources: "aliases",
                returnedFields: "mail,mailIDN",
                limit: 50,
                skip: 5,
                page: 2,
                perPage: 25,
                orderBy: "created_at",
                order: "desc",
                orderFor: ["mailIDN": "asc"],
                filters: ["has_alias": "true"]
            )
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)
        let queryItems = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems)
        let pairs = Set(queryItems.map { "\($0.name)=\($0.value ?? "")" })

        #expect(pairs.contains("search=alice"))
        #expect(pairs.contains("filter_by=active"))
        #expect(pairs.contains("with=aliases"))
        #expect(pairs.contains("return=mail,mailIDN"))
        #expect(pairs.contains("limit=50"))
        #expect(pairs.contains("skip=5"))
        #expect(pairs.contains("page=2"))
        #expect(pairs.contains("per_page=25"))
        #expect(pairs.contains("order_by=created_at"))
        #expect(pairs.contains("order=desc"))
        #expect(pairs.contains("order_for[mailIDN]=asc"))
        #expect(pairs.contains("filter[has_alias]=true"))
    }

    @Test("Mail list mailboxes required path parameter is encoded into the URL")
    func mailListMailboxesRequiredParametersAreNotOmitted() async throws {
        let client = InfomaniakAPIClient(configuration: APIClientConfiguration(bearerToken: "test-token"))
        let request = MailRequests.listMailboxes(mailHostingId: 456)

        let urlRequest = try await client.makeURLRequest(for: request)
        let path = try #require(urlRequest.url?.path)

        #expect(path == "/1/mail_hostings/456/mailboxes")
        #expect(!path.contains("{mail_hosting_id}"))
        #expect(urlRequest.url?.pathComponents.contains("456") == true)
    }

    @Test("Mail list mailboxes response decodes mailbox payloads with pagination")
    func mailListMailboxesResponseDecodesMailboxPayloads() throws {
        let json = """
        {
          "result": "success",
          "data": [
            {
              "id": 42,
              "mail": "alice@example.com",
              "mailIDN": "alice@example.com",
              "is_auth": true,
              "quota": null
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

        let response = try decoder.decode(PaginatedInfomaniakResponse<[MailMailbox]>.self, from: json)
        let mailbox = try #require(response.data.first)

        #expect(response.result == "success")
        #expect(response.total == 1)
        #expect(mailbox.values["id"] == .number(42))
        #expect(mailbox.values["mail"] == .string("alice@example.com"))
        #expect(mailbox.values["mailIDN"] == .string("alice@example.com"))
        #expect(mailbox.values["is_auth"] == .bool(true))
        #expect(mailbox.values["quota"] == .null)
    }
}

extension MailListMailboxesRequestTests {
    @Test("Mail list hosting accounts request encodes accounts path")
    func listMailHostingAccountsRequestEncodesAccountsPath() async throws {
        let client = InfomaniakAPIClient(configuration: APIClientConfiguration(bearerToken: "test-token"))
        let request = MailRequests.listMailHostingAccounts(mailHostingId: 123456)

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(url.path == "/1/mail_hostings/123456/accounts")
    }

    @Test("Mail list hosting accounts response decodes flexible accounts payload")
    func listMailHostingAccountsResponseDecodesFlexiblePayload() throws {
        let json = """
        {
          "result": "success",
          "data": {
            "accounts": ["user@example.com", "other@example.com"]
          }
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<MailHostingAccounts>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.values["accounts"] == .array([.string("user@example.com"), .string("other@example.com")]))
    }

    @Test("Mail get mailbox request encodes mailbox settings path")
    func getMailboxRequestEncodesSettingsPath() async throws {
        let client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(bearerToken: "test-token")
        )
        let request = MailRequests.getMailbox(mailHostingId: 123456, mailboxName: "user@example.com")

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(urlRequest.httpMethod == "GET")
        #expect(url.path == "/1/mail_hostings/123456/mailboxes/user@example.com")
    }

    @Test("Mail get mailbox response decodes flexible settings payload")
    func getMailboxResponseDecodesFlexibleSettingsPayload() throws {
        let json = """
        {
          "result": "success",
          "data": {
            "mail": "user@example.com",
            "mailbox_id": 42,
            "quota": null
          }
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<MailMailbox>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.values["mail"] == .string("user@example.com"))
        #expect(response.data.values["mailbox_id"] == .number(42))
    }

    @Test("Mail list mailbox aliases request encodes aliases path")
    func listMailboxAliasesRequestEncodesAliasesPath() async throws {
        let client = InfomaniakAPIClient(configuration: APIClientConfiguration(bearerToken: "test-token"))
        let request = MailRequests.listMailboxAliases(mailHostingId: 123456, mailboxName: "user@example.com")

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(url.path == "/1/mail_hostings/123456/mailboxes/user@example.com/aliases")
    }

    @Test("Mail list mailbox aliases response decodes flexible aliases payload")
    func listMailboxAliasesResponseDecodesFlexiblePayload() throws {
        let json = """
        {
          "result": "success",
          "data": {
            "enabled_alias": 1,
            "aliases": ["alias@example.com"]
          }
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<MailboxAliases>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.values["enabled_alias"] == .number(1))
        #expect(response.data.values["aliases"] == .array([.string("alias@example.com")]))
    }

    @Test("Mail list mailbox forwarding request encodes forwarding path")
    func listMailboxForwardingRequestEncodesForwardingPath() async throws {
        let client = InfomaniakAPIClient(configuration: APIClientConfiguration(bearerToken: "test-token"))
        let request = MailRequests.listMailboxForwarding(mailHostingId: 123456, mailboxName: "user@example.com")

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(url.path == "/1/mail_hostings/123456/mailboxes/user@example.com/forwarding_addresses")
    }

    @Test("Mail list mailbox forwarding response decodes flexible forwarding payload")
    func listMailboxForwardingResponseDecodesFlexiblePayload() throws {
        let json = """
        {
          "result": "success",
          "data": {
            "is_enabled": "1",
            "has_dont_deliver": "0",
            "has_forward_spam": "1",
            "redirect_adresses": [
              { "email": "forward@example.com", "email_idn": "forward@example.com" }
            ]
          }
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<MailboxForwarding>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.values["is_enabled"] == .string("1"))
        #expect(response.data.values["redirect_adresses"] == .array([
            .object(["email": .string("forward@example.com"), "email_idn": .string("forward@example.com")])
        ]))
    }

    @Test("Mail add mailbox alias request encodes alias payload")
    func addMailboxAliasRequestEncodesAliasPayload() async throws {
        let client = InfomaniakAPIClient(configuration: APIClientConfiguration(bearerToken: "test-token"))
        let request = try MailRequests.addMailboxAlias(
            mailHostingId: 123456,
            mailboxName: "user@example.com",
            alias: "potassium-disposable-alias"
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)
        let body = try #require(urlRequest.httpBody)
        let payload = try JSONDecoder().decode(AddMailboxAliasPayload.self, from: body)

        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(url.path == "/1/mail_hostings/123456/mailboxes/user@example.com/aliases")
        #expect(payload.alias == "potassium-disposable-alias")
    }

    @Test("Mail add mailbox alias response decodes boolean success")
    func addMailboxAliasResponseDecodesBooleanSuccess() throws {
        let json = """
        {
          "result": "success",
          "data": true
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<Bool>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data == true)
    }

    @Test("Mail add mailbox forwarding request encodes forwarding payload")
    func addMailboxForwardingRequestEncodesForwardingPayload() async throws {
        let client = InfomaniakAPIClient(configuration: APIClientConfiguration(bearerToken: "test-token"))
        let request = try MailRequests.addMailboxForwarding(
            mailHostingId: 123456,
            mailboxName: "user@example.com",
            redirectAddress: "forward@example.net"
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)
        let body = try #require(urlRequest.httpBody)
        let payload = try JSONDecoder().decode(AddMailboxForwardingPayload.self, from: body)

        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(url.path == "/1/mail_hostings/123456/mailboxes/user@example.com/forwarding_addresses")
        #expect(payload.redirectAddress == "forward@example.net")
    }

    @Test("Mail add mailbox forwarding response decodes created forwarding payload")
    func addMailboxForwardingResponseDecodesCreatedPayload() throws {
        let json = """
        {
          "result": "success",
          "data": {
            "redirect_address": "forward@example.net",
            "is_enabled": true
          }
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<CreatedMailboxForwarding>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data.values["redirect_address"] == .string("forward@example.net"))
        #expect(response.data.values["is_enabled"] == .bool(true))
    }

    @Test("Mail delete mailbox alias request encodes alias path")
    func deleteMailboxAliasRequestEncodesAliasPath() async throws {
        let client = InfomaniakAPIClient(configuration: APIClientConfiguration(bearerToken: "test-token"))
        let request = MailRequests.deleteMailboxAlias(
            mailHostingId: 123456,
            mailboxName: "user@example.com",
            alias: "potassium-disposable-alias"
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(urlRequest.httpMethod == "DELETE")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.httpBody == nil)
        #expect(url.path == "/1/mail_hostings/123456/mailboxes/user@example.com/aliases/potassium-disposable-alias")
    }

    @Test("Mail delete mailbox alias response decodes boolean success")
    func deleteMailboxAliasResponseDecodesBooleanSuccess() throws {
        let json = """
        {
          "result": "success",
          "data": true
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<Bool>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data == true)
    }

    @Test("Mail delete mailbox forwarding request encodes forwarding address path")
    func deleteMailboxForwardingRequestEncodesForwardingAddressPath() async throws {
        let client = InfomaniakAPIClient(configuration: APIClientConfiguration(bearerToken: "test-token"))
        let request = MailRequests.deleteMailboxForwarding(
            mailHostingId: 123456,
            mailboxName: "user@example.com",
            redirectAddress: "potassium-disposable-forward@example.net"
        )

        let urlRequest = try await client.makeURLRequest(for: request)
        let url = try #require(urlRequest.url)

        #expect(urlRequest.httpMethod == "DELETE")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(urlRequest.httpBody == nil)
        #expect(url.path == "/1/mail_hostings/123456/mailboxes/user@example.com/forwarding_addresses/potassium-disposable-forward@example.net")
    }

    @Test("Mail delete mailbox forwarding response decodes boolean success")
    func deleteMailboxForwardingResponseDecodesBooleanSuccess() throws {
        let json = """
        {
          "result": "success",
          "data": true
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(InfomaniakResponse<Bool>.self, from: json)

        #expect(response.result == "success")
        #expect(response.data == true)
    }
}
