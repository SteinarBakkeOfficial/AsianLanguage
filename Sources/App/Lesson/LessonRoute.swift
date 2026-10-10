import Foundation

/// Describes how a finite symbol group returns to the surface that opened it.
enum SymbolSequenceReturn: String, Hashable, Codable {
    case browse
    case history
    case quickReview
}

/// Ordered source context used to keep Next Symbol inside the list the learner opened.
/// Change this model here when a new ordered discovery surface needs its own sequence.
struct SymbolSequence: Hashable, Codable, Identifiable {
    let id: String
    let title: String
    let recordIDs: [String]
    let returnDestination: SymbolSequenceReturn

    init(
        id: String,
        title: String,
        recordIDs: [String],
        returnDestination: SymbolSequenceReturn = .browse
    ) {
        self.id = id
        self.title = title
        self.recordIDs = recordIDs
        self.returnDestination = returnDestination
    }

    /// Returns the next item in this exact sequence, including learned items that remain
    /// members of status lists such as Favorites or Learned.
    func nextRecordID(after recordID: String) -> String? {
        guard let index = recordIDs.firstIndex(of: recordID) else { return nil }
        let nextIndex = index + 1
        guard recordIDs.indices.contains(nextIndex) else { return nil }
        return recordIDs[nextIndex]
    }
}

/// Route information needed to open a Shared Character lesson.
struct LessonRoute: Hashable, Codable, Identifiable {
    /// Stable corpus identifier for the Shared Character lesson.
    let sharedCharacterID: String

    /// Optional exact position used for resume and Symbol Journey navigation.
    let startingPosition: SymbolJourneyPosition?

    /// Optional ordered source context used by the Next Symbol action.
    let sequence: SymbolSequence?

    var id: String {
        "\(sharedCharacterID):\(startingPosition?.section.rawValue ?? "default"):\(startingPosition?.stageID ?? ""):\(sequence?.id ?? "default")"
    }

    init(
        sharedCharacterID: String,
        startingPosition: SymbolJourneyPosition? = nil,
        sequence: SymbolSequence? = nil
    ) {
        self.sharedCharacterID = sharedCharacterID
        self.startingPosition = startingPosition
        self.sequence = sequence
    }

    /// Backward-compatible route initializer for older callers and migrations.
    init(sharedCharacterID: String, startingStep: LessonStep?) {
        self.init(
            sharedCharacterID: sharedCharacterID,
            startingPosition: startingStep.map(SymbolJourneyPosition.fromLegacy),
            sequence: nil
        )
    }
}
