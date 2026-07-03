# Changelog

All notable public changes to this package are summarized here.

## Unreleased

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
