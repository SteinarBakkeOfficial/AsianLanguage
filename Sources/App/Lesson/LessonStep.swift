import Foundation

/// Closed set of guided lesson steps for a V1 Shared Character lesson.
enum LessonStep: String, CaseIterable, Identifiable, Codable {
    case origin
    case character
    case modernForms
    case structure
    case usage
    case summary

    /// Stable identifier for SwiftUI lists and future persistence.
    var id: String { rawValue }

    /// User-facing step title shown in lesson navigation.
    var title: String {
        switch self {
        case .origin:
            return "Origin"
        case .character:
            return "Character"
        case .modernForms:
            return "Modern Forms"
        case .structure:
            return "Structure"
        case .usage:
            return "Usage"
        case .summary:
            return "Summary"
        }
    }
}
