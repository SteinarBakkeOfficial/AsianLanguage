import SwiftUI

/// Search entry point for character forms, English glosses, and readings.
struct SearchView: View {
    /// Search text entered by the learner.
    @State private var query = ""

    var body: some View {
        NavigationStack {
            PlaceholderScreen(
                title: "Search",
                message: "No results"
            )
            .searchable(text: $query, prompt: "Character, gloss, or reading")
            .navigationTitle("Search")
        }
    }
}
