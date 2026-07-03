import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// OAuth 2.0 helper requests for Infomaniak login flows.
public enum InfomaniakOAuthRequests {
    /// The default Infomaniak authorization endpoint.
    public static let defaultAuthorizationURL = URL(string: "https://login.infomaniak.com/authorize")!

    /// The default Infomaniak token endpoint.
    public static let defaultTokenURL = URL(string: "https://login.infomaniak.com/token")!

    /// Builds the URL an app should open to start an Infomaniak authorization-code login flow.
    public static func authorizationURL(
        clientId: String,
        redirectURI: URL,
        scopes: [String] = [],
        state: String? = nil,
        codeChallenge: String? = nil,
        codeChallengeMethod: InfomaniakOAuthCodeChallengeMethod = .s256,
        authorizationURL: URL = Self.defaultAuthorizationURL,
        additionalQueryItems: [URLQueryItem] = []
    ) throws -> URL {
        var components = try components(for: authorizationURL)
        var queryItems = [
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "redirect_uri", value: redirectURI.absoluteString),
        ]

        if !scopes.isEmpty {
            queryItems.append(URLQueryItem(name: "scope", value: scopes.joined(separator: " ")))
        }
        if let state {
            queryItems.append(URLQueryItem(name: "state", value: state))
        }
        if let codeChallenge {
            queryItems.append(URLQueryItem(name: "code_challenge", value: codeChallenge))
            queryItems.append(URLQueryItem(name: "code_challenge_method", value: codeChallengeMethod.rawValue))
        }
        queryItems.append(contentsOf: additionalQueryItems)
        components.queryItems = (components.queryItems ?? []) + queryItems

        guard let url = components.url else {
            throw InfomaniakOAuthRequestError.invalidURL(authorizationURL.absoluteString)
        }

        return url
    }

    /// Builds a form-encoded request that exchanges an authorization code for OAuth tokens.
    public static func authorizationCodeTokenRequest(
        clientId: String,
        clientSecret: String? = nil,
        code: String,
        redirectURI: URL? = nil,
        codeVerifier: String? = nil,
        tokenURL: URL = Self.defaultTokenURL,
        additionalParameters: [URLQueryItem] = []
    ) throws -> URLRequest {
        var parameters = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "code", value: code),
        ]

        if let clientSecret {
            parameters.append(URLQueryItem(name: "client_secret", value: clientSecret))
        }
        if let redirectURI {
            parameters.append(URLQueryItem(name: "redirect_uri", value: redirectURI.absoluteString))
        }
        if let codeVerifier {
            parameters.append(URLQueryItem(name: "code_verifier", value: codeVerifier))
        }
        parameters.append(contentsOf: additionalParameters)

        return try tokenRequest(tokenURL: tokenURL, parameters: parameters)
    }

    /// Builds a form-encoded request that refreshes an Infomaniak OAuth access token.
    public static func refreshTokenRequest(
        clientId: String,
        clientSecret: String? = nil,
        refreshToken: String,
        scopes: [String] = [],
        tokenURL: URL = Self.defaultTokenURL,
        additionalParameters: [URLQueryItem] = []
    ) throws -> URLRequest {
        var parameters = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "refresh_token", value: refreshToken),
        ]

        if let clientSecret {
            parameters.append(URLQueryItem(name: "client_secret", value: clientSecret))
        }
        if !scopes.isEmpty {
            parameters.append(URLQueryItem(name: "scope", value: scopes.joined(separator: " ")))
        }
        parameters.append(contentsOf: additionalParameters)

        return try tokenRequest(tokenURL: tokenURL, parameters: parameters)
    }

    private static func tokenRequest(tokenURL: URL, parameters: [URLQueryItem]) throws -> URLRequest {
        guard tokenURL.scheme != nil, tokenURL.host != nil else {
            throw InfomaniakOAuthRequestError.invalidURL(tokenURL.absoluteString)
        }

        var request = URLRequest(url: tokenURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = formEncodedData(from: parameters)

        return request
    }

    private static func components(for url: URL) throws -> URLComponents {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw InfomaniakOAuthRequestError.invalidURL(url.absoluteString)
        }

        return components
    }

    private static func formEncodedData(from parameters: [URLQueryItem]) -> Data {
        parameters
            .map { item in
                "\(formEncode(item.name))=\(formEncode(item.value ?? ""))"
            }
            .joined(separator: "&")
            .data(using: .utf8)!
    }

    private static func formEncode(_ value: String) -> String {
        var allowedCharacters = CharacterSet.alphanumerics
        allowedCharacters.insert(charactersIn: "-._*")

        return value
            .addingPercentEncoding(withAllowedCharacters: allowedCharacters)?
            .replacingOccurrences(of: "%20", with: "+") ?? value
    }
}

/// PKCE code challenge method values accepted by OAuth authorization requests.
public enum InfomaniakOAuthCodeChallengeMethod: String, Sendable {
    /// SHA-256 based PKCE challenge.
    case s256 = "S256"

    /// Plain-text PKCE challenge.
    case plain
}

/// Errors raised while building Infomaniak OAuth requests.
public enum InfomaniakOAuthRequestError: Error, Equatable, Sendable {
    /// The supplied endpoint URL is not absolute or cannot be represented.
    case invalidURL(String)
}
