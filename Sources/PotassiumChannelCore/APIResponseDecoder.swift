import Foundation

/// Decodes response bodies produced by ``InfomaniakAPIClient`` operations.
///
/// Implementations must be safe to call concurrently. Stateful decoders should
/// create fresh decoding state for each invocation.
public protocol APIResponseDecoding: Sendable {
    /// Decodes one response body as the requested response type.
    func decode<Response: Decodable & Sendable>(
        _ type: Response.Type,
        from data: Data
    ) throws -> Response
}

/// The standard JSON response decoder used by Infomaniak APIs.
public struct InfomaniakJSONResponseDecoder: APIResponseDecoding {
    /// Creates the standard response decoder.
    public init() {}

    public func decode<Response: Decodable & Sendable>(
        _ type: Response.Type,
        from data: Data
    ) throws -> Response {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(type, from: data)
    }
}
