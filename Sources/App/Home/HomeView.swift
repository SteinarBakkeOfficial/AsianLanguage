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
        let route = homeLessonRoute
        let featured = featuredSummary
        let actionTitle = homeActionTitle

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
                            if let whyThisNow = whyThisNow {
                                Text(whyThisNow)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                Section("Study Progress") {
                    LabeledContent("Learned", value: "\(learnedCount) / \(dependencies.installedSharedCharacterCount)")
                    LabeledContent("Review later", value: "\(reviewLaterCount)")
                    LabeledContent("Favorites", value: "\(favoriteCount)")
                }

                Section("Focus Tracks") {
                    Text(selectedFocusTrackTitles)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
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
            sharedCharacterID: nextUnlearnedRecord?.id ?? dependencies.nextFeaturedSharedCharacter.id,
            startingStep: .origin
        )
    }

    /// Chooses the next unlearned Shared Character before falling back to the dependency default.
    private var featuredSummary: FeaturedSharedCharacterSummary {
        nextUnlearnedRecord?.featuredSummary ?? dependencies.nextFeaturedSharedCharacter
    }

    /// Home action copy follows resume first, then next-symbol after any learned progress.
    private var homeActionTitle: String {
        if userStateStore.state.resumeLessonRoute != nil {
            return "Resume current lesson"
        }
        return learnedCount == 0 ? "New Symbol" : "Next Symbol"
    }

    /// First record in teaching order that has not been learned yet.
    private var nextUnlearnedRecord: SharedCharacterRecord? {
        dependencies.sharedCharacters.first { record in
            userStateStore.state.lessonStates[record.id]?.progressStatus != .learned
        }
    }

    /// Number of bundled lessons marked learned in local state.
    private var learnedCount: Int {
        dependencies.sharedCharacters.filter { record in
            userStateStore.state.lessonStates[record.id]?.progressStatus == .learned
        }.count
    }

    /// Number of bundled lessons saved for later review.
    private var reviewLaterCount: Int {
        dependencies.sharedCharacters.filter { record in
            userStateStore.state.lessonStates[record.id]?.isReviewLater == true
        }.count
    }

    /// Number of bundled lessons marked as favorites.
    private var favoriteCount: Int {
        dependencies.sharedCharacters.filter { record in
            userStateStore.state.lessonStates[record.id]?.isStarred == true
        }.count
    }

    /// Human-readable summary of enabled focus tracks.
    private var selectedFocusTrackTitles: String {
        userStateStore.state.focusSelection.selectedTracks
            .map(\.title)
            .joined(separator: ", ")
    }

    /// Editorial reason for the featured lesson placement.
    private var whyThisNow: String? {
        guard let record = nextUnlearnedRecord else {
            return "You have reached the end of the bundled seed corpus."
        }

        return "Why this now: \(record.recognitionTakeaway)"
    }
}
