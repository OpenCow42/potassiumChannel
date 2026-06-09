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

    /// Lists account names for a mail hosting service.
    public func listMailHostingAccounts(mailHostingId: Int) async throws -> InfomaniakResponse<MailHostingAccounts> {
        try await client.send(MailRequests.listMailHostingAccounts(mailHostingId: mailHostingId))
    }

    /// Reads one mailbox settings payload for a mail hosting service.
    public func getMailbox(mailHostingId: Int, mailboxName: String) async throws -> InfomaniakResponse<MailMailbox> {
        try await client.send(MailRequests.getMailbox(mailHostingId: mailHostingId, mailboxName: mailboxName))
    }

    /// Lists aliases for a mailbox in a mail hosting service.
    public func listMailboxAliases(mailHostingId: Int, mailboxName: String) async throws -> InfomaniakResponse<MailboxAliases> {
        try await client.send(MailRequests.listMailboxAliases(mailHostingId: mailHostingId, mailboxName: mailboxName))
    }

    /// Lists forwarding settings for a mailbox in a mail hosting service.
    public func listMailboxForwarding(mailHostingId: Int, mailboxName: String) async throws -> InfomaniakResponse<MailboxForwarding> {
        try await client.send(MailRequests.listMailboxForwarding(mailHostingId: mailHostingId, mailboxName: mailboxName))
    }

    /// Adds one alias to a mailbox for a mail hosting service.
    public func addMailboxAlias(mailHostingId: Int, mailboxName: String, alias: String) async throws -> InfomaniakResponse<Bool> {
        try await client.send(MailRequests.addMailboxAlias(mailHostingId: mailHostingId, mailboxName: mailboxName, alias: alias))
    }

    /// Adds one forwarding address to a mailbox for a mail hosting service.
    public func addMailboxForwarding(
        mailHostingId: Int,
        mailboxName: String,
        redirectAddress: String
    ) async throws -> InfomaniakResponse<CreatedMailboxForwarding> {
        try await client.send(MailRequests.addMailboxForwarding(mailHostingId: mailHostingId, mailboxName: mailboxName, redirectAddress: redirectAddress))
    }

    /// Removes one alias from a mailbox for a mail hosting service.
    public func deleteMailboxAlias(mailHostingId: Int, mailboxName: String, alias: String) async throws -> InfomaniakResponse<Bool> {
        try await client.send(MailRequests.deleteMailboxAlias(mailHostingId: mailHostingId, mailboxName: mailboxName, alias: alias))
    }

    /// Removes one forwarding address from a mailbox for a mail hosting service.
    public func deleteMailboxForwarding(mailHostingId: Int, mailboxName: String, redirectAddress: String) async throws -> InfomaniakResponse<Bool> {
        try await client.send(MailRequests.deleteMailboxForwarding(mailHostingId: mailHostingId, mailboxName: mailboxName, redirectAddress: redirectAddress))
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



    /// Saves a new draft for a mailbox.
    public func createDraft(mailboxUUID: String, payload: MailDraftPayload) async throws -> InfomaniakResponse<MailDraft> {
        try await client.send(MailRequests.createDraft(mailboxUUID: mailboxUUID, payload: payload))
    }

    /// Updates or sends an existing draft for a mailbox.
    public func updateDraft(mailboxUUID: String, draftUUID: String, payload: MailDraftPayload) async throws -> InfomaniakResponse<MailDraft> {
        try await client.send(MailRequests.updateDraft(mailboxUUID: mailboxUUID, draftUUID: draftUUID, payload: payload))
    }

    /// Reads a saved draft for a mailbox.
    public func getDraft(mailboxUUID: String, draftUUID: String) async throws -> InfomaniakResponse<MailDraft> {
        try await client.send(MailRequests.getDraft(mailboxUUID: mailboxUUID, draftUUID: draftUUID))
    }

    /// Deletes a saved draft for a mailbox.
    public func deleteDraft(mailboxUUID: String, draftUUID: String) async throws -> InfomaniakResponse<KDriveJSONValue> {
        try await client.send(MailRequests.deleteDraft(mailboxUUID: mailboxUUID, draftUUID: draftUUID))
    }

    /// Schedules a saved draft resource.
    public func scheduleDraft(draftResource: String, scheduleDate: String) async throws -> InfomaniakResponse<MailDraftSchedule> {
        try await client.send(MailRequests.scheduleDraft(draftResource: draftResource, scheduleDate: scheduleDate))
    }

    /// Removes a scheduled send and moves it back to drafts.
    public func deleteSchedule(scheduleAction: String) async throws -> InfomaniakResponse<KDriveJSONValue> {
        try await client.send(MailRequests.deleteSchedule(scheduleAction: scheduleAction))
    }

    /// Cancels a delayed send action.
    public func cancelSend(cancelSendResource: String) async throws -> InfomaniakResponse<KDriveJSONValue> {
        try await client.send(MailRequests.cancelSend(cancelSendResource: cancelSendResource))
    }

    /// Reads a message from a returned message resource path.
    public func getMessage(
        resource: String,
        options: GetMailMessageOptions = GetMailMessageOptions()
    ) async throws -> InfomaniakResponse<MailMessage> {
        try await client.send(MailRequests.getMessage(resource: resource, options: options))
    }

    /// Moves messages between mailbox folders.
    public func moveMessages(
        mailboxUUID: String,
        uids: [String],
        destinationFolderId: String
    ) async throws -> InfomaniakResponse<MailMoveResult> {
        try await client.send(MailRequests.moveMessages(
            mailboxUUID: mailboxUUID,
            payload: MailMoveMessagesPayload(uids: uids, to: destinationFolderId)
        ))
    }

    /// Reads the current my kSuite with optional mailbox details.
    public func currentMyKSuite(includedResources: String? = "mail") async throws -> InfomaniakResponse<CurrentMyKSuite> {
        try await client.send(MailRequests.currentMyKSuite(includedResources: includedResources))
    }
}
