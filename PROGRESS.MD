### Progress of the project

### Package foundation

- Branch: `main`
- Status: merged
- Implemented a Swift Package Manager library target named `potassiumChannel`.
- Package scope: shared networking primitives for Potassium clients.

### Network stack extraction

- Branch: `refactor/network-stack`
- Status: pushed
- Extracted the HTTP channel layer used by Potassium into this standalone
  package:
  - `APIClientConfiguration`
  - `APIClientError`
  - `APIRequest`
  - `HTTPHeader`
  - `HTTPMethod`
  - `InfomaniakAPIClient`
  - `QueryParameter`
- Validation:
  - run `swift build`
  - run `swift test`

### Potassium integration support

- Branch: `feat/kdrive-file-copy-to-drive-post-network`
- Status: pushed, ready for PR
- Purpose: support the Potassium copy-to-drive implementation by referencing the
  reusable network stack extracted into `potassiumChannel`.
- Related Potassium PR: https://github.com/OpenCow42/potassium/pull/53

### Documentation and license replication

- Branch: `feat/kdrive-file-copy-to-drive-post-network`
- Status: in progress
- Replicated and adapted the Potassium markdown project documents for this
  sub-component project:
  - `README.md`
  - `MANIFESTO.MD`
  - `PROGRESS.MD`
  - `SWIFT.MD`
- Duplicated Potassium's `LICENCE.MD`.

### Next work

- Keep future changes small and reviewable.
- Add or update tests whenever network primitives change.
- Keep API-domain behavior in Potassium unless it belongs in this reusable
  transport layer.
