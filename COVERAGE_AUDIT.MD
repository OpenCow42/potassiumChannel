# API specification coverage audit

Date: 2026-05-22

## Source of truth

This `potassiumChannel` checkout does not vendor OpenAPI files directly. The
manual audit compared request shapes in this package against Infomaniak OpenAPI
specifications that were available outside this repository at audit time.

Because those specs are not committed here, treat the operation totals below as
a dated manual snapshot. Before relying on exact counts, regenerate the audit
against the current OpenAPI files from the upstream API documentation or from a
local copy supplied by the maintainer.

## Manual coverage snapshot

The May 22, 2026 snapshot below compared literal request shapes now split
across `Sources/PotassiumKDrive`, `Sources/PotassiumMail`,
`Sources/PotassiumKChat`, and `Sources/PotassiumURLShortener` with the
available OpenAPI operation shapes at that time. Dynamic Mail application routes
such as `/api/mailbox` were tracked separately because they were not present in
the audited Mail hosting spec.

| Product | Spec operations | Implemented spec operations | Missing spec operations | Notes |
| --- | ---: | ---: | ---: | --- |
| kDrive | 187 | 105 | 82 | Broad read coverage plus many file, trash, search, activity, settings, import, and mutation routes. |
| Mail hosting spec | 124 | 9 | 115 | Implemented hosting routes focus on mailbox listing/settings, aliases, forwarding, and accounts. |
| Mail application routes | n/a | 9 | n/a | Current-user mailbox discovery, folders, messages, quotas, drafts, schedule/cancel are implemented outside the audited hosting spec. |
| kChat | 173 | 53 | 120 | Core teams, channels, users, posts, files, and search are implemented. |
| URL shortener | 7 | 5 | 2 | Two endpoints remained in the manual snapshot. |

At the time of the manual audit, every public request factory implemented in the
local product modules was referenced by Swift Testing coverage and the full test
suite passed. Exact test and suite counts are intentionally omitted here because
they go stale quickly; run `swift test` in the repository root for current
results.

For a quick shape check, count test files by product under `Tests/` and compare
that with the request families listed below.

## Documentation correctness

- Keep this audit independent of private or sibling-repository progress notes.
  Cross-repository CLI status can be useful context, but it should not be used
  as evidence for local package coverage unless reproduced in this checkout.
- Documentation should clearly distinguish local product-module request, DTO,
  and service coverage from any downstream CLI or live integration coverage
  maintained elsewhere.
- If exact OpenAPI operation counts are important, add a reproducible coverage
  report script or vendor/submodule the spec inputs instead of relying on manual
  notes.

## Finish plan by product

### URL shortener

1. Add quota models and request/service methods for:
   - `GET /1/url-shortener/quota`
   - `GET /2/url-shortener/quota`
2. Add request-shape and response-decoding tests.
3. Mirror downstream CLI support if this library is consumed by a CLI package.

### Mail

1. Separate local package coverage from downstream CLI/live coverage in any
   status documentation.
2. Finish prioritized mailbox-hosting routes identified by the manual audit:
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
2. Keep `README.md` aligned with the current product libraries and import paths.
3. Keep each new route to the existing standard: request construction,
   required path/body/query encoding, optional omission, response decoding, and
   service method coverage.
