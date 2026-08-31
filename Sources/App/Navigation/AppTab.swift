import SwiftUI

/// Shared visual language extracted from the approved app-shell reference.
enum ShellStyle {
    // Compatibility aliases let transitional screens adopt semantic tokens incrementally.
    static let paper = AppColors.appBackground
    static let clay = AppColors.separator
    static let ink = AppColors.textPrimary
    static let jade = AppColors.learned
    static let cinnabar = AppColors.accentPrimary
    static let softSurface = AppColors.surfaceSubtle

    /// Editorial serif reserved for characters, history, and exhibit headings.
    static let editorialFont = Font.system(.title2, design: .serif)
}

/// Restrained surface treatment shared by shell cards and content rows.
struct ShellSurface: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(ShellStyle.softSurface)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.surface))
            .overlay(RoundedRectangle(cornerRadius: AppRadius.surface).stroke(AppColors.separator, lineWidth: 1))
    }
}

extension View {
    func shellSurface() -> some View { modifier(ShellSurface()) }
}

/// Floating five-destination bar from the approved app-shell reference.
struct AppTabBar: View {
    @Binding var selectedTab: AppTab

    var body: some View {
        HStack(spacing: AppSpacing.space2xs) {
            ForEach(AppTab.allCases) { tab in
                Button {
                    selectedTab = tab
                } label: {
                    VStack(spacing: AppSpacing.space2xs) {
                        Image(systemName: tab.systemImageName)
                            .font(.system(size: 20, weight: .medium))
                        Text(tab.title)
                            .font(AppTypography.tabLabel)
                    }
                    .foregroundStyle(selectedTab == tab ? AppColors.accentPrimary : AppColors.textPrimary)
                    .frame(maxWidth: .infinity, minHeight: 62)
                    .background(selectedTab == tab ? AppColors.surfaceStrong : Color.clear)
                    .clipShape(Capsule())
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(selectedTab == tab ? .isSelected : [])
            }
        }
        .padding(AppSpacing.space2xs)
        .background(AppColors.surfaceStrong)
        .clipShape(Capsule())
        .overlay {
            Capsule().stroke(AppColors.separator, lineWidth: 1)
        }
        .padding(.horizontal, AppSpacing.spacePage)
        .padding(.bottom, AppSpacing.spaceXs)
    }
}

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
