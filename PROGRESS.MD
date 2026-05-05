### Progress of the project

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
| GET | `/3/drive/{drive_id}/files/{file_id}/versions` | `KDriveRequests.listFileVersions` |
| GET | `/2/drive/{drive_id}/activities` | `KDriveRequests.listActivities` |
| GET | `/3/drive/{drive_id}/activities` | `KDriveRequests.listDriveActivities` |
| GET | `/3/drive/{drive_id}/activities/total` | `KDriveRequests.listDriveActivityTotals` |
| GET | `/2/drive/{drive_id}/activities/reports` | `KDriveRequests.listActivityReports` |
| GET | `/2/drive/{drive_id}/imports` | `KDriveRequests.listImports` |
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

### Implemented DTO and service scope

#### kDrive

- Infomaniak response envelopes: `InfomaniakResponse`, `PaginatedInfomaniakResponse`, `CursorPaginatedInfomaniakResponse`.
- kDrive response DTOs and option/body DTOs required by the routes above.
- `KDriveService`, which sends the route factories through `InfomaniakAPIClient`.

#### Mail

not started

#### kChat

- `KChatClientConfig` response DTO for Mattermost-compatible client configuration values.
- `KChatRequests.getClientConfig(format:)` request factory.
- `KChatService`, which sends kChat route factories through `InfomaniakAPIClient` and can build `https://<team>.kchat.infomaniak.com` base URLs.

### Validation

- `swift test` passes with route/DTO/channel coverage.


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
