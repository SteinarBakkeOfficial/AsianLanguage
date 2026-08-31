import SwiftUI

/// Search entry point for character forms, English glosses, and readings.
struct SearchView: View {
    /// Shared app dependencies used for offline corpus search.
    let dependencies: AppDependencies

    /// Local state store used to show progress context in results.
    @ObservedObject private var userStateStore: LocalUserStateStore

    /// Search text entered by the learner.
    @State private var query = ""
    @Environment(\.dismiss) private var dismiss

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _userStateStore = ObservedObject(wrappedValue: dependencies.userStateStore)
    }

    /// Local in-memory index for the installed bundled corpus.
    private var searchIndex: SharedCharacterSearchIndex {
        SharedCharacterSearchIndex(records: dependencies.sharedCharacters)
    }

    /// Search results matching the current query.
    private var searchResults: [SharedCharacterRecord] {
        searchIndex.search(query)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.spaceLg) {
                AppSearchField(
                    text: $query,
                    prompt: "Character, meaning, or reading",
                    onCancel: { dismiss() }
                )

                if searchResults.isEmpty {
                    VStack(alignment: .leading, spacing: AppSpacing.spaceSm) {
                        Text(query.isEmpty ? "Search Shared Characters" : "No characters found")
                            .font(AppTypography.exhibitHeading)
                            .foregroundStyle(AppColors.textPrimary)
                        Text("Try another character, English meaning, reading, or romanization.")
                            .font(AppTypography.body)
                            .foregroundStyle(AppColors.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, AppSpacing.spaceSection)
                } else {
                    ForEach(searchResults) { record in
                        Button {
                            dependencies.navigationState.openSymbol(
                                LessonRoute(sharedCharacterID: record.id, startingPosition: nil)
                            )
                        } label: {
                            resultRow(record)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(AppSpacing.spacePage)
        }
        .scrollIndicators(.hidden)
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
        .background(AppColors.appBackground.ignoresSafeArea())
        .tint(AppColors.accentPrimary)
    }

    /// Text-first result hierarchy keeps the character prominent without a fake historical thumbnail.
    private func resultRow(_ record: SharedCharacterRecord) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.spaceXs) {
            HStack(alignment: .firstTextBaseline, spacing: AppSpacing.spaceSm) {
                Text(record.coreCharacter)
                    .font(.system(size: 44, weight: .regular, design: .serif))
                    .foregroundStyle(AppColors.textPrimary)
                Text(record.coreSharedMeaning.capitalized)
                    .font(AppTypography.body.weight(.semibold))
                    .foregroundStyle(AppColors.textPrimary)
                Spacer(minLength: 0)
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(AppColors.textTertiary)
                    .accessibilityHidden(true)
            }
            if let matchDescription = matchDescription(for: record) {
                Text(matchDescription)
                    .font(AppTypography.metadata)
                    .foregroundStyle(AppColors.textSecondary)
            }
            Text(statusTitle(for: record))
                .font(AppTypography.caption)
                .foregroundStyle(statusColor(for: record))
        }
        .padding(.vertical, AppSpacing.spaceSm)
        .overlay(alignment: .bottom) {
            Divider().overlay(AppColors.separator)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(record.coreCharacter), \(record.coreSharedMeaning), \(matchDescription(for: record) ?? ""), \(statusTitle(for: record))")
    }

    /// Compact reading summary for quick recognition while browsing results.
    private func readingSummary(for record: SharedCharacterRecord) -> String {
        let mandarin = record.focusCoverage.simplifiedChinese.readings.first?.value
        let japanese = record.focusCoverage.japanese.readings.first?.value
        let korean = record.focusCoverage.korean.readings.first?.value
        return [mandarin, japanese, korean].compactMap { $0 }.joined(separator: " / ")
    }

    /// Explains a reading match only when the query is more useful than the plain gloss result.
    private func matchDescription(for record: SharedCharacterRecord) -> String? {
        let normalized = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !normalized.isEmpty else { return readingSummary(for: record).isEmpty ? nil : readingSummary(for: record) }
        let matches: [(String, [CharacterReading])] = [
            ("Mandarin", record.focusCoverage.simplifiedChinese.readings),
            ("Traditional Chinese", record.focusCoverage.traditionalChinese.readings),
            ("Japanese", record.focusCoverage.japanese.readings),
            ("Korean", record.focusCoverage.korean.readings)
        ]
        for (label, readings) in matches where readings.contains(where: { $0.value.localizedCaseInsensitiveContains(normalized) }) {
            return "\(label) · \(readings.first?.value ?? "")"
        }
        return readingSummary(for: record).isEmpty ? nil : readingSummary(for: record)
    }

    private func statusTitle(for record: SharedCharacterRecord) -> String {
        switch userStateStore.state.lessonStates[record.id]?.progressStatus {
        case .learned: return "Learned"
        case .inProgress: return "In progress"
        default: return "Not started"
        }
    }

    private func statusColor(for record: SharedCharacterRecord) -> Color {
        userStateStore.state.lessonStates[record.id]?.progressStatus == .learned ? AppColors.learned : AppColors.textSecondary
    }
}
