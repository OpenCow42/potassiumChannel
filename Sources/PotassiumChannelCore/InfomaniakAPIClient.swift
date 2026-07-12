import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// A Sendable API client for constructing and executing Infomaniak requests.
public struct InfomaniakAPIClient: Sendable {
    /// The configuration used by this client.
    public let configuration: APIClientConfiguration

    private let responseDecoder: any APIResponseDecoding
    private let session: URLSession

    /// Creates an Infomaniak API client.
    public init(
        configuration: APIClientConfiguration,
        responseDecoder: any APIResponseDecoding = InfomaniakJSONResponseDecoder(),
        session: URLSession = .shared
    ) {
        self.configuration = configuration
        self.responseDecoder = responseDecoder
        self.session = session
    }

    /// Builds a URL request without executing it.
    public func makeURLRequest<Response>(for request: APIRequest<Response>) async throws -> URLRequest {
        try buildURLRequest(for: request)
    }

    private func buildURLRequest<Response>(for request: APIRequest<Response>) throws -> URLRequest {
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

    /// Creates a lazily started request operation that decodes its response.
    public func operation<Response>(
        for request: APIRequest<Response>
    ) throws -> APIRequestOperation<Response> {
        let decoder = responseDecoder
        return try makeOperation(for: request) { data in
            try decoder.decode(Response.self, from: data)
        }
    }

    /// Creates a lazily started request operation that returns raw response data.
    public func dataOperation<Response>(
        for request: APIRequest<Response>
    ) throws -> APIRequestOperation<Data> {
        try makeOperation(for: request) { $0 }
    }

    /// Executes a request and decodes its response body.
    public func send<Response>(_ request: APIRequest<Response>) async throws -> Response {
        try await operation(for: request).value
    }

    /// Executes a request and returns its raw response body.
    public func sendData<Response>(_ request: APIRequest<Response>) async throws -> Data {
        try await dataOperation(for: request).value
    }

    private func makeOperation<Response, Output: Sendable>(
        for request: APIRequest<Response>,
        transform: @escaping @Sendable (Data) throws -> Output
    ) throws -> APIRequestOperation<Output> {
        let urlRequest = try buildURLRequest(for: request)
        let state = APIRequestOperationState<Output>()
        let task = session.dataTask(with: urlRequest) { data, response, error in
            if let error {
                if (error as? URLError)?.code == .cancelled {
                    state.complete(with: .failure(CancellationError()))
                } else {
                    state.complete(with: .failure(error))
                }
                return
            }

            let result = Result<Output, Error> {
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIClientError.missingHTTPResponse
                }

                let data = data ?? Data()
                guard (200..<300).contains(httpResponse.statusCode) else {
                    let body = String(data: data, encoding: .utf8) ?? ""
                    throw APIClientError.unacceptableStatusCode(httpResponse.statusCode, body: body)
                }

                return try transform(data)
            }
            state.complete(with: result)
        }
        state.install(task: task)
        return APIRequestOperation(task: task, state: state)
    }
}
