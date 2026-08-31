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
    // Compatibility vocabulary: the product state remains known as Review later internally.
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
            Section("Your Library") {
                collectionRows(title: "Learned", systemImage: "checkmark.circle", records: learnedRecords)
                collectionRows(title: "Favorites", systemImage: "star", records: favoriteRecords)
                collectionRows(title: "Review Later", systemImage: "clock", records: reviewLaterRecords)
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
        .navigationTitle("Collections")
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(AppColors.appBackground.ignoresSafeArea())
        .tint(AppColors.accentPrimary)
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

    private var learnedRecords: [SharedCharacterRecord] {
        dependencies.sharedCharacters.filter { record in
            userStateStore.state.lessonStates[record.id]?.progressStatus == .learned
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
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.textSecondary)
        } else {
            ForEach(records) { record in
                CharacterTile(
                    record: record,
                    userState: userStateStore.state.lessonStates[record.id],
                    action: { dependencies.navigationState.openSymbol(record.id, intent: symbolIntent(for: title)) }
                )
            }
        }
    }

    private func symbolIntent(for collectionTitle: String) -> SymbolOpenIntent {
        collectionTitle == "Learned" ? .reviewFromBrowse : .view
    }

    /// Editorial collection detail page for curated lesson sets.
    private func editorialCollection(_ collection: SharedCharacterCollection) -> some View {
        let records = collection.sharedCharacterIDs.compactMap { id in dependencies.sharedCharacters.first { $0.id == id } }
        return List {
            Section(collection.title) {
                if records.isEmpty {
                    Text("No Shared Characters are available in this collection.")
                        .font(AppTypography.body)
                        .foregroundStyle(AppColors.textSecondary)
                }
                ForEach(records) { record in
                    CharacterTile(
                        record: record,
                        userState: userStateStore.state.lessonStates[record.id],
                        action: { dependencies.navigationState.openSymbol(record.id, intent: .view) }
                    )
                }
            }
        }
        .navigationTitle(collection.title)
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(AppColors.appBackground.ignoresSafeArea())
    }

}
