import SwiftUI

/// Lightweight About / Method screen for V1 scope and offline corpus information.
struct AboutMethodView: View {
    /// Number of Shared Character records installed in the bundled corpus.
    let corpusCount: Int

    var body: some View {
        List {
            Section("Method") {
                Text("Script Roots teaches one Shared Character at a time through one continuous Symbol Journey from recognizable origin through historical Evolution Stages into Today and word-level modern context.")
                    .font(AppTypography.body)
                Text("The app is English-first and focuses on cross-language recognition, not grammar lessons.")
                    .font(AppTypography.body)
            }

            Section("Offline") {
                Text("The core lesson flow uses the bundled offline corpus.")
                    .font(AppTypography.body)
                Text("History is an optional reference shelf for script periods; it is not a separate step inside a Symbol Journey.")
                    .font(AppTypography.body)
                LabeledContent("Installed Shared Characters", value: "\(corpusCount)")
            }
        }
        .navigationTitle("About / Method")
        .scrollContentBackground(.hidden)
        .background(AppColors.appBackground.ignoresSafeArea())
        .tint(AppColors.accentPrimary)
    }
}
