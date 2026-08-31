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
                VStack(alignment: .leading, spacing: 22) {
                    Text("Home")
                        .font(AppTypography.pageTitle)
                        .foregroundStyle(AppColors.textPrimary)

                    if let record = homeRecord {
                        hero(for: record)
                    } else {
                        ContentUnavailableView("No Shared Characters", systemImage: "character")
                    }

                    if !reviewRecords.isEmpty || (learnedCount > 0 && !incompleteCollectionRecords.isEmpty) {
                        Text("Continue Exploring").font(.title2.weight(.semibold))
                        if !reviewRecords.isEmpty { reviewModule }
                        if !incompleteCollectionRecords.isEmpty { collectionModule }
                    }

                    if learnedCount > 0 {
                        Text("\(learnedCount) symbols learned")
                            .font(AppTypography.metadata)
                            .foregroundStyle(AppColors.textSecondary)
                    }
                }
                .padding()
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
        return VStack(alignment: .leading, spacing: AppSpacing.spaceMd) {
            Text(record.coreSharedMeaning.uppercased())
                .font(AppTypography.conceptLabel)
                .tracking(1.4)
                .foregroundStyle(AppColors.textSecondary)
            HeroLineagePreview(record: record)
            Text("\(record.coreSharedMeaning.capitalized) · \(record.coreCharacter)")
                .font(AppTypography.sectionHeading)
                .foregroundStyle(AppColors.textPrimary)
            if isResuming, let position = userStateStore.state.lessonStates[record.id]?.lastPosition {
                Text("\(position.stageID ?? position.section.rawValue) · Continue your journey")
                    .font(AppTypography.metadata)
                    .foregroundStyle(AppColors.textSecondary)
            }
            PrimaryActionButton(isReviewHero ? "Start Quick Review" : (isResuming ? "Continue \(record.coreSharedMeaning.capitalized)" : "Start with \(record.coreSharedMeaning.capitalized)")) {
                dependencies.navigationState.openSymbol(record.id, intent: isReviewHero ? .review : (isResuming ? .resume : .start))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var reviewModule: some View {
        GroupedSurface {
            VStack(alignment: .leading, spacing: AppSpacing.spaceSm) {
            Text("Quick Review").font(AppTypography.sectionHeading)
            Text(reviewRecords.prefix(3).map(\.coreCharacter).joined(separator: "  "))
                .font(.system(size: 30, design: .serif))
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
                    Text("Continue Collection").font(AppTypography.sectionHeading)
                    Text("Nature").font(AppTypography.body.weight(.semibold))
                    Text(incompleteCollectionRecords.map(\.coreCharacter).joined(separator: "  "))
                        .font(.system(size: 25, design: .serif))
                    Text("Explore a curated set of Shared Characters")
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Continue Nature collection")
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

    private var incompleteCollectionRecords: [SharedCharacterRecord] {
        dependencies.sharedCharacters.prefix(6).filter { userStateStore.state.lessonStates[$0.id]?.progressStatus != .learned }
    }

    private var learnedCount: Int {
        dependencies.sharedCharacters.filter { userStateStore.state.lessonStates[$0.id]?.progressStatus == .learned }.count
    }
}

/// Reusable, intentionally compact historical preview for Home and future featured surfaces.
struct HeroLineagePreview: View {
    let record: SharedCharacterRecord

    var body: some View {
        LineagePreview(record: record, variant: .hero)
    }
}
