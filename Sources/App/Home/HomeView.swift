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
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if let route = homeLessonRoute, let record = homeRecord {
                        featuredSymbolCard(route: route, record: record, actionTitle: homeActionTitle)
                    } else {
                        corpusCompleteCard
                    }
                    dashboardCard
                    focusAndCorpusCard
                }
                .padding()
            }
            .navigationTitle("Home")
        }
    }

    /// Symbol-first Home card based on the app-structure reference sketch.
    private func featuredSymbolCard(
        route: LessonRoute,
        record: SharedCharacterRecord,
        actionTitle: String
    ) -> some View {
        Button {
            dependencies.navigationState.openSymbol(route)
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .center, spacing: 12) {
                    Text(record.history.originAnchor)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(4)

                    VStack(alignment: .leading, spacing: 6) {
                        Text(actionTitle)
                            .font(.caption.weight(.bold))
                            .foregroundStyle(Color.green)
                        Text(record.coreCharacter)
                            .font(.system(size: 72, weight: .regular, design: .serif))
                            .foregroundStyle(.primary)
                        Text(record.coreSharedMeaning.capitalized)
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(.primary)
                    }
                }

                if let whyThisNow {
                    Text(whyThisNow)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Text("Start with the picture idea, then follow the symbol through the historical journey into Today.")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color.brown)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(red: 0.99, green: 0.96, blue: 0.88))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.brown.opacity(0.28), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }

    /// Completion state shown when every installed record is learned.
    private var corpusCompleteCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Corpus complete").font(.title2.weight(.bold))
            Text("You have marked every installed Shared Character as Learned. Review a saved symbol or return when new content is installed.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
    }

    /// Compact progress card.
    private var dashboardCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Study Progress")
                .font(.headline)
            LabeledContent("Learned", value: "\(learnedCount) / \(dependencies.installedSharedCharacterCount)")
            LabeledContent("Review later", value: "\(reviewLaterCount)")
            LabeledContent("Favorites", value: "\(favoriteCount)")
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    /// Focus and corpus card.
    private var focusAndCorpusCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Focus Tracks")
                .font(.headline)
            Text(selectedFocusTrackTitles)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Divider()
            LabeledContent("Installed", value: dependencies.installedCorpusName)
            LabeledContent("Shared Characters", value: "\(dependencies.installedSharedCharacterCount)")
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    /// Chooses resume when local state has an in-progress lesson; otherwise opens the featured record.
    private var homeLessonRoute: LessonRoute? {
        if let resumeRoute = userStateStore.state.resumeLessonRoute {
            return resumeRoute
        }
        guard let next = nextUnlearnedRecord else { return nil }
        return LessonRoute(sharedCharacterID: next.id, startingPosition: .origin)
    }

    /// Resolves the same record that Home will open, preventing resume/display mismatches.
    private var homeRecord: SharedCharacterRecord? {
        guard let route = homeLessonRoute else { return nil }
        return dependencies.sharedCharacters.first { $0.id == route.sharedCharacterID }
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
        guard let record = homeRecord else {
            return "You have reached the end of the bundled seed corpus."
        }

        return "Why this now: \(record.recognitionTakeaway)"
    }
}
