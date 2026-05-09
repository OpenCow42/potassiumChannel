import Foundation

extension MailRequests {
    /// Creates a request that lists mailboxes available to the authenticated user.
    public static func listUserMailboxes(includedResources: String? = "unseen,aliases") -> APIRequest<InfomaniakResponse<[UserMailbox]>> {
        var queryParameters: [QueryParameter] = []
        if let includedResources {
            queryParameters.append(QueryParameter(name: "with", value: .string(includedResources)))
        }

        return APIRequest(
            method: .get,
            path: "/api/mailbox",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that lists folders for a mailbox.
    public static func listFolders(mailboxUUID: String, includedResources: String? = "ik-static") -> APIRequest<InfomaniakResponse<[MailFolder]>> {
        var queryParameters: [QueryParameter] = []
        if let includedResources {
            queryParameters.append(QueryParameter(name: "with", value: .string(includedResources)))
        }

        return APIRequest(
            method: .get,
            path: "/api/mail/\(mailboxUUID)/folder",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that lists threads/messages for a mailbox folder.
    public static func listThreads(
        mailboxUUID: String,
        folderId: String,
        options: ListMailThreadsOptions = ListMailThreadsOptions()
    ) -> APIRequest<InfomaniakResponse<MailThreadList>> {
        var queryParameters = [
            QueryParameter(name: "offset", value: .integer(options.offset)),
            QueryParameter(name: "thread", value: .string(options.threadMode)),
        ]
        if let filter = options.filter {
            queryParameters.append(QueryParameter(name: "filters", value: .string(filter)))
        }
        if let includedResources = options.includedResources {
            queryParameters.append(QueryParameter(name: "with", value: .string(includedResources)))
        }

        return APIRequest(
            method: .get,
            path: "/api/mail/\(mailboxUUID)/folder/\(folderId)/message",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that reads quota information for a discovered mailbox.
    public static func getMailboxQuota(
        mailbox: String,
        productId: Int,
        options: GetMailboxQuotaOptions = GetMailboxQuotaOptions()
    ) -> APIRequest<InfomaniakResponse<MailboxQuota>> {
        var queryParameters: [QueryParameter] = [
            QueryParameter(name: "mailbox", value: .string(mailbox)),
            QueryParameter(name: "product_id", value: .integer(productId)),
        ]
        if let unit = options.unit {
            queryParameters.append(QueryParameter(name: "unit", value: .string(unit)))
        }

        return APIRequest(
            method: .get,
            path: "/api/mailbox/quotas",
            queryParameters: queryParameters
        )
    }



    /// Creates a request that saves a new draft for a mailbox.
    public static func createDraft(mailboxUUID: String, payload: MailDraftPayload) throws -> APIRequest<InfomaniakResponse<MailDraft>> {
        let body = try JSONEncoder().encode(payload)
        return APIRequest(
            method: .post,
            path: "/api/mail/\(mailboxUUID)/draft",
            body: body
        )
    }

    /// Creates a request that updates or sends an existing draft for a mailbox.
    public static func updateDraft(mailboxUUID: String, draftUUID: String, payload: MailDraftPayload) throws -> APIRequest<InfomaniakResponse<MailDraft>> {
        let body = try JSONEncoder().encode(payload)
        return APIRequest(
            method: .put,
            path: "/api/mail/\(mailboxUUID)/draft/\(draftUUID)",
            body: body
        )
    }

    /// Creates a request that reads a saved draft for a mailbox.
    public static func getDraft(mailboxUUID: String, draftUUID: String) -> APIRequest<InfomaniakResponse<MailDraft>> {
        APIRequest(
            method: .get,
            path: "/api/mail/\(mailboxUUID)/draft/\(draftUUID)"
        )
    }

    /// Creates a request that deletes a saved draft for a mailbox.
    public static func deleteDraft(mailboxUUID: String, draftUUID: String) -> APIRequest<InfomaniakResponse<KDriveJSONValue>> {
        APIRequest(
            method: .delete,
            path: "/api/mail/\(mailboxUUID)/draft/\(draftUUID)"
        )
    }

    /// Creates a request that schedules a saved draft resource.
    public static func scheduleDraft(draftResource: String, scheduleDate: String) throws -> APIRequest<InfomaniakResponse<MailDraftSchedule>> {
        let body = try JSONEncoder().encode(MailDraftSchedulePayload(scheduleDate: scheduleDate))
        return APIRequest(
            method: .put,
            path: draftResource.appending("/schedule"),
            body: body
        )
    }

    /// Creates a request that removes a scheduled send and moves it back to drafts.
    public static func deleteSchedule(scheduleAction: String) -> APIRequest<InfomaniakResponse<KDriveJSONValue>> {
        APIRequest(
            method: .delete,
            path: scheduleAction
        )
    }

    /// Creates a request that cancels a delayed send action.
    public static func cancelSend(cancelSendResource: String) -> APIRequest<InfomaniakResponse<KDriveJSONValue>> {
        APIRequest(
            method: .put,
            path: cancelSendResource
        )
    }

    /// Creates a request that reads a message from a returned message resource path.
    public static func getMessage(
        resource: String,
        options: GetMailMessageOptions = GetMailMessageOptions()
    ) -> APIRequest<InfomaniakResponse<MailMessage>> {
        var queryParameters: [QueryParameter] = []
        if let preferredFormat = options.preferredFormat {
            queryParameters.append(QueryParameter(name: "prefered_format", value: .string(preferredFormat)))
        }
        if let includedResources = options.includedResources {
            queryParameters.append(QueryParameter(name: "with", value: .string(includedResources)))
        }

        return APIRequest(
            method: .get,
            path: resource,
            queryParameters: queryParameters
        )
    }

    /// Creates a request that reads the current my kSuite with optional mailbox details.
    public static func currentMyKSuite(includedResources: String? = "mail") -> APIRequest<InfomaniakResponse<CurrentMyKSuite>> {
        var queryParameters: [QueryParameter] = []
        if let includedResources {
            queryParameters.append(QueryParameter(name: "with", value: .string(includedResources)))
        }

        return APIRequest(
            method: .get,
            path: "/1/my_ksuite/current",
            queryParameters: queryParameters
        )
    }
}
