import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// A structured-concurrency API client for Infomaniak services.
public actor InfomaniakAPIClient {
    /// The configuration used by this client.
    public let configuration: APIClientConfiguration

    private let decoder: JSONDecoder
    private let session: URLSession

    /// Creates an Infomaniak API client.
    public init(
        configuration: APIClientConfiguration,
        decoder: JSONDecoder = JSONDecoder(),
        session: URLSession = .shared
    ) {
        self.configuration = configuration
        self.decoder = decoder
        self.session = session
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    /// Builds a URL request without executing it.
    public func makeURLRequest<Response>(for request: APIRequest<Response>) throws -> URLRequest {
        let url = try makeURL(for: request)
        var urlRequest = URLRequest(url: url)
        configureHTTPBasics(on: &urlRequest, for: request)
        applyDefaultHeaders(to: &urlRequest, hasBody: request.body != nil)
        applyCustomHeaders(request.headers, to: &urlRequest)

        return urlRequest
    }

    private func makeURL<Response>(for request: APIRequest<Response>) throws -> URL {
        guard var components = URLComponents(url: configuration.baseURL, resolvingAgainstBaseURL: false) else {
            throw APIClientError.invalidURL(path: request.path)
        }

        components.percentEncodedPath = percentEncodedPath(for: request.path, basePath: components.path)
        components.queryItems = queryItems(from: request.queryParameters)

        guard let url = components.url else {
            throw APIClientError.invalidURL(path: request.path)
        }

        return url
    }

    private func percentEncodedPath(for requestPath: String, basePath: String) -> String {
        let pathSegments = [basePath, requestPath]
            .map { $0.trimmingCharacters(in: CharacterSet(charactersIn: "/")) }
            .filter { !$0.isEmpty }
            .flatMap { $0.split(separator: "/", omittingEmptySubsequences: true).map(String.init) }

        return "/" + pathSegments.map(Self.percentEncodePathSegment).joined(separator: "/")
    }

    private func queryItems(from parameters: [QueryParameter]) -> [URLQueryItem] {
        parameters.flatMap { parameter in
            parameter.value.makeQueryItems(named: parameter.name)
        }
    }

    private func configureHTTPBasics<Response>(on urlRequest: inout URLRequest, for request: APIRequest<Response>) {
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body
    }

    private func applyDefaultHeaders(to urlRequest: inout URLRequest, hasBody: Bool) {
        urlRequest.setValue("Bearer \(configuration.bearerToken)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")

        if hasBody {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
    }

    private func applyCustomHeaders(_ headers: [HTTPHeader], to urlRequest: inout URLRequest) {
        for header in headers {
            urlRequest.setValue(header.value, forHTTPHeaderField: header.name)
        }
    }

    private static func percentEncodePathSegment(_ segment: String) -> String {
        var allowedCharacters = CharacterSet.urlPathAllowed
        allowedCharacters.insert(charactersIn: "%")
        allowedCharacters.remove(charactersIn: "/?#")

        let characters = Array(segment)
        var sanitized = ""
        var index = 0
        while index < characters.count {
            if characters[index] == "%",
               index + 2 < characters.count,
               characters[index + 1].isHexDigit,
               characters[index + 2].isHexDigit {
                sanitized.append("%")
                sanitized.append(characters[index + 1])
                sanitized.append(characters[index + 2])
                index += 3
            } else if characters[index] == "%" {
                sanitized.append("%25")
                index += 1
            } else {
                sanitized.append(characters[index])
                index += 1
            }
        }

        return sanitized.addingPercentEncoding(withAllowedCharacters: allowedCharacters) ?? sanitized
    }

    /// Executes a request and decodes its response body.
    public func send<Response>(_ request: APIRequest<Response>) async throws -> Response {
        let data = try await sendData(request)

        return try decoder.decode(Response.self, from: data)
    }

    /// Executes a request and returns its raw response body.
    public func sendData<Response>(_ request: APIRequest<Response>) async throws -> Data {
        let urlRequest = try makeURLRequest(for: request)
        let (data, response) = try await session.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIClientError.missingHTTPResponse
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            let body = String(data: data, encoding: .utf8) ?? ""
            throw APIClientError.unacceptableStatusCode(httpResponse.statusCode, body: body)
        }

        return data
    }
}
