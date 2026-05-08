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
