import Foundation

/// Container for app-wide services that need to be shared across SwiftUI screens.
struct AppDependencies {
    /// Read-only repository for bundled Shared Character records.
    let corpusRepository: BundleCorpusRepository

    /// Local writable store for progress and preferences.
    let userStateStore: LocalUserStateStore

    /// Bundled Shared Character records available to discovery surfaces.
    let sharedCharacters: [SharedCharacterRecord]

    /// Human-readable corpus label used by the shell before runtime corpus metadata exists.
    let installedCorpusName: String

    /// Count of bundled Shared Character records available to the current app build.
    let installedSharedCharacterCount: Int

    /// First featured Shared Character shown on Home until editorial sequencing is implemented.
    let nextFeaturedSharedCharacter: FeaturedSharedCharacterSummary

    /// Runtime dependency set used by the app shell.
    static let live: AppDependencies = {
        let repository = BundleCorpusRepository()
        let fallbackSummary = FeaturedSharedCharacterSummary(
            id: "tree",
            displayForm: "木",
            primaryGloss: "Tree / wood",
            actionTitle: "New Symbol"
        )

        let sharedCharacters = repository.sharedCharacters(ids: PrototypeCorpusManifest.recordIDs)
        let featuredRecord = sharedCharacters.first
        let featuredSummary = featuredRecord?.featuredSummary ?? fallbackSummary

        return AppDependencies(
            corpusRepository: repository,
            userStateStore: LocalUserStateStore.live(),
            sharedCharacters: sharedCharacters,
            installedCorpusName: "Draft V1 Corpus",
            installedSharedCharacterCount: sharedCharacters.count,
            nextFeaturedSharedCharacter: featuredSummary
        )
    }()

    /// Lightweight dependency set used by previews and the first app shell.
    static let preview = AppDependencies(
        corpusRepository: BundleCorpusRepository(),
        userStateStore: LocalUserStateStore.preview(),
        sharedCharacters: [],
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
