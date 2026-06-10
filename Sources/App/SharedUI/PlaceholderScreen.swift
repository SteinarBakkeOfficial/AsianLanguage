import SwiftUI

/// Shared placeholder used while Phase 2 establishes navigation before full feature screens exist.
struct PlaceholderScreen: View {
    /// Main placeholder title.
    let title: String

    /// Short implementation note for the current placeholder state.
    let message: String

    var body: some View {
        ContentUnavailableView(
            title,
            systemImage: "rectangle.and.pencil.and.ellipsis",
            description: Text(message)
        )
    }
}
