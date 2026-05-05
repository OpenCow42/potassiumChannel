import Foundation

/// An error produced while preparing or executing an Infomaniak API request.
public enum APIClientError: Error, Equatable, Sendable {
    /// The request path could not be resolved against the base URL.
    case invalidURL(path: String)

    /// The server returned a non-successful HTTP status code.
    case unacceptableStatusCode(Int, body: String)

    /// The response was not an HTTP response.
    case missingHTTPResponse
}
