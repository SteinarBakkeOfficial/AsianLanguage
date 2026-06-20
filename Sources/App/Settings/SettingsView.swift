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

    /// Controls the destructive reset confirmation.
    @State private var isShowingResetConfirmation = false

    /// Creates Settings with observed access to local user state.
    init(dependencies: AppDependencies, initialSection: InitialSection = .standard) {
        self.dependencies = dependencies
        self.initialSection = initialSection
        _userStateStore = ObservedObject(wrappedValue: dependencies.userStateStore)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Focus language") {
                    ForEach(FocusTrack.allCases) { track in
                        Toggle(track.title, isOn: focusTrackBinding(for: track))
                    }
                    Text("All tracks are enabled by default. Turn off tracks you do not want to study right now.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Section("Display preferences") {
                    Picker("Script detail", selection: .constant("Guided")) {
                        Text("Guided").tag("Guided")
                    }
                    Text("More display controls will be added here when the visual system moves beyond the current prototype assets.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Section("Offline corpus") {
                    LabeledContent("Installed", value: dependencies.installedCorpusName)
                    LabeledContent("Shared Characters", value: "\(dependencies.installedSharedCharacterCount)")
                    NavigationLink("About / Method") {
                        AboutMethodView(corpusCount: dependencies.installedSharedCharacterCount)
                    }
                }

                Section("Reset") {
                    Button("Reset app progress", role: .destructive) {
                        isShowingResetConfirmation = true
                    }
                }
            }
            .navigationTitle(initialSection == .focusLanguage ? "Languages" : "Settings")
            .alert("Reset app progress?", isPresented: $isShowingResetConfirmation) {
                Button("Reset", role: .destructive) {
                    userStateStore.reset()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This clears local progress, favorites, review-later state, and preferences on this device.")
            }
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
