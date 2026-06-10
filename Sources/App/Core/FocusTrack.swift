import Foundation

/// Modern display and usage lane selected by the learner.
enum FocusTrack: String, CaseIterable, Identifiable, Codable {
    case all
    case simplifiedChinese
    case traditionalChinese
    case japanese
    case korean

    /// Stable identifier for SwiftUI pickers and local preference storage.
    var id: String { rawValue }

    /// User-facing label for focus-track controls.
    var title: String {
        switch self {
        case .all:
            return "All"
        case .simplifiedChinese:
            return "Simplified Chinese"
        case .traditionalChinese:
            return "Traditional Chinese"
        case .japanese:
            return "Japanese"
        case .korean:
            return "Korean"
        }
    }
}
