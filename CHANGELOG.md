# Changelog

All notable public changes to this package are summarized here.

## Unreleased

- Added optional kDrive file `revisedAt` and `etag` metadata so clients can
  construct authoritative content versions and conditional replacements.
- Breaking: `APIClientError.unacceptableStatusCode` now includes
  `APIResponseMetadata`, which safely preserves the server's `Retry-After`
  field without exposing arbitrary response headers.
- Breaking: kDrive binary transfer service methods now return lazy
  `APIRequestOperation` values with live URL session progress and unified
  cancellation instead of immediately awaiting a `Data` response.
- Added synchronous request-operation construction to `InfomaniakAPIClient`;
  typed and raw async conveniences now execute through the same operation
  lifecycle.
- Replaced the client's shared mutable JSON decoder with a concurrent-safe
  response-decoder protocol whose default implementation creates fresh state
  for every response.
- Documented chronological advanced-listing actions and added a newest-first
  view for reducers where the latest server action must win.

- Breaking: split the former single `potassiumChannel` product/module into
  `PotassiumChannelCore`, `PotassiumKDrive`, `PotassiumMail`,
  `PotassiumKChat`, `PotassiumURLShortener`, and `PotassiumOAuth`.
- Breaking: Mail flexible payload APIs now use `MailJSONValue`; kDrive flexible
  payload APIs keep `KDriveJSONValue`, and `PotassiumMail` no longer depends on
  kDrive types.
- Added and expanded typed request builders, service methods, and response models for Infomaniak kDrive, Mail, URL shortener, and OAuth workflows.
- Broadened request-construction and response-decoding coverage across read, create, update, delete, and settings routes.
- Improved tolerant decoding for documented and observed API response envelopes, pagination shapes, nullable fields, and flexible result payloads.
- Added public OAuth helper models and request builders for authorization URL generation, authorization-code exchange, refresh-token exchange, PKCE challenge methods, token responses, and OAuth error responses.
- Continued separating potentially destructive or externally stateful behavior from regular unit coverage so the package remains suitable for repeatable local and CI test runs.

## 2026-05

- Added URL shortener support for listing, creating, updating, and reading quota information across supported API versions.
- Added Mail support for current-user mailbox discovery, mailbox folders, message resources, quotas, drafts, mailbox settings, aliases, forwarding addresses, and hosting-related mailbox routes.
- Added kDrive support for file comments, file operations, trashed-file operations, file versions, share-link settings, AI settings, office settings, trash settings, invitations, access requests, and related read/download helpers.
- Added Infomaniak OAuth helper support for applications that need to manage the OAuth flow directly.
