import SwiftUI

/// Collections entry point for Review later, Favorites, and editorial sets.
struct CollectionsView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Your Collections") {
                    Label("Review later", systemImage: "clock")
                    Label("Favorites", systemImage: "star")
                }

                Section("Explore Collections") {
                    Label("Featured Shared Characters", systemImage: "sparkles")
                }
            }
            .navigationTitle("Collections")
        }
    }
}
