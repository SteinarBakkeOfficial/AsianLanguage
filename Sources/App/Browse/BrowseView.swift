import SwiftUI

/// Browse entry point for shallow curated discovery.
struct BrowseView: View {
    /// Shared app dependencies used for bundled corpus browsing.
    let dependencies: AppDependencies

    /// Local state store used for progress labels in Browse.
    @ObservedObject private var userStateStore: LocalUserStateStore

    /// Creates Browse with observed access to local user state.
    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _userStateStore = ObservedObject(wrappedValue: dependencies.userStateStore)
    }

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
                        Section("Featured Path") {
                            ForEach(dependencies.sharedCharacters) { record in
                                NavigationLink(value: LessonRoute(sharedCharacterID: record.id, startingStep: .origin)) {
                                    browseRow(record)
                                }
                            }
                        }

                        Section("Browse Method") {
                            Text("Browse is intentionally shallow in V1: it follows the editorial teaching sequence and opens directly into Shared Character lessons.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
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

    /// Curated browse row with progress and recognition context.
    private func browseRow(_ record: SharedCharacterRecord) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(record.coreCharacter)
                .font(.system(size: 34, weight: .regular, design: .serif))
                .frame(width: 48)

            VStack(alignment: .leading, spacing: 4) {
                Text(record.coreSharedMeaning.capitalized)
                    .font(.headline)
                Text(record.recognitionTakeaway)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                Text(statusTitle(for: record))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }

    /// Local progress label for a record.
    private func statusTitle(for record: SharedCharacterRecord) -> String {
        userStateStore.state.lessonStates[record.id]?.progressStatus.rawValue ?? LessonProgressStatus.unseen.rawValue
    }
}
