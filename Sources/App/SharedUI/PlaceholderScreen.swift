import SwiftUI

/// Shared placeholder used while Phase 2 establishes navigation before full feature screens exist.
struct PlaceholderScreen: View {
    /// Main placeholder title.
    let title: String

    /// Short implementation note for the current placeholder state.
    let message: String

    /// SF Symbol used to identify the reserved app concept.
    var systemImageName: String = "rectangle.and.pencil.and.ellipsis"

    var body: some View {
        ContentUnavailableView(
            title,
            systemImage: systemImageName,
            description: Text(message)
        )
    }
}
