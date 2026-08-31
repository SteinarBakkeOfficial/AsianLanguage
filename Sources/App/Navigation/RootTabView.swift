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
                TabView(selection: $navigationState.selectedTab) {
                    HomeView(dependencies: dependencies)
                        .tabItem { Label("Home", systemImage: AppTab.home.systemImageName) }
                        .tag(AppTab.home)

                    SymbolRootView(dependencies: dependencies)
                        .tabItem { Label("Symbol", systemImage: AppTab.symbol.systemImageName) }
                        .tag(AppTab.symbol)

                    HistoryRootView(dependencies: dependencies)
                        .tabItem { Label("History", systemImage: AppTab.history.systemImageName) }
                        .tag(AppTab.history)

                    BrowseView(dependencies: dependencies)
                        .tabItem { Label("Browse", systemImage: AppTab.browse.systemImageName) }
                        .tag(AppTab.browse)

                    MoreRootView(dependencies: dependencies)
                        .tabItem { Label("More", systemImage: AppTab.more.systemImageName) }
                        .tag(AppTab.more)
                }
                .tint(AppColors.accentPrimary)
                .toolbarBackground(AppColors.appBackground, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
            }
        }
        .background(AppColors.appBackground.ignoresSafeArea())
    }
}

/// First-launch sequence: encounter Fire, configure optional focus emphasis, then enter Symbol.
struct OnboardingView: View {
    let dependencies: AppDependencies
    @ObservedObject private var userStateStore: LocalUserStateStore
    @State private var step: Step

    private enum Step { case intro, connection, focus }

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _userStateStore = ObservedObject(wrappedValue: dependencies.userStateStore)
        _step = State(initialValue: dependencies.userStateStore.state.hasSeenIntro ? .focus : .intro)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.spaceLg) {
                Text("SCRIPT ROOTS")
                    .font(AppTypography.conceptLabel)
                    .tracking(1.4)
                    .foregroundStyle(AppColors.textSecondary)
                switch step {
                case .intro:
                    Text("One idea. One symbol. Thousands of years.")
                        .font(AppTypography.exhibitHeading)
                        .foregroundStyle(AppColors.textPrimary)
                    Text("Follow Fire from a recognizable origin through its historical transformation.")
                        .font(AppTypography.body)
                        .foregroundStyle(AppColors.textSecondary)
                    if let fire = dependencies.sharedCharacters.first(where: { $0.id == "fire" }) {
                        HeroLineagePreview(record: fire)
                    }
                    PrimaryActionButton("Continue") {
                        userStateStore.markIntroSeen()
                        step = .connection
                    }
                case .connection:
                    Text("One Shared Character")
                        .font(AppTypography.exhibitHeading)
                        .foregroundStyle(AppColors.textPrimary)
                    Text("火 still connects languages across East Asia today.")
                        .font(AppTypography.body)
                        .foregroundStyle(AppColors.textSecondary)
                    Text("火")
                        .font(.system(size: 112, design: .serif))
                        .foregroundStyle(AppColors.textPrimary)
                        .frame(maxWidth: .infinity)
                        .accessibilityLabel("Shared Character Fire")
                    PrimaryActionButton("Continue") { step = .focus }
                case .focus:
                    Text("Which connections do you want to follow?")
                        .font(AppTypography.exhibitHeading)
                        .foregroundStyle(AppColors.textPrimary)
                    Text("All four are selected by default. You can change this anytime.")
                        .font(AppTypography.body)
                        .foregroundStyle(AppColors.textSecondary)
                    GroupedSurface {
                        VStack(spacing: 0) {
                            ForEach(FocusTrack.allCases) { track in
                                Toggle(track.title, isOn: focusBinding(for: track))
                                    .font(AppTypography.body)
                                    .frame(minHeight: 52)
                            }
                        }
                    }
                    PrimaryActionButton("Continue with Fire") {
                        userStateStore.markFocusLanguagesChosen()
                        userStateStore.markFirstSymbolStarted()
                        dependencies.navigationState.openSymbol("fire", intent: .start)
                    }
                }
            }
            .frame(maxWidth: 520)
            .padding(AppSpacing.spacePage)
        }
        .background(AppColors.appBackground.ignoresSafeArea())
        .tint(AppColors.accentPrimary)
    }

    /// Keeps all four focus tracks selected by default while allowing multi-select preference changes.
    private func focusBinding(for track: FocusTrack) -> Binding<Bool> {
        Binding(
            get: { userStateStore.state.focusSelection.contains(track) },
            set: { userStateStore.setFocusTrack(track, isSelected: $0) }
        )
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
        HistoryPeriod(id: "oracleBone", displayName: "Oracle Bone"),
        HistoryPeriod(id: "bronze", displayName: "Bronze"),
        HistoryPeriod(id: "seal", displayName: "Seal"),
        HistoryPeriod(id: "clerical", displayName: "Clerical"),
        HistoryPeriod(id: "regular", displayName: "Regular")
    ]

    var body: some View {
        NavigationStack {
            List(periods) { period in
                SettingsRow(
                    period.displayName,
                    destination: HistoryPeriodView(period: period, dependencies: dependencies)
                )
                .listRowBackground(Color.clear)
            }
            .listStyle(.insetGrouped)
            .navigationTitle("History")
            .scrollContentBackground(.hidden)
            .background(AppColors.appBackground.ignoresSafeArea())
            .tint(AppColors.accentPrimary)
        }
        .background(ShellStyle.paper.ignoresSafeArea())
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
            List {
                NavigationLink("Languages") { LanguagesView(dependencies: dependencies) }
                    .listRowBackground(Color.clear)
                SettingsRow("Account", destination: AccountView(dependencies: dependencies))
                    .listRowBackground(Color.clear)
                NavigationLink("Settings") { SettingsView(dependencies: dependencies) }
                    .listRowBackground(Color.clear)
                SettingsRow(
                    "About / Method",
                    destination: AboutMethodView(corpusCount: dependencies.installedSharedCharacterCount)
                )
                .listRowBackground(Color.clear)
                SettingsRow("Sources / Licenses", destination: SourcesLicensesView(dependencies: dependencies))
                    .listRowBackground(Color.clear)
            }
            .listStyle(.insetGrouped)
            .navigationTitle("More")
            .scrollContentBackground(.hidden)
            .background(AppColors.appBackground.ignoresSafeArea())
            .tint(AppColors.accentPrimary)
        }
        .background(AppColors.appBackground.ignoresSafeArea())
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
