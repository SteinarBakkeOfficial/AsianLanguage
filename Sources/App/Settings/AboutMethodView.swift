import SwiftUI

/// Presents the public app identity without mixing in the global source inventory.
struct AboutMethodView: View {
    /// Number of Shared Character records included in the bundled museum library.
    let corpusCount: Int

    private var appVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
    }

    private var appBuild: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1"
    }

    var body: some View {
        List {
            Section("Script Roots") {
                Text("An offline museum app about the shared history of Chinese characters and their modern forms across Chinese, Japanese, and Korean writing traditions.")
            }

            Section("App information") {
                LabeledContent("Developer", value: "Steinar Bakke")
                LabeledContent("Version", value: "\(appVersion) (\(appBuild))")
                LabeledContent("Release year", value: "2026")
            }

            Section("Offline museum library") {
                LabeledContent("Characters available", value: "\(corpusCount)")
                Text("The museum experience works offline with its bundled Shared Character corpus and local assets. Progress remains on this device.")
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }
        }
        .navigationTitle("About Script Roots")
        .scrollContentBackground(.hidden)
        .background(AppColors.appBackground.ignoresSafeArea())
        .tint(AppColors.accentPrimary)
    }
}
