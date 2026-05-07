## 2026-05-07 — kDrive v2 file version detail route

- Added shared support for `GET /2/drive/{drive_id}/files/{file_id}/versions/{version_id}` via `KDriveRequests.getFileVersionV2` and `KDriveService.getFileVersionV2`, reusing `KDriveFileVersionV2`.
- Added request/decoding tests covering method, OpenAPI v2 path with required `drive_id`/`file_id`/`version_id`, auth header, absent query parameters, explicit required path parameter substitution checks, and single-version decoding.
- Validation: `swift test` passes (309 tests).

## 2026-05-07 — kDrive v2 file versions route

- Added shared support for `GET /2/drive/{drive_id}/files/{file_id}/versions` via `KDriveRequests.listFileVersionsV2`, `KDriveService.listFileVersionsV2`, and `KDriveFileVersionV2`, keeping it distinct from the existing v3 `listFileVersions` route.
- Added request/decoding tests covering method, OpenAPI v2 path with required `drive_id`/`file_id`, auth header, optional `order_by`/`order`/`order_for` query parameters, absent query parameters, explicit required path parameter substitution checks, and `converted_type`/`name` decoding.
- Validation: `swift test` passes (306 tests).

## 2026-05-07 — kDrive file temporary URL route

- Added shared support for `GET /2/drive/{drive_id}/files/{file_id}/temporary_url` via `KDriveRequests.getFileTemporaryURL`, `KDriveService.getFileTemporaryURL`, and `KDriveFileTemporaryURL`.
- Added request/decoding tests covering method, OpenAPI path with required `drive_id`/`file_id`, auth header, optional `duration` query parameter, absent query parameters, explicit required path parameter substitution checks, and `temporary_url` decoding.
- Validation: `swift test` passes (302 tests).

## 2026-05-07 — kDrive file hash route

- Added shared support for `GET /2/drive/{drive_id}/files/{file_id}/hash` via `KDriveRequests.getFileHash`, `KDriveService.getFileHash`, and `KDriveFileHash`.
- Added request/decoding tests covering method, OpenAPI path with required `drive_id`/`file_id`, auth header, absent query parameters, explicit required path parameter substitution checks, and `hash` decoding.
- Validation: `swift test` passes (299 tests).

## 2026-05-07 — kDrive file size route

- Added shared support for `GET /2/drive/{drive_id}/files/{file_id}/sizes` via `KDriveRequests.getFileSize`, `KDriveService.getFileSize`, and `KDriveFileSize`.
- Added request/decoding tests covering method, OpenAPI path with required `drive_id`/`file_id`, auth header, optional `depth` query parameter, and `storage_size` decoding.
- Validation: `swift test` passes (296 tests).

## 2026-05-07 — kDrive import errored files route

- Added shared support for `GET /2/drive/{drive_id}/imports/{import_id}` via `KDriveRequests.listErroredImportFiles`, `KDriveService.listErroredImportFiles`, and `KDriveExternalImportFile`.
- Added request/decoding tests covering method, OpenAPI path with required `drive_id`/`import_id`, auth header, optional `with`/pagination/`total` query parameters, and response decoding.
- Validation: `swift test` passes (292 tests).

## 2026-05-07 — kDrive OAuth import eligible drives route

- Added shared support for `GET /2/drive/{drive_id}/imports/oauth/drives` via `KDriveRequests.listOAuthImportDrives`, `KDriveService.listOAuthImportDrives`, `KDriveThirdPartyDrivesList`, and `KDriveThirdPartyDrive`.
- Added request/decoding tests covering method, OpenAPI path, auth header, required `application` query parameter, optional `access_token_id`/`auth_code`, and response decoding.
- Validation: `swift test` passes (289 tests).

## 2026-05-07 — kDrive export activity share links statistics route

- Added shared support for `GET /2/drive/{drive_id}/statistics/activities/links/export` via `KDriveRequests.exportActivityShareLinks`, `KDriveService.exportActivityShareLinks`, and `ExportKDriveActivityShareLinksOptions`, reusing `KDriveStatisticShareLink`.
- Added request/decoding tests covering method, OpenAPI path, auth header, required `from` and `until` query parameters, optional export filters, and non-paginated share-link response decoding.
- Validation: `swift test` passes (286 tests).

### Progress of the project

## 2026-05-07 — kDrive activity share links statistics route

- Added shared support for `GET /2/drive/{drive_id}/statistics/activities/links` via `KDriveRequests.listActivityShareLinks`, `KDriveService.listActivityShareLinks`, `KDriveStatisticShareLink`, `KDriveStatisticShareLinkCapabilities`, and `ListKDriveActivityShareLinksOptions`.
- Added request/decoding tests covering method, OpenAPI path, auth header, required `from` and `until` query parameters, optional filters/sorting/pagination, and share-link fields.
- Validation: `swift test` passes (284 tests).

## 2026-05-07 — kDrive activity share links statistics route

- Added shared typed support for `GET /2/drive/{drive_id}/statistics/activities/links` via `KDriveRequests.listActivityShareLinks` and `KDriveService.listActivityShareLinks`.
- Added DTO/query option coverage for activity share-link statistics and request/decoding tests with explicit required `from`/`until` query checks.
- Validation: `swift test` passes.

## 2026-05-07 — kDrive activity chart statistics route

- Added shared support for `GET /2/drive/{drive_id}/statistics/activities` via `KDriveRequests.chartActivities` and `KDriveService.chartActivities`, returning `KDriveChart` for the required `metric` query parameter.
- Added request/decoding tests covering method, OpenAPI path, auth header, required `from`, `interval`, `metric`, and `until` query parameters, and chart decoding.
- Validation: `swift test` passes (281 tests).

## 2026-05-07 — kDrive activity shared files statistics route

- Added shared support for `GET /2/drive/{drive_id}/statistics/activities/shared_files` via `KDriveRequests.listActivitySharedFiles`, `KDriveService.listActivitySharedFiles`, and `KDriveSharedFileActivity`.
- Added request/decoding tests covering method, OpenAPI path, auth header, required `from` and `until` query parameters, and shared-file fields.
- Validation: `swift test` passes (279 tests).


## 2026-05-07 — kDrive activity users statistics route

- Added shared support for `GET /2/drive/{drive_id}/statistics/activities/users` via `KDriveRequests.listActivityUsers`, `KDriveService.listActivityUsers`, and `KDriveActiveMember`.
- Added request/decoding tests covering method, OpenAPI path, auth header, required `from` and `until` query parameters, and nullable user fields.
- Validation: `swift test` passes (277 tests).

## 2026-05-07 — kDrive export file sizes route

- Added shared support for `GET /2/drive/{drive_id}/statistics/sizes/export` via `KDriveRequests.exportFileSizes` and `KDriveService.exportFileSizes`, returning raw CSV `Data` with `Accept: text/csv`.
- Added request coverage for method/path/auth/CSV accept header and required `from`, `interval`, repeated `metrics`, and `until` query parameters.
- Validation: `swift test` passes (276 tests).

## 2026-05-07 — kDrive chart file sizes route consumed by Potassium CLI

- Existing shared `GET /2/drive/{drive_id}/statistics/sizes` support (`KDriveRequests.chartFileSizes`, `KDriveService.chartFileSizes`, `KDriveChart`) was verified while wiring Potassium CLI on `feat/kdrive`.
- No channel code changes were required for this follow-up; Potassium now consumes this route through `potassium kdrive chart-file-sizes`.

### Implemented API route inventory

`potassiumChannel` owns shared typed routes and DTOs segmented by target app.

#### kDrive

`potassiumChannel` owns the shared Infomaniak response envelopes, kDrive DTOs,
kDrive request factories, and `KDriveService` wrappers moved from Potassium.

| Method | Route | Request factory |
| --- | --- | --- |
| GET | `/2/drive` | `KDriveRequests.listAccessibleKDrives` |
| GET | `/3/drive/{drive_id}/users` | `KDriveRequests.listDriveUsers` |
| GET | `/3/drive/{drive_id}/files/recents` | `KDriveRequests.listRecentFiles` |
| GET | `/3/drive/{drive_id}/files/largest` | `KDriveRequests.listLargestFiles` |
| GET | `/3/drive/{drive_id}/files/last_modified` | `KDriveRequests.listLastModifiedFiles` |
| GET | `/3/drive/{drive_id}/files/most_versions` | `KDriveRequests.listMostVersionedFiles` |
| GET | `/3/drive/{drive_id}/files/favorites` | `KDriveRequests.listFavoriteFiles` |
| GET | `/3/drive/{drive_id}/files/dropboxes` | `KDriveRequests.listDropboxes` |
| GET | `/3/drive/{drive_id}/files/my_shared` | `KDriveRequests.listMySharedFiles` |
| GET | `/3/drive/{drive_id}/files/shared_with_me` | `KDriveRequests.listSharedWithMeFiles` |
| GET | `/3/drive/{drive_id}/files/links` | `KDriveRequests.listShareLinkFiles` |
| GET | `/3/drive/{drive_id}/files/search` | `KDriveRequests.searchFiles` |
| GET | `/3/drive/{drive_id}/files/search/favorites` | `KDriveRequests.searchFavorites` |
| GET | `/3/drive/{drive_id}/files/search/my_shared` | `KDriveRequests.searchMyShared` |
| GET | `/3/drive/{drive_id}/files/search/shared_with_me` | `KDriveRequests.searchSharedWithMe` |
| GET | `/3/drive/{drive_id}/trash` | `KDriveRequests.listTrashFiles` |
| GET | `/3/drive/{drive_id}/files/{file_id}` | `KDriveRequests.getFile` |
| GET | `/3/drive/{drive_id}/files/{file_id}/name` | `KDriveRequests.getFileByName` |
| GET | `/3/drive/{drive_id}/files/{file_id}/activities` | `KDriveRequests.listFileActivities` |
| GET | `/3/drive/{drive_id}/files/{file_id}/files` | `KDriveRequests.listDirectoryFiles` |
| GET | `/3/drive/{drive_id}/trash/{file_id}` | `KDriveRequests.getTrashedFile` |
| GET | `/2/drive/{drive_id}/files/{file_id}/download` | `KDriveRequests.downloadFile` |
| POST | `/3/drive/{drive_id}/upload` | `KDriveRequests.uploadFile` |
| GET | `/2/drive/{drive_id}/trash/{file_id}/thumbnail` | `KDriveRequests.getV2TrashedItemThumbnail` |
| GET | `/2/drive/{drive_id}/trash/{file_id}/count` | `KDriveRequests.getV2TrashedItemCount` |
| GET | `/3/drive/{drive_id}/trash/{file_id}/count` | `KDriveRequests.getTrashedItemCount` |
| GET | `/3/drive/{drive_id}/trash/{file_id}/files` | `KDriveRequests.listTrashedDirectoryFiles` |
| GET | `/3/drive/{drive_id}/files/search/trash` | `KDriveRequests.searchTrash` |
| GET | `/3/drive/{drive_id}/files/search/dropboxes` | `KDriveRequests.searchDropboxes` |
| GET | `/3/drive/{drive_id}/files/search/links` | `KDriveRequests.searchShareLinks` |
| GET | `/2/drive/{drive_id}` | `KDriveRequests.getDrive` |
| GET | `/2/drive/{drive_id}/settings` | `KDriveRequests.getDriveSettings` |
| GET | `/2/drive/{drive_id}/categories` | `KDriveRequests.listCategories` |
| GET | `/2/drive/{drive_id}/categories/rights` | `KDriveRequests.getCategoryRights` |
| GET | `/2/drive/{drive_id}/trash/count` | `KDriveRequests.getTrashCount` |
| GET | `/3/drive/{drive_id}/files/{file_id}/count` | `KDriveRequests.getDirectoryCount` |
| GET | `/2/drive/{drive_id}/files/{file_id}/sizes` | `KDriveRequests.getFileSize` |
| GET | `/3/drive/{drive_id}/files/{file_id}/versions` | `KDriveRequests.listFileVersions` |
| GET | `/2/drive/{drive_id}/files/{file_id}/versions` | `KDriveRequests.listFileVersionsV2` |
| GET | `/2/drive/{drive_id}/files/{file_id}/versions/{version_id}` | `KDriveRequests.getFileVersionV2` |
| GET | `/2/drive/{drive_id}/activities` | `KDriveRequests.listActivities` |
| GET | `/3/drive/{drive_id}/activities` | `KDriveRequests.listDriveActivities` |
| GET | `/3/drive/{drive_id}/activities/total` | `KDriveRequests.listDriveActivityTotals` |
| GET | `/2/drive/{drive_id}/statistics/sizes` | `KDriveRequests.chartFileSizes` |
| GET | `/2/drive/{drive_id}/statistics/activities` | `KDriveRequests.chartActivities` |
| GET | `/2/drive/{drive_id}/statistics/activities/users` | `KDriveRequests.listActivityUsers` |
| GET | `/2/drive/{drive_id}/statistics/activities/shared_files` | `KDriveRequests.listActivitySharedFiles` |
| GET | `/2/drive/{drive_id}/statistics/activities/links` | `KDriveRequests.listActivityShareLinks` |
| GET | `/2/drive/{drive_id}/statistics/activities/links/export` | `KDriveRequests.exportActivityShareLinks` |
| GET | `/2/drive/{drive_id}/activities/reports` | `KDriveRequests.listActivityReports` |
| GET | `/2/drive/{drive_id}/imports` | `KDriveRequests.listImports` |
| GET | `/2/drive/{drive_id}/imports/{import_id}` | `KDriveRequests.listErroredImportFiles` |
| GET | `/2/drive/{drive_id}/imports/oauth/drives` | `KDriveRequests.listOAuthImportDrives` |
| GET | `/2/drive/{drive_id}/users/invitation` | `KDriveRequests.listUserInvitations` |
| GET | `/2/drive/preferences` | `KDriveRequests.getUserPreferences` |
| GET | `/2/drive/users` | `KDriveRequests.listKDriveUsers` |
| GET | `/2/drive/{drive_id}/files/archives/{archive_uuid}` | `KDriveRequests.downloadArchive` |
| POST | `/3/drive/{drive_id}/files/{file_id}/file` | `KDriveRequests.createDefaultFileV3` |
| POST | `/2/drive/{drive_id}/files/{file_id}/rename` | `KDriveRequests.renameFileV2` |
| POST | `/3/drive/{drive_id}/files/{file_id}/copy/{destination_directory_id}` | `KDriveRequests.copyFileToDirectoryV3` |
| DELETE | `/2/drive/{drive_id}/files/{file_id}` | `KDriveRequests.trashFileV2` |

#### Mail

not started

#### kChat

| Method | Route | Request factory |
| --- | --- | --- |
| GET | `/api/v4/config/client` | `KChatRequests.getClientConfig` |
| GET | `/api/v4/channels` | `KChatRequests.listChannels` |
| GET | `/api/v4/channels/{channel_id}` | `KChatRequests.getChannel` |
| POST | `/api/v4/channels/search` | `KChatRequests.searchAllChannels` |
| GET | `/api/v4/channels/{channel_id}/stats` | `KChatRequests.getChannelStats` |
| GET | `/api/v4/channels/{channel_id}/members/{user_id}` | `KChatRequests.getChannelMember` |
| POST | `/api/v4/channels/{channel_id}/members/ids` | `KChatRequests.getChannelMembersByIds` |
| GET | `/api/v4/teams` | `KChatRequests.listTeams` |
| POST | `/api/v4/teams/{team_id}/members/ids` | `KChatRequests.getTeamMembersByIds` |
| GET | `/api/v4/teams/{team_id}/stats` | `KChatRequests.getTeamStats` |
| GET | `/api/v4/teams/{team_id}/members/{user_id}` | `KChatRequests.getTeamMember` |
| GET | `/api/v4/users/{user_id}/image` | `KChatRequests.getUserImage` |
| GET | `/api/v4/users/{user_id}/image/default` | `KChatRequests.getUserDefaultImage` |
| GET | `/api/v4/users/{user_id}/teams/members` | `KChatRequests.getUserTeamMembers` |
| GET | `/api/v4/users/{user_id}/teams/unread` | `KChatRequests.getUserTeamsUnread` |
| GET | `/api/v4/users/{user_id}/teams/{team_id}/unread` | `KChatRequests.getUserTeamUnread` |
| POST | `/api/v4/users/usernames` | `KChatRequests.getUsersByUsernames` |
| GET | `/api/v4/channels/{channel_id}/posts` | `KChatRequests.getChannelPosts` |
| GET | `/api/v4/posts/{post_id}` | `KChatRequests.getPost` |
| GET | `/api/v4/posts/{post_id}/thread` | `KChatRequests.getPostThread` |
| POST | `/api/v4/users/group_channels` | `KChatRequests.getUsersByGroupChannels` |

### Implemented DTO and service scope

#### kDrive

- Infomaniak response envelopes: `InfomaniakResponse`, `PaginatedInfomaniakResponse`, `CursorPaginatedInfomaniakResponse`.
- kDrive response DTOs and option/body DTOs required by the routes above.
- `KDriveService`, which sends the route factories through `InfomaniakAPIClient`.

#### Mail

not started

#### kChat

- `KChatClientConfig` response DTO for Mattermost-compatible client configuration values.
- `KChatListTeamsOptions` for the Mattermost-compatible teams list endpoint.
- `KChatListChannelsOptions` for the Mattermost-compatible all channels list endpoint.
- `KChatSearchAllChannelsOptions` and `KChatSearchAllChannelsResponse` for `POST /api/v4/channels/search`, including optional `system_console` query support and flexible paginated/non-paginated response decoding.
- `KChatRequests.getClientConfig(format:)`, `listTeams(options:)`, `getUsersByUsernames(body:)`, `getUsersByGroupChannels(body:)`, `getChannelPosts(channelId:options:)`, `getPost(postId:)`, and `getPostThread(postId:)` request factories.
- `KChatPost` and `KChatPostList` Mattermost-compatible post DTOs.
- `KChatService`, which sends kChat route factories through `InfomaniakAPIClient`, includes `getPostThread(postId:)`, and can build `https://<team>.kchat.infomaniak.com` base URLs.
- `KChatService.listTeams(options:)` convenience API returning `[KChatTeam]`.
- `KChatService.listChannels(options:)` convenience API returning `[KChatChannel]`.
- `KChatService.searchAllChannels(options:)` convenience API returning `KChatSearchAllChannelsResponse`.
- `KChatService.getChannel(channelId:)` convenience API returning `KChatChannel`.
- `KChatService.getChannelByName(teamId:channelName:)` convenience API returning `KChatChannel`.
- `KChatService.getChannelStats(channelId:)` convenience API returning `KChatChannelStats`.
- `KChatService.getChannelMember(channelId:userId:)` convenience API returning `KChatChannelMember`.
- `KChatService.getChannelMembersByIds(channelId:userIds:)` convenience API returning `[KChatChannelMember]`.
- `KChatService.getTeamStats(teamId:)` convenience API returning `KChatTeamStats`.
- `KChatService.getTeamMember(teamId:userId:)` convenience API returning `KChatTeamMember`.
- `KChatService.getUserTeamMembers(userId:)` convenience API returning `[KChatTeamMember]`.
- `KChatService.getUserTeamsUnread(userId:)` convenience API returning `[KChatTeamUnread]`.
- `KChatService.getUserTeamUnread(userId:teamId:)` convenience API returning `KChatTeamUnread`.
- `KChatService.getUserImage(userId:)`, which returns profile image bytes through the raw-data send path.
- `KChatService.getUserDefaultImage(userId:)`, which returns generated default profile image bytes through the raw-data send path.

### Validation

- `swift test` passes with route/DTO/channel coverage.


## 2026-05-07 — kChat get channel member route

- Verified OpenAPI `GetChannelMember` for `GET /api/v4/channels/{channel_id}/members/{user_id}`; response is Mattermost-compatible `ChannelMember`.
- Reused existing `KChatChannelMember`, including numeric `channel_id`/`user_id` string decoding.
- Added `KChatRequests.getChannelMember(channelId:userId:)` and `KChatService.getChannelMember(channelId:userId:)` returning `KChatChannelMember`.
- Added unit coverage for method/path/auth/accept headers, no body/query, percent-encoded channel id and user id path segments, and response decoding.

## 2026-05-07 — kChat get channel by team name and channel name route

- Verified OpenAPI `GetChannelByNameForTeamName` for `GET /api/v4/teams/name/{team_name}/channels/name/{channel_name}`; response is Mattermost-compatible `Channel`, with optional `include_deleted` query defaulting false.
- Reused existing `KChatChannel` for response decoding.
- Added `KChatRequests.getChannelByNameForTeamName(teamName:channelName:)` and `KChatService.getChannelByNameForTeamName(teamName:channelName:)` returning `KChatChannel`.
- Added unit coverage for method/path/auth/accept headers, no body/query, percent-encoded team name and channel name path segments, and response decoding.

## 2026-05-07 — kChat get channel by name route

- Verified OpenAPI `GetChannelByName` for `GET /api/v4/teams/{team_id}/channels/name/{channel_name}`; response is Mattermost-compatible `Channel`, with optional `include_deleted` query defaulting false.
- Reused existing `KChatChannel` for response decoding.
- Added `KChatRequests.getChannelByName(teamId:channelName:)` and `KChatService.getChannelByName(teamId:channelName:)` returning `KChatChannel`.
- Added unit coverage for method/path/auth/accept headers, no body/query, percent-encoded team id and channel name path segments, and response decoding.

## 2026-05-07 — kChat get channel route

- Verified OpenAPI `GetChannel` for `GET /api/v4/channels/{channel_id}`; response is `Channel`.
- Reused `KChatChannel` for Mattermost-compatible channel decoding.
- Added `KChatRequests.getChannel(channelId:)` and `KChatService.getChannel(channelId:)`.
- Added unit tests covering GET method, OpenAPI path, auth/accept headers, no query/body, path-segment percent encoding, and snake-case response decoding.

## 2026-05-07 — kChat get all channels route

- Target app: kChat.
- Branch: `feat/kchat`.
- Verified OpenAPI `GetAllChannels` for `GET /api/v4/channels`; response is an array of `ChannelWithTeamData`.
- Added `KChatRequests.listChannels(options:)` with `page`, `per_page`, `exclude_default_channels`, `include_deleted`, `include_total_count`, and `exclude_policy_constrained` query parameters.
- Reused and extended `KChatChannel` for optional team metadata (`team_display_name`, `team_name`, `team_update_at`, `policy_id`).
- Added `KChatService.listChannels(options:)` convenience API returning `[KChatChannel]`.
- Added unit tests covering GET method, OpenAPI path, auth/accept headers, query encoding, omitted empty options, no body, and snake-case channel/team metadata decoding.


## 2026-05-07 — kChat get team stats route

- Added `GET /api/v4/teams/{team_id}/stats` request support via `KChatRequests.getTeamStats`.
- Added `KChatTeamStats` Mattermost-compatible response DTO with `team_id`, `total_member_count`, and `active_member_count` decoding.
- Added `KChatService.getTeamStats(teamId:)` convenience API returning `KChatTeamStats`.
- Added unit tests covering GET method, OpenAPI path, auth/accept headers, no query/body, percent encoding, and snake-case response decoding.

## 2026-05-07 — kChat get team member route

- Added `GET /api/v4/teams/{team_id}/members/{user_id}` request support via `KChatRequests.getTeamMember`.
- Reused `KChatTeamMember`, including its hardened numeric `user_id` decoding to `String`.
- Added `KChatService.getTeamMember(teamId:userId:)` convenience API returning `KChatTeamMember`.
- Added unit tests covering GET method, OpenAPI path, auth/accept headers, no query/body, percent encoding for both path segments, and response decoding including numeric `user_id`.

## 2026-05-07 — kChat get all teams route

- Target app: kChat.
- Branch: `feat/kchat`.
- Added `GET /api/v4/teams` request support via `KChatRequests.listTeams(options:)`.
- Added `KChatListTeamsOptions` for `page`, `per_page`, `include_total_count`, and `exclude_policy_constrained` query parameters.
- Reused `KChatTeam` response decoding and added `KChatService.listTeams(options:)` convenience API.
- Added unit tests covering GET method, OpenAPI path, auth/accept headers, query encoding, omitted empty options, no body, and snake-case team response decoding.
- Verified with `swift test` in `potassiumChannel`.

## 2026-05-07 — kChat get user team unread route

- Added `GET /api/v4/users/{user_id}/teams/{team_id}/unread` request support via `KChatRequests.getUserTeamUnread`.
- Added `KChatService.getUserTeamUnread(userId:teamId:)` convenience API returning `KChatTeamUnread`.
- Added unit tests covering GET method, OpenAPI path, auth/accept headers, no query, no body, special `me`, percent encoding for both user and team ids, and response decoding.
- Live verification against the configured kChat tenant returned 404 route not found for this singular-team endpoint while `/api/v4/users/{user_id}/teams/unread` exists, so downstream live coverage should stay guarded/documentary unless the API becomes available.

## 2026-05-07 — kChat get user team unreads route

- Added `GET /api/v4/users/{user_id}/teams/unread` request support via `KChatRequests.getUserTeamsUnread`.
- Added `KChatTeamUnread` response model for Mattermost-compatible team unread rows.
- Added `KChatService.getUserTeamsUnread(userId:)` convenience API.
- Added unit tests covering GET method, OpenAPI path, auth/accept headers, no query, no body, special `me`, path encoding, and response decoding.

## 2026-05-07 — kChat get user team members route

- Added `GET /api/v4/users/{user_id}/teams/members` request support via `KChatRequests.getUserTeamMembers`.
- Added `KChatTeamMember` response model for Mattermost-compatible team membership rows.
- Added `KChatService.getUserTeamMembers(userId:)` convenience API.
- Added unit tests covering GET method, OpenAPI path, auth/accept headers, no query, no body, special `me`, path encoding, and response decoding.

## 2026-05-06 — kChat get user default image route

- Added `GET /api/v4/users/{user_id}/image/default` request support via `KChatRequests.getUserDefaultImage`.
- Added `KChatService.getUserDefaultImage(userId:)` convenience API returning raw default profile image bytes through `InfomaniakAPIClient.sendData`.
- Added unit tests covering GET method, OpenAPI path, auth/accept headers, no content type, no query, no body, and the special `me` user id path.

## 2026-05-06 — kChat get users by group channels route

- Added `POST /api/v4/users/group_channels` request support via `KChatRequests.getUsersByGroupChannels`.
- Added `KChatService.getUsersByGroupChannels(channelIds:)` convenience API returning the OpenAPI response shape as `[String: [KChatUser]]` keyed by group-channel id.
- Added unit tests covering POST method, OpenAPI path, auth/accept/content-type headers, JSON array body, no query parameters, and response decoding.

## 2026-05-06 — kChat get users by usernames route

- Added `POST /api/v4/users/usernames` request support via `KChatRequests.getUsersByUsernames`.
- Added `KChatService.getUsersByUsernames(usernames:)` convenience API reusing `KChatUser` response decoding.
- Added unit tests covering POST method, OpenAPI path, auth/accept/content-type headers, JSON array body, no query parameters, and response decoding.


## 2026-05-05 — kDrive create directory route

- Added `POST /3/drive/{drive_id}/files/{file_id}/directory` request support via `KDriveRequests.createDirectoryV3`.
- Added `CreateKDriveDirectoryOptions` with required `name` and optional `color`, `only_for_me`, and `relative_path` JSON fields.
- Added `KDriveService.createDirectory(...)` convenience API.
- Added unit tests covering the OpenAPI path/query/body shape and snake-case body encoding.
- Verified with `swift test` in `potassiumChannel`.

## 2026-05-05 — kDrive create default file route

- Added `POST /3/drive/{drive_id}/files/{file_id}/file` request support via `KDriveRequests.createDefaultFileV3`.
- Added `CreateKDriveDefaultFileOptions` with required `name` and `type` JSON fields.
- Added `KDriveService.createDefaultFile(...)` convenience API.
- Added unit tests covering the OpenAPI path/query/body shape and required body encoding.
- Verified with `swift test` in `potassiumChannel`.

## 2026-05-05 — kDrive rename file route

- Added `POST /2/drive/{drive_id}/files/{file_id}/rename` request support via `KDriveRequests.renameFileV2`.
- Added `RenameKDriveFileOptions` with required `name` JSON field.
- Added `KDriveService.renameFile(...)` convenience API.
- Added unit tests covering the OpenAPI v2 path/body shape and required body encoding.
- Verified with `swift test` in `potassiumChannel`.

## 2026-05-05 — kChat client config route (PR #11)

- Target app: kChat.
- PR: #11 (`feat/kchat-client-config-route`).
- Added `GET /api/v4/config/client?format=old` request support via `KChatRequests.getClientConfig(format:)`.
- Added `KChatClientConfig` for the Mattermost-compatible client configuration response body returned by kChat team hosts.
- Added `KChatService.getClientConfig(format:)` convenience API.
- Added `KChatService.baseURL(teamName:)` and team-token initializer for `https://<team>.kchat.infomaniak.com`.
- Added unit tests covering the OpenAPI path, required `format` query parameter, auth header, kChat team base URL, and response value decoding.
- Verified with `swift test` in `potassiumChannel`.

## 2026-05-05 — kChat user search route

- Target app: kChat.
- Branch: `feat/kchat-user-search`.
- Added `POST /api/v4/users/search` request support via `KChatRequests.searchUsers(body:)` using the Mattermost-compatible kChat team host.
- Added `KChatUserSearchOptions` with OpenAPI search criteria fields (`term`, team/channel/group filters, `allow_inactive`, `without_team`, and `limit`).
- Added `KChatUser` response model for the user array returned by the endpoint.
- Added `KChatService.searchUsers(options:)` convenience API.
- Added unit tests covering the OpenAPI path, POST method, JSON body, auth/content headers, snake-case body encoding, and snake-case response decoding.
- Verified with `swift test` in `potassiumChannel`.

## 2026-05-05 — kChat get user route

- Target app: kChat.
- Branch: `feat/kchat-user-get`.
- Added `GET /api/v4/users/{user_id}` request support via `KChatRequests.getUser(userId:)`, including the API's special `me` user id.
- Reused the existing Mattermost-compatible `KChatUser` response model.
- Added `KChatService.getUser(userId:)` convenience API.
- Added unit tests covering the OpenAPI path, GET method, auth/accept headers, absence of a JSON body, and the special `me` path.

## 2026-05-05 — kChat get user teams route

- Target app: kChat.
- Branch: `feat/kchat-user-teams-get`.
- Added `GET /api/v4/users/{user_id}/teams` request support via `KChatRequests.getUserTeams(userId:)`.
- Added `KChatTeam` response model for the Mattermost-compatible team array returned by the endpoint.
- Added `KChatService.getUserTeams(userId:)` convenience API.
- Added unit tests covering the OpenAPI path, GET method, auth/accept headers, absence of a JSON body, and snake-case team response decoding.

## 2026-05-05 — kChat get user team channels route

- Target app: kChat.
- Branch: `feat/kchat-user-team-channels-get`.
- Added `GET /api/v4/users/{user_id}/teams/{team_id}/channels` request support via `KChatRequests.getUserTeamChannels(userId:teamId:options:)`.
- Added `KChatUserTeamChannelsOptions` for `include_deleted` and `last_delete_at` query parameters.
- Added `KChatChannel` response model for the Mattermost-compatible channel array returned by the endpoint.
- Added `KChatService.getUserTeamChannels(userId:teamId:options:)` convenience API.
- Added unit tests covering the OpenAPI path, GET method, auth/accept headers, query parameters, absence of a JSON body, and snake-case channel response decoding. The user id test fixture is read from local `Tests/Env.swift` and not hard-coded.

## 2026-05-05 — kChat create post route

- Target app: kChat.
- Branch: `feat/kchat-post-create`.
- Added `POST /api/v4/posts` request support via `KChatRequests.createPost(body:)` and `KChatService.createPost(_:)`.
- Added `KChatPostCreateRequest` and `KChatPost` models for creating and decoding Mattermost-compatible posts.
- Added `DELETE /api/v4/posts/{post_id}` support via `KChatRequests.deletePost(postId:)` and `KChatService.deletePost(postId:)` so live tests and callers can clean up created posts.
- Added unit tests covering POST request shape/body encoding, cleanup DELETE request shape, and snake-case post response decoding.

## 2026-05-05 — kChat upload file route

- Target app: kChat.
- Branch: `feat/kchat-file-upload`.
- Added `POST /api/v4/files` request support via `KChatRequests.uploadFile(channelId:filename:body:)` and `KChatService.uploadFile(channelId:filename:data:)`.
- Added `KChatFileUploadResponse` and `KChatFileInfo` models for the Mattermost-compatible upload response.
- The request sends a `multipart/form-data` body with the required `files` field and supports optional `channel_id` and `filename` query parameters from the OpenAPI spec.
- Added unit tests covering method/path/query/header/body request shape and snake-case upload response decoding.

## 2026-05-06 — kChat get file route

- Target app: kChat.
- Branch: `feat/kchat-file-get`.
- Added `GET /api/v4/files/{file_id}` request support via `KChatRequests.getFile(fileId:)`.
- Added `KChatService.getFile(fileId:)` returning raw `Data` through `InfomaniakAPIClient.sendData`, matching the file download response body.
- Added unit coverage for method, OpenAPI path, auth/accept headers, absent content type, and empty body.


## 2026-05-06 — kChat get channel posts route

- Target app: kChat.
- Branch: `feat/kchat-channel-posts-get`.
- Added `GET /api/v4/channels/{channel_id}/posts` request support via `KChatRequests.getChannelPosts(channelId:options:)`.
- Added `KChatChannelPostsOptions` for `page`, `per_page`, `since`, `before`, `after`, and `include_deleted` query parameters.
- Added `KChatPostList` for the Mattermost-compatible post list response.
- Added `KChatService.getChannelPosts(channelId:options:)` convenience API.
- Added unit tests covering method, OpenAPI path, auth/accept headers, query parameters, absent body, omitted options, and snake-case post-list decoding.
- Verified with `swift test` in `potassiumChannel`.

## 2026-05-06 — kChat get post route

- Target app: kChat.
- Branch: `feat/kchat`.
- Added `GET /api/v4/posts/{post_id}` request support via `KChatRequests.getPost(postId:)`.
- Reused `KChatPost` for the Mattermost-compatible response body.
- Added `KChatService.getPost(postId:)` convenience API.
- Added unit tests covering method, OpenAPI path, auth/accept headers, absent content type/body, and snake-case response decoding.
- Verified with `swift test` in `potassiumChannel`.

## 2026-05-06 — kChat get post thread route

- Target app: kChat.
- Branch: `feat/kchat`.
- Added `GET /api/v4/posts/{post_id}/thread` request support via `KChatRequests.getPostThread(postId:)`, returning the Mattermost-compatible `KChatPostList` thread shape from the OpenAPI spec.
- Added `KChatService.getPostThread(postId:)` convenience API.
- Added unit tests covering method, OpenAPI path, auth/accept headers, absent content type/body, and snake-case post-list/thread decoding.
- Verified with `swift test` in `potassiumChannel`.

## 2026-05-06 — kChat post files info route

- Target app: kChat.
- Branch: `feat/kchat`.
- Added `GET /api/v4/posts/{post_id}/files/info` request support via `KChatRequests.getPostFilesInfo(postId:options:)`.
- Reused `KChatFileInfo` for the `[KChatFileInfo]` endpoint response and added `KChatPostFilesInfoOptions(includeDeleted:)` for the optional `include_deleted` query.
- Added `KChatService.getPostFilesInfo(postId:options:)` convenience API.
- Added unit tests covering method, OpenAPI path, auth/accept headers, no body, optional query, and snake-case response decoding.
- Verified with `swift test` in `potassiumChannel`.

## 2026-05-06 — kChat file info route

- Target app: kChat.
- Branch: `feat/kchat`.
- Added `GET /api/v4/files/{file_id}/info` request support via `KChatRequests.getFileInfo(fileId:)`.
- Reused `KChatFileInfo` for the endpoint response; the local OpenAPI schema matches the existing Mattermost-compatible file info fields.
- Added `KChatService.getFileInfo(fileId:)` convenience API.
- Added unit tests covering method, OpenAPI path, auth/accept headers, no body, and snake-case response decoding.

## 2026-05-06 — kChat get user image route

- Target app: kChat.
- Branch: `feat/kchat`.
- Added `GET /api/v4/users/{user_id}/image` request support via `KChatRequests.getUserImage(userId:)`, including the API's special `me` user id.
- Added `KChatService.getUserImage(userId:)` returning raw `Data` through `InfomaniakAPIClient.sendData`, matching the profile image response body.
- Added unit tests covering method, OpenAPI path, auth/accept headers, absent content type, absent body, absent query, and the special `me` path.

## 2026-05-06 — kChat get user status route

- Target app: kChat.
- Branch: `feat/kchat`.
- Added `GET /api/v4/users/{user_id}/status` request support via `KChatRequests.getUserStatus(userId:)`, including the API's special `me` user id.
- Added `KChatUserStatus` for the Mattermost-compatible status response (`user_id`, `status`, `manual`, `last_activity_at`, and tolerant `dnd_end_time`).
- Added `KChatService.getUserStatus(userId:)` convenience API.
- Added unit tests covering method, OpenAPI path, auth/accept headers, no body, the special `me` id, and snake-case response decoding.
- Verified with `swift test` in `potassiumChannel`.

## 2026-05-06 — kChat batch user statuses route

- Added `POST /api/v4/users/status/ids` request support via `KChatRequests.getUserStatusesByIds(body:)`.
- Added `KChatService.getUserStatusesByIds(userIds:)`, encoding the OpenAPI raw JSON string-array request body.
- Added Swift Testing coverage for method, OpenAPI path, auth/content/accept headers, JSON body, and response decoding.
- Verified targeted coverage with `swift test --filter KChatGetUserStatusesByIdsRequestTests`.

## 2026-05-06 — kChat list users route

- Target app: kChat.
- Branch: `feat/kchat`.
- Added `GET /api/v4/users` request support via `KChatRequests.listUsers(options:)`.
- Added `KChatListUsersOptions` for pagination and common user list filters including team/channel/group, active/inactive, role, sort, and role-scope query parameters.
- Reused `KChatUser` for the Mattermost-compatible user array response.
- Added `KChatService.listUsers(options:)` convenience API.
- Added unit tests covering method, OpenAPI path, auth/accept headers, query parameters, absent body, omitted options, and snake-case response decoding.

## 2026-05-06 — kChat users by ids route

- Target app: kChat.
- Branch: `feat/kchat`.
- Added `POST /api/v4/users/ids` request support via `KChatRequests.getUsersByIds(body:)`.
- Reused `KChatUser` for the returned Mattermost-compatible user array.
- Added `KChatService.getUsersByIds(userIds:)` convenience API.
- Added unit tests covering POST method, OpenAPI path, auth/accept/content-type headers, JSON array body, no query parameters, and response decoding.

## 2026-05-06 — kChat users autocomplete route

- Target app: kChat.
- Branch: `feat/kchat`.
- Added `GET /api/v4/users/autocomplete` request support via `KChatRequests.autocompleteUsers(options:)`.
- Added `KChatUserAutocompleteOptions` for `name`, `team_id`, `channel_id`, and `limit` query parameters.
- Added `KChatUserAutocomplete` for the OpenAPI response shape with separate `users` and `out_of_channel` user arrays, reusing `KChatUser`.
- Added `KChatService.autocompleteUsers(options:)` convenience API.
- Added unit tests covering method, OpenAPI path, auth/accept headers, query parameters, no body, omitted optional query parameters, and response decoding.

## 2026-05-06 — kChat get user by username route

- Added `GET /api/v4/users/username/{username}` request support via `KChatRequests.getUserByUsername(username:)`.
- Added `KChatService.getUserByUsername(username:)` convenience API returning `KChatUser`.
- Added unit tests covering GET method, OpenAPI path, auth/accept headers, encoded username path segment, no query/body, and response decoding.
- Hardened request URL construction so path segments are percent-encoded without splitting encoded path parameters.

## 2026-05-07 — kChat get user by username route

- Added `GET /api/v4/users/username/{username}` request support via `KChatRequests.getUserByUsername(username:)`.
- Added `KChatService.getUserByUsername(username:)` convenience API returning `KChatUser`.
- Added request/decoding tests covering GET method, OpenAPI path, auth/accept headers, path encoding, no query/body, and response decoding.
- Verified with `swift test` in `potassiumChannel`.

## 2026-05-07 — kChat get user by email route

- Added `GET /api/v4/users/email/{email}` request support via `KChatRequests.getUserByEmail(email:)`.
- Added `KChatService.getUserByEmail(email:)` convenience API returning `KChatUser`.
- Added request/decoding tests covering GET method, OpenAPI path, auth/accept headers, path encoding for email characters including `+`, `@`, and slash safety, no query/body, and response decoding.
- Verified with `swift test` in `potassiumChannel`.

## 2026-05-07 — kChat get user channel members route

- Added `GET /api/v4/users/{user_id}/channel_members` request support via `KChatRequests.getUserChannelMembers(userId:options:)`.
- Added `KChatUserChannelMembersOptions`, `KChatChannelMember`, and `KChatChannelNotifyProps` models for the Mattermost-compatible response.
- Added `KChatService.getUserChannelMembers(userId:options:)` convenience API.
- Added request/decoding tests covering GET method, OpenAPI path, auth/accept headers, path encoding, special `me`, pagination query, no body, and response decoding.
- Verified with `swift test` in `potassiumChannel`.

## 2026-05-07 — kChat get team route

- Added `GET /api/v4/teams/{team_id}` request support via `KChatRequests.getTeam(teamId:)`.
- Added `KChatService.getTeam(teamId:)` convenience API returning `KChatTeam`.
- Added request/decoding tests covering GET method, OpenAPI path, auth/accept headers, percent-encoded team id path segment, no query/body, and response decoding.
- Verified with `swift test` in `potassiumChannel`.

## 2026-05-07 — kChat get team by name route

- Added `GET /api/v4/teams/name/{name}` request support via `KChatRequests.getTeamByName(name:)`.
- Added `KChatService.getTeamByName(name:)` convenience API returning `KChatTeam`.
- Added request/decoding tests covering GET method, OpenAPI path, auth/accept headers, percent-encoded team name path segment, no query/body, and response decoding.
- Verified with `swift test` in `potassiumChannel`.

## 2026-05-07 — kChat get team members route

- Added `GET /api/v4/teams/{team_id}/members` request support via `KChatRequests.getTeamMembers(teamId:options:)`.
- Added `KChatTeamMembersOptions` for `page` and `per_page` query parameters.
- Added `KChatService.getTeamMembers(teamId:options:)` convenience API returning `[KChatTeamMember]`.
- Added request/decoding tests covering GET method, OpenAPI path, auth/accept headers, query encoding, omitted empty options, percent-encoded team id path segment, no body, and response decoding.
- Verified with `swift test` in `potassiumChannel`.

## 2026-05-07 — kChat get pinned posts route

- Verified OpenAPI `GetPinnedPosts` for `GET /api/v4/channels/{channel_id}/pinned`; response is Mattermost-compatible `PostList` (`38cb7293_PostList`).
- Reused `KChatPostList`/`KChatPost` for pinned post list decoding.
- Added `KChatRequests.getPinnedPosts(channelId:)` and `KChatService.getPinnedPosts(channelId:)`.
- Added unit tests covering GET method, OpenAPI path, auth/accept headers, no query/body, path-segment percent encoding, and snake-case post-list decoding.

## 2026-05-07 — kChat get public channels for team route

- Verified OpenAPI `GetPublicChannelsForTeam` for `GET /api/v4/teams/{team_id}/channels`; response is an array of Mattermost-compatible `Channel` objects.
- Reused `KChatChannel` for response decoding.
- Added `KChatPublicChannelsForTeamOptions` with `page` and `per_page` query parameters.
- Added `KChatRequests.getPublicChannelsForTeam(teamId:options:)` and `KChatService.getPublicChannelsForTeam(teamId:options:)` returning `[KChatChannel]`.
- Added unit tests covering GET method, OpenAPI path, auth/accept headers, percent-encoded `team_id`, query encoding, omitted empty options, no body, and snake-case channel decoding.

## 2026-05-07 — kChat get private channels for team route

- Verified OpenAPI `GetPrivateChannelsForTeam` for `GET /api/v4/teams/{team_id}/channels/private`; response is an array of Mattermost-compatible `Channel` objects and supports `page`/`per_page` query parameters.
- Reused `KChatChannel` for response decoding.
- Added `KChatPrivateChannelsForTeamOptions` with `page` and `per_page` query parameters.
- Added `KChatRequests.getPrivateChannelsForTeam(teamId:options:)` and `KChatService.getPrivateChannelsForTeam(teamId:options:)` returning `[KChatChannel]`.
- Added unit tests covering GET method, OpenAPI path, auth/accept headers, percent-encoded `team_id`, query encoding, omitted empty options, no body, and snake-case channel decoding.

## 2026-05-07 — kChat get deleted channels for team route

- Verified OpenAPI `GetDeletedChannelsForTeam` for `GET /api/v4/teams/{team_id}/channels/deleted`; response is an array of Mattermost-compatible `Channel` objects and supports `page`/`per_page` query parameters.
- Added `KChatDeletedChannelsForTeamOptions`, `KChatRequests.getDeletedChannelsForTeam(teamId:options:)`, and `KChatService.getDeletedChannelsForTeam(teamId:options:)`, reusing `KChatChannel`.
- Added request tests for method/path/auth/accept headers, path percent-encoding, query encoding, omitted empty options, no body, and response decoding.

## 2026-05-07 — kChat autocomplete channels for team route

- Verified OpenAPI `AutocompleteChannelsForTeam` for `GET /api/v4/teams/{team_id}/channels/autocomplete`; required query parameter is `name`, and the response is an array of Mattermost-compatible `Channel` objects.
- Reused `KChatChannel` for response decoding.
- Added `KChatChannelsForTeamAutocompleteOptions` with required `name` query parameter.
- Added `KChatRequests.autocompleteChannelsForTeam(teamId:options:)` and `KChatService.autocompleteChannelsForTeam(teamId:options:)` returning `[KChatChannel]`.
- Added unit tests covering GET method, OpenAPI path, auth/accept headers, percent-encoded `team_id`, required query encoding, no body, and snake-case channel decoding.

## 2026-05-07 - kChat team channels search autocomplete

- Verified OpenAPI `AutocompleteChannelsForTeamForSearch` for `GET /api/v4/teams/{team_id}/channels/search_autocomplete`; required query parameter is `name`, and the response is an array of Mattermost-compatible `Channel` objects.
- Reused existing `KChatChannel` response model and added `KChatChannelsForTeamSearchAutocompleteOptions`.
- Added `KChatRequests.autocompleteChannelsForTeamForSearch(teamId:options:)` and `KChatService.autocompleteChannelsForTeamForSearch(teamId:options:)` returning `[KChatChannel]`.
- Added request/encoding/header/body/response-decoding tests for the new search autocomplete endpoint.

## 2026-05-07 — kChat search channels route

- Verified OpenAPI `SearchChannels` for `POST /api/v4/teams/{team_id}/channels/search`; required path parameter is `team_id`, required JSON body field is `term`, response `201` is an array of Mattermost-compatible `Channel` objects.
- Reused existing `KChatChannel` for response decoding.
- Added `KChatChannelSearchOptions`, `KChatRequests.searchChannels(teamId:options:)`, and `KChatService.searchChannels(teamId:options:)` returning `[KChatChannel]`.
- Added request tests covering method/path/auth/accept/content-type headers, percent-encoded `team_id`, JSON body encoding, absence of query parameters, required empty `term` preservation, and response decoding.

### 2026-05-07 - kChat archived team channels search

- Verified OpenAPI `SearchArchivedChannels` for `POST /api/v4/teams/{team_id}/channels/search_archived`; required path parameter is `team_id`, required JSON body field is `term`, no query parameters, and response `201` is an array of Mattermost-compatible `Channel` objects.
- Reused `KChatChannelSearchOptions` because the archived-channel search body has the same required `term` shape as the existing team channel search endpoint.
- Added `KChatRequests.searchArchivedChannels(teamId:options:)` and `KChatService.searchArchivedChannels(teamId:options:)` returning `[KChatChannel]`.
- Added request/decoding unit tests covering POST method, encoded path, auth/accept/content-type headers, JSON body, no query parameters, empty required term preservation, and channel array decoding.

## 2026-05-07 — kChat get channel members route

- Verified OpenAPI `GetChannelMembers` uses `GET /api/v4/channels/{channel_id}/members` with optional `page` and `per_page` query parameters and returns an array of Mattermost-compatible `ChannelMember` rows.
- Added `KChatChannelMembersOptions` and `KChatRequests.getChannelMembers(channelId:options:)` for the channel members endpoint.
- Reused `KChatChannelMember` for the response and hardened its `channel_id`/`user_id` decoding for numeric ids returned by live kChat.
- Added `KChatService.getChannelMembers(channelId:options:)` and request/decoding tests covering headers, auth, path encoding, query omission, no body, and response decoding.

## 2026-05-07 — kChat get team members by ids route

- Verified OpenAPI `GetTeamMembersByIds` uses `POST /api/v4/teams/{team_id}/members/ids` with a required JSON array of user ids and returns an array of Mattermost-compatible `TeamMember` rows.
- Reused `KChatTeamMember` for responses.
- Added `KChatRequests.getTeamMembersByIds(teamId:userIds:)` and `KChatService.getTeamMembersByIds(teamId:userIds:)` returning `[KChatTeamMember]`.
- Added request/decoding tests covering method, path, auth/accept/content-type headers, percent-encoded `team_id`, JSON body encoding, no query parameters, and member array decoding.

## 2026-05-07 — kChat get channel members by ids route

- Verified OpenAPI `GetChannelMembersByIds` uses `POST /api/v4/channels/{channel_id}/members/ids` with a required JSON array of user ids and returns an array of Mattermost-compatible `ChannelMember` rows.
- Reused `KChatChannelMember` for responses.
- Added `KChatRequests.getChannelMembersByIds(channelId:userIds:)` and `KChatService.getChannelMembersByIds(channelId:userIds:)` returning `[KChatChannelMember]`.
- Added request/decoding tests covering method, path, auth/accept/content-type headers, percent-encoded `channel_id`, JSON body encoding, no query parameters, and member array decoding.

## 2026-05-07 — kDrive user drives route

- Added `GET /2/drive/users/{user_id}/drives` (`kDriveGetDrivesV2`) request factory and service method.
- Added query option support for `account_id`, `with`, `roles`, `status`, `page`, `per_page`, and `total`.
- Added unit coverage for URL construction and response decoding.

## 2026-05-07 — kDrive v2 drive users route

- Added network support for `GET /2/drive/{drive_id}/users` as `KDriveRequests.listDriveUsersV2` and `KDriveService.listDriveUsersV2`.
- Added `ListKDriveDriveUsersV2Options` for search, status, type, user id, pagination, total, and sort query parameters.
- Added unit coverage for request path/query encoding and response decoding.
- Verified with `swift test`.

## 2026-05-07 — kDrive chart file sizes route

- Branch: `feat/kdrive`.
- Added typed request/service support for non-destructive `GET /2/drive/{drive_id}/statistics/sizes` as `KDriveRequests.chartFileSizes` and `KDriveService.chartFileSizes`.
- Added `KDriveChart`, `KDriveChartData`, and flexible chart data value DTOs for the route's chart response schema.
- Added unit coverage for the OpenAPI path, required query parameters (`from`, `interval`, repeatable `metrics`, `until`), authorization header, and chart decoding.

## 2026-05-07 — kDrive export activities route

- Added typed request/service support for `GET /2/drive/{drive_id}/statistics/activities/export` as `KDriveRequests.exportActivities` and `KDriveService.exportActivities`.
- The request sends required query parameters `from`, `interval`, singular `metric`, and `until`, and requests `text/csv`.
- Added unit coverage for OpenAPI path, authorization, CSV accept header, and required query parameters.
