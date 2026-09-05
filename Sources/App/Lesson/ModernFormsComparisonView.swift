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
            Text("Regular Script")
                .font(AppTypography.exhibitHeading)
                .foregroundStyle(AppColors.textPrimary)
                .multilineTextAlignment(.center)
            ArtifactField {
                ZStack {
                    SymbolStageBackgroundView(stageID: "regular")
                    Text(record.coreCharacter)
                        // Match the Regular Script visual weight to the historical exhibits above it.
                        .font(CJKFontRole.museumRegular.font(size: 196))
                        .foregroundStyle(AppColors.artifactInk)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .minimumScaleFactor(0.55)
                        .lineLimit(1)
                        .accessibilityLabel("Regular Script \(record.coreCharacter)")

                }
                .frame(maxWidth: .infinity, minHeight: 280, maxHeight: 280)
                .overlay(alignment: .bottom) {
                    Text("Paper · brush")
                        .font(AppTypography.metadata)
                        .foregroundStyle(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, AppSpacing.spaceSm)
                        .padding(.bottom, AppSpacing.spaceSm)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(height: 304)
            Text("A modern standardized Kai reference rendering.")
                .font(AppTypography.body)
                .foregroundStyle(AppColors.textSecondary)
                .multilineTextAlignment(.center)
        }
    }
}
