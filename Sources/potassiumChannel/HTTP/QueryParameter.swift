import Foundation

/// A query parameter value that can be encoded into a URL query string.
public enum QueryParameterValue: Equatable, Sendable {
    /// A string query value.
    case string(String)

    /// An integer query value.
    case integer(Int)

    /// A boolean query value.
    case bool(Bool)

    /// A repeated query value encoded as multiple parameters with the same name.
    case strings([String])

    /// A repeated integer query value encoded as multiple parameters with the same name.
    case integers([Int])

    /// Returns query items for the supplied parameter name.
    public func makeQueryItems(named name: String) -> [URLQueryItem] {
        switch self {
        case let .string(value):
            [URLQueryItem(name: name, value: value)]
        case let .integer(value):
            [URLQueryItem(name: name, value: String(value))]
        case let .bool(value):
            [URLQueryItem(name: name, value: value ? "true" : "false")]
        case let .strings(values):
            values.map { URLQueryItem(name: name, value: $0) }
        case let .integers(values):
            values.map { URLQueryItem(name: name, value: String($0)) }
        }
    }
}

/// A URL query parameter used by an API request.
public struct QueryParameter: Equatable, Sendable {
    /// The parameter name.
    public let name: String

    /// The parameter value.
    public let value: QueryParameterValue

    /// Creates a query parameter.
    public init(name: String, value: QueryParameterValue) {
        self.name = name
        self.value = value
    }
}
