import SwiftUI

/// Root navigation shell for V1.
/// Add deeper NavigationStack routes inside each tab as those features become concrete.
struct RootTabView: View {
    /// Shared app dependencies passed down to feature screens.
    let dependencies: AppDependencies

    /// Currently selected tab in the root shell.
    @State private var selectedTab: AppTab = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(dependencies: dependencies)
                .tabItem {
                    Label(AppTab.home.title, systemImage: AppTab.home.systemImageName)
                }
                .tag(AppTab.home)

            SearchView(dependencies: dependencies)
                .tabItem {
                    Label(AppTab.search.title, systemImage: AppTab.search.systemImageName)
                }
                .tag(AppTab.search)

            BrowseView(dependencies: dependencies)
                .tabItem {
                    Label(AppTab.browse.title, systemImage: AppTab.browse.systemImageName)
                }
                .tag(AppTab.browse)

            CollectionsView(dependencies: dependencies)
                .tabItem {
                    Label(AppTab.collections.title, systemImage: AppTab.collections.systemImageName)
                }
                .tag(AppTab.collections)

            SettingsView(dependencies: dependencies)
                .tabItem {
                    Label(AppTab.settings.title, systemImage: AppTab.settings.systemImageName)
                }
                .tag(AppTab.settings)
        }
    }
}
