import Foundation

/// Safe response metadata preserved for callers when an API request is rejected.
///
/// This intentionally exposes only fields with defined client-recovery
/// semantics. It is not a general response-header container.
public struct APIResponseMetadata: Equatable, Sendable {
    /// The server's raw `Retry-After` field value, when present.
    public let retryAfter: String?

    public init(retryAfter: String? = nil) {
        self.retryAfter = retryAfter
    }
}

/// An error produced while preparing or executing an Infomaniak API request.
public enum APIClientError: Error, Equatable, Sendable {
    /// The request path could not be resolved against the base URL.
    case invalidURL(path: String)

    /// The server returned a non-successful HTTP status code.
    case unacceptableStatusCode(
        Int,
        body: String,
        metadata: APIResponseMetadata = APIResponseMetadata()
    )

    /// The response was not an HTTP response.
    case missingHTTPResponse
}
