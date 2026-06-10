import SwiftUI

/// Settings screen for local preferences and offline app information.
struct SettingsView: View {
    /// Shared app dependencies used by the shell until real stores exist.
    let dependencies: AppDependencies

    /// Local focus-track selection used until Phase 3 persists preferences.
    @State private var focusTrack: FocusTrack = .all

    var body: some View {
        NavigationStack {
            Form {
                Section("Focus language") {
                    Picker("Focus language", selection: $focusTrack) {
                        ForEach(FocusTrack.allCases) { track in
                            Text(track.title).tag(track)
                        }
                    }
                }

                Section("Offline corpus") {
                    LabeledContent("Installed", value: dependencies.installedCorpusName)
                    LabeledContent("Shared Characters", value: "\(dependencies.installedSharedCharacterCount)")
                }

                Section("Reset") {
                    Button("Reset app progress", role: .destructive) {
                        // Wire this to an explicit confirmation flow when local user state exists.
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}
