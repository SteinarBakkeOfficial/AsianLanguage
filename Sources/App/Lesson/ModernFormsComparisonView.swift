import SwiftUI

/// Today is the final room of the same Symbol Journey, showing forms without sentence-level lessons.
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
                Text("The character today")
                    .font(AppTypography.exhibitHeading)
                    .foregroundStyle(AppColors.textPrimary)
                Text(focusSelection.selectedTracks.isEmpty
                    ? "The museum journey remains focused on the character and its history."
                    : "One shared character, read and written differently across today's languages.")
                    .font(AppTypography.body)
                    .foregroundStyle(AppColors.textSecondary)
            }

            if focusSelection.selectedTracks.isEmpty {
                GroupedSurface {
                    VStack(alignment: .leading, spacing: AppSpacing.spaceXs) {
                        Text("Museum view")
                            .font(AppTypography.sectionHeading)
                            .foregroundStyle(AppColors.textPrimary)
                        Text("Modern language examples are turned off. Enable tracks later in More → Languages if you want to compare them.")
                            .font(AppTypography.body)
                            .foregroundStyle(AppColors.textSecondary)
                    }
                }
            } else {
                VStack(spacing: AppSpacing.spaceSm) {
                    if focusSelection.contains(.simplifiedChinese) {
                        modernSection(title: "Simplified Chinese", coverage: record.focusCoverage.simplifiedChinese)
                    }
                    if focusSelection.contains(.traditionalChinese) {
                        modernSection(title: "Traditional Chinese", coverage: record.focusCoverage.traditionalChinese)
                    }
                    if focusSelection.contains(.japanese) {
                        modernSection(title: "Japanese Kanji", coverage: record.focusCoverage.japanese)
                    }
                    if focusSelection.contains(.korean) {
                        koreanSection(record.focusCoverage.korean)
                    }
                }
            }
        }
    }

    /// The shared section shape keeps the four writing-system comparisons compact and readable.
    private func modernSection<Coverage: ModernCoverageDisplay>(title: String, coverage: Coverage) -> some View {
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
                        Text(coverage.readings.map(\.value).joined(separator: " · "))
                            .font(AppTypography.body.weight(.semibold))
                            .foregroundStyle(AppColors.textPrimary)
                        Text(coverage.glosses.joined(separator: ", "))
                            .font(AppTypography.metadata)
                            .foregroundStyle(AppColors.textSecondary)
                    }
                }
                Text("Character form and reading")
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textTertiary)
            }
        }
    }

    /// Korean everyday vocabulary is displayed in Hangul; the Hanja reading remains explanatory context.
    private func koreanSection(_ coverage: StandardFocusCoverage) -> some View {
        let hanjaReading = coverage.readings.first(where: { $0.system == "hanja" })?.value
        let nativeReading = coverage.readings.first(where: { $0.system == "native Korean" })?.value
        return GroupedSurface {
            VStack(alignment: .leading, spacing: AppSpacing.spaceSm) {
                Text("Korean")
                    .font(AppTypography.metadata)
                    .foregroundStyle(AppColors.textSecondary)
                HStack(alignment: .firstTextBaseline, spacing: AppSpacing.spaceMd) {
                    Text(nativeReading?.split(separator: "/").first.map(String.init) ?? coverage.form)
                        .font(.system(size: 42, design: .serif))
                        .foregroundStyle(AppColors.textPrimary)
                    VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
                        Text(nativeReading ?? "Everyday Korean")
                            .font(AppTypography.body.weight(.semibold))
                            .foregroundStyle(AppColors.textPrimary)
                        Text("Everyday Korean in Hangul")
                            .font(AppTypography.metadata)
                            .foregroundStyle(AppColors.textSecondary)
                    }
                }
                if let hanjaReading {
                    Text("Hanja 火: (hanjaReading)")
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColors.textSecondary)
                }
                Text("The shared character is a recognition bridge; everyday Korean words are written in Hangul.")
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textTertiary)
            }
        }
    }
}

/// Small adapter keeps Today shared by standard and regional coverage models.
private protocol ModernCoverageDisplay {
    var form: String { get }
    var readings: [CharacterReading] { get }
    var glosses: [String] { get }
}

extension StandardFocusCoverage: ModernCoverageDisplay {}
extension TraditionalChineseCoverage: ModernCoverageDisplay {}
