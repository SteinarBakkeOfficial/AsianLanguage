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
        }
    }
}

/// Minimal first-launch gate; the approved onboarding design can replace this surface later.
struct OnboardingView: View {
    let dependencies: AppDependencies

    var body: some View {
        VStack(spacing: 16) {
            Text("AsianLanguage").font(.title)
            Text("Follow shared characters from origin through history into modern recognition.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            Button("Continue") {
                dependencies.userStateStore.completeOnboarding()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
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
                NavigationLink {
                    HistoryPeriodView(period: period, dependencies: dependencies)
                } label: {
                    Text(period.displayName)
                }
            }
            .navigationTitle("History")
        }
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
        List {
            Section(period.displayName) {
                Text(period.shortDescription ?? "Historical editorial content is pending research.")
                    .foregroundStyle(.secondary)
            }
            if period.representativeCharacterIDs.isEmpty {
                Text("No representative Shared Characters are assigned yet.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(dependencies.sharedCharacters.filter { period.representativeCharacterIDs.contains($0.id) }) { record in
                    Button(record.coreCharacter) {
                        dependencies.navigationState.openSymbol(LessonRoute(sharedCharacterID: record.id, startingPosition: nil))
                    }
                }
            }
        }
        .navigationTitle(period.displayName)
    }
}

/// Utility area for focus tracks, settings, account, and method information.
private struct MoreRootView: View {
    let dependencies: AppDependencies

    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Languages") { LanguagesView(dependencies: dependencies) }
                NavigationLink("Account") { AccountView(dependencies: dependencies) }
                NavigationLink("Settings") { SettingsView(dependencies: dependencies) }
                NavigationLink("About / Method") {
                    AboutMethodView(corpusCount: dependencies.installedSharedCharacterCount)
                }
                NavigationLink("Sources / Licenses") {
                    SourcesLicensesView(dependencies: dependencies)
                }
            }
            .navigationTitle("More")
        }
    }
}

/// Global attribution surface; record-level claims remain available from Symbol sources.
struct SourcesLicensesView: View {
    let dependencies: AppDependencies

    var body: some View {
        List {
            if dependencies.sharedCharacters.flatMap(\.sources).isEmpty {
                Text("Source and license metadata is pending for the current draft corpus.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(dependencies.sharedCharacters.flatMap(\.sources), id: \.id) { source in
                    VStack(alignment: .leading) {
                        Text(source.label)
                        Text(source.citation).font(.caption).foregroundStyle(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Sources / Licenses")
    }
}
