# Contributing

Thank you for contributing to potassiumChannel. This package is the shared Swift
networking layer for Infomaniak API clients.

## Scope

Keep this repository focused on reusable transport concerns:

- API client configuration
- API request descriptions
- HTTP methods, headers, query parameters, and body encoding
- Infomaniak API client behavior
- API-client error handling

Do not add CLI commands, UI, or domain-service workflows here unless they are
part of the transport layer. Prefer small, stable public APIs that can be reused
by multiple Swift clients.

## Development

This is a Swift package library using Swift 6.2 and native structured
concurrency. The supported platform minimums are:

- macOS 12+
- iOS 15+
- tvOS 15+
- watchOS 8+
- visionOS 1+

Build and test with the standard Swift package commands:

```sh
swift build
swift test
```

Use of third-party Swift Package Manager dependencies should be limited and
well justified. Apple-provided SPM libraries are acceptable when they fit the
package scope.

## Code Style

- Follow the Swift API Design Guidelines summarized in `SWIFT.MD`.
- Keep software layers in separate folders and files.
- Use `Sendable` and `Codable` where appropriate.
- Prefer non-optional public data where absence is not meaningful.
- Design request and response APIs around deterministic behavior.

## Testing

Write tests for every new networking primitive or behavior. Tests must use
Swift Testing with `import Testing`; do not add XCTest.

Prefer deterministic unit tests for:

- request construction
- URL and query encoding
- header handling
- request body encoding
- response decoding
- client behavior and error handling

## Secrets And Live Fixtures

Do not commit secrets, API tokens, account identifiers, private URLs, or live API
fixtures. Tests should not require checked-in credentials.

Live API checks, when needed, must be opt-in and guarded by local environment
values. Keep recorded or synthetic fixtures sanitized and minimal.

## Pull Requests

Before opening a pull request:

- Keep the change scoped to one clear purpose.
- Add or update Swift Testing coverage for changed behavior.
- Run `swift build` and `swift test`.
- Note any intentionally skipped live checks and why they are safe to skip.
- Avoid unrelated formatting churn or documentation updates.
