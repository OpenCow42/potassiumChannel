# Contributing

Thank you for contributing to potassiumChannel. This package provides focused
Swift libraries for Infomaniak API clients.

## Scope

Keep this repository focused on reusable API client libraries:

- `PotassiumChannelCore` transport concerns such as API client configuration,
  request descriptions, HTTP methods, headers, query parameters, body encoding,
  client behavior, and error handling.
- Product libraries for kDrive, Mail, kChat, URL shortener, and OAuth helpers.
- Public DTOs and service wrappers that are useful outside a single CLI or app.

Do not add CLI commands or UI here. Prefer small, stable public APIs that can be
reused by multiple Swift clients.

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

For product-specific changes, also build the affected library product:

```sh
swift build --product PotassiumKDrive
```

Use of third-party Swift Package Manager dependencies should be limited and
well justified. Apple-provided SPM libraries are acceptable when they fit the
package scope.

## Code Style

- Follow the Swift API Design Guidelines summarized in `SWIFT.MD`.
- Keep software layers in separate folders and files.
- Keep product modules independent; product code should share transport through
  `PotassiumChannelCore`, not through another product target.
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
