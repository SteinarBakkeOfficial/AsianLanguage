import SwiftUI

/// Compact word context that completes the Today exhibit without becoming a second lesson page.
struct UsageExamplesView: View {
    let record: SharedCharacterRecord
    let focusSelection: FocusTrackSelection
    let track: FocusTrack?

    init(record: SharedCharacterRecord, focusSelection: FocusTrackSelection, track: FocusTrack? = nil) {
        self.record = record
        self.focusSelection = focusSelection
        self.track = track
    }

    private var visibleTracks: [FocusTrack] {
        if let track { return [track] }
        return focusSelection.selectedTracks
    }

    var body: some View {
        Group {
            if visibleTracks.isEmpty {
                // Museum-only journeys deliberately stop after the historical story.
                EmptyView()
            } else {
                VStack(alignment: .leading, spacing: AppSpacing.spaceSm) {
                    HStack(alignment: .firstTextBaseline) {
                        Text("IN A WORD")
                            .font(AppTypography.conceptLabel)
                            .tracking(1.6)
                            .foregroundStyle(AppColors.textSecondary)
                        Spacer()
                        if let track {
                            Text(track.title)
                                .font(AppTypography.caption)
                                .foregroundStyle(AppColors.textSecondary)
                        }
                    }

                    ForEach(visibleTracks) { visibleTrack in
                        compactWordCard(for: visibleTrack)
                    }
                }
            }
        }
    }

    /// Chooses the data lane while keeping every modern language in the same compact visual frame.
    @ViewBuilder
    private func compactWordCard(for track: FocusTrack) -> some View {
        switch track {
        case .simplifiedChinese:
            wordCard(
                title: "Simplified Chinese",
                examples: record.focusCoverage.simplifiedChinese.examples,
                variants: record.focusCoverage.simplifiedChinese.variants,
                fontRole: .simplifiedChinese
            )
        case .traditionalChinese:
            traditionalWordCard(record.focusCoverage.traditionalChinese)
        case .japanese:
            wordCard(
                title: "Japanese",
                examples: record.focusCoverage.japanese.examples,
                variants: record.focusCoverage.japanese.variants,
                fontRole: .japanese
            )
        case .korean:
            wordCard(
                title: "Korean · Hanja / Hangul",
                examples: record.focusCoverage.korean.examples,
                variants: record.focusCoverage.korean.variants,
                fontRole: .korean
            )
        }
    }

    /// Shows up to four existing word-level examples without inventing replacement content.
    private func wordCard(
        title: String,
        examples: [UsageExample],
        variants: [ModernFormVariant],
        fontRole: CJKFontRole
    ) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.spaceXs) {
            Text(title)
                .font(AppTypography.stageTitle)
                .foregroundStyle(AppColors.textPrimary)
            ForEach(examples.filter { $0.exampleLevel == .word }.prefix(4), id: \.text) { example in
                exampleRow(example, fontRole: fontRole)
            }
            ForEach(variants, id: \.id) { variant in
                ForEach(variant.examples.filter { $0.exampleLevel == .word }.prefix(1), id: \.text) { example in
                    HStack(alignment: .firstTextBaseline, spacing: AppSpacing.spaceXs) {
                        Text(variant.writingSystem ?? "Native form")
                            .font(AppTypography.caption)
                            .foregroundStyle(AppColors.textSecondary)
                        Text(example.text)
                            .font(fontRole.font(size: 16).weight(.semibold))
                            .foregroundStyle(AppColors.textPrimary)
                        if let reading = example.reading {
                            Text(reading)
                                .font(AppTypography.metadata)
                                .foregroundStyle(AppColors.textSecondary)
                        }
                        Spacer(minLength: 0)
                        Text(example.translation)
                            .font(AppTypography.caption)
                            .foregroundStyle(AppColors.textSecondary)
                            .multilineTextAlignment(.trailing)
                    }
                }
            }
            ForEach(variants, id: \.id) { variant in
                HStack(alignment: .firstTextBaseline, spacing: AppSpacing.spaceXs) {
                    Text(variant.writingSystem ?? "Alternate form")
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColors.textSecondary)
                    Text(variant.form)
                        .font(fontRole.font(size: 16).weight(.semibold))
                        .foregroundStyle(AppColors.textPrimary)
                    if !variant.readings.isEmpty {
                        Text(variant.readings.map(\.value).joined(separator: " · "))
                            .font(AppTypography.metadata)
                            .foregroundStyle(AppColors.textSecondary)
                    }
                }
            }
        }
        .padding(.vertical, AppSpacing.spaceSm)
        .padding(.horizontal, AppSpacing.spaceMd)
        .background(AppColors.surfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.surface))
        .overlay {
            RoundedRectangle(cornerRadius: AppRadius.surface)
                .stroke(AppColors.separator, lineWidth: 1)
        }
    }

    /// Keeps the existing row geometry while using the selected locale's modern font for the written example.
    private func exampleRow(_ example: UsageExample, fontRole: CJKFontRole) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: AppSpacing.spaceXs) {
            Text(example.text)
                .font(fontRole.font(size: 16).weight(.semibold))
                .foregroundStyle(AppColors.textPrimary)
            if let reading = example.reading {
                Text(reading)
                    .font(AppTypography.metadata)
                    .foregroundStyle(AppColors.textSecondary)
            }
            Spacer(minLength: 0)
            Text(example.translation)
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.textSecondary)
                .multilineTextAlignment(.trailing)
        }
    }

    /// Keeps Taiwan and Hong Kong usage visibly distinct while retaining one Traditional page.
    private func traditionalWordCard(_ coverage: TraditionalChineseCoverage) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.spaceXs) {
            Text("Traditional Chinese")
                .font(AppTypography.stageTitle)
                .foregroundStyle(AppColors.textPrimary)
            regionalExamples(title: "Taiwan", examples: coverage.taiwanExamples)
            regionalExamples(title: "Hong Kong", examples: coverage.hongKongExamples)
        }
        .padding(.vertical, AppSpacing.spaceSm)
        .padding(.horizontal, AppSpacing.spaceMd)
        .background(AppColors.surfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.surface))
        .overlay {
            RoundedRectangle(cornerRadius: AppRadius.surface)
                .stroke(AppColors.separator, lineWidth: 1)
        }
    }

    /// Renders up to four useful context entries for one Traditional Chinese region.
    private func regionalExamples(title: String, examples: [UsageExample]) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
            Text(title)
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.textSecondary)
            ForEach(examples.filter { $0.exampleLevel == .word }.prefix(4), id: \.text) { example in
                exampleRow(example, fontRole: .traditionalChinese)
            }
        }
    }
}
