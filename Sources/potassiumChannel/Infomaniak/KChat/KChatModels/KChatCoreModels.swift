import Foundation

/// A Mattermost-compatible kChat client configuration response.
public struct KChatClientConfig: Codable, Equatable, Sendable {
    /// Raw client configuration values keyed by Mattermost configuration name.
    public let values: [String: String]

    /// Creates a kChat client configuration value.
    public init(values: [String: String]) {
        self.values = values
    }

    /// Accesses a configuration value by key.
    public subscript(_ key: String) -> String? {
        values[key]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        values = try container.decode([String: String].self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(values)
    }
}

/// A Mattermost-compatible status response.
public struct KChatStatusOK: Codable, Equatable, Sendable {
    public let status: String?

    public init(status: String? = nil) {
        self.status = status
    }
}
