import Foundation

/// An HTTP method supported by the Infomaniak API client.
public enum HTTPMethod: String, Codable, Sendable {
    /// A read-only HTTP request.
    case get = "GET"

    /// A resource creation HTTP request.
    case post = "POST"

    /// A full resource replacement HTTP request.
    case put = "PUT"

    /// A partial resource update HTTP request.
    case patch = "PATCH"

    /// A resource deletion HTTP request.
    case delete = "DELETE"
}
