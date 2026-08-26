import Foundation

/// Route information needed to open a Shared Character lesson.
struct LessonRoute: Hashable, Codable, Identifiable {
    /// Stable corpus identifier for the Shared Character lesson.
    let sharedCharacterID: String

    /// Optional exact position used for resume and Symbol Journey navigation.
    let startingPosition: SymbolJourneyPosition?

    var id: String {
        "\(sharedCharacterID):\(startingPosition?.section.rawValue ?? "default"):\(startingPosition?.stageID ?? "")"
    }

    init(sharedCharacterID: String, startingPosition: SymbolJourneyPosition? = nil) {
        self.sharedCharacterID = sharedCharacterID
        self.startingPosition = startingPosition
    }

    /// Backward-compatible route initializer for older callers and migrations.
    init(sharedCharacterID: String, startingStep: LessonStep?) {
        self.init(
            sharedCharacterID: sharedCharacterID,
            startingPosition: startingStep.map(SymbolJourneyPosition.fromLegacy)
        )
    }
}
