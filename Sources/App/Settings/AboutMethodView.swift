import SwiftUI

/// Lightweight About / Method screen for V1 scope and offline corpus information.
struct AboutMethodView: View {
    /// Number of Shared Character records installed in the bundled corpus.
    let corpusCount: Int

    var body: some View {
        List {
            Section("Method") {
                Text("AsianLanguage teaches one Shared Character at a time through a Symbol Journey from recognizable origin and historical Evolution Stages into Today and modern usage.")
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
