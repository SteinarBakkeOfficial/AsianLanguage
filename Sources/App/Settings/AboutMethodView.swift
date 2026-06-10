import SwiftUI

/// Lightweight About / Method screen for V1 scope and offline corpus information.
struct AboutMethodView: View {
    /// Number of Shared Character records installed in the bundled corpus.
    let corpusCount: Int

    var body: some View {
        List {
            Section("Method") {
                Text("Asian Language teaches one Shared Character at a time through origin, character structure, modern forms, usage, and summary.")
                Text("The app is English-first and focuses on cross-language recognition, not grammar lessons.")
            }

            Section("Offline") {
                Text("The core lesson flow uses the bundled offline corpus.")
                LabeledContent("Installed Shared Characters", value: "\(corpusCount)")
            }
        }
        .navigationTitle("About / Method")
    }
}
