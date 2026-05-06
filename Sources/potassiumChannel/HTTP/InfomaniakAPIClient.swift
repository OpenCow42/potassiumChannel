import Foundation

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
        guard var components = URLComponents(url: configuration.baseURL, resolvingAgainstBaseURL: false) else {
            throw APIClientError.invalidURL(path: request.path)
        }

        let basePath = components.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let requestPath = request.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let pathSegments = [basePath, requestPath]
            .filter { !$0.isEmpty }
            .flatMap { $0.split(separator: "/", omittingEmptySubsequences: true).map(String.init) }
        components.percentEncodedPath = "/" + pathSegments.map(Self.percentEncodePathSegment).joined(separator: "/")
        components.queryItems = request.queryParameters.flatMap { parameter in
            parameter.value.makeQueryItems(named: parameter.name)
        }

        guard let url = components.url else {
            throw APIClientError.invalidURL(path: request.path)
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body
        urlRequest.setValue("Bearer \(configuration.bearerToken)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")

        if request.body != nil {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        for header in request.headers {
            urlRequest.setValue(header.value, forHTTPHeaderField: header.name)
        }

        return urlRequest
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
