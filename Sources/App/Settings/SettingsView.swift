import SwiftUI

/// Settings screen for local preferences and offline app information.
struct SettingsView: View {
    /// Optional section the screen should emphasize when opened from a specific tab.
    enum InitialSection {
        case standard
        case focusLanguage
    }

    /// Shared app dependencies used by the shell until real stores exist.
    let dependencies: AppDependencies

    /// Section emphasis used when Languages opens the same underlying controls.
    let initialSection: InitialSection

    /// Local state store used for focus language and reset controls.
    @ObservedObject private var userStateStore: LocalUserStateStore

    /// Controls the destructive learning-progress reset confirmation.
    @State private var isShowingResetConfirmation = false
    /// Controls the separate all-preferences reset confirmation.
    @State private var isShowingPreferencesResetConfirmation = false

    /// Creates Settings with observed access to local user state.
    init(dependencies: AppDependencies, initialSection: InitialSection = .standard) {
        self.dependencies = dependencies
        self.initialSection = initialSection
        _userStateStore = ObservedObject(wrappedValue: dependencies.userStateStore)
    }

    var body: some View {
        Form {
            Section("Focus tracks") {
                ForEach(FocusTrack.allCases) { track in
                    Toggle(track.title, isOn: focusTrackBinding(for: track))
                }
                Text("All four focus tracks are enabled by default. Turning them all off keeps the Symbol Journey museum-only.")
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }

            Section("Display preferences") {
                Picker("Appearance", selection: appearanceBinding) {
                    ForEach(AppearancePreference.allCases) { preference in
                        Text(preference.rawValue.capitalized).tag(preference)
                    }
                }
                Text("Choose System, Light, or Dark appearance for the gallery shell.")
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }

            Section("Offline corpus") {
                LabeledContent("Installed", value: dependencies.installedCorpusName)
                LabeledContent("Shared Characters", value: "\(dependencies.installedSharedCharacterCount)")
                NavigationLink("About / Method") {
                    AboutMethodView(corpusCount: dependencies.installedSharedCharacterCount)
                }
            }

            Section("Reset") {
                Button("Reset learning progress", role: .destructive) {
                    isShowingResetConfirmation = true
                }
                Button("Reset all preferences", role: .destructive) {
                    isShowingPreferencesResetConfirmation = true
                }
            }
        }
        .navigationTitle(initialSection == .focusLanguage ? "Languages" : "Settings")
        .scrollContentBackground(.hidden)
        .background(AppColors.appBackground.ignoresSafeArea())
        .tint(AppColors.accentPrimary)
        .alert("Reset app progress?", isPresented: $isShowingResetConfirmation) {
            Button("Reset", role: .destructive) {
                userStateStore.resetLearningProgress()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This clears local progress, favorites, and review-later state on this device. It keeps display and focus preferences.")
        }
        .alert("Reset all preferences?", isPresented: $isShowingPreferencesResetConfirmation) {
            Button("Reset All", role: .destructive) {
                userStateStore.resetAllPreferences()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This resets learning progress and preferences, but does not delete the bundled corpus.")
        }
    }

    /// Binding that writes one focus-track toggle into persisted local user state.
    private func focusTrackBinding(for track: FocusTrack) -> Binding<Bool> {
        Binding(
            get: { userStateStore.state.focusSelection.contains(track) },
            set: { userStateStore.setFocusTrack(track, isSelected: $0) }
        )
    }

    /// Binding for the small, intentionally limited appearance preference model.
    private var appearanceBinding: Binding<AppearancePreference> {
        Binding(
            get: { userStateStore.state.appearancePreference },
            set: { userStateStore.setAppearancePreference($0) }
        )
    }
}
