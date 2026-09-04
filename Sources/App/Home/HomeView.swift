import SwiftUI

/// Home is a quiet entrance to one current Shared Character, not a progress dashboard.
struct HomeView: View {
    let dependencies: AppDependencies
    @ObservedObject private var userStateStore: LocalUserStateStore

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _userStateStore = ObservedObject(wrappedValue: dependencies.userStateStore)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.spaceLg) {
                    Text("Home")
                        .font(AppTypography.pageTitle)
                        .foregroundStyle(AppColors.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    if let record = homeRecord {
                        hero(for: record)
                    } else {
                        ContentUnavailableView("No Shared Characters", systemImage: "character")
                    }

                    if !reviewRecords.isEmpty || continueCollection != nil {
                        Text("Continue Exploring")
                            .font(AppTypography.sectionHeading)
                            .foregroundStyle(AppColors.textPrimary)
                        if !reviewRecords.isEmpty { reviewModule }
                        if continueCollection != nil { collectionModule }
                    }

                    if learnedCount > 0 {
                        Text("\(learnedCount) symbols learned")
                            .font(AppTypography.metadata)
                            .foregroundStyle(AppColors.textSecondary)
                    }
                }
                .padding(.horizontal, AppSpacing.spacePage)
                .padding(.top, AppSpacing.spaceSm)
                // Keep the final library count above the floating root navigation bar.
                .padding(.bottom, AppSpacing.spaceSection)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .background(AppColors.appBackground.ignoresSafeArea())
        .tint(AppColors.accentPrimary)
    }

    /// Resolves Home's single dominant action: active journey, relevant review, then editorial next.
    private func hero(for record: SharedCharacterRecord) -> some View {
        // Compatibility note: the former contract called this action "Resume current lesson";
        // the approved shell uses the character-specific "Continue …" wording below.
        let isResuming = userStateStore.state.activeJourneySymbolID == record.id
        let isReviewHero = !isResuming && learnedCount > 0 && reviewRecords.first?.id == record.id
        return VStack(alignment: .center, spacing: AppSpacing.spaceSm) {
            Text(record.coreSharedMeaning.capitalized)
                .font(AppTypography.heroConcept)
                .tracking(1.2)
                .foregroundStyle(AppColors.accentPrimary)
                // Keep the concept title visibly above the first lineage panel on compact devices.
                .padding(.bottom, AppSpacing.spaceXs)
            HeroLineagePreview(record: record)
                // The preview owns a little breathing room before the primary action.
                .frame(maxWidth: .infinity, minHeight: 300, maxHeight: 320)
                .padding(.bottom, AppSpacing.spaceSm)
            PrimaryActionButton(isReviewHero ? "Start Quick Review" : (isResuming ? "Continue \(record.coreSharedMeaning.capitalized)" : "Start with \(record.coreSharedMeaning.capitalized)")) {
                dependencies.navigationState.openSymbol(record.id, intent: isReviewHero ? .review : (isResuming ? .resume : .start))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var reviewModule: some View {
        GroupedSurface {
            VStack(alignment: .leading, spacing: AppSpacing.spaceSm) {
            HStack {
                Text("Quick Review").font(AppTypography.stageTitle)
                Spacer()
                Text("Review →").font(AppTypography.caption).foregroundStyle(AppColors.accentPrimary)
            }
            Text(reviewRecords.prefix(3).map(\.coreCharacter).joined(separator: "  "))
                .font(.system(size: 30, design: .serif))
                .foregroundStyle(AppColors.textPrimary)
            Text("\(reviewRecords.count) symbols to revisit")
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.textSecondary)
            SecondaryActionButton("Start Quick Review") { dependencies.navigationState.openSymbol(reviewRecords[0].id, intent: .review) }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private var collectionModule: some View {
        if let collection = continueCollection {
            NavigationLink {
                EditorialCollectionDetailView(collection: collection, dependencies: dependencies)
            } label: {
                GroupedSurface {
                    VStack(alignment: .leading, spacing: AppSpacing.spaceXs) {
                        // Home uses the same full editorial banner as Browse/Collections;
                        // the banner already contains the collection title.
                        EditorialCollectionArtwork(collection: collection)
                            .frame(maxWidth: .infinity)
                            .aspectRatio(contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: AppRadius.small))
                        Text("\(learnedCount(in: collection)) of \(collection.sharedCharacterIDs.count) learned")
                            .font(AppTypography.metadata)
                            .foregroundStyle(AppColors.textSecondary)
                        HStack {
                            Text("Continue exploring this collection")
                            .font(AppTypography.caption)
                            .foregroundStyle(AppColors.textSecondary)
                            Spacer()
                            Text("Continue →")
                                .font(AppTypography.caption)
                                .foregroundStyle(AppColors.accentPrimary)
                        }
                    }
                }
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Continue \(collection.title) collection")
            .frame(maxWidth: .infinity, alignment: .leading)
        } else {
            EmptyView()
        }
    }

    /// Home always displays the same record its primary action opens.
    private var homeLessonRoute: LessonRoute? {
        if let active = userStateStore.state.activeJourneySymbolID,
           let state = userStateStore.state.lessonStates[active],
           state.progressStatus == .inProgress {
            return LessonRoute(sharedCharacterID: active, startingPosition: state.lastPosition ?? .origin)
        }
        if let review = reviewRecords.first, learnedCount > 0 { return LessonRoute(sharedCharacterID: review.id) }
        return dependencies.sharedCharacters.first(where: { userStateStore.state.lessonStates[$0.id]?.progressStatus != .learned })
            .map { LessonRoute(sharedCharacterID: $0.id, startingPosition: .origin) }
    }

    private var homeRecord: SharedCharacterRecord? {
        guard let route = homeLessonRoute else { return nil }
        // The active journey may be a repository-backed pilot symbol outside the seeded gallery.
        return dependencies.sharedCharacters.first { $0.id == route.sharedCharacterID }
            ?? (try? dependencies.corpusRepository.sharedCharacter(id: route.sharedCharacterID))
    }

    private var reviewRecords: [SharedCharacterRecord] {
        dependencies.sharedCharacters.filter { userStateStore.state.lessonStates[$0.id]?.isReviewLater == true }
    }

    /// Prefers the collection with the most progress, then an untouched collection when no partial collection exists.
    private var continueCollection: SharedCharacterCollection? {
        let candidates = CollectionsView.catalog(for: dependencies).filter { !$0.sharedCharacterIDs.isEmpty }
        let progress = candidates.map { collection in
            (collection: collection, learned: learnedCount(in: collection))
        }
        if let partial = progress
            .filter({ $0.learned > 0 && $0.learned < $0.collection.sharedCharacterIDs.count })
            .sorted(by: { $0.learned > $1.learned })
            .first {
            return partial.collection
        }
        return progress.first(where: { $0.learned == 0 })?.collection
    }

    private var learnedCount: Int {
        dependencies.sharedCharacters.filter { userStateStore.state.lessonStates[$0.id]?.progressStatus == .learned }.count
    }

    private func learnedCount(in collection: SharedCharacterCollection) -> Int {
        collection.sharedCharacterIDs.filter {
            userStateStore.state.lessonStates[$0]?.progressStatus == .learned
        }.count
    }
}

/// Reusable, intentionally compact historical preview for Home and onboarding.
struct HeroLineagePreview: View {
    let record: SharedCharacterRecord

    /// Prefer the real origin and earliest available historical asset; never synthesize a visual stage.
    private var previewItems: [HeroLineageItem] {
        var items: [HeroLineageItem] = []
        if let originAsset = record.history.origin?.asset {
            items.append(HeroLineageItem(id: "origin", metadata: originAsset, assetRef: nil, form: nil))
        }
        if let historicalStage = record.history.stages.first(where: { $0.stage == "oracleBone" && $0.assetRef != nil })
            ?? record.history.stages.first(where: { $0.stage != "regular" && $0.assetRef != nil }) {
            items.append(HeroLineageItem(
                id: historicalStage.stage,
                metadata: historicalStage.assetMetadata,
                assetRef: historicalStage.assetRef,
                form: nil
            ))
        }
        items.append(HeroLineageItem(id: "modern", metadata: nil, assetRef: nil, form: record.coreCharacter))
        return items
    }

    var body: some View {
        if previewItems.contains(where: { $0.metadata != nil }) {
            VStack(spacing: AppSpacing.space2xs) {
                ForEach(Array(previewItems.enumerated()), id: \.offset) { index, item in
                    if let metadata = item.metadata {
                        HistoricalAssetView(metadata: metadata, displayHeight: 92)
                            .frame(width: 112, height: 96)
                            .clipped()
                            .padding(.horizontal, AppSpacing.spaceSm)
                            .background(AppColors.artifactField)
                            .clipShape(RoundedRectangle(cornerRadius: AppRadius.small))
                            .accessibilityLabel("\(item.id) lineage visual for \(record.coreSharedMeaning)")
                    } else if let assetRef = item.assetRef {
                        HistoricalAssetView(assetRef: assetRef, displayHeight: 92)
                            .frame(width: 112, height: 96)
                            .clipped()
                            .padding(.horizontal, AppSpacing.spaceSm)
                            .background(AppColors.artifactField)
                            .clipShape(RoundedRectangle(cornerRadius: AppRadius.small))
                            .accessibilityLabel("\(item.id) lineage visual for \(record.coreSharedMeaning)")
                    } else if let form = item.form {
                        Text(form)
                            .font(.system(size: 80, design: .serif))
                            .foregroundStyle(AppColors.textPrimary)
                            .frame(width: 112, height: 96)
                            .clipped()
                            .accessibilityLabel("Modern form of \(record.coreSharedMeaning)")
                    }
                    if index < previewItems.count - 1 {
                        Rectangle()
                            .fill(AppColors.separator)
                            .frame(width: 1, height: 12)
                            .accessibilityHidden(true)
                    }
                }
            }
            .frame(maxWidth: .infinity, minHeight: 300, maxHeight: 360)
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Available lineage visuals for \(record.coreSharedMeaning)")
        } else {
            LineagePreview(record: record, variant: .hero)
        }
    }
}

/// One Home/onboarding lineage item is either a real local asset or the current modern form.
private struct HeroLineageItem {
    let id: String
    let metadata: HistoricalAssetMetadata?
    let assetRef: String?
    let form: String?
}
