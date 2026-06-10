import Foundation

/// Route information needed to open a Shared Character lesson.
struct LessonRoute: Hashable, Codable {
    /// Stable corpus identifier for the Shared Character lesson.
    let sharedCharacterID: String

    /// Optional step override used for resume and progress-bar navigation.
    let startingStep: LessonStep?
}
