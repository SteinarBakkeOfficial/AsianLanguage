import SwiftUI

/// Home screen for resume state and the next featured Shared Character.
struct HomeView: View {
    /// Shared app dependencies used by the shell until real stores exist.
    let dependencies: AppDependencies

    /// Local state store used for resume behavior.
    @ObservedObject private var userStateStore: LocalUserStateStore

    /// Creates Home with observed access to local user state.
    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _userStateStore = ObservedObject(wrappedValue: dependencies.userStateStore)
    }

    var body: some View {
        let featured = dependencies.nextFeaturedSharedCharacter
        let route = homeLessonRoute
        let actionTitle = userStateStore.state.resumeLessonRoute == nil ? featured.actionTitle : "Resume current lesson"

        NavigationStack {
            List {
                Section {
                    NavigationLink(value: route) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(actionTitle)
                                .font(.headline)
                            Text(featured.displayForm)
                                .font(.system(size: 56, weight: .regular, design: .serif))
                            Text(featured.primaryGloss)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }

                Section("Corpus") {
                    LabeledContent("Installed", value: dependencies.installedCorpusName)
                    LabeledContent("Shared Characters", value: "\(dependencies.installedSharedCharacterCount)")
                }
            }
            .navigationTitle("Home")
            .navigationDestination(for: LessonRoute.self) { route in
                LessonView(route: route, dependencies: dependencies)
            }
        }
    }

    /// Chooses resume when local state has an in-progress lesson; otherwise opens the featured record.
    private var homeLessonRoute: LessonRoute {
        userStateStore.state.resumeLessonRoute ?? LessonRoute(
            sharedCharacterID: dependencies.nextFeaturedSharedCharacter.id,
            startingStep: .origin
        )
    }
}
