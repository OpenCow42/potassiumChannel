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
