import Foundation
import PotassiumChannelCore

/// Placeholder response type for kDrive endpoints that return binary data.
public struct KDriveBinaryResponse: Decodable, Sendable {
    public init() {}
}

/// Lossless JSON value used by kDrive endpoints whose payload shape can vary by access type.
public enum KDriveJSONValue: Codable, Equatable, Sendable {
    case string(String)
    case number(Double)
    case bool(Bool)
    case object([String: KDriveJSONValue])
    case array([KDriveJSONValue])
    case null

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            self = .null
        } else if let value = try? container.decode(Bool.self) {
            self = .bool(value)
        } else if let value = try? container.decode(Double.self) {
            self = .number(value)
        } else if let value = try? container.decode(String.self) {
            self = .string(value)
        } else if let value = try? container.decode([String: KDriveJSONValue].self) {
            self = .object(value)
        } else if let value = try? container.decode([KDriveJSONValue].self) {
            self = .array(value)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unsupported JSON value")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case let .string(value):
            try container.encode(value)
        case let .number(value):
            try container.encode(value)
        case let .bool(value):
            try container.encode(value)
        case let .object(value):
            try container.encode(value)
        case let .array(value):
            try container.encode(value)
        case .null:
            try container.encodeNil()
        }
    }
}

/// A cancellation token returned after a file is moved to kDrive trash.
public struct KDriveCancelResource: Codable, Equatable, Sendable {
    /// Identifier that can be used by Infomaniak APIs to cancel the action while it remains valid.
    public let cancelId: String

    /// Unix timestamp until which the cancellation identifier remains valid.
    public let validUntil: Int

    /// Creates a cancellation resource value.
    public init(cancelId: String, validUntil: Int) {
        self.cancelId = cancelId
        self.validUntil = validUntil
    }
}

/// Result returned after restoring a trashed kDrive file or directory.
public enum KDriveRestoreTrashedFileResult: Codable, Equatable, Sendable {
    /// The API completed the restore synchronously.
    case bool(Bool)

    /// The API started a cancellable restore operation.
    case cancelResource(KDriveCancelResource)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode(Bool.self) {
            self = .bool(value)
        } else if let value = try? container.decode(KDriveCancelResource.self) {
            self = .cancelResource(value)
        } else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Expected a boolean or kDrive cancel resource"
            )
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case let .bool(value):
            try container.encode(value)
        case let .cancelResource(value):
            try container.encode(value)
        }
    }
}

/// UUID token returned after requesting an asynchronous kDrive archive build.
public struct KDriveUUIDResource: Codable, Equatable, Sendable {
    /// Universally unique identifier of the built archive resource.
    public let uuid: String

    /// Creates a UUID resource value.
    public init(uuid: String) {
        self.uuid = uuid
    }
}

/// JSON body accepted by the kDrive undo-action endpoint.
public struct UndoKDriveActionOptions: Encodable, Equatable, Sendable {
    /// Single cancellation identifier to undo.
    public let cancelId: String?

    /// Multiple cancellation identifiers to undo.
    public let cancelIds: [String]?

    public enum CodingKeys: String, CodingKey {
        case cancelId = "cancel_id"
        case cancelIds = "cancel_ids"
    }

    /// Creates options for undoing one or more cancellable kDrive actions.
    public init(cancelId: String? = nil, cancelIds: [String]? = nil) {
        self.cancelId = cancelId
        self.cancelIds = cancelIds
    }
}

/// A UUID feedback resource returned by kDrive undo-action responses.
public struct KDriveUUIDFeedbackResource: Codable, Equatable, Sendable {
    /// Identifier of the action feedback resource.
    public let id: String

    /// Whether the undo operation succeeded for this identifier.
    public let result: Bool

    /// Optional API message, usually present when `result` is false.
    public let message: String?

    /// Creates a UUID feedback resource value.
    public init(id: String, result: Bool, message: String? = nil) {
        self.id = id
        self.result = result
        self.message = message
    }
}

/// Result returned after undoing one or more cancellable kDrive actions.
public enum KDriveUndoActionResult: Codable, Equatable, Sendable {
    /// The API returned a single feedback resource.
    case feedbackResource(KDriveUUIDFeedbackResource)

    /// The API returned multiple feedback resources.
    case feedbackResources([KDriveUUIDFeedbackResource])

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode(KDriveUUIDFeedbackResource.self) {
            self = .feedbackResource(value)
        } else if let values = try? container.decode([KDriveUUIDFeedbackResource].self) {
            self = .feedbackResources(values)
        } else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Expected a kDrive UUID feedback resource or an array of feedback resources"
            )
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case let .feedbackResource(value):
            try container.encode(value)
        case let .feedbackResources(values):
            try container.encode(values)
        }
    }
}
