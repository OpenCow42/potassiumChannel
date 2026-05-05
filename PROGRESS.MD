### Progress of the project

### Implemented API route inventory

`potassiumChannel` currently implements the shared HTTP channel layer only. It
does not define concrete Infomaniak API endpoint wrappers in this repository.
Concrete routes live in the main Potassium CLI project.

Existing route coverage in this package:

| Route | Method | Status | Notes |
| --- | --- | --- | --- |
| _None_ | _N/A_ | _Not implemented here_ | `APIRequest` accepts arbitrary relative paths so Potassium can build typed requests in higher-level packages. |

### Implemented channel primitives

- `APIRequest<Response>` — typed request description with method, relative path,
  query parameters, headers, and optional body.
- `InfomaniakAPIClient` — builds and sends URL requests from `APIRequest` values.
- `APIClientConfiguration` — base URL and token configuration for API clients.
- `APIClientError` — shared transport/client error cases.
- `HTTPMethod` — supported HTTP verbs.
- `HTTPHeader` — request header representation.
- `QueryParameter` — URL query parameter representation, including repeated
  values.

### Validation

- `swift test` passes with request-building and query-encoding coverage.
