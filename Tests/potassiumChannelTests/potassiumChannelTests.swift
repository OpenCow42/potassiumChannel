import Foundation
import Testing
@testable import potassiumChannel

@Test func apiClientBuildsAuthenticatedURLRequests() async throws {
    let client = InfomaniakAPIClient(
        configuration: APIClientConfiguration(
            baseURL: URL(string: "https://api.example.test/2")!,
            bearerToken: "test-token"
        )
    )

    let request = APIRequest<String>(
        method: .post,
        path: "/kdrive/files",
        queryParameters: [
            QueryParameter(name: "page", value: .integer(2)),
            QueryParameter(name: "tags", value: .integers([10, 20]))
        ],
        headers: [HTTPHeader(name: "X-Test", value: "yes")],
        body: Data("{}".utf8)
    )

    let urlRequest = try await client.makeURLRequest(for: request)

    #expect(urlRequest.url?.absoluteString == "https://api.example.test/2/kdrive/files?page=2&tags=10&tags=20")
    #expect(urlRequest.httpMethod == "POST")
    #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
    #expect(urlRequest.value(forHTTPHeaderField: "Accept") == "application/json")
    #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
    #expect(urlRequest.value(forHTTPHeaderField: "X-Test") == "yes")
    #expect(urlRequest.httpBody == Data("{}".utf8))
}

@Test func queryParametersEncodeRepeatedValues() {
    #expect(QueryParameterValue.strings(["a", "b"]).makeQueryItems(named: "with") == [
        URLQueryItem(name: "with", value: "a"),
        URLQueryItem(name: "with", value: "b")
    ])
}
