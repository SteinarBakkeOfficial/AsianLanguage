import SwiftUI

/// Editorial discovery library; retrieval states live here rather than in root navigation.
struct BrowseView: View {
    let dependencies: AppDependencies
    @ObservedObject private var userStateStore: LocalUserStateStore
    @ObservedObject private var navigationState: AppNavigationState
    @State private var navigationPath = NavigationPath()

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _userStateStore = ObservedObject(wrappedValue: dependencies.userStateStore)
        _navigationState = ObservedObject(wrappedValue: dependencies.navigationState)
    }

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.spaceSection) {
                    Text("Browse")
                        .font(AppTypography.pageTitle)
                        .foregroundStyle(AppColors.textPrimary)

                    browseLink(title: "Search", detail: "Search characters, meanings, readings…", systemImage: "magnifyingglass") {
                        SearchView(dependencies: dependencies)
                    }

                    if !inProgressRecords.isEmpty {
                        browseSection("In Progress") {
                            ForEach(inProgressRecords) { record in
                                characterRow(record, position: true)
                            }
                        }
                    }

                    browseSection("Collections") {
                        browseLink(title: "Explore Collections", detail: "Nature · Pictographs · Dramatic Changes", systemImage: "square.grid.2x2") {
                            CollectionsView(dependencies: dependencies)
                        }
                    }

                    browseSection("Browse All Symbols") {
                        ForEach(dependencies.sharedCharacters) { record in
                            characterRow(record)
                        }
                    }

                    browseSection("Your Library") {
                        browseLink(title: "Learned", detail: "Review completed symbols", systemImage: "checkmark.circle") {
                            BrowseStatusView(title: "Learned", records: learnedRecords, dependencies: dependencies)
                        }
                        browseLink(title: "Favorites", detail: "Saved for easy return", systemImage: "star") {
                            BrowseStatusView(title: "Favorites", records: favoriteRecords, dependencies: dependencies)
                        }
                        browseLink(title: "Review Later", detail: "Symbols you marked to revisit", systemImage: "clock") {
                            BrowseStatusView(title: "Review Later", records: reviewLaterRecords, dependencies: dependencies)
                        }
                    }
                }
                .padding(.horizontal, AppSpacing.spacePage)
                .padding(.top, AppSpacing.spaceMd)
                .padding(.bottom, AppSpacing.spaceSection)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .onChange(of: navigationState.selectedTab) { _, selectedTab in
            if selectedTab != .browse {
                // Browse is a fresh discovery surface each time it is revisited.
                navigationPath = NavigationPath()
            }
        }
        .scrollContentBackground(.hidden)
        .background(ShellStyle.paper.ignoresSafeArea())
        .tint(ShellStyle.cinnabar)
    }

    /// Section headings mirror the approved shell while leaving each group open and scannable.
    @ViewBuilder
    private func browseSection<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.spaceSm) {
            Text(title)
                .font(AppTypography.sectionHeading)
                .foregroundStyle(AppColors.textPrimary)
            content()
        }
    }

    /// Search and library destinations use one calm row treatment instead of native list chrome.
    private func browseLink<Destination: View>(
        title: String,
        detail: String,
        systemImage: String,
        @ViewBuilder destination: () -> Destination
    ) -> some View {
        NavigationLink {
            destination()
        } label: {
            HStack(spacing: AppSpacing.spaceSm) {
                Image(systemName: systemImage)
                    .foregroundStyle(AppColors.accentPrimary)
                    .frame(width: 24)
                VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
                    Text(title)
                        .font(AppTypography.body.weight(.semibold))
                        .foregroundStyle(AppColors.textPrimary)
                    Text(detail)
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColors.textSecondary)
                }
                Spacer(minLength: 0)
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(AppColors.textTertiary)
            }
            .padding(AppSpacing.spaceMd)
            .background(AppColors.surfaceElevated)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.card))
            .overlay {
                RoundedRectangle(cornerRadius: AppRadius.card)
                    .stroke(AppColors.separator, lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
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
                        action: { dependencies.navigationState.openSymbol(record.id, intent: symbolIntent) }
                    )
                }
            }
        }
        .navigationTitle(title)
        .scrollContentBackground(.hidden)
        .background(ShellStyle.paper.ignoresSafeArea())
        .tint(ShellStyle.cinnabar)
    }

    private var symbolIntent: SymbolOpenIntent {
        title == "Learned" ? .reviewFromBrowse : .view
    }
}
