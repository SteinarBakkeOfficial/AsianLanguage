import SwiftUI

/// Reusable comparison of the modern focus-track forms for one Shared Character.
struct ModernFormsComparisonView: View {
    /// Bundled Shared Character record being studied.
    let record: SharedCharacterRecord

    /// Focus tracks currently enabled by the learner.
    let focusSelection: FocusTrackSelection

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Modern Descendants")
                .font(.title3.weight(.semibold))

            if focusSelection.contains(.simplifiedChinese) {
                formCard(
                    title: "Simplified Chinese",
                    form: record.focusCoverage.simplifiedChinese.form,
                    readings: record.focusCoverage.simplifiedChinese.readings,
                    glosses: record.focusCoverage.simplifiedChinese.glosses,
                    accent: .orange
                )
            }
            if focusSelection.contains(.traditionalChinese) {
                formCard(
                    title: "Traditional Chinese",
                    form: record.focusCoverage.traditionalChinese.form,
                    readings: record.focusCoverage.traditionalChinese.readings,
                    glosses: record.focusCoverage.traditionalChinese.glosses,
                    accent: .red
                )
            }
            if focusSelection.contains(.japanese) {
                formCard(
                    title: "Japanese Kanji",
                    form: record.focusCoverage.japanese.form,
                    readings: record.focusCoverage.japanese.readings,
                    glosses: record.focusCoverage.japanese.glosses,
                    accent: .purple
                )
            }
            if focusSelection.contains(.korean) {
                formCard(
                    title: "Korean Hanja",
                    form: record.focusCoverage.korean.form,
                    readings: record.focusCoverage.korean.readings,
                    glosses: record.focusCoverage.korean.glosses,
                    accent: .blue
                )
            }
        }
    }

    /// One modern descendant card with form, sound, and gloss context.
    private func formCard(
        title: String,
        form: String,
        readings: [CharacterReading],
        glosses: [String],
        accent: Color
    ) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(accent.opacity(0.16))

            HStack(alignment: .center, spacing: 12) {
                Text(form)
                    .font(.system(size: 48, weight: .regular, design: .serif))
                    .frame(width: 74, height: 74)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(accent.opacity(0.45), lineWidth: 1)
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text("Sound: \(readings.map { $0.value }.joined(separator: " / "))")
                        .font(.subheadline.weight(.semibold))
                    Text("Meaning: \(glosses.joined(separator: ", "))")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(10)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(accent.opacity(0.35), lineWidth: 1)
        )
    }
}
