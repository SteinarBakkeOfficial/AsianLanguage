import SwiftUI

/// Browse entry point for shallow curated discovery.
struct BrowseView: View {
    /// Shared app dependencies used for bundled corpus browsing.
    let dependencies: AppDependencies

    var body: some View {
        NavigationStack {
            Group {
                if dependencies.sharedCharacters.isEmpty {
                    ContentUnavailableView(
                        "No Shared Characters",
                        systemImage: "square.grid.2x2",
                        description: Text("The bundled corpus is empty.")
                    )
                } else {
                    List {
                        Section("Shared Characters") {
                            ForEach(dependencies.sharedCharacters) { record in
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
            }
            .navigationTitle("Browse")
            .navigationDestination(for: LessonRoute.self) { route in
                LessonView(route: route, dependencies: dependencies)
            }
        }
    }
}
