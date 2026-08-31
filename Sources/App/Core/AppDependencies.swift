import Combine
import Foundation

/// Container for app-wide services that need to be shared across SwiftUI screens.
struct AppDependencies {
    /// Read-only repository for bundled Shared Character records.
    let corpusRepository: BundleCorpusRepository

    /// Local writable store for progress and preferences.
    let userStateStore: LocalUserStateStore

    /// Shared root navigation state so every entry point opens the canonical Symbol destination.
    let navigationState: AppNavigationState

    /// Bundled Shared Character records available to discovery surfaces.
    let sharedCharacters: [SharedCharacterRecord]

    /// Human-readable corpus loading failure shown instead of silently dropping records.
    let corpusLoadError: String?

    /// Human-readable corpus label used by the shell before runtime corpus metadata exists.
    let installedCorpusName: String

    /// Count of bundled Shared Character records available to the current app build.
    let installedSharedCharacterCount: Int

    /// First featured Shared Character shown on Home until editorial sequencing is implemented.
    let nextFeaturedSharedCharacter: FeaturedSharedCharacterSummary

    /// Returns the next Shared Character after the current lesson in editorial teaching order.
    func nextSharedCharacter(after sharedCharacterID: String) -> SharedCharacterRecord? {
        guard let currentIndex = sharedCharacters.firstIndex(where: { $0.id == sharedCharacterID }) else {
            return sharedCharacters.first {
                userStateStore.state.lessonStates[$0.id]?.progressStatus != .learned
            }
        }

        return sharedCharacters[(currentIndex + 1)...].first { record in
            userStateStore.state.lessonStates[record.id]?.progressStatus != .learned
        }
    }

    /// Returns the next locally saved review item without making the corpus depend on user state.
    func nextReviewLater(after sharedCharacterID: String) -> SharedCharacterRecord? {
        sharedCharacters.first { record in
            record.id != sharedCharacterID
                && userStateStore.state.lessonStates[record.id]?.isReviewLater == true
        }
    }

    /// Runtime dependency set used by the app shell.
    static let live: AppDependencies = {
        let repository = BundleCorpusRepository()
        let fallbackSummary = FeaturedSharedCharacterSummary(
            id: "fire",
            displayForm: "火",
            primaryGloss: "Fire",
            actionTitle: "New Symbol"
        )

        let sharedCharacters: [SharedCharacterRecord]
        let corpusLoadError: String?
        do {
            sharedCharacters = try repository.sharedCharacters(ids: SeedCorpusManifest.recordIDs)
            corpusLoadError = nil
        } catch {
            sharedCharacters = []
            corpusLoadError = "The bundled corpus could not be loaded: \(error.localizedDescription)"
        }
        let featuredRecord = sharedCharacters.first
        let featuredSummary = featuredRecord?.featuredSummary ?? fallbackSummary

        return AppDependencies(
            corpusRepository: repository,
            userStateStore: LocalUserStateStore.live(),
            navigationState: AppNavigationState(),
            sharedCharacters: sharedCharacters,
            corpusLoadError: corpusLoadError,
            installedCorpusName: "Draft V1 Corpus",
            installedSharedCharacterCount: sharedCharacters.count,
            nextFeaturedSharedCharacter: featuredSummary
        )
    }()

    /// Lightweight dependency set used by previews and the first app shell.
    static let preview = AppDependencies(
        corpusRepository: BundleCorpusRepository(),
        userStateStore: LocalUserStateStore.preview(),
        navigationState: AppNavigationState(),
        sharedCharacters: [],
        corpusLoadError: nil,
        installedCorpusName: "Draft V1 Corpus",
        installedSharedCharacterCount: 1,
        nextFeaturedSharedCharacter: FeaturedSharedCharacterSummary(
            id: "fire",
            displayForm: "火",
            primaryGloss: "Fire",
            actionTitle: "New Symbol"
        )
    )
}

/// Shared root navigation state used by Home, Browse, Search, and Collections.
final class AppNavigationState: ObservableObject {
    @Published var selectedTab: AppTab = .home
    /// The Symbol currently selected by the learner, which may differ from Home's active journey.
    @Published var selectedSymbolID: String?
    /// Explicit opening intent consumed by the canonical Symbol root.
    @Published var symbolOpenIntent: SymbolOpenIntent?
    @Published var symbolRoute: LessonRoute?

    /// Opens every Shared Character through the one canonical Symbol root.
    func openSymbol(_ symbolID: String, intent: SymbolOpenIntent = .view) {
        selectedSymbolID = symbolID
        symbolOpenIntent = intent
        symbolRoute = LessonRoute(sharedCharacterID: symbolID, startingPosition: intent.startingPosition)
        selectedTab = .symbol
    }

    /// Compatibility adapter for existing callers while routes migrate to the shared router API.
    func openSymbol(_ route: LessonRoute) {
        selectedSymbolID = route.sharedCharacterID
        symbolOpenIntent = route.startingPosition.map { .stage($0.stageID ?? "origin") } ?? .view
        symbolRoute = route
        selectedTab = .symbol
    }
}

/// Semantic reason a discovery surface opened a Shared Character.
enum SymbolOpenIntent: Hashable {
    case start
    case resume
    case view
    case review
    case stage(String)

    var startingPosition: SymbolJourneyPosition? {
        switch self {
        case .start: return .origin
        case .resume, .review: return nil
        case .view: return .origin
        case .stage(let stageID): return SymbolJourneyPosition(section: .evolution, stageID: stageID)
        }
    }
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
