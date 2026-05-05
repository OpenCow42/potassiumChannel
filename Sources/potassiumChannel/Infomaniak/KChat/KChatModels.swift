import Foundation

/// A Mattermost-compatible kChat status response.
public struct KChatStatusOK: Codable, Equatable, Sendable {
    /// Contains `ok` when the request completed successfully.
    public let status: String

    /// Creates a kChat status response value.
    public init(status: String) {
        self.status = status
    }
}
