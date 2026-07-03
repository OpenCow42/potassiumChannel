import Foundation
import PotassiumChannelCore

extension KDriveService {
    /// Lists activities recorded on a kDrive.
    public func listActivities(
        driveId: Int,
        page: Int? = nil,
        perPage: Int? = nil,
        lang: String? = nil
    ) async throws -> PaginatedInfomaniakResponse<[KDriveActivity]> {
        try await client.send(
            KDriveRequests.listActivities(driveId: driveId, page: page, perPage: perPage, lang: lang)
        )
    }

    /// Lists v3 drive-scoped activities.
    public func listDriveActivities(
        driveId: Int,
        page: Int? = nil,
        perPage: Int? = nil,
        lang: String? = nil
    ) async throws -> InfomaniakResponse<[KDriveDriveActivity]> {
        try await client.send(
            KDriveRequests.listDriveActivities(driveId: driveId, page: page, perPage: perPage, lang: lang)
        )
    }

    /// Lists v3 drive-scoped activity totals.
    public func listDriveActivityTotals(
        driveId: Int
    ) async throws -> InfomaniakResponse<Int> {
        try await client.send(
            KDriveRequests.listDriveActivityTotals(driveId: driveId)
        )
    }

    /// Returns v2 drive-scoped file size statistics.
    public func chartFileSizes(
        driveId: Int,
        from: Int,
        interval: Int,
        metrics: [String],
        until: Int
    ) async throws -> InfomaniakResponse<KDriveChart> {
        try await client.send(
            KDriveRequests.chartFileSizes(
                driveId: driveId,
                from: from,
                interval: interval,
                metrics: metrics,
                until: until
            )
        )
    }

    /// Returns v2 drive-scoped activity statistics.
    public func chartActivities(
        driveId: Int,
        from: Int,
        interval: Int,
        metric: String,
        until: Int
    ) async throws -> InfomaniakResponse<KDriveChart> {
        try await client.send(
            KDriveRequests.chartActivities(
                driveId: driveId,
                from: from,
                interval: interval,
                metric: metric,
                until: until
            )
        )
    }

    /// Exports v2 drive-scoped file size statistics as CSV data.
    public func exportFileSizes(
        driveId: Int,
        from: Int,
        interval: Int,
        metrics: [String],
        until: Int
    ) async throws -> Data {
        try await client.sendData(
            KDriveRequests.exportFileSizes(
                driveId: driveId,
                from: from,
                interval: interval,
                metrics: metrics,
                until: until
            )
        )
    }

    /// Exports v2 drive-scoped activity statistics as CSV data.
    public func exportActivities(
        driveId: Int,
        from: Int,
        interval: Int,
        metric: String,
        until: Int
    ) async throws -> Data {
        try await client.sendData(
            KDriveRequests.exportActivities(
                driveId: driveId,
                from: from,
                interval: interval,
                metric: metric,
                until: until
            )
        )
    }

    /// Lists users active on a kDrive during a statistics period.
    public func listActivityUsers(
        driveId: Int,
        from: Int,
        until: Int
    ) async throws -> InfomaniakResponse<[KDriveActiveMember]> {
        try await client.send(
            KDriveRequests.listActivityUsers(driveId: driveId, from: from, until: until)
        )
    }

    /// Lists files shared on a kDrive during a statistics period.
    public func listActivitySharedFiles(
        driveId: Int,
        from: Int,
        until: Int
    ) async throws -> InfomaniakResponse<[KDriveSharedFileActivity]> {
        try await client.send(
            KDriveRequests.listActivitySharedFiles(driveId: driveId, from: from, until: until)
        )
    }

    /// Lists share links active on a kDrive during a statistics period.
    public func listActivityShareLinks(
        driveId: Int,
        from: Int,
        until: Int,
        options: ListKDriveActivityShareLinksOptions = ListKDriveActivityShareLinksOptions()
    ) async throws -> PaginatedInfomaniakResponse<[KDriveStatisticShareLink]> {
        try await client.send(
            KDriveRequests.listActivityShareLinks(driveId: driveId, from: from, until: until, options: options)
        )
    }

    /// Exports share links active on a kDrive during a statistics period.
    public func exportActivityShareLinks(
        driveId: Int,
        from: Int,
        until: Int,
        options: ExportKDriveActivityShareLinksOptions = ExportKDriveActivityShareLinksOptions()
    ) async throws -> InfomaniakResponse<[KDriveStatisticShareLink]> {
        try await client.send(
            KDriveRequests.exportActivityShareLinks(driveId: driveId, from: from, until: until, options: options)
        )
    }

    /// Lists generated kDrive activity reports.
    public func listActivityReports(
        driveId: Int,
        page: Int? = nil,
        perPage: Int? = nil
    ) async throws -> PaginatedInfomaniakResponse<[KDriveActivityReport]> {
        try await client.send(
            KDriveRequests.listActivityReports(driveId: driveId, page: page, perPage: perPage)
        )
    }

    /// Generates a new kDrive activity report.
    public func createActivityReport(
        driveId: Int,
        options: CreateKDriveActivityReportOptions = CreateKDriveActivityReportOptions()
    ) async throws -> InfomaniakResponse<Int> {
        try await client.send(
            KDriveRequests.createActivityReport(driveId: driveId, options: options)
        )
    }

    /// Gets a generated kDrive activity report.
    public func getActivityReport(
        driveId: Int,
        reportId: Int
    ) async throws -> InfomaniakResponse<KDriveActivityReport> {
        try await client.send(
            KDriveRequests.getActivityReport(driveId: driveId, reportId: reportId)
        )
    }

    /// Exports a generated kDrive activity report as CSV data.
    public func exportActivityReport(
        driveId: Int,
        reportId: Int
    ) async throws -> Data {
        try await client.sendData(
            KDriveRequests.exportActivityReport(driveId: driveId, reportId: reportId)
        )
    }

    /// Deletes a generated kDrive activity report.
    public func deleteActivityReport(
        driveId: Int,
        reportId: Int
    ) async throws -> InfomaniakResponse<Bool> {
        try await client.send(
            KDriveRequests.deleteActivityReport(driveId: driveId, reportId: reportId)
        )
    }
}
