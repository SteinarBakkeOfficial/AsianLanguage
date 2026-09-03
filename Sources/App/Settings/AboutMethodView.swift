import SwiftUI

/// Lightweight About / Method screen for V1 scope and offline corpus information.
struct AboutMethodView: View {
    /// Number of Shared Character records installed in the bundled corpus.
    let corpusCount: Int

    var body: some View {
        List {
            Section("References") {
                Text("Historical museum glyph images")
                    .font(AppTypography.body)
                Link("Visit 漢典 / ZDIC", destination: URL(string: "https://zdic.net")!)
                Text("ZDIC is currently a reference source. Copied historical images require reuse permission or replacement with cleared/public-domain assets before commercial release.")
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textSecondary)

                Text("Regular Script font")
                    .font(AppTypography.body)
                Link("CNS11643 / 正楷體 source", destination: URL(string: "https://www.cns11643.gov.tw")!)

                Text("Modern Chinese, Japanese, and Korean font family")
                    .font(AppTypography.body)
                Link("Adobe Source Han Serif source", destination: URL(string: "https://github.com/adobe-fonts/source-han-serif")!)
                Text("Origin and History artwork are local editorial/reference assets supplied for this app.")
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }

            Section("V1") {
                LabeledContent("Installed Shared Characters", value: "\(corpusCount)")
                Text("The app works offline with its bundled corpus and local assets.")
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }
        }
        .navigationTitle("About / Method")
        .scrollContentBackground(.hidden)
        .background(AppColors.appBackground.ignoresSafeArea())
        .tint(AppColors.accentPrimary)
    }
}
