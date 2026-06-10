import SwiftUI

/// Browse entry point for shallow curated discovery.
struct BrowseView: View {
    var body: some View {
        NavigationStack {
            PlaceholderScreen(
                title: "Browse",
                message: "No Shared Characters"
            )
            .navigationTitle("Browse")
        }
    }
}
