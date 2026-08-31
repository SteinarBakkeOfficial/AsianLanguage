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
                VStack(spacing: AppSpacing.spaceXs) {
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

    /// The language card follows the reference proportions: metadata header, red shared glyph,
    /// then reading and meaning on one calm elevated surface.
    private func modernSection<Coverage: ModernCoverageDisplay>(title: String, coverage: Coverage) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.spaceSm) {
            HStack {
                Text(title)
                    .font(AppTypography.metadata)
                    .foregroundStyle(AppColors.textSecondary)
                Spacer()
                Image(systemName: "speaker.wave.2")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(AppColors.textSecondary)
                    .accessibilityLabel("Play pronunciation")
            }
            HStack(alignment: .firstTextBaseline, spacing: AppSpacing.spaceMd) {
                Text(coverage.form)
                    .font(.system(size: 48, design: .serif))
                    .foregroundStyle(AppColors.accentPrimary)
                    .frame(width: 44, alignment: .leading)
                VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
                    Text(coverage.readings.map(\.value).joined(separator: " · "))
                        .font(AppTypography.body.weight(.semibold))
                        .foregroundStyle(AppColors.textPrimary)
                    Text(coverage.glosses.joined(separator: ", "))
                        .font(AppTypography.metadata)
                        .foregroundStyle(AppColors.textSecondary)
                }
                Spacer(minLength: 0)
            }
            Text("Shared character form and reading")
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.textTertiary)
        }
        .padding(AppSpacing.spaceMd)
        .background(AppColors.surfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.surface))
        .overlay {
            RoundedRectangle(cornerRadius: AppRadius.surface)
                .stroke(AppColors.separator, lineWidth: 1)
        }
    }

    /// Korean everyday vocabulary is displayed in Hangul; the Hanja reading remains explanatory context.
    private func koreanSection(_ coverage: StandardFocusCoverage) -> some View {
        let hanjaReading = coverage.readings.first(where: { $0.system == "hanja" })?.value
        let nativeReading = coverage.readings.first(where: { $0.system == "native Korean" })?.value
        return VStack(alignment: .leading, spacing: AppSpacing.spaceSm) {
            HStack {
                Text("Korean")
                    .font(AppTypography.metadata)
                    .foregroundStyle(AppColors.textSecondary)
                Spacer()
                Image(systemName: "speaker.wave.2")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(AppColors.textSecondary)
                    .accessibilityLabel("Play pronunciation")
            }
            HStack(alignment: .firstTextBaseline, spacing: AppSpacing.spaceMd) {
                Text(coverage.form)
                    .font(.system(size: 48, design: .serif))
                    .foregroundStyle(AppColors.accentPrimary)
                    .frame(width: 44, alignment: .leading)
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
                        .font(AppTypography.metadata)
                        .foregroundStyle(AppColors.textSecondary)
                }
                Spacer(minLength: 0)
            }
            Text("Everyday Korean is written in Hangul; Hanja remains the recognition bridge.")
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.textTertiary)
        }
        .padding(AppSpacing.spaceMd)
        .background(AppColors.surfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.surface))
        .overlay {
            RoundedRectangle(cornerRadius: AppRadius.surface)
                .stroke(AppColors.separator, lineWidth: 1)
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
