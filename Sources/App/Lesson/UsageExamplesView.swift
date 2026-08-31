import SwiftUI

/// Progressive word and sentence examples across the required focus tracks.
struct UsageExamplesView: View {
    /// Bundled record for the current lesson.
    let record: SharedCharacterRecord

    /// Focus tracks currently enabled by the learner.
    let focusSelection: FocusTrackSelection

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.spaceLg) {
            Text("USAGE")
                .font(AppTypography.conceptLabel)
                .tracking(1.4)
                .foregroundStyle(AppColors.textSecondary)
            Text("Where the character lives today")
                .font(AppTypography.exhibitHeading)
                .foregroundStyle(AppColors.textPrimary)
            Text(record.usage.coreMeaningFirst)
                .font(AppTypography.body)

            if focusSelection.contains(.simplifiedChinese) {
                exampleGroup("Simplified Chinese", examples: record.focusCoverage.simplifiedChinese.examples)
            }
            if focusSelection.contains(.traditionalChinese) {
                exampleGroup("Traditional Chinese - Taiwan", examples: record.focusCoverage.traditionalChinese.taiwanExamples)
                exampleGroup("Traditional Chinese - Hong Kong", examples: record.focusCoverage.traditionalChinese.hongKongExamples)
            }
            if focusSelection.contains(.japanese) {
                exampleGroup("Japanese", examples: record.focusCoverage.japanese.examples)
            }
            if focusSelection.contains(.korean) {
                exampleGroup("Korean", examples: record.focusCoverage.korean.examples)
            }
        }
    }

    /// One focus-track example group, ordered from word to sentence.
    private func exampleGroup(_ title: String, examples: [UsageExample]) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(AppTypography.sectionHeading)
                .foregroundStyle(AppColors.textPrimary)

            GroupedSurface {
                VStack(alignment: .leading, spacing: 2) {
                    ForEach(Array(examples.enumerated()), id: \.offset) { index, example in
                        VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
                            HStack(alignment: .firstTextBaseline) {
                                Text(example.text)
                                    .font(.system(size: 24, design: .serif))
                                    .foregroundStyle(AppColors.textPrimary)
                                Spacer()
                                Text(example.exampleLevel.rawValue.capitalized)
                                    .font(AppTypography.caption)
                                    .foregroundStyle(AppColors.textSecondary)
                            }
                            if let reading = example.reading, !reading.isEmpty {
                                Text(reading)
                                    .font(AppTypography.metadata)
                                    .foregroundStyle(AppColors.textSecondary)
                            }
                            Text(example.translation)
                                .font(AppTypography.body)
                                .foregroundStyle(AppColors.textSecondary)
                            if !example.reusesKnownSymbols.isEmpty {
                                Text("Reuses: \(example.reusesKnownSymbols.joined(separator: ", "))")
                                    .font(AppTypography.caption)
                                    .foregroundStyle(AppColors.textSecondary)
                            }
                        }
                        .padding(.vertical, AppSpacing.spaceXs)
                        if index < examples.count - 1 {
                            Divider().overlay(AppColors.separator)
                        }
                    }
                }
            }
        }
    }
}
