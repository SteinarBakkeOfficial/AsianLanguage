import SwiftUI

/// Collections entry point for Review later, Favorites, and editorial sets.
struct CollectionsView: View {
    /// Shared app dependencies used for corpus and user-state collections.
    let dependencies: AppDependencies

    /// Local state store used for system collections.
    @ObservedObject private var userStateStore: LocalUserStateStore

    /// Creates Collections with observed access to local user state.
    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _userStateStore = ObservedObject(wrappedValue: dependencies.userStateStore)
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Your Collections") {
                    collectionRows(
                        title: "Review later",
                        systemImage: "clock",
                        records: reviewLaterRecords
                    )
                    collectionRows(
                        title: "Favorites",
                        systemImage: "star",
                        records: favoriteRecords
                    )
                }

                Section("Explore Collections") {
                    NavigationLink {
                        editorialCollection(title: "Source-Backed Seed Path", records: dependencies.sharedCharacters)
                    } label: {
                        Label("Source-Backed Seed Path", systemImage: "sparkles")
                    }
                    NavigationLink {
                        editorialCollection(title: "Pictographic Starters", records: dependencies.sharedCharacters.prefix(6).map { $0 })
                    } label: {
                        Label("Pictographic Starters", systemImage: "leaf")
                    }
                }
            }
            .navigationTitle("Saved / Archive")
            .navigationDestination(for: LessonRoute.self) { route in
                LessonView(route: route, dependencies: dependencies)
            }
        }
    }

    /// Records currently marked review-later.
    private var reviewLaterRecords: [SharedCharacterRecord] {
        dependencies.sharedCharacters.filter { record in
            userStateStore.state.lessonStates[record.id]?.isReviewLater == true
        }
    }

    /// Records currently marked as favorites.
    private var favoriteRecords: [SharedCharacterRecord] {
        dependencies.sharedCharacters.filter { record in
            userStateStore.state.lessonStates[record.id]?.isStarred == true
        }
    }

    /// Renders a system collection header plus any records in that collection.
    @ViewBuilder
    private func collectionRows(
        title: String,
        systemImage: String,
        records: [SharedCharacterRecord]
    ) -> some View {
        Label(title, systemImage: systemImage)
        if records.isEmpty {
            Text("No saved Shared Characters")
                .foregroundStyle(.secondary)
        } else {
            ForEach(records) { record in
                NavigationLink(value: LessonRoute(sharedCharacterID: record.id, startingStep: .origin)) {
                    collectionRecordRow(record)
                }
            }
        }
    }

    /// Editorial collection detail page for curated lesson sets.
    private func editorialCollection(title: String, records: [SharedCharacterRecord]) -> some View {
        List {
            Section(title) {
                ForEach(records) { record in
                    NavigationLink(value: LessonRoute(sharedCharacterID: record.id, startingStep: .origin)) {
                        collectionRecordRow(record)
                    }
                }
            }
        }
        .navigationTitle(title)
        .navigationDestination(for: LessonRoute.self) { route in
            LessonView(route: route, dependencies: dependencies)
        }
    }

    /// Shared collection row with symbol and meaning context.
    private func collectionRecordRow(_ record: SharedCharacterRecord) -> some View {
        HStack {
            Text(record.coreCharacter)
                .font(.system(size: 28, weight: .regular, design: .serif))
                .frame(width: 40)
            VStack(alignment: .leading, spacing: 2) {
                Text(record.coreSharedMeaning.capitalized)
                Text(userStateStore.state.lessonStates[record.id]?.progressStatus.rawValue ?? LessonProgressStatus.unseen.rawValue)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
