import SwiftUI

/// Word-level modern context for the Symbol Journey; sentence lessons are intentionally out of scope.
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
        VStack(alignment: .leading, spacing: AppSpacing.spaceLg) {
            Text("HOW IT’S USED")
                .font(AppTypography.conceptLabel)
                .tracking(1.4)
                .foregroundStyle(AppColors.textSecondary)
            Text("The character in a word")
                .font(AppTypography.exhibitHeading)
                .foregroundStyle(AppColors.textPrimary)
            Text("See the shared character, its reading, and the everyday form used alongside it."
            )
                .font(AppTypography.body)
                .foregroundStyle(AppColors.textSecondary)

            if focusSelection.selectedTracks.isEmpty {
                Text("Modern word context is turned off. You can enable tracks later in More → Languages.")
                    .font(AppTypography.body)
                    .foregroundStyle(AppColors.textSecondary)
            } else {
                if visibleTracks.contains(.simplifiedChinese) {
                    wordSection(
                        title: "Simplified Chinese",
                        form: record.focusCoverage.simplifiedChinese.form,
                        readings: record.focusCoverage.simplifiedChinese.readings,
                        glosses: record.focusCoverage.simplifiedChinese.glosses,
                        examples: record.focusCoverage.simplifiedChinese.examples,
                        variants: record.focusCoverage.simplifiedChinese.variants
                    )
                }
                if visibleTracks.contains(.traditionalChinese) {
                    wordSection(
                        title: "Traditional Chinese · Taiwan / Hong Kong",
                        form: record.focusCoverage.traditionalChinese.form,
                        readings: record.focusCoverage.traditionalChinese.readings,
                        glosses: record.focusCoverage.traditionalChinese.glosses,
                        examples: record.focusCoverage.traditionalChinese.taiwanExamples + record.focusCoverage.traditionalChinese.hongKongExamples,
                        variants: record.focusCoverage.traditionalChinese.variants
                    )
                }
                if visibleTracks.contains(.japanese) {
                    wordSection(
                        title: "Japanese Kanji",
                        form: record.focusCoverage.japanese.form,
                        readings: record.focusCoverage.japanese.readings,
                        glosses: record.focusCoverage.japanese.glosses,
                        examples: record.focusCoverage.japanese.examples,
                        variants: record.focusCoverage.japanese.variants
                    )
                }
                if visibleTracks.contains(.korean) {
                    koreanWordSection(record.focusCoverage.korean)
                }
            }
        }
    }

    /// Shows one focused character word rather than an unexplained full sentence.
    private func wordSection(
        title: String,
        form: String,
        readings: [CharacterReading],
        glosses: [String],
        examples: [UsageExample],
        variants: [ModernFormVariant]
    ) -> some View {
        GroupedSurface {
            VStack(alignment: .leading, spacing: AppSpacing.spaceSm) {
                Text(title)
                    .font(AppTypography.sectionHeading)
                    .foregroundStyle(AppColors.textPrimary)
                HStack(alignment: .top, spacing: AppSpacing.spaceMd) {
                    Text(form)
                        .font(.system(size: 48, design: .serif))
                        .foregroundStyle(AppColors.accentPrimary)
                    VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
                        Text(readings.map(\.value).joined(separator: " · "))
                            .font(AppTypography.body.weight(.semibold))
                            .foregroundStyle(AppColors.textPrimary)
                        Text(glosses.joined(separator: ", "))
                            .font(AppTypography.body)
                            .foregroundStyle(AppColors.textSecondary)
                    }
                }
                Divider().overlay(AppColors.separator)
                ForEach(examples.filter { $0.exampleLevel == .word }.prefix(2), id: \.text) { example in
                    exampleRow(example)
                }
                ForEach(variants, id: \.id) { variant in
                    variantRow(variant)
                }
            }
        }
    }

    /// Korean uses native Hangul for everyday vocabulary while retaining the Hanja bridge as context.
    private func koreanWordSection(_ coverage: StandardFocusCoverage) -> some View {
        let hanjaReading = coverage.readings.first(where: { $0.system == "hanja" })?.value
        let nativeReading = coverage.readings.first(where: { $0.system == "native Korean" })?.value
        return GroupedSurface {
            VStack(alignment: .leading, spacing: AppSpacing.spaceSm) {
                Text("Korean")
                    .font(AppTypography.sectionHeading)
                    .foregroundStyle(AppColors.textPrimary)
                HStack(alignment: .top, spacing: AppSpacing.spaceMd) {
                    Text(coverage.form)
                        .font(.system(size: 42, design: .serif))
                        .foregroundStyle(AppColors.accentPrimary)
                    VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
                        Text(nativeReading ?? "Everyday Korean")
                            .font(AppTypography.body.weight(.semibold))
                            .foregroundStyle(AppColors.textPrimary)
                        if let hanjaReading {
                            Text("Hanja: \(hanjaReading)")
                                .font(AppTypography.metadata)
                                .foregroundStyle(AppColors.textSecondary)
                        }
                        Text(coverage.glosses.joined(separator: ", "))
                            .font(AppTypography.body)
                            .foregroundStyle(AppColors.textSecondary)
                    }
                }
                Divider().overlay(AppColors.separator)
                ForEach(coverage.examples.filter { $0.exampleLevel == .word }.prefix(2), id: \.text) { example in
                    exampleRow(example)
                }
                ForEach(coverage.variants, id: \.id) { variant in
                    variantRow(variant)
                }
            }
        }
    }

    /// Keeps word-level meaning visible while intentionally filtering sentence lessons out of the museum.
    private func exampleRow(_ example: UsageExample) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: AppSpacing.spaceSm) {
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

    private func variantRow(_ variant: ModernFormVariant) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: AppSpacing.spaceSm) {
            Text("Also written")
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.textTertiary)
            Text(variant.form)
                .font(AppTypography.body.weight(.semibold))
                .foregroundStyle(AppColors.textPrimary)
            if let writingSystem = variant.writingSystem {
                Text("· \(writingSystem)")
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }
            if !variant.readings.isEmpty {
                Text(variant.readings.map(\.value).joined(separator: " · "))
                    .font(AppTypography.metadata)
                    .foregroundStyle(AppColors.textSecondary)
            }
        }
    }
}
