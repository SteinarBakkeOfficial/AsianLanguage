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
                // Reading systems are not unique: Japanese may have several On/Kun readings,
                // and Korean may expose ordinary and sound-law variants.
                ForEach(Array(readings.enumerated()), id: \.offset) { _, reading in
                    readingRow(reading, fontRole: fontRole)
                }
            }
            Spacer(minLength: 0)
        }
    }

    /// Keeps the learner's script prominent while placing the reading label and audio beside it.
    private func readingRow(_ reading: CharacterReading, fontRole: CJKFontRole) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: AppSpacing.spaceXs) {
            VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
                Text(readingLabel(reading))
                    .font(AppTypography.metadata)
                    .foregroundStyle(AppColors.textSecondary)
                let parts = displayReadingParts(reading.value)
                Text(parts.script)
                    .font(fontRole.font(size: 22).weight(.medium))
                    .foregroundStyle(AppColors.textPrimary)
                if let romanization = parts.romanization {
                    Text(romanization)
                        .font(AppTypography.metadata)
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
            PronunciationButton(reading: reading)
        }
    }

    /// Uses established linguistic labels instead of flattening distinct reading systems into one caption.
    private func readingLabel(_ reading: CharacterReading) -> String {
        let normalized = reading.system.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if normalized == "on" { return "On · Sino-Japanese" }
        if normalized == "kun" { return "Kun · native Japanese" }
        if normalized == "hanja" { return "Hanja · Sino-Korean" }
        if normalized.hasPrefix("hanja · ") {
            return "Hanja · " + String(reading.system.dropFirst("hanja · ".count))
        }
        if normalized == "native korean" || normalized == "everyday korean" {
            return "Everyday Korean"
        }
        if normalized.hasPrefix("native korean · ") || normalized.hasPrefix("everyday korean · ") {
            let separator = reading.system.firstIndex(of: "·")
            let detail = separator.map {
                String(reading.system[reading.system.index(after: $0)...])
                    .trimmingCharacters(in: .whitespacesAndNewlines)
            } ?? ""
            return detail.isEmpty ? "Everyday Korean" : "Everyday Korean · \(detail)"
        }
        return reading.system.capitalized
    }

    /// Splits the current editorial display form from optional romanization without changing the stored value.
    private func displayReadingParts(_ value: String) -> (script: String, romanization: String?) {
        let parentheticalParts = value.split(separator: "(", maxSplits: 1, omittingEmptySubsequences: true)
        if parentheticalParts.count == 2 {
            return (
                String(parentheticalParts[0]).trimmingCharacters(in: .whitespaces),
                String(parentheticalParts[1]).trimmingCharacters(in: CharacterSet(charactersIn: ") "))
            )
        }
        let slashParts = value.components(separatedBy: " / ")
        if slashParts.count == 2 {
            return (slashParts[0], slashParts[1])
        }
        return (value, nil)
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
                ForEach(Array(variant.readings.enumerated()), id: \.offset) { _, reading in
                    readingRow(reading, fontRole: .korean)
                }
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
            if !coverage.taiwanReadings.isEmpty || !coverage.taiwanExamples.isEmpty {
                regionalExamples(title: "Taiwan", readings: coverage.taiwanReadings, examples: coverage.taiwanExamples)
            }
            if !coverage.hongKongReadings.isEmpty || !coverage.hongKongExamples.isEmpty {
                regionalExamples(title: "Hong Kong · Cantonese / Jyutping", readings: coverage.hongKongReadings, examples: coverage.hongKongExamples)
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

    /// Renders up to four useful context entries for one Traditional Chinese region.
    private func regionalExamples(title: String, readings: [CharacterReading], examples: [UsageExample]) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
            Text(title)
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.textSecondary)
            ForEach(Array(readings.enumerated()), id: \.offset) { _, reading in
                readingRow(reading, fontRole: .traditionalChinese)
            }
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
