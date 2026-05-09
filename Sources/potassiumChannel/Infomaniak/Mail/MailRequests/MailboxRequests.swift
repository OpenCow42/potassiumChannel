import Foundation

extension MailRequests {
    /// Creates a request that lists mailboxes for a mail hosting service.
    public static func listMailboxes(
        mailHostingId: Int,
        options: ListMailboxesOptions = ListMailboxesOptions()
    ) -> APIRequest<PaginatedInfomaniakResponse<[MailMailbox]>> {
        var queryParameters: [QueryParameter] = []

        if let search = options.search {
            queryParameters.append(QueryParameter(name: "search", value: .string(search)))
        }
        if let filterBy = options.filterBy {
            queryParameters.append(QueryParameter(name: "filter_by", value: .string(filterBy)))
        }
        if let includedResources = options.includedResources {
            queryParameters.append(QueryParameter(name: "with", value: .string(includedResources)))
        }
        if let returnedFields = options.returnedFields {
            queryParameters.append(QueryParameter(name: "return", value: .string(returnedFields)))
        }
        if let limit = options.limit {
            queryParameters.append(QueryParameter(name: "limit", value: .integer(limit)))
        }
        if let skip = options.skip {
            queryParameters.append(QueryParameter(name: "skip", value: .integer(skip)))
        }
        if let page = options.page {
            queryParameters.append(QueryParameter(name: "page", value: .integer(page)))
        }
        if let perPage = options.perPage {
            queryParameters.append(QueryParameter(name: "per_page", value: .integer(perPage)))
        }
        if let orderBy = options.orderBy {
            queryParameters.append(QueryParameter(name: "order_by", value: .string(orderBy)))
        }
        if let order = options.order {
            queryParameters.append(QueryParameter(name: "order", value: .string(order)))
        }
        for (field, order) in options.orderFor.sorted(by: { $0.key < $1.key }) {
            queryParameters.append(QueryParameter(name: "order_for[\(field)]", value: .string(order)))
        }
        for (field, value) in options.filters.sorted(by: { $0.key < $1.key }) {
            queryParameters.append(QueryParameter(name: "filter[\(field)]", value: .string(value)))
        }

        return APIRequest(
            method: .get,
            path: "/1/mail_hostings/\(mailHostingId)/mailboxes",
            queryParameters: queryParameters
        )
    }

    /// Creates a request that lists account names for a mail hosting service.
    public static func listMailHostingAccounts(mailHostingId: Int) -> APIRequest<InfomaniakResponse<MailHostingAccounts>> {
        APIRequest(
            method: .get,
            path: "/1/mail_hostings/\(mailHostingId)/accounts"
        )
    }

    /// Creates a request that reads one mailbox settings payload for a mail hosting service.
    public static func getMailbox(mailHostingId: Int, mailboxName: String) -> APIRequest<InfomaniakResponse<MailMailbox>> {
        APIRequest(
            method: .get,
            path: "/1/mail_hostings/\(mailHostingId)/mailboxes/\(mailboxName)"
        )
    }

    /// Creates a request that lists aliases for a mailbox in a mail hosting service.
    public static func listMailboxAliases(
        mailHostingId: Int,
        mailboxName: String
    ) -> APIRequest<InfomaniakResponse<MailboxAliases>> {
        APIRequest(
            method: .get,
            path: "/1/mail_hostings/\(mailHostingId)/mailboxes/\(mailboxName)/aliases"
        )
    }

    /// Creates a request that lists forwarding settings for a mailbox in a mail hosting service.
    public static func listMailboxForwarding(
        mailHostingId: Int,
        mailboxName: String
    ) -> APIRequest<InfomaniakResponse<MailboxForwarding>> {
        APIRequest(
            method: .get,
            path: "/1/mail_hostings/\(mailHostingId)/mailboxes/\(mailboxName)/forwarding_addresses"
        )
    }

    /// Creates a request that adds one alias to a mailbox for a mail hosting service.
    public static func addMailboxAlias(
        mailHostingId: Int,
        mailboxName: String,
        alias: String
    ) throws -> APIRequest<InfomaniakResponse<Bool>> {
        let body = try JSONEncoder().encode(AddMailboxAliasPayload(alias: alias))
        return APIRequest(
            method: .post,
            path: "/1/mail_hostings/\(mailHostingId)/mailboxes/\(mailboxName)/aliases",
            body: body
        )
    }

    /// Creates a request that removes one alias from a mailbox for a mail hosting service.
    public static func deleteMailboxAlias(
        mailHostingId: Int,
        mailboxName: String,
        alias: String
    ) -> APIRequest<InfomaniakResponse<Bool>> {
        APIRequest(
            method: .delete,
            path: "/1/mail_hostings/\(mailHostingId)/mailboxes/\(mailboxName)/aliases/\(alias)"
        )
    }
}
