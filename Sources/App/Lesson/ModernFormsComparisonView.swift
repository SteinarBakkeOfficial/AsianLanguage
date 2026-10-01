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
                VStack(spacing: SymbolExhibitMetrics.captionGap) {
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
                    .frame(width: SymbolExhibitMetrics.squareSize, height: SymbolExhibitMetrics.squareSize)

                    // Regular is the Museum endpoint; reserve the shared band without assigning it a historical method.
                    Color.clear
                        .frame(width: SymbolExhibitMetrics.squareSize, height: SymbolExhibitMetrics.captionHeight)
                        .accessibilityHidden(true)
                }
                .frame(maxWidth: .infinity)
                .frame(height: SymbolExhibitMetrics.contentHeight)
            }
            .frame(height: SymbolExhibitMetrics.fieldHeight)
            Text(regularConclusion)
                .font(AppTypography.body)
                .foregroundStyle(AppColors.textPrimary)
                .multilineTextAlignment(.center)
        }
    }

    /// Uses the record's approved Regular-stage conclusion instead of repeating a generic font description.
    private var regularConclusion: String {
        let regularStage = record.history.stages.first(where: { $0.stage == "regular" })
        return regularStage?.transitionNote
            ?? regularStage?.stageExplanation
            ?? "The character settles into its balanced Regular Script form."
    }
}
