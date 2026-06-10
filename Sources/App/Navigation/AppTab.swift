import SwiftUI

/// Top-level destinations available from the V1 tab shell.
enum AppTab: Hashable, CaseIterable, Identifiable {
    case home
    case search
    case browse
    case collections
    case settings

    /// Stable identifier for SwiftUI tab selection and future persistence.
    var id: Self { self }

    /// User-facing tab label. Keep `Home` as the shell label per product decision.
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .search:
            return "Search"
        case .browse:
            return "Browse"
        case .collections:
            return "Collections"
        case .settings:
            return "Settings"
        }
    }

    /// System symbol name used by the tab bar.
    var systemImageName: String {
        switch self {
        case .home:
            return "house"
        case .search:
            return "magnifyingglass"
        case .browse:
            return "square.grid.2x2"
        case .collections:
            return "bookmark"
        case .settings:
            return "gearshape"
        }
    }
}
