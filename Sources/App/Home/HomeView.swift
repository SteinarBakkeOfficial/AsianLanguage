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

                    if !reviewRecords.isEmpty || (learnedCount > 0 && !natureCollectionRecords.isEmpty) {
                        Text("Continue Exploring")
                            .font(AppTypography.sectionHeading)
                            .foregroundStyle(AppColors.textPrimary)
                        if !reviewRecords.isEmpty { reviewModule }
                        if !natureCollectionRecords.isEmpty { collectionModule }
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
            Text(record.coreSharedMeaning.uppercased())
                .font(AppTypography.heroConcept)
                .tracking(1.2)
                .foregroundStyle(AppColors.accentPrimary)
            HeroLineagePreview(record: record)
                .frame(maxWidth: .infinity, minHeight: 240, maxHeight: 280)
            Text("\(record.coreSharedMeaning.capitalized) · \(record.coreCharacter)")
                .font(AppTypography.exhibitHeading)
                .foregroundStyle(AppColors.textPrimary)
            .multilineTextAlignment(.center)
            if isResuming, let position = userStateStore.state.lessonStates[record.id]?.lastPosition {
                Text("\(position.stageID ?? position.section.rawValue) · Continue your journey")
                    .font(AppTypography.metadata)
                    .foregroundStyle(AppColors.textSecondary)
            }
            Text(isReviewHero ? "Review what you know" : (isResuming ? "Continue your journey" : "Follow one picture across thousands of years."))
                .font(AppTypography.metadata)
                .foregroundStyle(AppColors.textSecondary)
                .multilineTextAlignment(.center)
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

    private var collectionModule: some View {
        Button {
            guard let nextRecord = incompleteCollectionRecords.first else { return }
            dependencies.navigationState.openSymbol(nextRecord.id, intent: .start)
        } label: {
            GroupedSurface {
                VStack(alignment: .leading, spacing: AppSpacing.spaceXs) {
                    HStack {
                        Text("Nature & Cosmos").font(AppTypography.stageTitle)
                        Spacer()
                        Text("Continue →").font(AppTypography.caption).foregroundStyle(AppColors.accentPrimary)
                    }
                    HStack(spacing: AppSpacing.spaceSm) {
                        HistoricalAssetView(assetRef: "Assets/Collections/nature-cosmos.png", displayHeight: 58)
                            .frame(width: 78, height: 58)
                            .clipShape(RoundedRectangle(cornerRadius: AppRadius.small))
                        Text(natureCollectionRecords.prefix(6).map(\.coreCharacter).joined(separator: "  "))
                            .font(.system(size: 25, design: .serif))
                    }
                    Text("Explore a curated set of Shared Characters")
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Continue Nature and Cosmos collection")
        .frame(maxWidth: .infinity, alignment: .leading)
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
        return dependencies.sharedCharacters.first { $0.id == route.sharedCharacterID }
    }

    private var reviewRecords: [SharedCharacterRecord] {
        dependencies.sharedCharacters.filter { userStateStore.state.lessonStates[$0.id]?.isReviewLater == true }
    }

    private var natureCollectionRecords: [SharedCharacterRecord] {
        let natureCharacters = Set("水山木日月土川天雨田井泉云南北年白黑正上下中立央林明夏冬".map(String.init))
        return dependencies.sharedCharacters.filter {
            natureCharacters.contains($0.coreCharacter)
                && userStateStore.state.lessonStates[$0.id]?.progressStatus != .learned
        }
    }

    private var learnedCount: Int {
        dependencies.sharedCharacters.filter { userStateStore.state.lessonStates[$0.id]?.progressStatus == .learned }.count
    }
}

/// Reusable, intentionally compact historical preview for Home and onboarding.
struct HeroLineagePreview: View {
    let record: SharedCharacterRecord

    /// Prefer the real origin and earliest available historical asset; never synthesize a visual stage.
    private var previewItems: [HeroLineageItem] {
        var items: [HeroLineageItem] = []
        if let originAsset = record.history.origin?.asset {
            items.append(HeroLineageItem(id: "origin", metadata: originAsset, form: nil))
        }
        if let historicalAsset = record.history.stages.first(where: { $0.stage != "regular" && $0.assetMetadata != nil })?.assetMetadata
            ?? record.history.stages.first(where: { $0.assetMetadata != nil })?.assetMetadata {
            items.append(HeroLineageItem(id: historicalAsset.assetRef, metadata: historicalAsset, form: nil))
        }
        items.append(HeroLineageItem(id: "modern", metadata: nil, form: record.coreCharacter))
        return items
    }

    var body: some View {
        if previewItems.contains(where: { $0.metadata != nil }) {
            VStack(spacing: AppSpacing.space2xs) {
                ForEach(Array(previewItems.enumerated()), id: \.offset) { index, item in
                    if let metadata = item.metadata {
                        HistoricalAssetView(metadata: metadata, displayHeight: 72)
                            .frame(maxWidth: 88, maxHeight: 72)
                            .padding(.horizontal, AppSpacing.spaceSm)
                            .background(AppColors.artifactField)
                            .clipShape(RoundedRectangle(cornerRadius: AppRadius.small))
                            .accessibilityLabel("\(item.id) lineage visual for \(record.coreSharedMeaning)")
                    } else if let form = item.form {
                        Text(form)
                            .font(.system(size: 64, design: .serif))
                            .foregroundStyle(AppColors.textPrimary)
                            .frame(minWidth: 88, minHeight: 72)
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
            .frame(maxWidth: .infinity, minHeight: 240, maxHeight: 280)
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
    let form: String?
}
