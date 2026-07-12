# potassiumChannel

Typed Swift request builders, DTOs, and service helpers for Infomaniak APIs.

## Overview

`potassiumChannel` is a Swift Package Manager package for building and executing
Infomaniak API requests. It ships as focused library products: a small HTTP core
plus reusable product layers for kDrive, Mail, kChat, the URL shortener, and
OAuth flows.

The package is designed for Swift clients that want typed request descriptions,
`Sendable`-friendly response models, and async service wrappers without copying
transport code or endpoint-specific DTOs into each application.

## Package Contents

- `PotassiumChannelCore`: HTTP primitives such as `APIRequest`,
  `InfomaniakAPIClient`,
  `APIClientConfiguration`, `HTTPMethod`, `HTTPHeader`, query parameters, and
  client errors, plus Infomaniak response wrappers.
- `PotassiumKDrive`: kDrive request builders, models, and service methods for
  drive discovery, files, trash, comments, access, sharing, search,
  activity/statistics, imports, transfers, settings, and preferences.
- `PotassiumMail`: Mail request builders, models, and service methods for
  mailboxes, folders, threads, messages, quota, draft operations, scheduling,
  and mailbox discovery.
- `PotassiumKChat`: kChat request builders, models, and service methods for
  teams, channels, users, posts, files, search, sidebar metadata, and client
  configuration.
- `PotassiumURLShortener`: URL shortener request builders, models, and service
  methods for listing, quota, creation, and updates.
- `PotassiumOAuth`: OAuth helpers for authorization URLs,
  authorization-code token requests, and refresh-token requests.

## Requirements

- Swift 6.2 or newer
- macOS 12+, iOS 15+, tvOS 15+, watchOS 8+, or visionOS 1+
- Swift Testing for the test suite

## Installation

Add the package to a SwiftPM project:

```swift
dependencies: [
    .package(url: "https://github.com/OpenCow42/potassiumChannel.git", branch: "main")
]
```

Then add only the library products a target needs:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "PotassiumChannelCore", package: "potassiumChannel"),
        .product(name: "PotassiumKDrive", package: "potassiumChannel")
    ]
)
```

## Basic Usage

```swift
import PotassiumChannelCore
import PotassiumKDrive

let client = InfomaniakAPIClient(
    configuration: APIClientConfiguration(bearerToken: "<access-token>")
)

let kDrive = KDriveService(client: client)
let drives = try await kDrive.listAccessibleKDrives(accountId: 12345)
```

File transfers return a lazy operation so callers can observe Foundation's
live byte progress before starting the request and can cancel the underlying
URL session task directly:

```swift
let transfer = try kDrive.downloadFile(driveId: 123, fileId: 456)
let progress = transfer.progress
let contents = try await transfer.value
```

Awaiting `value` starts the request once. Multiple awaiters share its result,
while cancelling the operation, its progress, or an awaiting task cancels the
request for every waiter. Transfers continue to use full in-memory `Data` in
this release; streaming and upload sessions are intentionally deferred.

Product services can be created from a shared `InfomaniakAPIClient`, or through
service-specific convenience initializers where provided. Lower-level
`*Requests` builders are also public when callers need to create a typed
`APIRequest` and handle execution themselves.

## Migration From The Old Module

The package no longer exposes a `potassiumChannel` product or module. Replace
`import potassiumChannel` with the product modules used by each source file,
for example `import PotassiumMail` or `import PotassiumKChat`. Code that
constructs `InfomaniakAPIClient`, `APIClientConfiguration`, `APIRequest`, or
response envelopes should also import `PotassiumChannelCore`.

Mail flexible payloads now use `MailJSONValue`; kDrive flexible payloads keep
using `KDriveJSONValue`. `PotassiumMail` does not depend on `PotassiumKDrive`.

## Development

Build the package:

```sh
swift build
```

Run tests:

```sh
swift test
```

## Secrets And Testing

Do not commit API tokens, refresh tokens, account identifiers, mailbox names,
team names, or other live-account details. Tests should use synthetic fixtures,
sample IDs, and request-building assertions unless a maintainer explicitly sets
up an isolated integration environment outside version control.

When adding examples, keep credentials as placeholders such as
`<access-token>` and avoid references to private machines, local files, or
personal accounts.

## Documentation

- [Contributing](CONTRIBUTING.md)
- [Changelog](CHANGELOG.md)
- [License](LICENSE)
