import Foundation

/// Configuration used by the Infomaniak API client.
public struct APIClientConfiguration: Sendable {
    /// The default Infomaniak API base URL.
    public static let defaultBaseURL = URL(string: "https://api.infomaniak.com")!

    /// The base URL used to build API requests.
    public let baseURL: URL

    /// The bearer token used for authenticated Infomaniak requests.
    public let bearerToken: String

    /// Creates an API client configuration.
    public init(baseURL: URL = Self.defaultBaseURL, bearerToken: String) {
        self.baseURL = baseURL
        self.bearerToken = bearerToken
    }
}
