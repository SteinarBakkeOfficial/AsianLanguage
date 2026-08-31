import SwiftUI

/// Dedicated Languages page for choosing the focus tracks shown in lessons.
struct LanguagesView: View {
    /// Shared dependencies used to access local state.
    let dependencies: AppDependencies

    /// Local state store for focus-track preferences.
    @ObservedObject private var userStateStore: LocalUserStateStore

    /// Creates the Languages page.
    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _userStateStore = ObservedObject(wrappedValue: dependencies.userStateStore)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.spaceLg) {
                headerCard
                ForEach(FocusTrack.allCases) { track in
                    languageCard(for: track)
                }
            }
            .padding(AppSpacing.spacePage)
        }
        .scrollIndicators(.hidden)
        .navigationTitle("Languages")
        .background(AppColors.appBackground.ignoresSafeArea())
        .tint(AppColors.accentPrimary)
    }

    /// Intro card explaining multi-select focus behavior.
    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Choose Focus Tracks")
                .font(AppTypography.exhibitHeading)
                .foregroundStyle(AppColors.textPrimary)
            Text("All tracks are enabled by default. Turn tracks off when you want a narrower comparison, or turn them all off for a museum-only journey.")
                .font(AppTypography.body)
                .foregroundStyle(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    /// One focus-track card with visible enabled state.
    private func languageCard(for track: FocusTrack) -> some View {
        GroupedSurface {
            Toggle(isOn: focusTrackBinding(for: track)) {
                VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
                    Text(track.title)
                        .font(AppTypography.body.weight(.semibold))
                        .foregroundStyle(AppColors.textPrimary)
                    Text(description(for: track))
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColors.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .toggleStyle(.switch)
            .frame(minHeight: 52)
        }
    }

    /// Short learner-facing track description.
    private func description(for track: FocusTrack) -> String {
        switch track {
        case .simplifiedChinese:
            return "Modern mainland-style forms, Mandarin readings, and simplified examples."
        case .traditionalChinese:
            return "Traditional forms with Taiwan and Hong Kong example sets."
        case .japanese:
            return "Kanji forms with on and kun readings."
        case .korean:
            return "Hanja recognition with Korean Hanja and native-word context."
        }
    }

    /// Binding that writes one focus-track toggle into persisted local user state.
    private func focusTrackBinding(for track: FocusTrack) -> Binding<Bool> {
        Binding(
            get: { userStateStore.state.focusSelection.contains(track) },
            set: { userStateStore.setFocusTrack(track, isSelected: $0) }
        )
    }
}
