import SwiftUI

/// Modern is the single final museum endpoint; each selected language continues on its own Usage page.
struct ModernFormsComparisonView: View {
    let record: SharedCharacterRecord

    // Keep the initializer compatible with existing journey callers while Modern remains language-neutral.
    init(record: SharedCharacterRecord, focusSelection: FocusTrackSelection, track: FocusTrack? = nil) {
        self.record = record
        BundledFontRegistrar.registerMuseumFonts()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.spaceMd) {
            Text("MODERN")
                .font(AppTypography.conceptLabel)
                .tracking(1.6)
                .foregroundStyle(AppColors.textSecondary)
            Text("Regular Script")
                .font(AppTypography.exhibitHeading)
                .foregroundStyle(AppColors.textPrimary)
            ArtifactField {
                Text(record.coreCharacter)
                    .font(CJKFontRole.museumRegular.font(size: 148))
                    .foregroundStyle(AppColors.artifactInk)
                    .frame(maxWidth: .infinity, minHeight: 236, maxHeight: 236)
                    .minimumScaleFactor(0.55)
                    .lineLimit(1)
                    .clipped()
                    .accessibilityLabel("Regular Script \(record.coreCharacter)")
            }
            Text("A modern standardized Kai reference rendering.")
                .font(AppTypography.body)
                .foregroundStyle(AppColors.textSecondary)
        }
    }
}
