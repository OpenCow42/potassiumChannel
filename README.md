# potassiumChannel

Shared networking primitives for Potassium clients.

## Abstract

`potassiumChannel` is the reusable Swift package that carries Potassium's HTTP
channel layer. It extracts the request, header, method, query parameter, API
client configuration, and Infomaniak API client error types that are useful
across Potassium components.

The package exists so Potassium can keep API-specific services focused on
Infomaniak domains while sharing a small, testable, Swift 6 networking core.

## Relationship with Potassium

- Main project: https://github.com/OpenCow42/potassium
- Component project: https://github.com/OpenCow42/potassiumChannel
- Initial extraction reference: https://github.com/OpenCow42/potassium/pull/53

Potassium remains the CLI application that targets Infomaniak APIs. This package
is a sub-component intended to be consumed by Potassium and, where useful, by
other Swift clients that need the same Infomaniak-oriented HTTP primitives.

## Technical stack

- Swift Package Manager library package
- Swift 6.2 minimum tools version
- Apple platform minimums aligned with async/await availability:
  - macOS 12+
  - iOS 15+
  - tvOS 15+
  - watchOS 8+
  - visionOS 1+
- Modern Swift concurrency and `Sendable`-friendly model types
- Swift Testing for tests (`import Testing`), not XCTest

## Development

Build the package:

```sh
swift build
```

Run tests:

```sh
swift test
```

Use small, reviewable commits and structured commit messages. Keep the package
focused on networking primitives; API-domain models and CLI behavior should stay
in Potassium unless they are genuinely reusable transport concerns.

## License

This project follows the same license as Potassium. See `LICENCE.MD`.
