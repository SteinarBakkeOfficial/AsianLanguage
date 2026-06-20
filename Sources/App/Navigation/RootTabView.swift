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
                    Label(AppTab.savedArchive.title, systemImage: AppTab.savedArchive.systemImageName)
                }
                .tag(AppTab.savedArchive)

            SettingsView(dependencies: dependencies, initialSection: .focusLanguage)
            .tabItem {
                Label(AppTab.languages.title, systemImage: AppTab.languages.systemImageName)
            }
            .tag(AppTab.languages)

            NavigationStack {
                PlaceholderScreen(
                    title: "Account",
                    message: "Account is reserved for public testing features such as profiles, sync, and release access. It is intentionally shallow while symbol recognition is being tested.",
                    systemImageName: "person.crop.circle"
                )
            }
            .tabItem {
                Label(AppTab.account.title, systemImage: AppTab.account.systemImageName)
            }
            .tag(AppTab.account)

            SettingsView(dependencies: dependencies)
                .tabItem {
                    Label(AppTab.settings.title, systemImage: AppTab.settings.systemImageName)
                }
                .tag(AppTab.settings)
        }
    }
}
