### Progress of the project

### Implemented API route inventory

`potassiumChannel` now owns the shared Infomaniak response envelopes, kDrive DTOs,
kDrive request factories, and `KDriveService` wrappers that were previously in
Potassium.

| Method | Route | Request factory |
| --- | --- | --- |
| GET | `/2/drive` | `KDriveRequests.listAccessibleKDrives` |
| GET | `/2/drive/users` | `KDriveRequests.listKDriveUsers` |
| GET | `/2/drive/preferences` | `KDriveRequests.getUserPreferences` |
| GET | `/2/drive/{drive_id}` | `KDriveRequests.getDrive` |
| GET | `/2/drive/{drive_id}/settings` | `KDriveRequests.getDriveSettings` |
| GET | `/2/drive/{drive_id}/categories` | `KDriveRequests.listCategories` |
| GET | `/2/drive/{drive_id}/categories/rights` | `KDriveRequests.getCategoryRights` |
| GET | `/2/drive/{drive_id}/trash/count` | `KDriveRequests.getTrashCount` |
| GET | `/2/drive/{drive_id}/activities` | `KDriveRequests.listActivities` |
| GET | `/2/drive/{drive_id}/activities/reports` | `KDriveRequests.listActivityReports` |
| GET | `/2/drive/{drive_id}/imports` | `KDriveRequests.listImports` |
| GET | `/2/drive/{drive_id}/users/invitation` | `KDriveRequests.listUserInvitations` |
| GET | `/2/drive/{drive_id}/files/{file_id}/download` | `KDriveRequests.downloadFile` |
| POST | `/2/drive/{drive_id}/files/{file_id}/copy-to-drive` | `KDriveRequests.copyFileToDriveV2` |
| GET | `/2/drive/{drive_id}/trash/{file_id}/thumbnail` | `KDriveRequests.getV2TrashedItemThumbnail` |
| GET | `/2/drive/{drive_id}/trash/{file_id}/count` | `KDriveRequests.getV2TrashedItemCount` |
| GET | `/3/drive/{drive_id}/users` | `KDriveRequests.listDriveUsers` |
| GET | `/3/drive/{drive_id}/activities` | `KDriveRequests.listDriveActivities` |
| GET | `/3/drive/{drive_id}/activities/total` | `KDriveRequests.listDriveActivityTotals` |
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
| GET | `/3/drive/{drive_id}/files/search/dropboxes` | `KDriveRequests.searchDropboxes` |
| GET | `/3/drive/{drive_id}/files/search/links` | `KDriveRequests.searchShareLinks` |
| GET | `/3/drive/{drive_id}/files/search/trash` | `KDriveRequests.searchTrash` |
| GET | `/3/drive/{drive_id}/files/{file_id}` | `KDriveRequests.getFile` |
| GET | `/3/drive/{drive_id}/files/{file_id}/name` | `KDriveRequests.getFileByName` |
| GET | `/3/drive/{drive_id}/files/{file_id}/activities` | `KDriveRequests.listFileActivities` |
| GET | `/3/drive/{drive_id}/files/{file_id}/files` | `KDriveRequests.listDirectoryFiles` |
| GET | `/3/drive/{drive_id}/files/{file_id}/count` | `KDriveRequests.getDirectoryCount` |
| GET | `/3/drive/{drive_id}/files/{file_id}/versions` | `KDriveRequests.listFileVersions` |
| POST | `/3/drive/{drive_id}/upload` | `KDriveRequests.uploadFile` |
| GET | `/3/drive/{drive_id}/trash` | `KDriveRequests.listTrashFiles` |
| GET | `/3/drive/{drive_id}/trash/{file_id}` | `KDriveRequests.getTrashedFile` |
| GET | `/3/drive/{drive_id}/trash/{file_id}/files` | `KDriveRequests.listTrashedDirectoryFiles` |
| GET | `/3/drive/{drive_id}/trash/{file_id}/count` | `KDriveRequests.getTrashedItemCount` |

### Implemented DTO and service scope

- Infomaniak response envelopes: `InfomaniakResponse`,
  `PaginatedInfomaniakResponse`, `CursorPaginatedInfomaniakResponse`.
- kDrive response DTOs and option/body DTOs required by the routes above.
- `KDriveService`, which sends the route factories through `InfomaniakAPIClient`.

### Validation

- `swift test` passes with 92 route/DTO/channel tests.
