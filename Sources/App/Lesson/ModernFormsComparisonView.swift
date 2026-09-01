import SwiftUI

/// Today is the final room of the same Symbol Journey, showing one language exhibit at a time.
struct ModernFormsComparisonView: View {
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
        VStack(alignment: .leading, spacing: AppSpacing.spaceMd) {
            todayHeading

            if visibleTracks.isEmpty {
                GroupedSurface {
                    VStack(alignment: .leading, spacing: AppSpacing.spaceXs) {
                        Text("Museum view")
                            .font(AppTypography.sectionHeading)
                            .foregroundStyle(AppColors.textPrimary)
                        Text("Modern language examples are turned off. The character journey remains complete without selecting a language.")
                            .font(AppTypography.metadata)
                            .foregroundStyle(AppColors.textSecondary)
                    }
                }
            } else {
                ForEach(visibleTracks) { visibleTrack in
                    exhibitCard(for: visibleTrack)
                }
            }
        }
    }

    /// Keeps Today visually continuous with the historical exhibit instead of creating a second lesson header.
    private var todayHeading: some View {
        VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
            Text("TODAY")
                .font(AppTypography.conceptLabel)
                .tracking(1.6)
                .foregroundStyle(AppColors.textSecondary)
            Text(track?.title ?? "The character today")
                .font(AppTypography.exhibitHeading)
                .foregroundStyle(AppColors.textPrimary)
            Text("The shared character in modern writing and speech.")
                .font(AppTypography.metadata)
                .foregroundStyle(AppColors.textSecondary)
        }
    }

    /// Selects the appropriate canonical coverage without duplicating the visual card layout.
    @ViewBuilder
    private func exhibitCard(for track: FocusTrack) -> some View {
        switch track {
        case .simplifiedChinese:
            languageCard(title: "Simplified Chinese", coverage: record.focusCoverage.simplifiedChinese)
        case .traditionalChinese:
            languageCard(title: "Traditional Chinese · Taiwan / Hong Kong", coverage: record.focusCoverage.traditionalChinese)
        case .japanese:
            languageCard(title: "Japanese · Kanji", coverage: record.focusCoverage.japanese)
        case .korean:
            koreanCard(record.focusCoverage.korean)
        }
    }

    /// Renders one clean language exhibit; alternate forms are reserved for the
    /// dedicated language story so Today does not repeat the same information.
    private func languageCard<Coverage: ModernCoverageDisplay>(title: String, coverage: Coverage) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.spaceSm) {
            cardHeading(title)
            HStack(alignment: .top, spacing: AppSpacing.spaceMd) {
                Text(coverage.form)
                    .font(.system(size: 56, design: .serif))
                    .foregroundStyle(AppColors.accentPrimary)
                    .frame(width: 62, alignment: .leading)
                VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
                    ForEach(coverage.readings, id: \.system) { reading in
                        readingLine(reading)
                    }
                    Text(coverage.glosses.joined(separator: ", "))
                        .font(AppTypography.metadata)
                        .foregroundStyle(AppColors.textSecondary)
                }
                Spacer(minLength: 0)
            }
        }
        .exhibitCardSurface()
    }

    /// Korean keeps Hanja and everyday Hangul in parallel so neither reading is hidden as a footnote.
    private func koreanCard(_ coverage: StandardFocusCoverage) -> some View {
        let nativeVariant = coverage.variants.first(where: { $0.writingSystem == "Hangul" })
        return VStack(alignment: .leading, spacing: AppSpacing.spaceSm) {
            cardHeading("Korean")
            HStack(alignment: .top, spacing: AppSpacing.spaceMd) {
                VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
                    Text("Hanja")
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColors.textSecondary)
                    Text(coverage.form)
                        .font(.system(size: 52, design: .serif))
                        .foregroundStyle(AppColors.accentPrimary)
                    if let hanjaReading = coverage.readings.first(where: { $0.system == "hanja" })?.value {
                        Text("Hanja: \(hanjaReading)")
                            .font(AppTypography.metadata.weight(.semibold))
                            .foregroundStyle(AppColors.textPrimary)
                    }
                }
                Rectangle()
                    .fill(AppColors.separator)
                    .frame(width: 1, height: 86)
                VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
                    Text("Everyday Korean")
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColors.textSecondary)
                    Text(nativeVariant?.form ?? "—")
                        .font(.system(size: 40, design: .serif))
                        .foregroundStyle(AppColors.textPrimary)
                    if let nativeVariant {
                        readingValues(for: nativeVariant.readings)
                    } else {
                        readingValues(for: coverage.readings.filter { $0.system == "native Korean" })
                    }
                }
                Spacer(minLength: 0)
            }
            Text(coverage.glosses.joined(separator: ", "))
                .font(AppTypography.metadata)
                .foregroundStyle(AppColors.textSecondary)
        }
        .exhibitCardSurface()
    }

    private func cardHeading(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(AppTypography.stageTitle)
                .foregroundStyle(AppColors.textPrimary)
            Spacer()
            Image(systemName: "speaker.wave.2")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(AppColors.textSecondary)
                .accessibilityLabel("Play pronunciation")
        }
    }

    private func readingLine(_ reading: CharacterReading) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: AppSpacing.spaceXs) {
            Text(reading.system.capitalized)
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.textSecondary)
            Text(reading.value)
                .font(AppTypography.body.weight(.semibold))
                .foregroundStyle(AppColors.textPrimary)
        }
    }

    private func readingValues(for readings: [CharacterReading]) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
            ForEach(readings, id: \.system) { reading in
                Text(reading.value)
                    .font(AppTypography.metadata.weight(.semibold))
                    .foregroundStyle(AppColors.textPrimary)
            }
        }
    }

}

/// Small adapter keeps Today shared by standard and regional coverage models.
private protocol ModernCoverageDisplay {
    var form: String { get }
    var readings: [CharacterReading] { get }
    var glosses: [String] { get }
    var variants: [ModernFormVariant] { get }
}

extension StandardFocusCoverage: ModernCoverageDisplay {}
extension TraditionalChineseCoverage: ModernCoverageDisplay {}

private struct ExhibitCardSurface: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(AppSpacing.spaceMd)
            .background(AppColors.surfaceElevated)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.card))
            .overlay {
                RoundedRectangle(cornerRadius: AppRadius.card)
                    .stroke(AppColors.separator, lineWidth: 1)
            }
            .shadow(color: AppColors.textPrimary.opacity(0.05), radius: 8, y: 3)
    }
}

private extension View {
    /// Shared card treatment for Today exhibits; keep this geometry aligned with the shell cards.
    func exhibitCardSurface() -> some View { modifier(ExhibitCardSurface()) }
}
