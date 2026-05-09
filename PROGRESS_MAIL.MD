# Mail implementation progress

See `/Users/opencow/Software/potassium/PROGRESS_MAIL.MD` for the full prioritized route order.

## Updated assessment

The usable discovery path for the configured account is current-user scoped, not hosting-wide Mail Service listing. Shared networking priority should therefore favor Mail application/current-user routes first, then use discovered `hosting_id`, mailbox name, and mailbox UUID for follow-up requests.

## Priority route order for potassiumChannel

1. [x] `GET https://mail.infomaniak.com/api/mailbox?with=unseen,aliases` via `MailRequests.listUserMailboxes` and `MailService.mailHost(...).listUserMailboxes`.
2. [x] `GET /1/my_ksuite/current?with=mail` via `MailRequests.currentMyKSuite` and `MailService.currentMyKSuite`.
3. [blocked] `GET https://mail.infomaniak.com/api/mail/{mailbox_uuid}` — direct mailbox profile path redirects to login (`302`) with the current token; mailbox profile data currently comes from `GET /api/mailbox`.
4. [x] `GET https://mail.infomaniak.com/api/mail/{mailbox_uuid}/folder?with=ik-static` — list folders.
5. [x] `GET https://mail.infomaniak.com/api/mail/{mailbox_uuid}/folder/{folder_id}/message` — list folder threads/messages.
6. [x] `GET {message_resource}` — read a message from a returned resource URL.
7. [x] `GET https://mail.infomaniak.com/api/mailbox/quotas?mailbox={mailbox_name}&product_id={hosting_id}&unit=B` — read mailbox quota.
8. [x] `POST https://mail.infomaniak.com/api/mail/{mailbox_uuid}/draft` — create/send draft payload.
9. [x] `PUT https://mail.infomaniak.com/api/mail/{mailbox_uuid}/draft/{draft_uuid}` — update/send draft payload.
10. [x] `GET https://mail.infomaniak.com/api/mail/{mailbox_uuid}/draft/{draft_uuid}` or returned draft resource — read draft state.
11. [x] `DELETE https://mail.infomaniak.com/api/mail/{mailbox_uuid}/draft/{draft_uuid}` — cleanup draft fixture.
12. [ ] `GET /1/mail_hostings/{mail_hosting_id}/mailboxes/{mailbox_name}` — read hosting-specific mailbox settings using discovered fields.
13. [x] `GET /1/mail_hostings/{mail_hosting_id}/mailboxes/{mailbox_name}/aliases` — read aliases/settings if authorized.
14. [ ] `GET /1/mail_hostings/{mail_hosting_id}/mailboxes/{mailbox_name}/forwarding_addresses` — read forwarding settings if authorized.
15. [x] `POST /1/mail_hostings/{mail_hosting_id}/mailboxes/{mailbox_name}/aliases` — create a disposable alias fixture, gated by the CLI/live-test layer.
16. [x] `DELETE /1/mail_hostings/{mail_hosting_id}/mailboxes/{mailbox_name}/aliases/{alias}` — remove the disposable alias fixture.
17. [x] `GET /1/mail_hostings/{mail_hosting_id}/mailboxes` — implemented, but live hosting-wide listing is fixture-gated/disabled for the configured account.

## Testing policy

- Add request-construction and response-decoding tests for every route.
- Prefer flexible payload wrappers until schemas are confirmed from live responses.
- Live current-user read routes can run with the local token, but must not print secrets or email addresses.
- Draft/send and destructive routes must be disabled by default behind explicit environment opt-ins.
- Hosting-wide Mail Service routes require a true authorized Mail Service fixture before live tests are enabled.

## Completed routes

- `GET /1/mail_hostings/{mail_hosting_id}/mailboxes`
  - Added Mail request namespace, mailbox models/options, request factory, and service method.
  - Added Swift Testing coverage for path/auth/query encoding and paginated mailbox decoding.
  - Verified with `swift test --filter MailListMailboxesRequestTests`.
- `GET https://mail.infomaniak.com/api/mailbox?with=unseen,aliases`
  - Added current-user mailbox discovery request/service support.
  - Added flexible `UserMailbox` response wrapper.
  - Verified with `swift test --filter Mail`.
- `GET /1/my_ksuite/current?with=mail`
  - Added current my kSuite request/service support.
  - Added flexible `CurrentMyKSuite` response wrapper.
  - Verified with `swift test --filter Mail`.
- `GET https://mail.infomaniak.com/api/mail/{mailbox_uuid}/folder?with=ik-static`
  - Added mailbox folder request/service support.
  - Added flexible `MailFolder` response wrapper.
  - Verified with `swift test --filter Mail`.

## Mail folder threads/messages update

- Added mailbox folder thread/message listing via `GET https://mail.infomaniak.com/api/mail/{mailbox_uuid}/folder/{folder_id}/message`.
- Added flexible thread-list response handling; detailed message reads should use the message/resource URLs surfaced by this listing once the next route is implemented.
- Verified with `swift test --filter Mail`.

## Mail message resource update

- Added message reading from returned message resources (`GET {message_resource}`).
- Added flexible message payload handling and request-construction/decoding tests.
- Verified with `swift test --filter Mail`.

## Mail mailbox quota update

- Added mailbox quota reading via `GET https://mail.infomaniak.com/api/mailbox/quotas?mailbox={mailbox_name}&product_id={hosting_id}&unit=B`.
- Confirmed live API accepts `B`; the Mail OpenAPI spec documents storage units as `B`, `MB`, and `kB` on mailbox quota/settings-related parameters.
- Added CLI support: `potassium mail quota --mailbox <mailbox-name> --product-id <hosting-id> [--unit B|kB|MB]`.
- Verified with `swift test --filter Mail`.

## Mail draft CRUD update

- Added draft creation/update/read/delete support for `POST|PUT|GET|DELETE https://mail.infomaniak.com/api/mail/{mailbox_uuid}/draft[/draft_uuid]`.
- Added flexible draft payload/response handling in `potassiumChannel` and CLI support in `potassium`:
  - `potassium mail draft-create ...`
  - `potassium mail draft-update ...`
  - `potassium mail draft ...`
  - `potassium mail draft-delete ...`
- Live draft creation is intentionally opt-in only (`MAIL_DRAFT_LIVE_TESTS=1` + `MAIL_DRAFT_RECIPIENT`) to avoid silently creating remote draft objects.
- Verified with `swift test --filter Mail` in both repositories.

## Mail draft schedule/cancel update

- Added schedule, delete-schedule, and cancel-send support:
  - `PUT {draft_resource}/schedule`
  - `DELETE {schedule_action}`
  - `PUT {cancel_send_resource}`
- Added flexible schedule response handling in `potassiumChannel` and CLI support in `potassium`:
  - `potassium mail draft-schedule ...`
  - `potassium mail schedule-delete ...`
  - `potassium mail cancel-send ...`
- Schedule/send live execution remains fixture/opt-in policy territory; unit request/CLI coverage is in place.
- Verified with `swift test --filter Mail` in both repositories, plus `swift test --filter CommandLineTests` in `potassium`.

## Mail mailbox settings update

- Added `GET /1/mail_hostings/{mail_hosting_id}/mailboxes/{mailbox_name}` for mailbox settings/capabilities using discovered hosting id and mailbox name.
- Added CLI support: `potassium mail mailbox --mail-hosting-id <id> --mailbox <mailbox-name>`.
- Verified with `swift test --filter Mail`.

## Mail alias read/create/delete update

- Added shared support for `GET /1/mail_hostings/{mail_hosting_id}/mailboxes/{mailbox_name}/aliases` via `MailRequests.listMailboxAliases` and `MailService.listMailboxAliases`, returning flexible `MailboxAliases` payloads.
- Added shared support for `POST /1/mail_hostings/{mail_hosting_id}/mailboxes/{mailbox_name}/aliases` via `MailRequests.addMailboxAlias` and `MailService.addMailboxAlias`, returning `InfomaniakResponse<Bool>`.
- Added shared support for `DELETE /1/mail_hostings/{mail_hosting_id}/mailboxes/{mailbox_name}/aliases/{alias}` via `MailRequests.deleteMailboxAlias` and `MailService.deleteMailboxAlias`, returning `InfomaniakResponse<Bool>`.
- Added `AddMailboxAliasPayload(alias:)` and request/response coverage for method, path, auth/JSON headers, required body encoding, no-body delete behavior, alias payload decoding, and boolean data decoding.
- Verified with `swift test --filter Mail`.
