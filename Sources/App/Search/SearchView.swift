import SwiftUI

/// Search entry point for character forms, English glosses, and readings.
struct SearchView: View {
    /// Shared app dependencies used for offline corpus search.
    let dependencies: AppDependencies

    /// Local state store used to show progress context in results.
    @ObservedObject private var userStateStore: LocalUserStateStore

    /// Search text entered by the learner.
    @State private var query = ""

    /// Creates Search with observed access to local progress badges.
    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _userStateStore = ObservedObject(wrappedValue: dependencies.userStateStore)
    }

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
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    Text("Search")
                        .font(.largeTitle.weight(.bold))
                    Text("Find a symbol by form, meaning, or sound, then open its evolution board.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    if searchResults.isEmpty {
                        ContentUnavailableView(
                            query.isEmpty ? "Search Shared Characters" : "No results",
                            systemImage: "magnifyingglass",
                            description: Text("Search by character form, English meaning, or Mandarin, Japanese, and Korean readings.")
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.top, 40)
                    } else {
                        ForEach(searchResults) { record in
                            NavigationLink(value: LessonRoute(sharedCharacterID: record.id, startingStep: .origin)) {
                                resultRow(record)
                            }
                        }
                    }
                }
                .padding()
            }
            .searchable(text: $query, prompt: "Character, gloss, or reading")
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: LessonRoute.self) { route in
                LessonView(route: route, dependencies: dependencies)
            }
        }
    }

    /// Search result row with enough context to avoid a raw catalog feel.
    private func resultRow(_ record: SharedCharacterRecord) -> some View {
        HStack(alignment: .center, spacing: 12) {
            SymbolPictogramView(recordID: record.id, fallbackCharacter: record.coreCharacter)
                .frame(width: 82, height: 82)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(record.coreCharacter)
                        .font(.system(size: 40, weight: .regular, design: .serif))
                    Text(statusTitle(for: record))
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Color.green)
                }
                Text(record.coreSharedMeaning.capitalized)
                    .font(.headline)
                Text(readingSummary(for: record))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "arrow.right.circle.fill")
                .foregroundStyle(Color.green)
        }
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.green.opacity(0.22), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    /// Compact reading summary for quick recognition while browsing results.
    private func readingSummary(for record: SharedCharacterRecord) -> String {
        let mandarin = record.focusCoverage.simplifiedChinese.readings.first?.value
        let japanese = record.focusCoverage.japanese.readings.first?.value
        let korean = record.focusCoverage.korean.readings.first?.value
        return [mandarin, japanese, korean].compactMap { $0 }.joined(separator: " / ")
    }

    /// Local progress label for a record.
    private func statusTitle(for record: SharedCharacterRecord) -> String {
        userStateStore.state.lessonStates[record.id]?.progressStatus.rawValue ?? LessonProgressStatus.unseen.rawValue
    }
}
