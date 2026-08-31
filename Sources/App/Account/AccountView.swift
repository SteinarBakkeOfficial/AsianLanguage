import SwiftUI

/// Lightweight local account/testing profile until real sync accounts are introduced.
struct AccountView: View {
    /// Shared dependencies used to summarize local testing progress.
    let dependencies: AppDependencies

    /// Local state store used for progress and saved counts.
    @ObservedObject private var userStateStore: LocalUserStateStore

    /// Creates the local account/testing profile screen.
    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _userStateStore = ObservedObject(wrappedValue: dependencies.userStateStore)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.spaceLg) {
                profileCard
                progressCard
                deferredAccountCard
            }
            .padding(AppSpacing.spacePage)
        }
        .scrollIndicators(.hidden)
        .navigationTitle("Account")
        .background(AppColors.appBackground.ignoresSafeArea())
        .tint(AppColors.accentPrimary)
    }

    /// Local-only state explanation; no fake profile identity is presented.
    private var profileCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Local data")
                .font(AppTypography.sectionHeading)
                .foregroundStyle(AppColors.textPrimary)
            Text("Progress, Favorites, Review Later, and preferences are saved only on this device. No account is required for V1.")
                .font(AppTypography.body)
                .foregroundStyle(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .groupedSurface()
    }

    /// Local progress summary for testing sessions.
    private var progressCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Testing Progress")
                .font(AppTypography.sectionHeading)
            LabeledContent("Installed corpus", value: dependencies.installedCorpusName)
            LabeledContent("Shared Characters", value: "\(dependencies.installedSharedCharacterCount)")
            LabeledContent("Learned", value: "\(learnedCount)")
            LabeledContent("Review later", value: "\(reviewLaterCount)")
            LabeledContent("Favorites", value: "\(favoriteCount)")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .groupedSurface()
    }

    /// Keeps the deferred account surface explicit without presenting fake account functionality.
    private var deferredAccountCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Account features deferred")
                .font(AppTypography.sectionHeading)
            Text("Sign-in, cloud sync, social profiles, and public account features are not part of V1. Progress remains local to this device.")
                .font(AppTypography.body)
                .foregroundStyle(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .groupedSurface()
    }

    /// Learned count from local state.
    private var learnedCount: Int {
        dependencies.sharedCharacters.filter { record in
            userStateStore.state.lessonStates[record.id]?.progressStatus == .learned
        }.count
    }

    /// Review-later count from local state.
    private var reviewLaterCount: Int {
        dependencies.sharedCharacters.filter { record in
            userStateStore.state.lessonStates[record.id]?.isReviewLater == true
        }.count
    }

    /// Favorites count from local state.
    private var favoriteCount: Int {
        dependencies.sharedCharacters.filter { record in
            userStateStore.state.lessonStates[record.id]?.isStarred == true
        }.count
    }
}
