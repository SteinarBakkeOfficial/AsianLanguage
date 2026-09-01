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
    /// Local state store used for editorial collection progress indicators.
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

                collectionSection("Explore Collections") {
                    ForEach(editorialCollections) { collection in
                        NavigationLink {
                            editorialCollection(collection)
                        } label: {
                            HStack(alignment: .center, spacing: AppSpacing.spaceSm) {
                                collectionArtwork(for: collection)
                                    .frame(width: 88, height: 72)
                                    .clipShape(RoundedRectangle(cornerRadius: AppRadius.surface))
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

    /// Uses the approved educational concept art only as collection decoration;
    /// historical stages continue to render their separate source-backed assets.
    @ViewBuilder
    private func collectionArtwork(for collection: SharedCharacterCollection) -> some View {
        if let assetRef = collectionArtworkRef(for: collection) {
            HistoricalAssetView(assetRef: assetRef, displayHeight: 72)
        } else {
            ZStack {
                AppColors.surfaceSubtle
                Image(systemName: "square.grid.2x2")
                    .foregroundStyle(AppColors.accentPrimary)
            }
        }
    }

    private func collectionArtworkRef(for collection: SharedCharacterCollection) -> String? {
        collection.sharedCharacterIDs
            .compactMap { characterID in
                dependencies.sharedCharacters.first(where: { record in record.id == characterID })
            }
            .compactMap { record in record.history.origin?.asset?.assetRef }
            .first
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

    private var editorialCollections: [SharedCharacterCollection] {
        [
            SharedCharacterCollection(id: "nature", title: "Nature", description: "Symbols rooted in the natural world.", sharedCharacterIDs: ["fire", "water", "mountain", "tree", "day", "moon"], type: .editorial, sourceIDs: []),
            SharedCharacterCollection(id: "pictographs", title: "Pictographs", description: "Early images carried into written form.", sharedCharacterIDs: dependencies.sharedCharacters.map(\.id), type: .editorial, sourceIDs: []),
            SharedCharacterCollection(id: "dramatic-changes", title: "Dramatic Changes", description: "Journeys where the written form changes visibly over time.", sharedCharacterIDs: dependencies.sharedCharacters.map(\.id), type: .editorial, sourceIDs: [])
        ]
    }
}
