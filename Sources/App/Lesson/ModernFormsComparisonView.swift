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
        VStack(alignment: .center, spacing: AppSpacing.spaceMd) {
            Text("MODERN")
                .font(AppTypography.conceptLabel)
                .tracking(1.6)
                .foregroundStyle(AppColors.textSecondary)
            Text("Regular Script")
                .font(AppTypography.exhibitHeading)
                .foregroundStyle(AppColors.textPrimary)
                .multilineTextAlignment(.center)
            ArtifactField {
                ZStack(alignment: .bottom) {
                    SymbolStageBackgroundView(stageID: "regular")
                    Text(record.coreCharacter)
                        // Match the Regular Script visual weight to the historical exhibits above it.
                        .font(CJKFontRole.museumRegular.font(size: 196))
                        .foregroundStyle(AppColors.artifactInk)
                        .frame(maxWidth: .infinity, minHeight: 236, maxHeight: 236)
                        .minimumScaleFactor(0.55)
                        .lineLimit(1)
                        .clipped()
                        .accessibilityLabel("Regular Script \(record.coreCharacter)")

                    Text("Paper · brush")
                        .font(AppTypography.metadata)
                        .foregroundStyle(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, AppSpacing.spaceSm)
                        .padding(.bottom, AppSpacing.spaceSm)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
            }
            Text("A modern standardized Kai reference rendering.")
                .font(AppTypography.body)
                .foregroundStyle(AppColors.textSecondary)
                .multilineTextAlignment(.center)
        }
    }
}
