import SwiftUI
import UIKit

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
    /// Explicit editorial artwork keeps collection covers independent from symbol-origin assets.
    let artworkResourceName: String
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
                            collectionArtwork(for: collection)
                            .frame(maxWidth: .infinity)
                            .aspectRatio(contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: AppRadius.surface))
                            .contentShape(RoundedRectangle(cornerRadius: AppRadius.surface))
                            .accessibilityLabel(collection.title)
                            .accessibilityHint("Open collection")
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

    /// Uses the explicit editorial panel artwork; historical stages keep their separate source-backed assets.
    @ViewBuilder
    private func collectionArtwork(for collection: SharedCharacterCollection) -> some View {
        if let imageURL = Bundle.main.url(forResource: collection.artworkResourceName, withExtension: "png"),
           let image = UIImage(contentsOfFile: imageURL.path) {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
        } else {
            ZStack {
                AppColors.surfaceSubtle
                Image(systemName: "photo")
                    .foregroundStyle(AppColors.accentPrimary)
            }
        }
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
                if records.isEmpty {
                    Text("No installed V1 symbols are currently assigned to this collection.")
                        .font(AppTypography.body)
                        .foregroundStyle(AppColors.textSecondary)
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
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .background(AppColors.appBackground.ignoresSafeArea())
    }

    private var editorialCollections: [SharedCharacterCollection] {
        [
            SharedCharacterCollection(id: "nature-cosmos", title: "Nature & Cosmos", description: "Symbols rooted in the natural world and sky.", sharedCharacterIDs: ids(for: "水山木日月土川天雨田井泉云南北年白黑正上下中立央林明夏冬"), type: .editorial, sourceIDs: [], artworkResourceName: "Collections/nature-cosmos"),
            SharedCharacterCollection(id: "plants-animals-food", title: "Plants, Animals & Food", description: "Living things and the foods people gather.", sharedCharacterIDs: ids(for: "首肉牛犬羊虎竹豆玉生男采甘美香"), type: .editorial, sourceIDs: [], artworkResourceName: "Collections/plants-animals-food"),
            SharedCharacterCollection(id: "people-body-life", title: "People, Body & Life", description: "People, bodies, relationships, and living experience.", sharedCharacterIDs: ids(for: "人女子大小口目耳身首舌心自角老入好兄兵先妻"), type: .editorial, sourceIDs: [], artworkResourceName: "Collections/people-body-life"),
            SharedCharacterCollection(id: "home-tools-materials", title: "Home, Tools & Materials", description: "Objects, materials, tools, and places made by people.", sharedCharacterIDs: ids(for: "衣王刀弓册示工宗守官宿"), type: .editorial, sourceIDs: [], artworkResourceName: "Collections/home-tools-materials"),
            SharedCharacterCollection(id: "place-direction-movement", title: "Place, Direction & Movement", description: "Ways of locating, moving, arriving, and departing.", sharedCharacterIDs: ids(for: "长出入行走休从交望得旅"), type: .editorial, sourceIDs: [], artworkResourceName: "Collections/place-direction-movement"),
            SharedCharacterCollection(id: "time-number-measure", title: "Time, Number & Measure", description: "Counting, contrast, sequence, and the passage of time.", sharedCharacterIDs: ids(for: "高多少一十二三"), type: .editorial, sourceIDs: [], artworkResourceName: "Collections/time-number-measure"),
            SharedCharacterCollection(id: "family-society-institutions", title: "Family, Society & Institutions", description: "Kinship, groups, authority, ritual, and public life.", sharedCharacterIDs: ids(for: "友典令取反同合各向利祭族祝吉品"), type: .editorial, sourceIDs: [], artworkResourceName: "Collections/family-society-institutions"),
            SharedCharacterCollection(id: "action-work-change", title: "Action, Work & Change", description: "Actions, craft, effort, conflict, and transformation.", sharedCharacterIDs: ids(for: "力申止及告步分益武古"), type: .editorial, sourceIDs: [], artworkResourceName: "Collections/action-work-change"),
            SharedCharacterCollection(id: "mind-speech-learning", title: "Mind, Speech & Learning", description: "Speaking, understanding, remembering, and teaching.", sharedCharacterIDs: ids(for: "言"), type: .editorial, sourceIDs: [], artworkResourceName: "Collections/mind-speech-learning"),
            SharedCharacterCollection(id: "qualities-relations-abstract-ideas", title: "Qualities, Relations & Abstract Ideas", description: "Concepts that connect concrete images to broader ideas.", sharedCharacterIDs: ids(for: "石贝民後集"), type: .editorial, sourceIDs: [], artworkResourceName: "Collections/qualities-relations-abstract-ideas")
        ]
    }

    /// Converts the editorial character group into runtime IDs so collection content follows the bundled corpus.
    private func ids(for characters: String) -> [String] {
        characters.map(String.init).compactMap { character in
            dependencies.sharedCharacters.first(where: { $0.coreCharacter == character })?.id
        }
    }
}
