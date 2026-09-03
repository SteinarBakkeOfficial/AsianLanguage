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
                        Text("IN CONTEXT")
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
                examples: record.focusCoverage.simplifiedChinese.examples
            )
        case .traditionalChinese:
            traditionalWordCard(record.focusCoverage.traditionalChinese)
        case .japanese:
            wordCard(
                title: "Japanese",
                examples: record.focusCoverage.japanese.examples
            )
        case .korean:
            wordCard(
                title: "Korean · Hanja / Hangul",
                examples: record.focusCoverage.korean.examples
            )
        }
    }

    /// Shows up to four context examples across word, phrase, and sentence levels.
    private func wordCard(title: String, examples: [UsageExample]) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.spaceXs) {
            Text(title)
                .font(AppTypography.stageTitle)
                .foregroundStyle(AppColors.textPrimary)
            ForEach(examples.prefix(4), id: \.text) { example in
                HStack(alignment: .firstTextBaseline, spacing: AppSpacing.spaceXs) {
                    Text(example.text)
                        .font(AppTypography.body.weight(.semibold))
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
        .padding(.vertical, AppSpacing.spaceSm)
        .padding(.horizontal, AppSpacing.spaceMd)
        .background(AppColors.surfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.surface))
        .overlay {
            RoundedRectangle(cornerRadius: AppRadius.surface)
                .stroke(AppColors.separator, lineWidth: 1)
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
            ForEach(examples.prefix(4), id: \.text) { example in
                HStack(alignment: .firstTextBaseline, spacing: AppSpacing.spaceXs) {
                    Text(example.text)
                        .font(AppTypography.body.weight(.semibold))
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
    }
}
