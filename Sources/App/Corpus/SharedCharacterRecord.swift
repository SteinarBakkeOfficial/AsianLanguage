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

    /// Editorial recognition takeaway shown in character detail and Home previews.
    let recognitionTakeaway: String

    /// Draft/review/published state used by validation and content tooling.
    let publicationStatus: String

    /// Optional editorial metadata kept alongside the lesson record for human review.
    let unicodeCodePoint: String?

    /// Optional alternate modern forms used by editorial and packaging tools.
    let simplifiedForm: String?
    let traditionalForm: String?
    let additionalMeanings: [String]?

    /// Optional pedagogical classification; absence means the formation is not yet classified.
    let formationType: SymbolFormationType?

    /// Editable image-composition guidance for educational reconstructions.
    let visualTeachingNotes: [String]?

    /// Stable references back to the human-editable content folder and documents.
    let contentFolder: String?
    let learnerCopyPath: String?
    let researchNotesPath: String?
    let reviewPath: String?

    /// Source conflicts remain explicit so generation cannot silently approve disagreement.
    let sourceConflicts: [SymbolSourceConflict]?

    /// Normalized editorial state; legacy publicationStatus remains source-compatible.
    let editorialStatus: SymbolEditorialStatus?

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

    /// Maps legacy publication values into the content workflow vocabulary.
    var normalizedEditorialStatus: SymbolEditorialStatus {
        editorialStatus ?? SymbolEditorialStatus.fromLegacy(publicationStatus)
    }
}

/// Pedagogical formation modes supported by the Symbol content workflow.
enum SymbolFormationType: String, Codable, Hashable {
    case pictograph
    case simpleIdeograph
    case compoundIdeograph
    case phonoSemantic
    case phoneticLoan
    case laterFormation
    case uncertain
}

/// Human review state for a Symbol record; generated content never defaults to approved.
enum SymbolEditorialStatus: String, Codable, Hashable {
    case draft
    case needsReview
    case approved
    case rejected
    case needsSources
    case needsArtwork
    case needsCopyEdit

    /// Keeps existing draft/review/published records readable during migration.
    static func fromLegacy(_ value: String) -> SymbolEditorialStatus {
        switch value.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() {
        case "review", "needsreview": return .needsReview
        case "published", "approved": return .approved
        case "rejected": return .rejected
        default: return .draft
        }
    }
}

/// A documented disagreement between source-backed claims.
struct SymbolSourceConflict: Decodable, Hashable {
    let topic: String
    let claims: [SourceConflictClaim]
    let requiresHumanReview: Bool
}

/// One source's claim within an explicit Symbol conflict.
struct SourceConflictClaim: Decodable, Hashable {
    let sourceID: String
    let claim: String

    private enum CodingKeys: String, CodingKey {
        case sourceID = "source"
        case claim
    }
}

/// Distinguishes evidence from educational reconstruction in asset metadata.
enum HistoricalAssetContentClass: String, Codable, Hashable {
    case historicalEvidence
    case educationalReconstruction
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

    /// Explicit modern alternatives, such as a kana or Hangul presentation.
    let variants: [ModernFormVariant]

    private enum CodingKeys: String, CodingKey {
        case form, readings, glosses, examples, variants
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        form = try container.decode(String.self, forKey: .form)
        readings = try container.decode([CharacterReading].self, forKey: .readings)
        glosses = try container.decode([String].self, forKey: .glosses)
        examples = try container.decode([UsageExample].self, forKey: .examples)
        variants = try container.decodeIfPresent([ModernFormVariant].self, forKey: .variants) ?? []
    }
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

    /// Optional region-specific readings; absent in older draft records.
    let taiwanReadings: [CharacterReading]

    /// Optional region-specific readings; absent in older draft records.
    let hongKongReadings: [CharacterReading]

    /// Explicit modern alternatives for regional written usage.
    let variants: [ModernFormVariant]

    private enum CodingKeys: String, CodingKey {
        case form, readings, glosses, taiwanExamples, hongKongExamples
        case taiwanReadings, hongKongReadings, variants
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        form = try container.decode(String.self, forKey: .form)
        readings = try container.decode([CharacterReading].self, forKey: .readings)
        glosses = try container.decode([String].self, forKey: .glosses)
        taiwanExamples = try container.decode([UsageExample].self, forKey: .taiwanExamples)
        hongKongExamples = try container.decode([UsageExample].self, forKey: .hongKongExamples)
        taiwanReadings = try container.decodeIfPresent([CharacterReading].self, forKey: .taiwanReadings) ?? []
        hongKongReadings = try container.decodeIfPresent([CharacterReading].self, forKey: .hongKongReadings) ?? []
        variants = try container.decodeIfPresent([ModernFormVariant].self, forKey: .variants) ?? []
    }
}

/// One explicit modern form or writing-system alternative within a focus track.
struct ModernFormVariant: Decodable, Hashable {
    let id: String
    let form: String
    let writingSystem: String?
    let readings: [CharacterReading]
    let notes: [String]
    let examples: [UsageExample]
}

/// Reading attached to a focus-track form or example.
struct CharacterReading: Decodable, Hashable {
    /// Reading system label, such as pinyin, on, kun, hangul, or rr.
    let system: String

    /// Reading value in the named system.
    let value: String

    /// Optional future pronunciation asset; absence is a normal unavailable state.
    let audioAssetRef: String?

    private enum CodingKeys: String, CodingKey { case system, value, audioAssetRef }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        system = try container.decode(String.self, forKey: .system)
        value = try container.decode(String.self, forKey: .value)
        audioAssetRef = try container.decodeIfPresent(String.self, forKey: .audioAssetRef)
    }
}

/// Editorial confidence vocabulary; missing assets remain a separate availability concern.
enum EditorialConfidence: String, Codable, Hashable {
    case supported
    case qualified
    case disputed
    case missing

    /// Maps legacy draft certainty labels into the published confidence vocabulary.
    static func fromLegacy(_ value: String) -> EditorialConfidence {
        switch value.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() {
        case "high", "supported", "strongly supported": return .supported
        case "disputed": return .disputed
        case "missing": return .missing
        default: return .qualified
        }
    }

    /// Human-readable label for calm scholarly metadata, not a warning badge.
    var displayName: String {
        switch self {
        case .supported: return "Strongly supported"
        case .qualified: return "Qualified interpretation"
        case .disputed: return "Disputed interpretation"
        case .missing: return "Evidence incomplete"
        }
    }
}

/// Separates a stage's editorial inclusion decision from its scholarly confidence.
enum HistoricalAvailabilityState: String, Codable, Hashable {
    case available
    case unavailableAsset
    case unsupportedStage
    case intentionallyOmitted
}

/// Presentation-facing reasons for content being unavailable or intentionally absent.
enum MissingContentKind: String, Codable, Hashable {
    case intentionallyOmitted
    case assetNotReady
    case unavailable
    case unresolvedReference
}

struct MissingContentState: Hashable {
    let kind: MissingContentKind
    let message: String
}

/// Editorial modern usage example retained for future word-level content review.
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
    /// Legacy duplicated stage map retained only for backward-compatible decoding.
    /// New content must use the asset metadata owned by each historical stage.
    let evolutionAssetRefs: [String: String]?

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

    /// Data-driven origin presentation; absent in older draft records.
    let origin: CharacterOrigin?
}

/// Content-driven origin presentation for the first Symbol Journey stage.
struct CharacterOrigin: Decodable, Hashable {
    let concept: String
    let explanation: String
    let asset: HistoricalAssetMetadata?
    let sourceIds: [String]
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

    /// Optional artifact or compiled visual metadata for this exact stage.
    let assetMetadata: HistoricalAssetMetadata?

    /// Components first visible or editorially meaningful at this stage.
    let introducedComponentIds: [String]?

    /// Symbol-specific explanation for this stage.
    let stageExplanation: String?

    /// Explicit content availability; legacy records infer this from their asset reference.
    let availabilityState: HistoricalAvailabilityState

    /// Normalized confidence used by UI without changing legacy JSON certainty values.
    var editorialConfidence: EditorialConfidence {
        EditorialConfidence.fromLegacy(certainty)
    }

    private enum CodingKeys: String, CodingKey {
        case stage, label, form, assetRef, changeNoteFromPrevious, certainty, sourceIds
        case historicalSound, assetMetadata, introducedComponentIds, stageExplanation
        case availabilityState
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        stage = try container.decode(String.self, forKey: .stage)
        label = try container.decode(String.self, forKey: .label)
        form = try container.decodeIfPresent(String.self, forKey: .form)
        assetRef = try container.decodeIfPresent(String.self, forKey: .assetRef)
        changeNoteFromPrevious = try container.decodeIfPresent(String.self, forKey: .changeNoteFromPrevious)
        certainty = try container.decode(String.self, forKey: .certainty)
        sourceIds = try container.decode([String].self, forKey: .sourceIds)
        historicalSound = try container.decodeIfPresent(String.self, forKey: .historicalSound)
        assetMetadata = try container.decodeIfPresent(HistoricalAssetMetadata.self, forKey: .assetMetadata)
        introducedComponentIds = try container.decodeIfPresent([String].self, forKey: .introducedComponentIds)
        stageExplanation = try container.decodeIfPresent(String.self, forKey: .stageExplanation)
        availabilityState = try container.decodeIfPresent(HistoricalAvailabilityState.self, forKey: .availabilityState)
            ?? ((assetRef == nil && assetMetadata == nil) ? .unavailableAsset : .available)
    }
}

/// Provenance and renderability metadata for a bundled historical or origin visual.
struct HistoricalAssetMetadata: Decodable, Hashable {
    /// Optional identity fields retained for source and review reports.
    let characterID: String?
    let historicalStage: String?
    let approximatePeriod: String?
    let sourceInstitution: String?
    let sourcePageURL: String?
    let sourceAssetURL: String?
    let catalogueReference: String?
    let sourceDescription: String?
    let retrievedAt: String?
    let contentClass: HistoricalAssetContentClass?

    let assetRef: String
    let artifactAssetRef: String?
    let assetKind: String
    let provenance: String?
    let licenseStatus: String?
    let accessibilityDescription: String?
    let readiness: String

    private enum CodingKeys: String, CodingKey {
        case characterID, historicalStage, approximatePeriod, sourceInstitution
        case sourcePageURL, sourceAssetURL, catalogueReference, sourceDescription
        case retrievedAt, contentClass
        case assetRef, artifactAssetRef, assetKind, provenance, licenseStatus, accessibilityDescription, readiness
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        characterID = try container.decodeIfPresent(String.self, forKey: .characterID)
        historicalStage = try container.decodeIfPresent(String.self, forKey: .historicalStage)
        approximatePeriod = try container.decodeIfPresent(String.self, forKey: .approximatePeriod)
        sourceInstitution = try container.decodeIfPresent(String.self, forKey: .sourceInstitution)
        sourcePageURL = try container.decodeIfPresent(String.self, forKey: .sourcePageURL)
        sourceAssetURL = try container.decodeIfPresent(String.self, forKey: .sourceAssetURL)
        catalogueReference = try container.decodeIfPresent(String.self, forKey: .catalogueReference)
        sourceDescription = try container.decodeIfPresent(String.self, forKey: .sourceDescription)
        retrievedAt = try container.decodeIfPresent(String.self, forKey: .retrievedAt)
        contentClass = try container.decodeIfPresent(HistoricalAssetContentClass.self, forKey: .contentClass)
        assetRef = try container.decode(String.self, forKey: .assetRef)
        artifactAssetRef = try container.decodeIfPresent(String.self, forKey: .artifactAssetRef)
        assetKind = try container.decode(String.self, forKey: .assetKind)
        provenance = try container.decodeIfPresent(String.self, forKey: .provenance)
        licenseStatus = try container.decodeIfPresent(String.self, forKey: .licenseStatus)
        accessibilityDescription = try container.decodeIfPresent(String.self, forKey: .accessibilityDescription)
        readiness = try container.decode(String.self, forKey: .readiness)
    }
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
    /// Stable identity used when the same component is discussed across stages.
    let id: String?

    /// Component label shown to the learner.
    let label: String

    /// Component role in the explanation.
    let role: String

    /// Short meaning hint, if editorially defensible.
    let meaningHint: String

    /// Component form when representable independently.
    let form: String?

    /// What the component is understood to depict.
    let depicts: String?

    /// First stage where the component becomes visible or meaningful.
    let introducedAtStage: String?

    /// Symbol-specific explanation for this component.
    let explanation: String?

    /// Sources supporting this component analysis.
    let sourceIds: [String]?
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
