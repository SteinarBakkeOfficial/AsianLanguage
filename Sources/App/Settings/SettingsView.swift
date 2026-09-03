import SwiftUI

/// Settings screen for local preferences and offline app information.
struct SettingsView: View {
    /// Shared app dependencies used by the shell until real stores exist.
    let dependencies: AppDependencies

    /// Local state store used for focus language and reset controls.
    @ObservedObject private var userStateStore: LocalUserStateStore

    /// Controls the destructive learning-progress reset confirmation.
    @State private var isShowingResetConfirmation = false
    /// Controls the separate all-preferences reset confirmation.
    @State private var isShowingPreferencesResetConfirmation = false

    /// Creates Settings with observed access to local user state.
    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _userStateStore = ObservedObject(wrappedValue: dependencies.userStateStore)
    }

    var body: some View {
        Form {
            Section("Display preferences") {
                Picker("Appearance", selection: appearanceBinding) {
                    ForEach(AppearancePreference.allCases) { preference in
                        Text(preference.rawValue.capitalized).tag(preference)
                    }
                }
                Text("Choose Light or Dark appearance for the gallery shell.")
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
        .navigationTitle("Settings")
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

    /// Binding for the small, intentionally limited appearance preference model.
    private var appearanceBinding: Binding<AppearancePreference> {
        Binding(
            get: { userStateStore.state.appearancePreference },
            set: { userStateStore.setAppearancePreference($0) }
        )
    }
}
