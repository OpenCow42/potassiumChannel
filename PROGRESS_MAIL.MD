# Mail implementation progress

See `/Users/opencow/Software/potassium/PROGRESS_MAIL.MD` for the full prioritized route order.

## Updated assessment

The usable discovery path for the configured account is current-user scoped, not hosting-wide Mail Service listing. Shared networking priority should therefore favor Mail application/current-user routes first, then use discovered `hosting_id`, mailbox name, and mailbox UUID for follow-up requests.

## Priority route order for potassiumChannel

1. [x] `GET https://mail.infomaniak.com/api/mailbox?with=unseen,aliases` via `MailRequests.listUserMailboxes` and `MailService.mailHost(...).listUserMailboxes`.
2. [x] `GET /1/my_ksuite/current?with=mail` via `MailRequests.currentMyKSuite` and `MailService.currentMyKSuite`.
3. [ ] `GET https://mail.infomaniak.com/api/mail/{mailbox_uuid}` — read one mailbox by UUID.
4. [ ] `GET https://mail.infomaniak.com/api/mail/{mailbox_uuid}/folder` or discovered folder resource route — list folders.
5. [ ] `GET https://mail.infomaniak.com/api/mail/{mailbox_uuid}/folder/{folder_id}/threads` or discovered thread resource route — list folder threads/messages.
6. [ ] `GET {message_resource}` — read a message from a returned resource URL.
7. [ ] `GET https://mail.infomaniak.com/api/mailbox/quotas?mailbox={mailbox_name}&product_id={hosting_id}&unit=B` — read mailbox quota.
8. [ ] `POST https://mail.infomaniak.com/api/mail/{mailbox_uuid}/draft` — create/send draft payload.
9. [ ] `PUT https://mail.infomaniak.com/api/mail/{mailbox_uuid}/draft/{draft_uuid}` — update/send draft payload.
10. [ ] `GET https://mail.infomaniak.com/api/mail/{mailbox_uuid}/draft/{draft_uuid}` or returned draft resource — read draft state.
11. [ ] `DELETE https://mail.infomaniak.com/api/mail/{mailbox_uuid}/draft/{draft_uuid}` — cleanup draft fixture.
12. [ ] `GET /1/mail_hostings/{mail_hosting_id}/mailboxes/{mailbox_name}` — read hosting-specific mailbox settings using discovered fields.
13. [ ] `GET /1/mail_hostings/{mail_hosting_id}/mailboxes/{mailbox_name}/aliases` — read aliases/settings if authorized.
14. [ ] `GET /1/mail_hostings/{mail_hosting_id}/mailboxes/{mailbox_name}/forwarding_addresses` — read forwarding settings if authorized.
15. [x] `GET /1/mail_hostings/{mail_hosting_id}/mailboxes` — implemented, but live hosting-wide listing is fixture-gated/disabled for the configured account.

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
