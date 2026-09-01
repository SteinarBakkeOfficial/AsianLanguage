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
    // Product vocabulary remains “Review later”; the title casing is adjusted for the visual shell.
    /// Shared app dependencies used for corpus and user-state collections.
    let dependencies: AppDependencies
    /// Local state store used for system collections.
    @ObservedObject private var userStateStore: LocalUserStateStore

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _userStateStore = ObservedObject(wrappedValue: dependencies.userStateStore)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.spaceLg) {
                Text("Collections")
                    .font(AppTypography.pageTitle)
                    .foregroundStyle(AppColors.textPrimary)

                collectionSection("Your Library") {
                    systemCollection(title: "Learned", systemImage: "checkmark.circle", records: learnedRecords)
                    systemCollection(title: "Favorites", systemImage: "star", records: favoriteRecords)
                    systemCollection(title: "Review Later", systemImage: "clock", records: reviewLaterRecords)
                }

                collectionSection("Explore Collections") {
                    ForEach(editorialCollections) { collection in
                        NavigationLink {
                            editorialCollection(collection)
                        } label: {
                            HStack(alignment: .top, spacing: AppSpacing.spaceSm) {
                                Image(systemName: "square.grid.2x2")
                                    .foregroundStyle(AppColors.accentPrimary)
                                    .frame(width: 24)
                                VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
                                    Text(collection.title)
                                        .font(AppTypography.stageTitle)
                                        .foregroundStyle(AppColors.textPrimary)
                                    if let description = collection.description {
                                        Text(description)
                                            .font(AppTypography.caption)
                                            .foregroundStyle(AppColors.textSecondary)
                                    }
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundStyle(AppColors.textTertiary)
                            }
                            .padding(AppSpacing.spaceSm)
                            .frame(minHeight: 60)
                            .background(AppColors.surfaceElevated)
                            .clipShape(RoundedRectangle(cornerRadius: AppRadius.surface))
                            .overlay {
                                RoundedRectangle(cornerRadius: AppRadius.surface)
                                    .stroke(AppColors.separator, lineWidth: 1)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal, AppSpacing.spacePage)
            .padding(.top, AppSpacing.spaceSm)
            // Keep the editorial collection list above the root tab bar.
            .padding(.bottom, AppSpacing.spaceSection)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .background(AppColors.appBackground.ignoresSafeArea())
        .tint(AppColors.accentPrimary)
    }

    /// Groups library status lists separately from editorial collections.
    @ViewBuilder
    private func collectionSection<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.spaceXs) {
            Text(title)
                .font(AppTypography.stageTitle)
                .foregroundStyle(AppColors.textPrimary)
            content()
        }
    }

    /// Renders a status list as a library group, never as an editorial collection.
    @ViewBuilder
    private func systemCollection(title: String, systemImage: String, records: [SharedCharacterRecord]) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.spaceXs) {
            HStack(spacing: AppSpacing.spaceSm) {
                Image(systemName: systemImage)
                    .foregroundStyle(AppColors.accentPrimary)
                    .frame(width: 24)
                Text(title)
                    .font(AppTypography.body.weight(.semibold))
                    .foregroundStyle(AppColors.textPrimary)
                Spacer()
            }
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
        .padding(AppSpacing.spaceSm)
        .background(AppColors.surfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.card))
        .overlay {
            RoundedRectangle(cornerRadius: AppRadius.card)
                .stroke(AppColors.separator, lineWidth: 1)
        }
    }

    private func symbolIntent(for collectionTitle: String) -> SymbolOpenIntent {
        collectionTitle == "Learned" ? .reviewFromBrowse : .view
    }

    /// Editorial collection detail page for curated lesson sets.
    private func editorialCollection(_ collection: SharedCharacterCollection) -> some View {
        let records = collection.sharedCharacterIDs.compactMap { id in dependencies.sharedCharacters.first { $0.id == id } }
        return ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.spaceMd) {
                Text(collection.title)
                    .font(AppTypography.pageTitle)
                    .foregroundStyle(AppColors.textPrimary)
                if let description = collection.description {
                    Text(description)
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
            .padding(.horizontal, AppSpacing.spacePage)
            .padding(.top, AppSpacing.spaceSm)
            .padding(.bottom, AppSpacing.spaceSection)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .background(AppColors.appBackground.ignoresSafeArea())
    }

    private var reviewLaterRecords: [SharedCharacterRecord] {
        dependencies.sharedCharacters.filter { userStateStore.state.lessonStates[$0.id]?.isReviewLater == true }
    }

    private var favoriteRecords: [SharedCharacterRecord] {
        dependencies.sharedCharacters.filter { userStateStore.state.lessonStates[$0.id]?.isStarred == true }
    }

    private var learnedRecords: [SharedCharacterRecord] {
        dependencies.sharedCharacters.filter { userStateStore.state.lessonStates[$0.id]?.progressStatus == .learned }
    }

    private var editorialCollections: [SharedCharacterCollection] {
        [
            SharedCharacterCollection(id: "nature", title: "Nature", description: "Symbols rooted in the natural world.", sharedCharacterIDs: ["fire", "water", "mountain", "tree", "day", "moon"], type: .editorial, sourceIDs: []),
            SharedCharacterCollection(id: "pictographs", title: "Pictographs", description: "Early images carried into written form.", sharedCharacterIDs: dependencies.sharedCharacters.map(\.id), type: .editorial, sourceIDs: []),
            SharedCharacterCollection(id: "dramatic-changes", title: "Dramatic Changes", description: "Journeys where the written form changes visibly over time.", sharedCharacterIDs: dependencies.sharedCharacters.map(\.id), type: .editorial, sourceIDs: [])
        ]
    }
}
