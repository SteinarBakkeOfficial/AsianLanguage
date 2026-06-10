import Foundation

/// Container for app-wide services that need to be shared across SwiftUI screens.
/// Add concrete corpus and user-state stores here when Phase 3 begins.
struct AppDependencies {
    /// Human-readable corpus label used by the shell before runtime corpus metadata exists.
    let installedCorpusName: String

    /// Count of bundled Shared Character records available to the current app build.
    let installedSharedCharacterCount: Int

    /// Lightweight dependency set used by previews and the first app shell.
    static let preview = AppDependencies(
        installedCorpusName: "Draft V1 Corpus",
        installedSharedCharacterCount: 1
    )
}
