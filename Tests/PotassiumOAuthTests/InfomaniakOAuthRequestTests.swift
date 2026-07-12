import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Testing
@testable import PotassiumOAuth

@Suite("Infomaniak OAuth requests")
struct InfomaniakOAuthRequestTests {
    @Test("authorization URL uses the documented Infomaniak authorize endpoint")
    func authorizationURLUsesInfomaniakAuthorizeEndpoint() throws {
        let url = try InfomaniakOAuthRequests.authorizationURL(
            clientId: "client-id",
            redirectURI: URL(string: "potassium-example://oauth/callback")!,
            scopes: ["openid", "profile", "email"],
            state: "opaque-state",
            codeChallenge: "code-challenge"
        )
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        let queryItems = components.queryItems ?? []

        #expect(components.scheme == "https")
        #expect(components.host == "login.infomaniak.com")
        #expect(components.path == "/authorize")
        #expect(queryItems.contains(URLQueryItem(name: "response_type", value: "code")))
        #expect(queryItems.contains(URLQueryItem(name: "client_id", value: "client-id")))
        #expect(queryItems.contains(URLQueryItem(name: "redirect_uri", value: "potassium-example://oauth/callback")))
        #expect(queryItems.contains(URLQueryItem(name: "scope", value: "openid profile email")))
        #expect(queryItems.contains(URLQueryItem(name: "state", value: "opaque-state")))
        #expect(queryItems.contains(URLQueryItem(name: "code_challenge", value: "code-challenge")))
        #expect(queryItems.contains(URLQueryItem(name: "code_challenge_method", value: "S256")))
    }

    @Test("authorization code token request uses form encoding without bearer auth")
    func authorizationCodeTokenRequestUsesFormEncodingWithoutBearerAuth() throws {
        let request = try InfomaniakOAuthRequests.authorizationCodeTokenRequest(
            clientId: "client id",
            clientSecret: "client/secret",
            code: "auth code",
            redirectURI: URL(string: "https://app.example/callback")!,
            codeVerifier: "verifier value"
        )
        let form = try decodedFormBody(from: request)

        #expect(request.url?.absoluteString == "https://login.infomaniak.com/token")
        #expect(request.httpMethod == "POST")
        #expect(request.value(forHTTPHeaderField: "Authorization") == nil)
        #expect(request.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(request.value(forHTTPHeaderField: "Content-Type") == "application/x-www-form-urlencoded")
        #expect(form["grant_type"] == "authorization_code")
        #expect(form["client_id"] == "client id")
        #expect(form["client_secret"] == "client/secret")
        #expect(form["code"] == "auth code")
        #expect(form["redirect_uri"] == "https://app.example/callback")
        #expect(form["code_verifier"] == "verifier value")
    }

    @Test("refresh token request keeps requested scopes")
    func refreshTokenRequestKeepsRequestedScopes() throws {
        let request = try InfomaniakOAuthRequests.refreshTokenRequest(
            clientId: "client-id",
            refreshToken: "refresh-token",
            scopes: ["openid", "email"]
        )
        let form = try decodedFormBody(from: request)

        #expect(form["grant_type"] == "refresh_token")
        #expect(form["client_id"] == "client-id")
        #expect(form["refresh_token"] == "refresh-token")
        #expect(form["scope"] == "openid email")
    }

    @Test("OAuth token response decodes snake-case fields")
    func tokenResponseDecodesSnakeCaseFields() throws {
        let json = """
        {
          "access_token": "access-token",
          "token_type": "Bearer",
          "expires_in": 3600,
          "refresh_token": "refresh-token",
          "scope": "openid profile email",
          "id_token": "id-token"
        }
        """.data(using: .utf8)!

        let response = try JSONDecoder().decode(InfomaniakOAuthTokenResponse.self, from: json)

        #expect(response.accessToken == "access-token")
        #expect(response.tokenType == "Bearer")
        #expect(response.expiresIn == 3_600)
        #expect(response.refreshToken == "refresh-token")
        #expect(response.scope == "openid profile email")
        #expect(response.scopes == ["openid", "profile", "email"])
        #expect(response.idToken == "id-token")
    }

    @Test("OAuth error response decodes standard fields")
    func errorResponseDecodesStandardFields() throws {
        let json = """
        {
          "error": "invalid_grant",
          "error_description": "The authorization code is invalid.",
          "error_uri": "https://developer.infomaniak.com/docs/api"
        }
        """.data(using: .utf8)!

        let response = try JSONDecoder().decode(InfomaniakOAuthErrorResponse.self, from: json)

        #expect(response == InfomaniakOAuthErrorResponse(
            error: "invalid_grant",
            errorDescription: "The authorization code is invalid.",
            errorURI: "https://developer.infomaniak.com/docs/api"
        ))
    }

    private func decodedFormBody(from request: URLRequest) throws -> [String: String] {
        let body = try #require(request.httpBody)
        let string = String(decoding: body, as: UTF8.self)
        var values: [String: String] = [:]

        for pair in string.split(separator: "&") {
            let parts = pair.split(separator: "=", maxSplits: 1, omittingEmptySubsequences: false)
            let name = String(parts[0]).replacingOccurrences(of: "+", with: " ").removingPercentEncoding ?? String(parts[0])
            let value = parts.count > 1
                ? String(parts[1]).replacingOccurrences(of: "+", with: " ").removingPercentEncoding ?? String(parts[1])
                : ""
            values[name] = value
        }

        return values
    }
}
