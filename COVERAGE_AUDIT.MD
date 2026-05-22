# API specification coverage audit

Date: 2026-05-22

## Source of truth

The current `potassiumChannel` checkout does not vendor OpenAPI files directly.
The vendored specs referenced by the project documentation are in the sibling
Potassium checkout:

- `/Users/opencow/Software/potassium/api_specifications/kdrive_infomaniak_api_1777809422.json`
- `/Users/opencow/Software/potassium/api_specifications/mail_infomaniak_api_1777809438.json`
- `/Users/opencow/Software/potassium/api_specifications/kchat_infomaniak_api_1777809259.json`
- `/Users/opencow/Software/potassium/api_specifications/url-shortener_infomaniak_api_1778320020.json`

## Current coverage

Coverage below compares literal request shapes implemented in
`Sources/potassiumChannel/Infomaniak` with the vendored OpenAPI operation
shapes. Dynamic Mail application routes such as `/api/mailbox` are tracked
separately because they are not present in the vendored Mail hosting spec.

| Product | Spec operations | Implemented spec operations | Missing spec operations | Notes |
| --- | ---: | ---: | ---: | --- |
| kDrive | 187 | 105 | 82 | Broad read coverage plus many file, trash, search, activity, settings, import, and mutation routes. |
| Mail hosting spec | 124 | 9 | 115 | Implemented hosting routes focus on mailbox listing/settings, aliases, forwarding, and accounts. |
| Mail application routes | n/a | 9 | n/a | Current-user mailbox discovery, folders, messages, quotas, drafts, schedule/cancel are implemented outside the vendored hosting spec. |
| kChat | 173 | 53 | 120 | Core teams, channels, users, posts, files, and search are implemented. |
| URL shortener | 7 | 5 | 2 | Only v1/v2 quota endpoints remain. |

Every public request factory currently implemented in `potassiumChannel` is
referenced by Swift Testing coverage, and the current test run passes:

- `swift test` passed with 470 tests in 161 suites.
- Test files by product: kDrive 102, kChat 52, Mail 2, URL shortener 5.

## Documentation correctness

- `PROGRESS_MAIL.MD` is accurate for the current-user Mail strategy: it correctly
  marks `GET /api/mail/{mailbox_uuid}` as blocked and prioritizes `/api/mailbox`
  discovery.
- `PROGRESS_MAIL.MD` is less complete than the sibling
  `/Users/opencow/Software/potassium/PROGRESS_MAIL.MD`: the sibling plan still
  lists open Mail hosting work such as mailbox `PATCH` and mailing-list routes.
- `PROGRESS_MAIL.MD` mentions CLI support in Potassium. That is useful cross-repo
  context, but it should be clearly labeled as sibling-repo coverage, not local
  `potassiumChannel` coverage.
- `README.md` still describes this package as mostly shared networking
  primitives. The package now contains reusable product request factories, DTOs,
  and service layers for kDrive, Mail, kChat, and URL shortener, so README scope
  is stale.
- The vendored spec location is not documented inside this repo except through
  an absolute sibling path. A portable note should explain that specs are sourced
  from Potassium's `api_specifications` directory, or the specs should be
  vendored/submoduled here.

## Finish plan by product

### URL shortener

1. Add quota models and request/service methods for:
   - `GET /1/url-shortener/quota`
   - `GET /2/url-shortener/quota`
2. Add request-shape and response-decoding tests.
3. Mirror the CLI support in Potassium if this library is consumed there.

### Mail

1. Reconcile `PROGRESS_MAIL.MD` with the sibling plan:
   - Add the missing open items from the sibling doc.
   - Separate local channel coverage from Potassium CLI/live coverage.
2. Finish prioritized mailbox-hosting routes already identified by the sibling
   plan:
   - `PATCH /1/mail_hostings/{mail_hosting_id}/mailboxes/{mailbox_name}`
   - `POST /1/mail_hostings/{mail_hosting_id}/mailing_lists`
   - `PUT /1/mail_hostings/{mail_hosting_id}/mailing_lists/{mailing_list_name}/send`
3. Add read-first hosting clusters before broad mutations:
   - preferences, signatures/templates, auto replies, filters, redirections,
     mailbox auth/folders, webmail/device accesses, invitations, mailing lists.
4. Add destructive/admin mutations only with fixture-gated tests and rollback
   notes, following the existing alias/forwarding pattern.

### kDrive

1. Close low-risk read/download gaps:
   - share-link detail, access-request detail, user-invitation detail, file
     version download, archive/share download.
2. Finish small paired mutation groups with rollback tests:
   - category create/edit/delete and file-category attach/detach.
   - share-link and dropbox create/update/invite/delete.
   - file access grants/check/force/sync-parent/user/team deletion.
3. Complete operational/admin surfaces:
   - upload sessions v2/v3, batch cleanup, imports create/delete, user
     create/delete/lock/unlock/manager, activity-report create/delete.
4. Add high-risk file state routes last:
   - v3 file lock/unlock, trash bulk delete, version restore/delete by version.

### kChat

1. Finish media read gaps:
   - file preview and thumbnail.
2. Add social/message adjuncts:
   - post reactions, thread following, custom status, channel categories.
3. Add admin/read clusters:
   - bots, commands, emoji, hooks, groups, roles, top analytics.
4. Add destructive/admin mutations after read coverage:
   - channel deletion, member removal, command/hook/emoji deletion, reaction
     deletion.

### Cross-product

1. Add a generated spec coverage report script that emits implemented, missing,
   and extra operation shapes per product.
2. Update `README.md` to describe the current product-service scope.
3. Keep each new route to the existing standard: request construction,
   required path/body/query encoding, optional omission, response decoding, and
   service method coverage.
