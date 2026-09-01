import SwiftUI

/// Five-area root shell for the Symbol Journey product model.
struct RootTabView: View {
    let dependencies: AppDependencies
    @ObservedObject private var navigationState: AppNavigationState

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _navigationState = ObservedObject(wrappedValue: dependencies.navigationState)
    }

    var body: some View {
        Group {
            if let corpusLoadError = dependencies.corpusLoadError {
                ContentUnavailableView("Corpus unavailable", systemImage: "exclamationmark.triangle", description: Text(corpusLoadError))
            } else {
                VStack(spacing: 0) {
                    rootContent
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    AppTabBar(selectedTab: $navigationState.selectedTab)
                }
            }
        }
        .background(AppColors.appBackground.ignoresSafeArea())
    }

    @ViewBuilder
    private var rootContent: some View {
        switch navigationState.selectedTab {
        case .home:
            HomeView(dependencies: dependencies)
        case .symbol:
            SymbolRootView(dependencies: dependencies)
        case .history:
            HistoryRootView(dependencies: dependencies)
        case .browse:
            BrowseView(dependencies: dependencies)
        case .more:
            MoreRootView(dependencies: dependencies)
        }
    }
}

/// First-launch sequence: enter the Fire exhibit before offering optional modern-language preferences.
struct OnboardingView: View {
    let dependencies: AppDependencies
    @ObservedObject private var userStateStore: LocalUserStateStore
    @State private var step: Step

    private enum Step { case intro, connection }

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _userStateStore = ObservedObject(wrappedValue: dependencies.userStateStore)
        _step = State(initialValue: dependencies.userStateStore.state.hasSeenIntro ? .connection : .intro)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: AppSpacing.spaceMd) {
                Text("SCRIPT ROOTS")
                    .font(AppTypography.conceptLabel)
                    .tracking(1.4)
                    .foregroundStyle(AppColors.textSecondary)
                switch step {
                case .intro:
                    Text("One idea. One symbol. Thousands of years.")
                        .font(AppTypography.exhibitHeading)
                        .foregroundStyle(AppColors.textPrimary)
                        .multilineTextAlignment(.center)
                    Text("Follow Fire from a recognizable origin through its historical transformation.")
                        .font(AppTypography.body)
                        .foregroundStyle(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                    if let fire = dependencies.sharedCharacters.first(where: { $0.id == "fire" }) {
                        HeroLineagePreview(record: fire)
                            .frame(minHeight: 260, maxHeight: 300)
                    }
                    PrimaryActionButton("Continue") {
                        userStateStore.markIntroSeen()
                        step = .connection
                    }
                case .connection:
                    Text("Enter the Fire exhibit")
                        .font(AppTypography.exhibitHeading)
                        .foregroundStyle(AppColors.textPrimary)
                        .multilineTextAlignment(.center)
                    Text("Begin with 火 as a museum object: its origin, historical forms, and the path into today.")
                        .font(AppTypography.body)
                        .foregroundStyle(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                    if let fire = dependencies.sharedCharacters.first(where: { $0.id == "fire" }) {
                        HeroLineagePreview(record: fire)
                            .frame(minHeight: 220, maxHeight: 260)
                    }
                    Text("Fire")
                        .font(AppTypography.exhibitHeading)
                        .foregroundStyle(AppColors.textPrimary)
                    Text("All four modern language tracks are available later. The exhibit comes first.")
                        .font(AppTypography.metadata)
                        .foregroundStyle(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                    PrimaryActionButton("Enter Fire") {
                        userStateStore.markFirstSymbolStarted()
                        dependencies.navigationState.openSymbol("fire", intent: .start)
                    }
                }
            }
            .frame(maxWidth: 390)
            .padding(AppSpacing.spacePage)
            .padding(.bottom, AppSpacing.spaceSection)
        }
        .background(AppColors.appBackground.ignoresSafeArea())
        .tint(AppColors.accentPrimary)
    }

}

/// Canonical owner of the active Shared Character journey.
private struct SymbolRootView: View {
    let dependencies: AppDependencies
    @ObservedObject private var navigationState: AppNavigationState

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _navigationState = ObservedObject(wrappedValue: dependencies.navigationState)
    }

    var body: some View {
        NavigationStack {
            if let route = navigationState.symbolRoute {
                LessonView(route: route, dependencies: dependencies)
                    .id(route.id)
            } else {
                ContentUnavailableView("No Symbol Selected", systemImage: "character")
            }
        }
    }
}

/// Generic script-period explainer kept separate from individual symbol lessons.
private struct HistoryRootView: View {
    let dependencies: AppDependencies

    private let periods = [
        HistoryPeriod(id: "oracleBone", displayName: "Oracle Bone Script"),
        HistoryPeriod(id: "bronze", displayName: "Bronze Inscriptions"),
        HistoryPeriod(id: "seal", displayName: "Seal Script"),
        HistoryPeriod(id: "clerical", displayName: "Clerical Script"),
        HistoryPeriod(id: "regular", displayName: "Regular Script")
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.spaceLg) {
                    Text("History")
                        .font(AppTypography.pageTitle)
                        .foregroundStyle(AppColors.textPrimary)
                    Text("How writing changed over thousands of years.")
                        .font(AppTypography.metadata)
                        .foregroundStyle(AppColors.textSecondary)

                    if let fire = dependencies.sharedCharacters.first(where: { $0.id == "fire" }),
                       let oracle = fire.history.stages.first(where: { $0.stage == "oracleBone" }),
                       let metadata = oracle.assetMetadata {
                        ArtifactField {
                            HistoricalAssetView(metadata: metadata)
                        }
                        .frame(height: 250)
                        Text(oracle.label)
                            .font(AppTypography.exhibitHeading)
                            .foregroundStyle(AppColors.textPrimary)
                        Text("A source-backed view into the earliest available Fire form.")
                            .font(AppTypography.body)
                            .foregroundStyle(AppColors.textSecondary)
                    }

                    VStack(alignment: .leading, spacing: AppSpacing.spaceSm) {
                        Text("Historical Stages")
                            .font(AppTypography.stageTitle)
                            .foregroundStyle(AppColors.textPrimary)
                        ForEach(periods) { period in
                            historyRow(period)
                        }
                    }
                }
                .padding(.horizontal, AppSpacing.spacePage)
                .padding(.top, AppSpacing.spaceSm)
                .padding(.bottom, AppSpacing.spaceSection)
            }
            .navigationBarTitleDisplayMode(.inline)
            .tint(AppColors.accentPrimary)
        }
        .background(AppColors.appBackground.ignoresSafeArea())
    }

    /// Period navigation uses the same elevated surface language as the app-shell reference.
    private func historyRow(_ period: HistoryPeriod) -> some View {
        NavigationLink {
            HistoryPeriodView(period: period, dependencies: dependencies)
        } label: {
            HStack(spacing: AppSpacing.spaceSm) {
                if let metadata = fireMetadata(for: period) {
                    HistoricalAssetView(metadata: metadata)
                        .frame(width: 56, height: 48)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: AppRadius.small))
                } else {
                    RoundedRectangle(cornerRadius: AppRadius.small)
                        .fill(AppColors.surfaceSubtle)
                        .frame(width: 56, height: 48)
                        .overlay {
                            Image(systemName: "character")
                                .foregroundStyle(AppColors.textSecondary)
                        }
                }
                Text(period.displayName)
                    .font(AppTypography.body.weight(.semibold))
                    .foregroundStyle(AppColors.textPrimary)
                Spacer()
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

    /// Reuses only bundled stage metadata for the overview thumbnails; no new historical claims are created here.
    private func fireMetadata(for period: HistoryPeriod) -> HistoricalAssetMetadata? {
        guard let fire = dependencies.sharedCharacters.first(where: { $0.id == "fire" }) else { return nil }
        return fire.history.stages.first(where: { $0.stage == period.id })?.assetMetadata
    }
}

/// Stable structural model for generic history, intentionally without unsourced claims.
private struct HistoryPeriod: Identifiable, Hashable {
    let id: String
    let displayName: String
    let approximateDateLabel: String? = nil
    let shortDescription: String? = nil
    let materialContext: String? = nil
    let representativeCharacterIDs: [String] = []
    let sourceIDs: [String] = []
}

private struct HistoryPeriodView: View {
    let period: HistoryPeriod
    let dependencies: AppDependencies

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.spaceLg) {
                Text(period.displayName.uppercased())
                    .font(AppTypography.conceptLabel)
                    .tracking(1.4)
                    .foregroundStyle(AppColors.textSecondary)

                Text(period.shortDescription ?? "Historical editorial content is pending research.")
                    .font(AppTypography.exhibitHeading)
                    .foregroundStyle(AppColors.textPrimary)

                if let date = period.approximateDateLabel {
                    Text(date)
                        .font(AppTypography.metadata)
                        .foregroundStyle(AppColors.textSecondary)
                }

                GroupedSurface {
                    VStack(alignment: .leading, spacing: AppSpacing.spaceSm) {
                        Text("Historical context")
                            .font(AppTypography.sectionHeading)
                            .foregroundStyle(AppColors.textPrimary)
                        Text(period.materialContext ?? "Approved context and representative material are pending editorial review.")
                            .font(AppTypography.body)
                            .foregroundStyle(AppColors.textSecondary)
                    }
                }

                if period.representativeCharacterIDs.isEmpty {
                    HistoricalMissingState(
                        title: "Representative characters not yet assigned",
                        detail: "This period will link to approved Shared Character context when the corpus is ready."
                    )
                } else {
                    VStack(alignment: .leading, spacing: AppSpacing.spaceSm) {
                        Text("Explore characters")
                            .font(AppTypography.sectionHeading)
                            .foregroundStyle(AppColors.textPrimary)
                        ForEach(dependencies.sharedCharacters.filter { period.representativeCharacterIDs.contains($0.id) }) { record in
                            CharacterTile(record: record, userState: dependencies.userStateStore.state.lessonStates[record.id]) {
                                dependencies.navigationState.openSymbol(LessonRoute(sharedCharacterID: record.id, startingPosition: nil))
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, AppSpacing.spacePage)
            .padding(.vertical, AppSpacing.spaceLg)
        }
        .navigationTitle(period.displayName)
        .background(AppColors.appBackground.ignoresSafeArea())
        .tint(AppColors.accentPrimary)
    }
}

/// Utility area for focus tracks, settings, account, and method information.
private struct MoreRootView: View {
    let dependencies: AppDependencies

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.spaceLg) {
                    Text("More")
                        .font(AppTypography.pageTitle)
                        .foregroundStyle(AppColors.textPrimary)

                    utilitySection("Learning") {
                        utilityLink("Languages", detail: "Choose which modern tracks appear in Today", systemImage: "character.book.closed") {
                            LanguagesView(dependencies: dependencies)
                        }
                        utilityLink("Settings", detail: "Appearance and local app controls", systemImage: "gearshape") {
                            SettingsView(dependencies: dependencies)
                        }
                    }

                    utilitySection("About") {
                        utilityLink("Account", detail: "Local-only learner profile", systemImage: "person") {
                            AccountView(dependencies: dependencies)
                        }
                        utilityLink("About / Method", detail: "How Script Roots teaches characters", systemImage: "info.circle") {
                            AboutMethodView(corpusCount: dependencies.installedSharedCharacterCount)
                        }
                        utilityLink("Sources / Licenses", detail: "Evidence and attribution", systemImage: "doc.text.magnifyingglass") {
                            SourcesLicensesView(dependencies: dependencies)
                        }
                    }
                }
                .padding(.horizontal, AppSpacing.spacePage)
                .padding(.top, AppSpacing.spaceSm)
                .padding(.bottom, AppSpacing.spaceSection)
            }
            .navigationBarTitleDisplayMode(.inline)
            .tint(AppColors.accentPrimary)
        }
        .background(AppColors.appBackground.ignoresSafeArea())
    }

    /// Groups utility destinations into the same quiet editorial sections as the reference shell.
    @ViewBuilder
    private func utilitySection<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.spaceSm) {
            Text(title)
                .font(AppTypography.conceptLabel)
                .tracking(0.2)
                .foregroundStyle(AppColors.textSecondary)
            content()
        }
    }

    /// Utility rows expose their purpose in secondary copy without adding another navigation layer.
    private func utilityLink<Destination: View>(
        _ title: String,
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
        }
        .buttonStyle(.plain)
    }
}

/// Global attribution surface; record-level claims remain available from Symbol sources.
struct SourcesLicensesView: View {
    let dependencies: AppDependencies

    var body: some View {
        List {
            if dependencies.sharedCharacters.flatMap(\.sources).isEmpty {
                Text("Source and license metadata is pending for the current draft corpus.")
                    .font(AppTypography.body)
                    .foregroundStyle(AppColors.textSecondary)
            } else {
                ForEach(dependencies.sharedCharacters.flatMap(\.sources), id: \.id) { source in
                    VStack(alignment: .leading) {
                        Text(source.label)
                            .font(AppTypography.body.weight(.semibold))
                            .foregroundStyle(AppColors.textPrimary)
                        Text(source.citation)
                            .font(AppTypography.caption)
                            .foregroundStyle(AppColors.textSecondary)
                    }
                    .padding(.vertical, AppSpacing.spaceXs)
                    .listRowBackground(Color.clear)
                }
            }
        }
        .navigationTitle("Sources / Licenses")
        .scrollContentBackground(.hidden)
        .background(AppColors.appBackground.ignoresSafeArea())
        .tint(AppColors.accentPrimary)
    }
}
