import SwiftUI

/// Word-level modern context for the Symbol Journey; sentence lessons are intentionally out of scope.
struct UsageExamplesView: View {
    let record: SharedCharacterRecord
    let focusSelection: FocusTrackSelection

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.spaceLg) {
            Text("WORD CONTEXT")
                .font(AppTypography.conceptLabel)
                .tracking(1.4)
                .foregroundStyle(AppColors.textSecondary)
            Text("Start with the character")
                .font(AppTypography.exhibitHeading)
                .foregroundStyle(AppColors.textPrimary)
            Text("Each language keeps the lesson at word level: the written form, its reading, and what the character contributes to the word. Sentence study is not part of this museum journey.")
                .font(AppTypography.body)
                .foregroundStyle(AppColors.textSecondary)

            if focusSelection.selectedTracks.isEmpty {
                Text("Modern word context is turned off. You can enable tracks later in More → Languages.")
                    .font(AppTypography.body)
                    .foregroundStyle(AppColors.textSecondary)
            } else {
                if focusSelection.contains(.simplifiedChinese) {
                    wordSection(
                        title: "Simplified Chinese",
                        form: record.focusCoverage.simplifiedChinese.form,
                        readings: record.focusCoverage.simplifiedChinese.readings,
                        glosses: record.focusCoverage.simplifiedChinese.glosses
                    )
                }
                if focusSelection.contains(.traditionalChinese) {
                    wordSection(
                        title: "Traditional Chinese · Taiwan / Hong Kong",
                        form: record.focusCoverage.traditionalChinese.form,
                        readings: record.focusCoverage.traditionalChinese.readings,
                        glosses: record.focusCoverage.traditionalChinese.glosses
                    )
                }
                if focusSelection.contains(.japanese) {
                    wordSection(
                        title: "Japanese Kanji",
                        form: record.focusCoverage.japanese.form,
                        readings: record.focusCoverage.japanese.readings,
                        glosses: record.focusCoverage.japanese.glosses
                    )
                }
                if focusSelection.contains(.korean) {
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
        glosses: [String]
    ) -> some View {
        GroupedSurface {
            VStack(alignment: .leading, spacing: AppSpacing.spaceSm) {
                Text(title)
                    .font(AppTypography.sectionHeading)
                    .foregroundStyle(AppColors.textPrimary)
                HStack(alignment: .top, spacing: AppSpacing.spaceMd) {
                    Text(form)
                        .font(.system(size: 48, design: .serif))
                        .foregroundStyle(AppColors.textPrimary)
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
                Text("Character focus: \(form) · \(glosses.joined(separator: ", "))")
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }
        }
    }

    /// Korean uses native Hangul for everyday vocabulary while retaining the Hanja bridge as context.
    private func koreanWordSection(_ coverage: StandardFocusCoverage) -> some View {
        let hanjaReading = coverage.readings.first(where: { $0.system == "hanja" })?.value
        let nativeReading = coverage.readings.first(where: { $0.system == "native Korean" })?.value
        let nativeWord = nativeReading?.split(separator: "/").first.map(String.init) ?? coverage.form
        return GroupedSurface {
            VStack(alignment: .leading, spacing: AppSpacing.spaceSm) {
                Text("Korean")
                    .font(AppTypography.sectionHeading)
                    .foregroundStyle(AppColors.textPrimary)
                HStack(alignment: .top, spacing: AppSpacing.spaceMd) {
                    Text(nativeWord)
                        .font(.system(size: 42, design: .serif))
                        .foregroundStyle(AppColors.textPrimary)
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
                Text("Everyday word: \(nativeWord) · \(coverage.glosses.joined(separator: ", "))")
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textSecondary)
                if let hanjaReading {
                    Text("Shared character \(coverage.form) · Hanja reading \(hanjaReading)")
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColors.textTertiary)
                }
            }
        }
    }
}
