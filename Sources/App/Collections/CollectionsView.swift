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
                    ForEach(dependencies.sharedCharacters) { record in
                        NavigationLink(value: LessonRoute(sharedCharacterID: record.id, startingStep: .origin)) {
                            Label(record.coreCharacter, systemImage: "sparkles")
                        }
                    }
                }
            }
            .navigationTitle("Collections")
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
                    Text(record.coreCharacter)
                }
            }
        }
    }
}
