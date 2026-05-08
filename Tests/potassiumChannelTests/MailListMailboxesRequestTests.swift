import Foundation
import Testing
@testable import potassiumChannel

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
