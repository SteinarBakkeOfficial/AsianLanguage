import SwiftUI

/// Today endpoint showing one Shared Character across the learner's selected modern tracks.
struct ModernFormsComparisonView: View {
    let record: SharedCharacterRecord
    let focusSelection: FocusTrackSelection

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.spaceLg) {
            VStack(alignment: .leading, spacing: AppSpacing.spaceXs) {
                Text("TODAY")
                    .font(AppTypography.conceptLabel)
                    .tracking(1.4)
                    .foregroundStyle(AppColors.textSecondary)
                Text(record.coreCharacter)
                    .font(AppTypography.exhibitHeading)
                    .foregroundStyle(AppColors.textPrimary)
                Text("One lineage, connected across your selected language tracks.")
                    .font(AppTypography.body)
                    .foregroundStyle(AppColors.textSecondary)
            }

            VStack(spacing: AppSpacing.spaceSm) {
                if focusSelection.contains(.simplifiedChinese) {
                    modernSection(title: "Simplified Chinese", coverage: record.focusCoverage.simplifiedChinese, examples: record.focusCoverage.simplifiedChinese.examples)
                }
                if focusSelection.contains(.traditionalChinese) {
                    modernSection(title: "Traditional Chinese", coverage: record.focusCoverage.traditionalChinese, examples: record.focusCoverage.traditionalChinese.taiwanExamples)
                }
                if focusSelection.contains(.japanese) {
                    modernSection(title: "Japanese", coverage: record.focusCoverage.japanese, examples: record.focusCoverage.japanese.examples)
                }
                if focusSelection.contains(.korean) {
                    modernSection(title: "Korean (Hanja)", coverage: record.focusCoverage.korean, examples: record.focusCoverage.korean.examples)
                }
            }
        }
    }

    /// The shared section shape keeps Today dense enough for four tracks without language color coding.
    private func modernSection<Coverage: ModernCoverageDisplay>(title: String, coverage: Coverage, examples: [UsageExample]) -> some View {
        GroupedSurface {
            VStack(alignment: .leading, spacing: AppSpacing.spaceSm) {
                Text(title)
                    .font(AppTypography.metadata)
                    .foregroundStyle(AppColors.textSecondary)
                HStack(alignment: .firstTextBaseline, spacing: AppSpacing.spaceMd) {
                    Text(coverage.form)
                        .font(.system(size: 52, design: .serif))
                        .foregroundStyle(AppColors.textPrimary)
                    VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
                        Text(coverage.readingSummary)
                            .font(AppTypography.body.weight(.semibold))
                            .foregroundStyle(AppColors.textPrimary)
                        Text(coverage.glossSummary)
                            .font(AppTypography.metadata)
                            .foregroundStyle(AppColors.textSecondary)
                    }
                }
                if let example = examples.first {
                    Text("Example: \(example.text)\(example.reading.map { " · \($0)" } ?? "") — \(example.translation)")
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
        }
    }
}

/// Small adapter protocol keeps the Today view shared by standard and regional coverage models.
private protocol ModernCoverageDisplay {
    var form: String { get }
    var readings: [CharacterReading] { get }
    var glosses: [String] { get }
}

private extension ModernCoverageDisplay {
    var readingSummary: String { readings.map(\.value).joined(separator: " / ") }
    var glossSummary: String { glosses.joined(separator: ", ") }
}

extension StandardFocusCoverage: ModernCoverageDisplay {}
extension TraditionalChineseCoverage: ModernCoverageDisplay {}
