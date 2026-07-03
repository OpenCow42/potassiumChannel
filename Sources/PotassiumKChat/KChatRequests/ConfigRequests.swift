import Foundation
import PotassiumChannelCore

extension KChatRequests {
    /// Creates a request that fetches the client configuration required by kChat clients.
    ///
    /// The current public API only implements the legacy `old` format.
    public static func getClientConfig(format: String) -> APIRequest<KChatClientConfig> {
        APIRequest(
            method: .get,
            path: "/api/v4/config/client",
            queryParameters: [
                QueryParameter(name: "format", value: .string(format)),
            ]
        )
    }
}
