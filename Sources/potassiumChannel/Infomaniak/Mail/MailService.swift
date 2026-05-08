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

    /// Lists folders for a mailbox.
    public func listFolders(mailboxUUID: String, includedResources: String? = "ik-static") async throws -> InfomaniakResponse<[MailFolder]> {
        try await client.send(MailRequests.listFolders(mailboxUUID: mailboxUUID, includedResources: includedResources))
    }

    /// Lists threads/messages for a mailbox folder.
    public func listThreads(
        mailboxUUID: String,
        folderId: String,
        options: ListMailThreadsOptions = ListMailThreadsOptions()
    ) async throws -> InfomaniakResponse<MailThreadList> {
        try await client.send(MailRequests.listThreads(mailboxUUID: mailboxUUID, folderId: folderId, options: options))
    }

    /// Reads quota information for a discovered mailbox.
    public func getMailboxQuota(
        mailbox: String,
        productId: Int,
        options: GetMailboxQuotaOptions = GetMailboxQuotaOptions()
    ) async throws -> InfomaniakResponse<MailboxQuota> {
        try await client.send(MailRequests.getMailboxQuota(mailbox: mailbox, productId: productId, options: options))
    }

    /// Reads a message from a returned message resource path.
    public func getMessage(
        resource: String,
        options: GetMailMessageOptions = GetMailMessageOptions()
    ) async throws -> InfomaniakResponse<MailMessage> {
        try await client.send(MailRequests.getMessage(resource: resource, options: options))
    }

    /// Reads the current my kSuite with optional mailbox details.
    public func currentMyKSuite(includedResources: String? = "mail") async throws -> InfomaniakResponse<CurrentMyKSuite> {
        try await client.send(MailRequests.currentMyKSuite(includedResources: includedResources))
    }
}
