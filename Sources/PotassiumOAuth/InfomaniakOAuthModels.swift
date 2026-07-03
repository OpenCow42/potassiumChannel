import Foundation

/// Token payload returned by the Infomaniak OAuth token endpoint.
public struct InfomaniakOAuthTokenResponse: Decodable, Equatable, Sendable {
    /// Access token to use as a bearer token for Infomaniak API requests.
    public let accessToken: String

    /// OAuth token type, usually `Bearer`.
    public let tokenType: String

    /// Access-token lifetime in seconds, when returned by the server.
    public let expiresIn: Int?

    /// Refresh token used to request a new access token, when returned by the server.
    public let refreshToken: String?

    /// Space-separated scope string returned by the server, when present.
    public let scope: String?

    /// OpenID Connect ID token, when requested and returned by the server.
    public let idToken: String?

    /// Scope names split from the returned space-separated scope string.
    public var scopes: [String] {
        scope?.split(separator: " ").map(String.init) ?? []
    }

    /// Creates an OAuth token response value.
    public init(
        accessToken: String,
        tokenType: String,
        expiresIn: Int? = nil,
        refreshToken: String? = nil,
        scope: String? = nil,
        idToken: String? = nil
    ) {
        self.accessToken = accessToken
        self.tokenType = tokenType
        self.expiresIn = expiresIn
        self.refreshToken = refreshToken
        self.scope = scope
        self.idToken = idToken
    }

    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case scope
        case idToken = "id_token"
    }
}

/// Error payload returned by an OAuth endpoint.
public struct InfomaniakOAuthErrorResponse: Decodable, Equatable, Sendable {
    /// Machine-readable OAuth error code.
    public let error: String

    /// Human-readable error description, when returned by the server.
    public let errorDescription: String?

    /// Documentation URI for the error, when returned by the server.
    public let errorURI: String?

    /// Creates an OAuth error response value.
    public init(error: String, errorDescription: String? = nil, errorURI: String? = nil) {
        self.error = error
        self.errorDescription = errorDescription
        self.errorURI = errorURI
    }

    private enum CodingKeys: String, CodingKey {
        case error
        case errorDescription = "error_description"
        case errorURI = "error_uri"
    }
}
