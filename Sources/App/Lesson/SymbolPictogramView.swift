import SwiftUI

/// Explicit placeholder retained for list surfaces until origin assets are data-driven.
/// It never presents a modern character or fabricated drawing as a historical form.
struct SymbolPictogramView: View {
    let recordID: String
    let fallbackCharacter: String

    var body: some View {
        ContentUnavailableView(
            "Origin visual unavailable",
            systemImage: "photo",
            description: Text("Source-backed origin artwork is not bundled for this draft symbol.")
        )
        .accessibilityLabel("Origin visual unavailable for \(recordID)")
    }
}
