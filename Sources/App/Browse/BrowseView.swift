import SwiftUI

/// Browse entry point for shallow curated discovery.
struct BrowseView: View {
    /// Shared app dependencies used for bundled corpus browsing.
    let dependencies: AppDependencies

    /// Local state store used for progress labels in Browse.
    @ObservedObject private var userStateStore: LocalUserStateStore

    /// Creates Browse with observed access to local user state.
    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _userStateStore = ObservedObject(wrappedValue: dependencies.userStateStore)
    }

    var body: some View {
        NavigationStack {
            Group {
                if dependencies.sharedCharacters.isEmpty {
                    ContentUnavailableView(
                        "No Shared Characters",
                        systemImage: "square.grid.2x2",
                        description: Text("The bundled corpus is empty.")
                    )
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 14) {
                            Text("Browse")
                                .font(.largeTitle.weight(.bold))
                            Text("Choose a symbol and follow it from picture idea to modern forms.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            NavigationLink("Search") { SearchView(dependencies: dependencies) }
                            NavigationLink("Collections") { CollectionsView(dependencies: dependencies) }
                            NavigationLink("In Progress") { BrowseStatusView(title: "In Progress", records: inProgressRecords, dependencies: dependencies) }
                            NavigationLink("Learned") { BrowseStatusView(title: "Learned", records: learnedRecords, dependencies: dependencies) }
                            ForEach(dependencies.sharedCharacters) { record in
                                Button {
                                    dependencies.navigationState.openSymbol(
                                        LessonRoute(sharedCharacterID: record.id, startingPosition: nil)
                                    )
                                } label: {
                                    browseRow(record)
                                }
                                .buttonStyle(.plain)
                            }

                            Text("Browse is intentionally shallow in V1: it follows the editorial teaching sequence and opens directly into Shared Character lessons.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Browse")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    /// Curated browse row with progress and recognition context.
    private func browseRow(_ record: SharedCharacterRecord) -> some View {
        HStack(alignment: .center, spacing: 12) {
            SymbolPictogramView(recordID: record.id, fallbackCharacter: record.coreCharacter)
                .frame(width: 88, height: 88)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(record.coreCharacter)
                        .font(.system(size: 42, weight: .regular, design: .serif))
                    Text(statusTitle(for: record))
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Color.green)
                }
                Text(record.coreSharedMeaning.capitalized)
                    .font(.headline)
                Text(record.recognitionTakeaway)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            Spacer()
            Image(systemName: "arrow.right.circle.fill")
                .foregroundStyle(Color.green)
        }
        .padding(12)
        .background(Color(red: 0.99, green: 0.96, blue: 0.88))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.brown.opacity(0.25), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    /// Local progress label for a record.
    private func statusTitle(for record: SharedCharacterRecord) -> String {
        userStateStore.state.lessonStates[record.id]?.progressStatus.rawValue ?? LessonProgressStatus.unseen.rawValue
    }

    private var inProgressRecords: [SharedCharacterRecord] {
        dependencies.sharedCharacters.filter { userStateStore.state.lessonStates[$0.id]?.progressStatus == .inProgress }
    }

    private var learnedRecords: [SharedCharacterRecord] {
        dependencies.sharedCharacters.filter { userStateStore.state.lessonStates[$0.id]?.progressStatus == .learned }
    }
}

/// Shared structural list for Browse status collections.
struct BrowseStatusView: View {
    let title: String
    let records: [SharedCharacterRecord]
    let dependencies: AppDependencies

    var body: some View {
        List {
            if records.isEmpty {
                ContentUnavailableView("Nothing here yet", systemImage: "tray", description: Text("No Shared Characters match this collection."))
            } else {
                ForEach(records) { record in
                    Button {
                        dependencies.navigationState.openSymbol(LessonRoute(sharedCharacterID: record.id, startingPosition: nil))
                    } label: {
                        Label("\(record.coreCharacter)  \(record.coreSharedMeaning)", systemImage: "character")
                    }
                }
            }
        }
        .navigationTitle(title)
    }
}
