import Foundation

/// Internal content phases retained for migration and editorial grouping.
/// These phases are not the primary user-facing navigation for a Symbol Journey.
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

/// The user-facing sections of a Shared Character Symbol Journey.
enum SymbolJourneySection: String, CaseIterable, Identifiable, Codable, Hashable {
    case evolution
    case today
    case structure
    case usage
    case summary

    var id: String { rawValue }
}

/// Exact saved location inside a Shared Character Symbol Journey.
struct SymbolJourneyPosition: Codable, Hashable {
    let section: SymbolJourneySection
    let stageID: String?

    static let origin = SymbolJourneyPosition(section: .evolution, stageID: "origin")

    init(section: SymbolJourneySection, stageID: String? = nil) {
        self.section = section
        self.stageID = stageID
    }

    /// Maps pre-Symbol-Journey progress into the closest current position.
    static func fromLegacy(_ step: LessonStep) -> SymbolJourneyPosition {
        switch step {
        case .origin, .character:
            return .origin
        case .modernForms:
            return SymbolJourneyPosition(section: .today)
        case .structure:
            return SymbolJourneyPosition(section: .structure)
        case .usage:
            return SymbolJourneyPosition(section: .usage)
        case .summary:
            return SymbolJourneyPosition(section: .summary)
        }
    }
}
