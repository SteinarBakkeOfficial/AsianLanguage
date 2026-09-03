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

            Section("Historical glyph reference") {
                Text("The museum’s Oracle Bone, Bronze, Small Seal, and Clerical reference images are selected from 漢典 (ZDIC), using the first available glyph by stage during research intake. V1 currently includes 126 characters with all four stages selected, plus a modern Kai endpoint.")
                    .font(AppTypography.body)
                Link("Visit 漢典 / ZDIC", destination: URL(string: "https://zdic.net")!)
                Text("ZDIC is currently a reference source. Copied historical images require reuse permission or replacement with cleared/public-domain assets before commercial release.")
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }

            Section("Modern forms and typography") {
                Text("The historical journey ends at Regular Script. Used Today is a parallel comparison of living language forms, not another chronological stage: Traditional Chinese, Simplified Chinese, Japanese Kanji, and Korean Hanja may share an identity while using different written forms and regional glyph conventions.")
                    .font(AppTypography.body)
                Text("Japanese examples retain Kanji with Hiragana or Katakana readings. Korean presents Hanja together with contemporary Hangul readings and examples. Readings belong to language data and are never inferred from the glyph alone.")
                    .font(AppTypography.body)
                Text("Regular Script uses the modern standardized CNS11643 Kai reference. Used Today uses the bundled locale-specific Adobe Source Han Serif Regular faces for Traditional Chinese Taiwan, Simplified Chinese, Japanese, and Korean. The font files are included locally for offline rendering; they are not archaeological evidence.")
                    .font(AppTypography.body)
                Link("CNS11643 / 正楷體 source", destination: URL(string: "https://www.cns11643.gov.tw")!)
                Link("Adobe Source Han Serif source", destination: URL(string: "https://github.com/adobe-fonts/source-han-serif")!)
                Text("Bundled files: TW-Kai-98_1.ttf; SourceHanSerifJP-Regular.otf; SourceHanSerifKR-Regular.otf; SourceHanSerifSC-Regular.otf; and SourceHanSerifTC-Regular.otf. Source Han Serif is distributed under SIL OFL 1.1. CNS11643 source and attribution terms are recorded with the bundled font notices.")
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }

            Section("V1 bundled content") {
                Text("The complete V1 corpus contains 126 Shared Characters. Each journey includes a locally bundled origin illustration, selected and normalized ZDIC Oracle Bone / Bronze / Small Seal / Clerical assets, and Regular Script rendered from the bundled CNS11643 Kai font.")
                    .font(AppTypography.body)
                Text("The origin illustrations are educational reconstructions in the approved Soft Ink & Wash museum style; they are not historical evidence. Their source and status are recorded per character.")
                    .font(AppTypography.body)
                Text("Historical ZDIC images are bundled for this implementation and remain marked review-required. Confirm reuse permission or replace them with cleared/public-domain equivalents before commercial distribution.")
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textSecondary)
                Text("History overview artwork: History_V1.png, an approved editorial reference image supplied for the app design. The former period-by-period History design remains in the project for a future release.")
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }

            Section("Offline") {
                Text("The core lesson flow uses the bundled offline corpus.")
                    .font(AppTypography.body)
                Text("The History tab currently presents the approved visual overview image. The detailed period-by-period design remains preserved in the code for a later release.")
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
