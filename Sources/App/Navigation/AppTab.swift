import SwiftUI

/// Top-level destinations available from the V1 tab shell.
enum AppTab: Hashable, CaseIterable, Identifiable {
    case home
    case symbol
    case history
    case browse
    case more

    /// Stable identifier for SwiftUI tab selection and future persistence.
    var id: Self { self }

    /// User-facing tab label. Keep `Home` as the shell label per product decision.
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .symbol:
            return "Symbol"
        case .history:
            return "History"
        case .browse:
            return "Browse"
        case .more:
            return "More"
        }
    }

    /// System symbol name used by the tab bar.
    var systemImageName: String {
        switch self {
        case .home:
            return "house"
        case .symbol:
            return "character"
        case .history:
            return "clock.arrow.circlepath"
        case .browse:
            return "square.grid.2x2"
        case .more:
            return "ellipsis.circle"
        }
    }
}
