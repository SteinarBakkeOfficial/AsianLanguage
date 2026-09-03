import SwiftUI

/// Editorial discovery library; retrieval states live here rather than in root navigation.
struct BrowseView: View {
    let dependencies: AppDependencies
    @ObservedObject private var userStateStore: LocalUserStateStore
    @ObservedObject private var navigationState: AppNavigationState
    @State private var navigationPath = NavigationPath()
    @State private var browseQuery = ""

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _userStateStore = ObservedObject(wrappedValue: dependencies.userStateStore)
        _navigationState = ObservedObject(wrappedValue: dependencies.navigationState)
    }

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.spaceLg) {
                    Text("Browse")
                        .font(AppTypography.pageTitle)
                        .foregroundStyle(AppColors.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    // Browse owns the primary discovery search; the All Symbols destination
                    // repeats the same control so its full-library search remains self-contained.
                    AppSearchField(text: $browseQuery, prompt: "Search symbols, meanings, readings…", onCancel: {
                        browseQuery = ""
                    })

                    if browseQuery.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        if !inProgressRecords.isEmpty {
                            browseSection("In Progress") {
                                ForEach(inProgressRecords) { record in
                                    characterRow(record, position: true)
                                }
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

                        browseSection("Library") {
                            browseLink(title: "All Symbols", detail: "Open the complete V1 library", systemImage: "books.vertical") {
                                AllSymbolsLibraryView(dependencies: dependencies)
                            }
                        }

                        browseSection("Collections") {
                            collectionPreviewLink(
                                title: "Nature & Cosmos",
                                detail: "Natural forms, sky, water, and time",
                                assetRef: "Assets/Collections/nature-cosmos.png"
                            ) {
                                CollectionsView(dependencies: dependencies)
                            }
                            collectionPreviewLink(
                                title: "People, Body & Life",
                                detail: "People, bodies, relationships, and life",
                                assetRef: "Assets/Collections/people-body-life.png"
                            ) {
                                CollectionsView(dependencies: dependencies)
                            }
                            browseLink(title: "Explore all collections", detail: "Ten editorial collections", systemImage: "square.grid.2x2") {
                                CollectionsView(dependencies: dependencies)
                            }
                        }
                    } else {
                        browseSection("Search Results") {
                            Text("\(browseSearchResults.count) matching symbols")
                                .font(AppTypography.caption)
                                .foregroundStyle(AppColors.textSecondary)
                            if browseSearchResults.isEmpty {
                                ContentUnavailableView(
                                    "No symbols found",
                                    systemImage: "magnifyingglass",
                                    description: Text("Try a character, meaning, or reading.")
                                )
                                .frame(maxWidth: .infinity, minHeight: 220)
                            } else {
                                ForEach(browseSearchResults) { record in
                                    characterRow(record)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, AppSpacing.spacePage)
                .padding(.top, AppSpacing.spaceSm)
                // Browse is a root surface; keep all discovery sections clear of the tab capsule.
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
        VStack(alignment: .leading, spacing: AppSpacing.spaceXs) {
            Text(title)
                .font(AppTypography.stageTitle)
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
            .padding(.horizontal, AppSpacing.spaceSm)
            .frame(minHeight: 56)
            .background(AppColors.surfaceElevated)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.surface))
            .overlay {
                RoundedRectangle(cornerRadius: AppRadius.surface)
                    .stroke(AppColors.separator, lineWidth: 1)
            }
            .shadow(color: AppColors.textPrimary.opacity(0.04), radius: 6, y: 2)
        }
        .buttonStyle(.plain)
    }

    /// Editorial collection cards keep Browse visually aligned with the
    /// reference shell while leaving status lists in Your Library below.
    private func collectionPreviewLink<Destination: View>(
        title: String,
        detail: String,
        assetRef: String,
        @ViewBuilder destination: () -> Destination
    ) -> some View {
        NavigationLink {
            destination()
        } label: {
            HStack(spacing: AppSpacing.spaceSm) {
                HistoricalAssetView(assetRef: assetRef, displayHeight: 72)
                    .frame(width: 96, height: 72)
                    .clipShape(RoundedRectangle(cornerRadius: AppRadius.surface))
                VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
                    Text(title)
                        .font(AppTypography.stageTitle)
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
            .padding(AppSpacing.spaceXs)
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
    private var browseSearchResults: [SharedCharacterRecord] {
        SharedCharacterSearchIndex(records: dependencies.sharedCharacters).search(browseQuery)
    }

    private func records(with status: LessonProgressStatus) -> [SharedCharacterRecord] {
        dependencies.sharedCharacters.filter { userStateStore.state.lessonStates[$0.id]?.progressStatus == status }
    }
}

/// Complete read-only V1 library. Browse owns discovery; this is the deliberate all-symbol destination.
struct AllSymbolsLibraryView: View {
    let dependencies: AppDependencies
    @ObservedObject private var userStateStore: LocalUserStateStore
    @State private var query = ""

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _userStateStore = ObservedObject(wrappedValue: dependencies.userStateStore)
    }

    private var records: [SharedCharacterRecord] {
        let normalized = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !normalized.isEmpty else { return dependencies.sharedCharacters }
        return SharedCharacterSearchIndex(records: dependencies.sharedCharacters).search(normalized)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.spaceSm) {
                AppSearchField(text: $query, prompt: "Search the V1 library", onCancel: {})
                Text("\(records.count) of \(dependencies.sharedCharacters.count) symbols")
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textSecondary)
                if records.isEmpty {
                    ContentUnavailableView("No symbols found", systemImage: "magnifyingglass", description: Text("Try a character, meaning, or reading."))
                        .frame(maxWidth: .infinity, minHeight: 220)
                } else {
                    ForEach(records) { record in
                        CharacterTile(
                            record: record,
                            userState: userStateStore.state.lessonStates[record.id],
                            action: { dependencies.navigationState.openSymbol(record.id, intent: .view) }
                        )
                    }
                }
            }
            .padding(.horizontal, AppSpacing.spacePage)
            .padding(.top, AppSpacing.spaceSm)
            .padding(.bottom, AppSpacing.spaceSection)
        }
        .navigationTitle("All Symbols")
        .navigationBarTitleDisplayMode(.inline)
        .scrollContentBackground(.hidden)
        .background(ShellStyle.paper.ignoresSafeArea())
        .tint(ShellStyle.cinnabar)
    }
}

/// Shared structural list for Browse status collections.
struct BrowseStatusView: View {
    let title: String
    let records: [SharedCharacterRecord]
    let dependencies: AppDependencies

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.spaceSm) {
                if records.isEmpty {
                    ContentUnavailableView("Nothing here yet", systemImage: "tray", description: Text("No Shared Characters match this collection."))
                        .frame(maxWidth: .infinity, minHeight: 260)
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
            .padding(.horizontal, AppSpacing.spacePage)
            .padding(.top, AppSpacing.spaceSm)
            .padding(.bottom, AppSpacing.spaceSection)
        }
        .navigationTitle(title)
        .background(ShellStyle.paper.ignoresSafeArea())
        .tint(ShellStyle.cinnabar)
    }

    private var symbolIntent: SymbolOpenIntent {
        title == "Learned" ? .reviewFromBrowse : .view
    }
}
