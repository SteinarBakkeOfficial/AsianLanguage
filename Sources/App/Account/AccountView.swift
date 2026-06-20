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
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    profileCard
                    progressCard
                    testingAccessCard
                }
                .padding()
            }
            .navigationTitle("Account")
        }
    }

    /// Local tester identity card; real sign-in remains a future implementation.
    private var profileCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 12) {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(Color.green)
                VStack(alignment: .leading, spacing: 3) {
                    Text("Local Tester")
                        .font(.title3.weight(.bold))
                    Text("Progress is saved only on this device.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 0.99, green: 0.96, blue: 0.88))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.brown.opacity(0.25), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    /// Local progress summary for testing sessions.
    private var progressCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Testing Progress")
                .font(.headline)
            LabeledContent("Installed corpus", value: dependencies.installedCorpusName)
            LabeledContent("Shared Characters", value: "\(dependencies.installedSharedCharacterCount)")
            LabeledContent("Learned", value: "\(learnedCount)")
            LabeledContent("Review later", value: "\(reviewLaterCount)")
            LabeledContent("Favorites", value: "\(favoriteCount)")
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    /// Public-testing account features reserved without pretending sync exists.
    private var testingAccessCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Public Testing Account")
                .font(.headline)
            Text("Real sign-in, sync, tester invitations, and release access are reserved for the public-testing build. This screen keeps the agreed account page visible without inventing a backend.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8))
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
