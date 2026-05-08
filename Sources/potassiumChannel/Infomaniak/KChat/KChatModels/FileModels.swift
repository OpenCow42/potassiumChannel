import Foundation

/// Response returned by the Mattermost-compatible kChat file upload endpoint.
public struct KChatFileUploadResponse: Codable, Equatable, Sendable {
    public let fileInfos: [KChatFileInfo]?
    public let clientIds: [String]?

    public init(fileInfos: [KChatFileInfo]? = nil, clientIds: [String]? = nil) {
        self.fileInfos = fileInfos
        self.clientIds = clientIds
    }
}

/// Mattermost-compatible kChat file metadata.
public struct KChatFileInfo: Codable, Equatable, Sendable {
    public let id: String?
    public let userId: String?
    public let postId: String?
    public let createAt: Int64?
    public let updateAt: Int64?
    public let deleteAt: Int64?
    public let name: String?
    public let `extension`: String?
    public let size: Int?
    public let mimeType: String?
    public let width: Int?
    public let height: Int?
    public let hasPreviewImage: Bool?

    public init(
        id: String? = nil,
        userId: String? = nil,
        postId: String? = nil,
        createAt: Int64? = nil,
        updateAt: Int64? = nil,
        deleteAt: Int64? = nil,
        name: String? = nil,
        extension: String? = nil,
        size: Int? = nil,
        mimeType: String? = nil,
        width: Int? = nil,
        height: Int? = nil,
        hasPreviewImage: Bool? = nil
    ) {
        self.id = id
        self.userId = userId
        self.postId = postId
        self.createAt = createAt
        self.updateAt = updateAt
        self.deleteAt = deleteAt
        self.name = name
        self.extension = `extension`
        self.size = size
        self.mimeType = mimeType
        self.width = width
        self.height = height
        self.hasPreviewImage = hasPreviewImage
    }
}
