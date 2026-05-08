import Foundation

extension KDriveService {
    /// Lists comments for a kDrive file or directory.
    public func listFileComments(
        driveId: Int,
        fileId: Int
    ) async throws -> InfomaniakResponse<[KDriveFileComment]> {
        try await client.send(
            KDriveRequests.listFileComments(driveId: driveId, fileId: fileId)
        )
    }

    /// Adds a comment to a kDrive file or directory.
    public func addFileComment(
        driveId: Int,
        fileId: Int,
        body: String,
        with includedResources: String? = nil
    ) async throws -> InfomaniakResponse<KDriveFileComment> {
        let requestBody = try JSONEncoder().encode(AddKDriveFileCommentOptions(body: body))
        return try await client.send(
            KDriveRequests.addFileComment(
                driveId: driveId,
                fileId: fileId,
                with: includedResources,
                body: requestBody
            )
        )
    }

    /// Adds a reply to a kDrive file comment.
    public func addFileCommentReply(
        driveId: Int,
        fileId: Int,
        commentId: Int,
        body: String,
        with includedResources: String? = nil
    ) async throws -> InfomaniakResponse<KDriveFileComment> {
        let requestBody = try JSONEncoder().encode(AddKDriveFileCommentReplyOptions(body: body))
        return try await client.send(
            KDriveRequests.addFileCommentReply(
                driveId: driveId,
                fileId: fileId,
                commentId: commentId,
                with: includedResources,
                body: requestBody
            )
        )
    }

    /// Modifies a kDrive file comment.
    public func modifyFileComment(
        driveId: Int,
        fileId: Int,
        commentId: String,
        options: ModifyKDriveFileCommentOptions
    ) async throws -> InfomaniakResponse<Bool> {
        let requestBody = try JSONEncoder().encode(options)
        return try await client.send(
            KDriveRequests.modifyFileComment(
                driveId: driveId,
                fileId: fileId,
                commentId: commentId,
                options: options,
                body: requestBody
            )
        )
    }

    /// Deletes a kDrive file comment.
    public func deleteFileComment(
        driveId: Int,
        fileId: Int,
        commentId: String
    ) async throws -> InfomaniakResponse<Bool> {
        try await client.send(
            KDriveRequests.deleteFileComment(
                driveId: driveId,
                fileId: fileId,
                commentId: commentId
            )
        )
    }

    /// Likes a kDrive file comment.
    public func likeFileComment(
        driveId: Int,
        fileId: Int,
        commentId: String
    ) async throws -> InfomaniakResponse<Bool> {
        try await client.send(
            KDriveRequests.likeFileComment(
                driveId: driveId,
                fileId: fileId,
                commentId: commentId
            )
        )
    }

    /// Unlikes a kDrive file comment.
    public func unlikeFileComment(
        driveId: Int,
        fileId: Int,
        commentId: String
    ) async throws -> InfomaniakResponse<Bool> {
        try await client.send(
            KDriveRequests.unlikeFileComment(
                driveId: driveId,
                fileId: fileId,
                commentId: commentId
            )
        )
    }

    /// Lists replies to a kDrive file comment.
    public func listFileCommentReplies(
        driveId: Int,
        fileId: Int,
        commentId: String,
        options: ListKDriveFileCommentRepliesOptions = ListKDriveFileCommentRepliesOptions()
    ) async throws -> PaginatedInfomaniakResponse<[KDriveFileComment]> {
        try await client.send(
            KDriveRequests.listFileCommentReplies(
                driveId: driveId,
                fileId: fileId,
                commentId: commentId,
                options: options
            )
        )
    }
}
