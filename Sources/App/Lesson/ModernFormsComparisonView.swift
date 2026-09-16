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
                // Match the museum-stage caption spacing while preserving the established frame size.
                VStack(spacing: 16) {
                    ZStack {
                        SymbolStageBackgroundView(stageID: "regular")
                        Text(record.coreCharacter)
                            // Keep the Regular Script glyph dark against the light paper background in Dark mode too.
                            .font(CJKFontRole.museumRegular.font(size: 196))
                            .foregroundStyle(AppColors.artifactInk)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                            .minimumScaleFactor(0.55)
                            .lineLimit(1)
                            .accessibilityLabel("Regular Script \(record.coreCharacter)")
                    }
                    .frame(maxWidth: .infinity, height: 248)

                    // Keep the material cue in its own quiet band instead of over the paper artwork.
                    Text("Paper · brush")
                        .font(AppTypography.metadata)
                        .foregroundStyle(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, height: 20)
                        .padding(.horizontal, AppSpacing.spaceSm)
                }
                .frame(maxWidth: .infinity, height: 284)
            }
            .frame(height: 304)
            Text("A modern standardized Kai reference rendering.")
                .font(AppTypography.body)
                .foregroundStyle(AppColors.textSecondary)
                .multilineTextAlignment(.center)
        }
    }
}
