import SwiftUI

/// Settings screen for local preferences and offline app information.
struct SettingsView: View {
    /// Shared app dependencies used by the shell until real stores exist.
    let dependencies: AppDependencies

    /// Local state store used for focus language and reset controls.
    @ObservedObject private var userStateStore: LocalUserStateStore

    /// Controls the destructive reset confirmation.
    @State private var isShowingResetConfirmation = false

    /// Creates Settings with observed access to local user state.
    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _userStateStore = ObservedObject(wrappedValue: dependencies.userStateStore)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Focus language") {
                    Picker("Focus language", selection: focusTrackBinding) {
                        ForEach(FocusTrack.allCases) { track in
                            Text(track.title).tag(track)
                        }
                    }
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
            .navigationTitle("Settings")
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

    /// Binding that writes focus changes into persisted local user state.
    private var focusTrackBinding: Binding<FocusTrack> {
        Binding(
            get: { userStateStore.state.focusTrack },
            set: { userStateStore.setFocusTrack($0) }
        )
    }
}
