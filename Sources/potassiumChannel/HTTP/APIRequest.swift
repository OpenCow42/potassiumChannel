import Foundation

/// A typed description of an Infomaniak API request.
public struct APIRequest<Response: Decodable & Sendable>: Sendable {
    /// The HTTP method used by the request.
    public let method: HTTPMethod

    /// The API path relative to the configured base URL.
    public let path: String

    /// Query parameters appended to the URL.
    public let queryParameters: [QueryParameter]

    /// Additional request headers.
    public let headers: [HTTPHeader]

    /// The request body, when the endpoint requires one.
    public let body: Data?

    /// Creates a typed API request.
    public init(
        method: HTTPMethod,
        path: String,
        queryParameters: [QueryParameter] = [],
        headers: [HTTPHeader] = [],
        body: Data? = nil
    ) {
        self.method = method
        self.path = path
        self.queryParameters = queryParameters
        self.headers = headers
        self.body = body
    }
}
