import Foundation

/// A high-level service for Infomaniak Mail API operations.
public struct MailService: Sendable {
    private let client: InfomaniakAPIClient

    /// Creates a Mail service backed by an API client.
    public init(client: InfomaniakAPIClient) {
        self.client = client
    }

    /// Creates a Mail service for the default Infomaniak API host.
    public init(bearerToken: String) {
        self.client = InfomaniakAPIClient(
            configuration: APIClientConfiguration(bearerToken: bearerToken)
        )
    }

    /// Creates a Mail service for the default Infomaniak Mail application API host.
    public static func mailHost(bearerToken: String) -> MailService {
        MailService(
            client: InfomaniakAPIClient(
                configuration: APIClientConfiguration(
                    baseURL: APIClientConfiguration.defaultMailBaseURL,
                    bearerToken: bearerToken
                )
            )
        )
    }

    /// Lists mailboxes for a mail hosting service.
    public func listMailboxes(
        mailHostingId: Int,
        options: ListMailboxesOptions = ListMailboxesOptions()
    ) async throws -> PaginatedInfomaniakResponse<[MailMailbox]> {
        try await client.send(MailRequests.listMailboxes(mailHostingId: mailHostingId, options: options))
    }

    /// Lists mailboxes available to the authenticated user.
    public func listUserMailboxes(includedResources: String? = "unseen,aliases") async throws -> InfomaniakResponse<[UserMailbox]> {
        try await client.send(MailRequests.listUserMailboxes(includedResources: includedResources))
    }

    /// Reads the current my kSuite with optional mailbox details.
    public func currentMyKSuite(includedResources: String? = "mail") async throws -> InfomaniakResponse<CurrentMyKSuite> {
        try await client.send(MailRequests.currentMyKSuite(includedResources: includedResources))
    }
}
