import Foundation

/// Read-only bundled corpus record for one V1 Shared Character lesson.
struct SharedCharacterRecord: Decodable, Identifiable, Hashable {
    /// Stable corpus identifier used by routes, user state, and bundled resources.
    let id: String

    /// Schema/content version for this specific record.
    let version: Int

    /// Canonical underlying character label for editorial and display use.
    let coreCharacter: String

    /// One teachable overlapping meaning across all required focus tracks.
    let coreSharedMeaning: String

    /// Editorial recognition takeaway shown in lesson summary and Home previews.
    let recognitionTakeaway: String

    /// Draft/review/published state used by validation and content tooling.
    let publicationStatus: String

    /// Editorial teaching order; low values are shown earlier.
    let teachingSequence: Int

    /// Required modern coverage across Simplified Chinese, Traditional Chinese, Japanese, and Korean.
    let focusCoverage: FocusCoverage

    /// Visual assets used by history and lesson presentation.
    let visuals: SharedCharacterVisuals

    /// Historical origin anchor and displayed script stages.
    let history: CharacterHistory

    /// Component or character-structure explanation.
    let structure: CharacterStructure

    /// Modern usage framing for the lesson.
    let usage: UsageSummary

    /// Lightweight source notes backing editorial claims.
    let sources: [CorpusSource]

    /// Editorial caveats that remain available to source/notes UI.
    let notes: [String]

    /// Small Home-card adapter for the next featured Shared Character.
    var featuredSummary: FeaturedSharedCharacterSummary {
        FeaturedSharedCharacterSummary(
            id: id,
            displayForm: coreCharacter,
            primaryGloss: coreSharedMeaning.capitalized,
            actionTitle: "New Symbol"
        )
    }
}

/// Required modern focus-track coverage for a Shared Character record.
struct FocusCoverage: Decodable, Hashable {
    /// Modern Simplified Chinese form, readings, glosses, and examples.
    let simplifiedChinese: StandardFocusCoverage

    /// Modern Traditional Chinese form, readings, glosses, and regional examples.
    let traditionalChinese: TraditionalChineseCoverage

    /// Modern Japanese Kanji form, readings, glosses, and examples.
    let japanese: StandardFocusCoverage

    /// Modern Korean Hanja form, readings, glosses, and examples.
    let korean: StandardFocusCoverage
}

/// Common coverage shape for focus tracks with one example list.
struct StandardFocusCoverage: Decodable, Hashable {
    /// Modern display form for this focus track.
    let form: String

    /// Modern readings relevant to this focus track.
    let readings: [CharacterReading]

    /// English glosses for this focus track.
    let glosses: [String]

    /// At least two examples, including one direct core-meaning example.
    let examples: [UsageExample]
}

/// Traditional Chinese coverage with separate Taiwan and Hong Kong example sets.
struct TraditionalChineseCoverage: Decodable, Hashable {
    /// Modern Traditional Chinese display form.
    let form: String

    /// Modern readings for Traditional Chinese usage.
    let readings: [CharacterReading]

    /// English glosses for this focus track.
    let glosses: [String]

    /// Taiwan usage examples shown when Traditional Chinese is selected.
    let taiwanExamples: [UsageExample]

    /// Hong Kong usage examples shown when Traditional Chinese is selected.
    let hongKongExamples: [UsageExample]
}

/// Reading attached to a focus-track form or example.
struct CharacterReading: Decodable, Hashable {
    /// Reading system label, such as pinyin, on, kun, hangul, or rr.
    let system: String

    /// Reading value in the named system.
    let value: String
}

/// Modern usage example shown in the Usage lesson step.
struct UsageExample: Decodable, Hashable {
    /// Example text in the relevant writing system.
    let text: String

    /// Optional reading for learner support.
    let reading: String?

    /// English translation of the example.
    let translation: String

    /// Whether this example directly shows the core shared meaning.
    let showsCoreMeaning: Bool

    /// Learning level for progressive examples: word, phrase, or sentence.
    let exampleLevel: UsageExampleLevel

    /// Optional group id linking parallel examples across focus tracks.
    let parallelExampleGroupID: String?

    /// Previously learned symbols reused by this example.
    let reusesKnownSymbols: [String]

    /// Symbols introduced by this example.
    let introducedSymbols: [String]
}

/// Progressive example level for teaching sequence and lesson usage display.
enum UsageExampleLevel: String, Decodable, Hashable {
    case word
    case phrase
    case sentence
}

/// Visual asset metadata for one Shared Character.
struct SharedCharacterVisuals: Decodable, Hashable {
    /// Draft or source-backed asset references keyed by displayed stage.
    let evolutionAssetRefs: [String: String]

    /// Whether the current assets are draft or publication-ready.
    let assetStatus: String

    /// Editorial note describing visual provenance and replacement needs.
    let note: String
}

/// Historical origin anchor and displayed stages.
struct CharacterHistory: Decodable, Hashable {
    /// Short source-backed origin statement.
    let originAnchor: String

    /// Editorially chosen displayed script stages.
    let stages: [HistoricalStage]
}

/// One displayed historical stage in the evolution framework.
struct HistoricalStage: Decodable, Hashable {
    /// Machine-readable stage identifier from the canonical history spine.
    let stage: String

    /// User-facing stage label.
    let label: String

    /// Text form when Unicode can represent it responsibly.
    let form: String?

    /// Optional app-native visual asset reference.
    let assetRef: String?

    /// Required for every displayed stage after the first.
    let changeNoteFromPrevious: String?

    /// Editorial certainty label for this stage.
    let certainty: String

    /// Source identifiers supporting the stage.
    let sourceIds: [String]

    /// Optional sourced historical sound label.
    let historicalSound: String?
}

/// Character/component structure explanation.
struct CharacterStructure: Decodable, Hashable {
    /// User-facing structure explanation.
    let summary: String

    /// Displayed component list when useful.
    let components: [StructureComponent]

    /// Editorial certainty label for the structure explanation.
    let certainty: String

    /// Required when certainty is not high.
    let caveat: String?

    /// Source identifiers supporting the structure explanation.
    let sourceIds: [String]
}

/// One displayed structure component.
struct StructureComponent: Decodable, Hashable {
    /// Component label shown to the learner.
    let label: String

    /// Component role in the explanation.
    let role: String

    /// Short meaning hint, if editorially defensible.
    let meaningHint: String
}

/// Modern usage framing outside individual examples.
struct UsageSummary: Decodable, Hashable {
    /// Core shared-meaning framing shown before focus-track examples.
    let coreMeaningFirst: String

    /// Additional editorial usage notes.
    let notes: [String]
}

/// Lightweight source metadata attached to a corpus record.
struct CorpusSource: Decodable, Hashable {
    /// Stable source identifier referenced by record sections.
    let id: String

    /// Human-readable source label.
    let label: String

    /// Source type used by app-facing notes.
    let type: String

    /// Citation or editorial replacement note.
    let citation: String

    /// Optional web URL for source-backed records; internal prototype sources may omit it.
    let url: String?
}
