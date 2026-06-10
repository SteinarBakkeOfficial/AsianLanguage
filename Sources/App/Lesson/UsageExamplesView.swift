import SwiftUI

/// Progressive word and sentence examples across the required focus tracks.
struct UsageExamplesView: View {
    /// Bundled record for the current lesson.
    let record: SharedCharacterRecord

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(record.usage.coreMeaningFirst)
                .font(.subheadline)

            exampleGroup("Simplified Chinese", examples: record.focusCoverage.simplifiedChinese.examples)
            exampleGroup("Traditional Chinese - Taiwan", examples: record.focusCoverage.traditionalChinese.taiwanExamples)
            exampleGroup("Traditional Chinese - Hong Kong", examples: record.focusCoverage.traditionalChinese.hongKongExamples)
            exampleGroup("Japanese", examples: record.focusCoverage.japanese.examples)
            exampleGroup("Korean", examples: record.focusCoverage.korean.examples)
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
