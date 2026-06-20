import SwiftUI

/// Dedicated Languages page for choosing the focus tracks shown in lessons.
struct LanguagesView: View {
    /// Shared dependencies used to access local state.
    let dependencies: AppDependencies

    /// Local state store for focus-track preferences.
    @ObservedObject private var userStateStore: LocalUserStateStore

    /// Creates the Languages page.
    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _userStateStore = ObservedObject(wrappedValue: dependencies.userStateStore)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    headerCard
                    ForEach(FocusTrack.allCases) { track in
                        languageCard(for: track)
                    }
                }
                .padding()
            }
            .navigationTitle("Languages")
        }
    }

    /// Intro card explaining multi-select focus behavior.
    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Choose Focus Tracks")
                .font(.title2.weight(.bold))
            Text("All tracks are enabled by default. Turn tracks off only when you want lessons, modern forms, and examples narrowed for a test session.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
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

    /// One focus-track card with visible enabled state.
    private func languageCard(for track: FocusTrack) -> some View {
        Toggle(isOn: focusTrackBinding(for: track)) {
            VStack(alignment: .leading, spacing: 5) {
                Text(track.title)
                    .font(.headline)
                Text(description(for: track))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .toggleStyle(.switch)
        .padding(14)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    /// Short learner-facing track description.
    private func description(for track: FocusTrack) -> String {
        switch track {
        case .simplifiedChinese:
            return "Modern mainland-style forms, Mandarin readings, and simplified examples."
        case .traditionalChinese:
            return "Traditional forms with Taiwan and Hong Kong example sets."
        case .japanese:
            return "Kanji forms with on and kun readings."
        case .korean:
            return "Hanja recognition with Korean Hanja and native-word context."
        }
    }

    /// Binding that writes one focus-track toggle into persisted local user state.
    private func focusTrackBinding(for track: FocusTrack) -> Binding<Bool> {
        Binding(
            get: { userStateStore.state.focusSelection.contains(track) },
            set: { userStateStore.setFocusTrack(track, isSelected: $0) }
        )
    }
}
