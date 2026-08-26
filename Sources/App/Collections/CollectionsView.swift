import SwiftUI

/// Structural collection model; progress is always derived from local user state.
struct SharedCharacterCollection: Identifiable, Hashable {
    enum CollectionType: String, Hashable {
        case editorial
        case system
    }

    let id: String
    let title: String
    let description: String?
    let sharedCharacterIDs: [String]
    let type: CollectionType
    let sourceIDs: [String]
}

/// Collections entry point for Browse-owned status lists and editorial sets.
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
                    ForEach(editorialCollections) { collection in
                        NavigationLink {
                            editorialCollection(collection)
                        } label: {
                            Label(collection.title, systemImage: "square.grid.2x2")
                        }
                    }
                }
            }
        .navigationTitle("Saved / Archive")
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

    private var editorialCollections: [SharedCharacterCollection] {
        [
            SharedCharacterCollection(id: "seed-path", title: "Source-Backed Seed Path", description: nil, sharedCharacterIDs: dependencies.sharedCharacters.map(\.id), type: .editorial, sourceIDs: []),
            SharedCharacterCollection(id: "pictographic-starters", title: "Pictographic Starters", description: nil, sharedCharacterIDs: dependencies.sharedCharacters.prefix(6).map(\.id), type: .editorial, sourceIDs: [])
        ]
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
                Button {
                    dependencies.navigationState.openSymbol(
                        LessonRoute(sharedCharacterID: record.id, startingPosition: nil)
                    )
                } label: {
                    collectionRecordRow(record)
                }
                .buttonStyle(.plain)
            }
        }
    }

    /// Editorial collection detail page for curated lesson sets.
    private func editorialCollection(_ collection: SharedCharacterCollection) -> some View {
        let records = collection.sharedCharacterIDs.compactMap { id in dependencies.sharedCharacters.first { $0.id == id } }
        List {
            Section(collection.title) {
                if records.isEmpty {
                    Text("No Shared Characters are available in this collection.")
                        .foregroundStyle(.secondary)
                }
                ForEach(records) { record in
                    Button {
                        dependencies.navigationState.openSymbol(
                            LessonRoute(sharedCharacterID: record.id, startingPosition: nil)
                        )
                    } label: {
                        collectionRecordRow(record)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .navigationTitle(collection.title)
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
