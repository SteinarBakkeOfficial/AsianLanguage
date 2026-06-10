import Foundation

/// Container for app-wide services that need to be shared across SwiftUI screens.
/// Add concrete corpus and user-state stores here when Phase 3 begins.
struct AppDependencies {
    /// Human-readable corpus label used by the shell before runtime corpus metadata exists.
    let installedCorpusName: String

    /// Count of bundled Shared Character records available to the current app build.
    let installedSharedCharacterCount: Int

    /// First featured Shared Character shown on Home until editorial sequencing is implemented.
    let nextFeaturedSharedCharacter: FeaturedSharedCharacterSummary

    /// Lightweight dependency set used by previews and the first app shell.
    static let preview = AppDependencies(
        installedCorpusName: "Draft V1 Corpus",
        installedSharedCharacterCount: 1,
        nextFeaturedSharedCharacter: FeaturedSharedCharacterSummary(
            id: "tree",
            displayForm: "木",
            primaryGloss: "Tree / wood",
            actionTitle: "New Symbol"
        )
    )
}

/// Lightweight Home card summary for the next featured Shared Character.
/// Replace this with decoded corpus metadata when the local data layer is implemented.
struct FeaturedSharedCharacterSummary: Hashable {
    /// Stable corpus identifier used by lesson routes.
    let id: String

    /// Main modern form displayed in the Home card.
    let displayForm: String

    /// Short English gloss shown below the form.
    let primaryGloss: String

    /// Primary call-to-action label, such as `New Symbol` or `Next Symbol`.
    let actionTitle: String
}
