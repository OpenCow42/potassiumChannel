import Foundation

extension KChatRequests {
    /// Creates a request that gets a previously uploaded kChat file.
    public static func getFile(fileId: String) -> APIRequest<Data> {
        APIRequest(
            method: .get,
            path: "/api/v4/files/\(fileId)"
        )
    }

    /// Creates a request that gets metadata for a previously uploaded kChat file.
    public static func getFileInfo(fileId: String) -> APIRequest<KChatFileInfo> {
        APIRequest(
            method: .get,
            path: "/api/v4/files/\(fileId)/info"
        )
    }

    /// Creates a request that gets a previously uploaded kChat file preview.
    public static func getFilePreview(fileId: String) -> APIRequest<Data> {
        APIRequest(
            method: .get,
            path: "/api/v4/files/\(percentEncodePathSegment(fileId))/preview"
        )
    }

    /// Creates a request that gets a previously uploaded kChat file thumbnail.
    public static func getFileThumbnail(fileId: String) -> APIRequest<Data> {
        APIRequest(
            method: .get,
            path: "/api/v4/files/\(percentEncodePathSegment(fileId))/thumbnail"
        )
    }

    /// Creates a request that uploads a file to kChat.
    public static func uploadFile(channelId: String? = nil, filename: String? = nil, body: Data, contentType: String) -> APIRequest<KChatFileUploadResponse> {
        var queryParameters: [QueryParameter] = []

        if let channelId {
            queryParameters.append(QueryParameter(name: "channel_id", value: .string(channelId)))
        }

        if let filename {
            queryParameters.append(QueryParameter(name: "filename", value: .string(filename)))
        }

        return APIRequest(
            method: .post,
            path: "/api/v4/files",
            queryParameters: queryParameters,
            headers: [HTTPHeader(name: "Content-Type", value: contentType)],
            body: body
        )
    }
}
