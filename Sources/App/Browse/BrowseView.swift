import SwiftUI

/// Editorial discovery library; retrieval states live here rather than in root navigation.
struct BrowseView: View {
    let dependencies: AppDependencies
    @ObservedObject private var userStateStore: LocalUserStateStore

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _userStateStore = ObservedObject(wrappedValue: dependencies.userStateStore)
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink { SearchView(dependencies: dependencies) } label: {
                        Label("Search characters, meanings, readings…", systemImage: "magnifyingglass")
                    }
                }

                if !inProgressRecords.isEmpty {
                    Section("In Progress") {
                        ForEach(inProgressRecords) { record in characterRow(record, position: true) }
                    }
                }

                Section("Collections") {
                    NavigationLink { CollectionsView(dependencies: dependencies) } label: {
                        Label("Explore Collections", systemImage: "square.grid.2x2")
                    }
                }

                Section("Browse All Symbols") {
                    ForEach(dependencies.sharedCharacters) { record in characterRow(record) }
                }

                Section("Your Library") {
                    NavigationLink { BrowseStatusView(title: "Learned", records: learnedRecords, dependencies: dependencies) } label: { Label("Learned", systemImage: "checkmark.circle") }
                    NavigationLink { BrowseStatusView(title: "Favorites", records: favoriteRecords, dependencies: dependencies) } label: { Label("Favorites", systemImage: "star") }
                    NavigationLink { BrowseStatusView(title: "Review Later", records: reviewLaterRecords, dependencies: dependencies) } label: { Label("Review Later", systemImage: "clock") }
                }
            }
            .navigationTitle("Browse")
        }
        .scrollContentBackground(.hidden)
        .background(ShellStyle.paper.ignoresSafeArea())
        .tint(ShellStyle.cinnabar)
    }

    /// Character selections always switch to the canonical Symbol root.
    @ViewBuilder
    private func characterRow(_ record: SharedCharacterRecord, position: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
            CharacterTile(
                record: record,
                userState: userStateStore.state.lessonStates[record.id],
                action: {
                    dependencies.navigationState.openSymbol(record.id, intent: .view)
                }
            )
            if position {
                Text("Opens at Origin")
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textSecondary)
                    .padding(.leading, AppSpacing.spaceMd)
            }
        }
    }

    private var inProgressRecords: [SharedCharacterRecord] { records(with: .inProgress) }
    private var learnedRecords: [SharedCharacterRecord] { records(with: .learned) }
    private var favoriteRecords: [SharedCharacterRecord] { dependencies.sharedCharacters.filter { userStateStore.state.lessonStates[$0.id]?.isStarred == true } }
    private var reviewLaterRecords: [SharedCharacterRecord] { dependencies.sharedCharacters.filter { userStateStore.state.lessonStates[$0.id]?.isReviewLater == true } }

    private func records(with status: LessonProgressStatus) -> [SharedCharacterRecord] {
        dependencies.sharedCharacters.filter { userStateStore.state.lessonStates[$0.id]?.progressStatus == status }
    }
}

/// Shared structural list for Browse status collections.
struct BrowseStatusView: View {
    let title: String
    let records: [SharedCharacterRecord]
    let dependencies: AppDependencies

    var body: some View {
        List {
            if records.isEmpty {
                ContentUnavailableView("Nothing here yet", systemImage: "tray", description: Text("No Shared Characters match this collection."))
            } else {
                ForEach(records) { record in
                    CharacterTile(
                        record: record,
                        userState: dependencies.userStateStore.state.lessonStates[record.id],
                        action: { dependencies.navigationState.openSymbol(record.id, intent: .view) }
                    )
                }
            }
        }
        .navigationTitle(title)
        .scrollContentBackground(.hidden)
        .background(ShellStyle.paper.ignoresSafeArea())
        .tint(ShellStyle.cinnabar)
    }
}
