import SwiftUI

/// Search entry point for character forms, English glosses, and readings.
struct SearchView: View {
    /// Shared app dependencies used for offline corpus search.
    let dependencies: AppDependencies

    /// Search text entered by the learner.
    @State private var query = ""

    /// Local in-memory index for the installed bundled corpus.
    private var searchIndex: SharedCharacterSearchIndex {
        SharedCharacterSearchIndex(records: dependencies.sharedCharacters)
    }

    /// Search results matching the current query.
    private var searchResults: [SharedCharacterRecord] {
        searchIndex.search(query)
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Results") {
                    if searchResults.isEmpty {
                        Text("No results")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(searchResults) { record in
                            NavigationLink(value: LessonRoute(sharedCharacterID: record.id, startingStep: .origin)) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(record.coreCharacter)
                                        .font(.title2)
                                    Text(record.coreSharedMeaning.capitalized)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
            }
            .searchable(text: $query, prompt: "Character, gloss, or reading")
            .navigationTitle("Search")
            .navigationDestination(for: LessonRoute.self) { route in
                LessonView(route: route, dependencies: dependencies)
            }
        }
    }
}
