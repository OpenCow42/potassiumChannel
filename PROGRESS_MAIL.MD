# Mail implementation progress

See `/Users/opencow/Software/potassium/PROGRESS_MAIL.MD` for the route order. Shared networking work begins with:

- [x] `GET /1/mail_hostings/{mail_hosting_id}/mailboxes` via `MailRequests.listMailboxes` and `MailService.listMailboxes`.

## Completed routes

- `GET /1/mail_hostings/{mail_hosting_id}/mailboxes`
  - Added Mail request namespace, mailbox models/options, request factory, and service method.
  - Added Swift Testing coverage for path/auth/query encoding and paginated mailbox decoding.
  - Verified with `swift test --filter MailListMailboxesRequestTests`.

## Mailbox discovery update

- Added `MailRequests.listUserMailboxes` for `GET https://mail.infomaniak.com/api/mailbox?with=unseen,aliases`.
- Added `MailRequests.currentMyKSuite` for `GET /1/my_ksuite/current?with=mail`.
- Added flexible response wrappers for user mailbox and current my kSuite payloads.
- Verified with `swift test --filter Mail`.
