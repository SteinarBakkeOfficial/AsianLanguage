import Foundation

/// In-memory exact and partial search over bundled Shared Character records.
struct SharedCharacterSearchIndex {
    /// Records available in the installed offline corpus.
    let records: [SharedCharacterRecord]

    /// Returns records matching character forms, English glosses, or language readings.
    func search(_ query: String) -> [SharedCharacterRecord] {
        let normalizedQuery = Self.normalize(query)
        guard !normalizedQuery.isEmpty else {
            return []
        }

        return records
            .map { record in
                (record: record, score: score(record: record, normalizedQuery: normalizedQuery))
            }
            .filter { $0.score > 0 }
            .sorted {
                if $0.score == $1.score {
                    return $0.record.coreCharacter < $1.record.coreCharacter
                }
                return $0.score > $1.score
            }
            .map(\.record)
    }

    /// Normalizes user input and indexed text for practical V1 matching.
    private static func normalize(_ value: String) -> String {
        value
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .folding(options: [.caseInsensitive, .diacriticInsensitive], locale: .current)
            .lowercased()
    }

    /// Scores exact matches ahead of partial matches while keeping ranking simple.
    private func score(record: SharedCharacterRecord, normalizedQuery: String) -> Int {
        let fields = searchableFields(for: record)
        if fields.contains(normalizedQuery) {
            return 100
        }
        if fields.contains(where: { $0.contains(normalizedQuery) }) {
            return 50
        }
        return 0
    }

    /// Extracts the searchable fields required by the V1 discovery decision.
    private func searchableFields(for record: SharedCharacterRecord) -> [String] {
        var fields = [
            record.coreCharacter,
            record.coreSharedMeaning,
            record.recognitionTakeaway,
            record.focusCoverage.simplifiedChinese.form,
            record.focusCoverage.traditionalChinese.form,
            record.focusCoverage.japanese.form,
            record.focusCoverage.korean.form
        ]

        fields.append(contentsOf: record.focusCoverage.simplifiedChinese.glosses)
        fields.append(contentsOf: record.focusCoverage.traditionalChinese.glosses)
        fields.append(contentsOf: record.focusCoverage.japanese.glosses)
        fields.append(contentsOf: record.focusCoverage.korean.glosses)
        fields.append(contentsOf: record.focusCoverage.simplifiedChinese.readings.map(\.value))
        fields.append(contentsOf: record.focusCoverage.traditionalChinese.readings.map(\.value))
        fields.append(contentsOf: record.focusCoverage.japanese.readings.map(\.value))
        fields.append(contentsOf: record.focusCoverage.korean.readings.map(\.value))
        fields.append(contentsOf: record.focusCoverage.simplifiedChinese.examples.flatMap { [$0.text, $0.translation] })
        fields.append(contentsOf: record.focusCoverage.traditionalChinese.taiwanExamples.flatMap { [$0.text, $0.translation] })
        fields.append(contentsOf: record.focusCoverage.traditionalChinese.hongKongExamples.flatMap { [$0.text, $0.translation] })
        fields.append(contentsOf: record.focusCoverage.japanese.examples.flatMap { [$0.text, $0.translation] })
        fields.append(contentsOf: record.focusCoverage.korean.examples.flatMap { [$0.text, $0.translation] })

        return fields.map(Self.normalize)
    }
}
