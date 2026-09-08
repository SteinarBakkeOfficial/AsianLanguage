import SwiftUI

/// Local progress summary; V1 deliberately has no identity or cloud account.
struct AccountView: View {
    /// Shared dependencies used to summarize local progress.
    let dependencies: AppDependencies

    /// Local state store used for progress and saved counts.
    @ObservedObject private var userStateStore: LocalUserStateStore

    /// Creates the local progress screen.
    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _userStateStore = ObservedObject(wrappedValue: dependencies.userStateStore)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.spaceLg) {
                learningCard
                offlineLibraryCard
                dataCard
            }
            .padding(AppSpacing.spacePage)
        }
        .scrollIndicators(.hidden)
        .navigationTitle("Your Progress")
        .background(AppColors.appBackground.ignoresSafeArea())
        .tint(AppColors.accentPrimary)
    }

    /// Shows durable learning state without implying a cloud account.
    private var learningCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Learning")
                .font(AppTypography.sectionHeading)
                .foregroundStyle(AppColors.textPrimary)
            LabeledContent("Characters learned", value: "\(learnedCount)")
            LabeledContent("Review later", value: "\(reviewLaterCount)")
            LabeledContent("Favorites", value: "\(favoriteCount)")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .groupedSurface()
    }

    /// Explains what is available without exposing the internal corpus identifier.
    private var offlineLibraryCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("On this device")
                .font(AppTypography.sectionHeading)
            LabeledContent("Offline library", value: "\(dependencies.installedSharedCharacterCount) characters")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .groupedSurface()
    }

    /// Makes local storage scope clear without presenting deferred account features.
    private var dataCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Your data")
                .font(AppTypography.sectionHeading)
            Text("Your learning progress, favorites, review list, and preferences are stored on this device.")
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
