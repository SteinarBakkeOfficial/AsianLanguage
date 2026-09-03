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
                form: record.focusCoverage.simplifiedChinese.form,
                readings: record.focusCoverage.simplifiedChinese.readings,
                examples: record.focusCoverage.simplifiedChinese.examples,
                variants: record.focusCoverage.simplifiedChinese.variants,
                fontRole: .simplifiedChinese
            )
        case .traditionalChinese:
            traditionalWordCard(record.focusCoverage.traditionalChinese)
        case .japanese:
            wordCard(
                title: "Japanese",
                form: record.focusCoverage.japanese.form,
                readings: record.focusCoverage.japanese.readings,
                examples: record.focusCoverage.japanese.examples,
                variants: record.focusCoverage.japanese.variants,
                fontRole: .japanese
            )
        case .korean:
            koreanWordCard(record.focusCoverage.korean)
        }
    }

    /// Shows up to four real editorial examples without exposing importer placeholders as learner content.
    private func wordCard(
        title: String,
        form: String,
        readings: [CharacterReading],
        examples: [UsageExample],
        variants: [ModernFormVariant],
        fontRole: CJKFontRole
    ) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.spaceXs) {
            Text(title)
                .font(AppTypography.stageTitle)
                .foregroundStyle(AppColors.textPrimary)
            languageFormHeader(form: form, readings: readings, fontRole: fontRole)
            ForEach(displayExamples(examples, variants: variants).prefix(4), id: \.text) { example in
                exampleRow(example, fontRole: fontRole)
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

    /// Presents the selected language's modern form before its contextual examples.
    private func languageFormHeader(form: String, readings: [CharacterReading], fontRole: CJKFontRole) -> some View {
        HStack(alignment: .top, spacing: AppSpacing.spaceMd) {
            Text(form)
                .font(fontRole.font(size: 48))
                .foregroundStyle(AppColors.accentPrimary)
                .frame(minWidth: 58, minHeight: 58, alignment: .leading)
                .minimumScaleFactor(0.55)
                .lineLimit(1)
                .clipped()
            VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
                ForEach(readings, id: \.system) { reading in
                    Text("\(reading.system.capitalized): \(reading.value)")
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
            Spacer(minLength: 0)
        }
    }

    /// Korean keeps the Hanja form and an explicit native-script variant together on the Usage page.
    private func koreanWordCard(_ coverage: StandardFocusCoverage) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.spaceXs) {
            Text("Korean · Hanja / Hangul")
                .font(AppTypography.stageTitle)
                .foregroundStyle(AppColors.textPrimary)
            languageFormHeader(form: coverage.form, readings: coverage.readings, fontRole: .korean)
            ForEach(coverage.variants, id: \.id) { variant in
                HStack(alignment: .firstTextBaseline, spacing: AppSpacing.spaceXs) {
                    Text(variant.writingSystem ?? "Native Korean")
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColors.textSecondary)
                    Text(variant.form)
                        .font(CJKFontRole.korean.font(size: 22).weight(.semibold))
                        .foregroundStyle(AppColors.textPrimary)
                    Text(variant.readings.map(\.value).joined(separator: " · "))
                        .font(AppTypography.metadata)
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
            ForEach(displayExamples(coverage.examples, variants: coverage.variants).prefix(4), id: \.text) { example in
                exampleRow(example, fontRole: .korean)
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
            languageFormHeader(form: coverage.form, readings: coverage.readings, fontRole: .traditionalChinese)
            regionalExamples(title: "Taiwan", examples: coverage.taiwanExamples)
            regionalExamples(title: "Hong Kong · Cantonese / Jyutping", examples: coverage.hongKongExamples)
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
            ForEach(displayExamples(examples).prefix(4), id: \.text) { example in
                exampleRow(example, fontRole: .traditionalChinese)
            }
        }
    }

    /// Keeps learner-facing examples real while allowing future reviewed entries to expand to four naturally.
    private func displayExamples(_ examples: [UsageExample], variants: [ModernFormVariant] = []) -> [UsageExample] {
        var result: [UsageExample] = []
        for example in examples + variants.flatMap(\.examples) {
            let translation = example.translation.lowercased()
            let isPlaceholder = translation.contains("pending")
                || translation.contains("core character reference")
                || example.text.contains("·")
                || example.text.contains("…")
            guard !isPlaceholder, !result.contains(where: { $0.text == example.text }) else { continue }
            result.append(example)
        }
        return result
    }
}
