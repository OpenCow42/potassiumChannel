import Foundation

/// A single HTTP header used to build a request.
public struct HTTPHeader: Codable, Equatable, Sendable {
    /// The header field name.
    public let name: String

    /// The header field value.
    public let value: String

    /// Creates a header with a field name and value.
    public init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}
