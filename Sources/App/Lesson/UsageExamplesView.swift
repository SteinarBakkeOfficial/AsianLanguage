import SwiftUI

/// Progressive word and sentence examples across the required focus tracks.
struct UsageExamplesView: View {
    /// Bundled record for the current lesson.
    let record: SharedCharacterRecord

    /// Focus tracks currently enabled by the learner.
    let focusSelection: FocusTrackSelection

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(record.usage.coreMeaningFirst)
                .font(.subheadline)

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
                .font(.headline)

            ForEach(examples, id: \.self) { example in
                VStack(alignment: .leading, spacing: 2) {
                    Text(example.text)
                    Text(example.exampleLevel.rawValue.capitalized)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(example.translation)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    if !example.reusesKnownSymbols.isEmpty {
                        Text("Reuses: \(example.reusesKnownSymbols.joined(separator: ", "))")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 2)
            }
        }
    }
}
