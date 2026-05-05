## potassiumChannel project

### Abstract

This project is the shared networking sub-component for Potassium.

Potassium is a Swift CLI for Infomaniak APIs. `potassiumChannel` provides the
small reusable HTTP layer that Potassium components can depend on without
coupling every package to the executable CLI project.

Home of the GitHub project is here: https://github.com/OpenCow42/potassiumChannel

### Location

Dev project path:
/Users/opencow/Software/potassiumChannel

Main Potassium project path:
/Users/opencow/Software/potassium

Secrets and live API fixtures should remain local-only and must not be committed.
This package should not require checked-in tokens.

### Architecture

`/Users/opencow/Software/potassiumChannel` is a Swift package of type library.
It should expose transport primitives that are stable and useful to Potassium and
related Swift clients:

- API client configuration
- API request description
- HTTP method, headers, and query parameters
- Infomaniak API client implementation
- API-client error handling

The technical stack should be standard Swift 6 code.

Platform minimums are set to the first OS versions with native async/await
support across Apple platforms:

- macOS 12+
- iOS 15+
- tvOS 15+
- watchOS 8+
- visionOS 1+

Use of SPM libraries is allowed but should be limited to a strict minimum. SPM
libraries produced by Apple are allowed without restrictions.

### Specifications

Keep this project scoped to the shared channel layer. Do not add CLI commands,
UI, or Infomaniak domain-service models here unless they are truly transport
concerns.

Code should:

- keep software layers in separate folders and files;
- use `Sendable` and `Codable` where appropriate;
- prefer non-nullable types in public data structures;
- use modern Swift 6 features such as structured concurrency;
- provide clear public APIs that are useful to both humans and agents;
- follow the Swift API Design Guidelines summarized in `SWIFT.MD`.

### Testing

For every new networking primitive or behavior, write corresponding modern Swift
tests using `import Testing`. XCTest is strictly forbidden.

Testing should be run with standard Swift CLI commands:

```sh
swift build
swift test
```

Prefer deterministic unit tests for request construction, URL/query encoding,
headers, error handling, decoding, and client behavior. Live API tests should
remain opt-in and guarded by local environment values when they are needed.

### Project management

Track meaningful progress in both `PROGRESS.MD` and OpenCow's usual task notes.

Push each branch in a dedicated PR on GitHub. Adrien will review and merge PRs.

You can ping Adrien on Telegram regarding any issue.
