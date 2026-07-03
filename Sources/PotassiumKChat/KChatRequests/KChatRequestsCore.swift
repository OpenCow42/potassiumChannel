import Foundation
import PotassiumChannelCore

/// Factory methods for kChat API requests.
public enum KChatRequests {
    static func percentEncodePathSegment(_ segment: String) -> String {
        var allowedCharacters = CharacterSet.urlPathAllowed
        allowedCharacters.remove(charactersIn: "/?#%")

        return segment.addingPercentEncoding(withAllowedCharacters: allowedCharacters) ?? segment
    }
}
