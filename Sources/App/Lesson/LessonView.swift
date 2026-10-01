import SwiftUI
import UIKit

/// Canonical Symbol Journey host shared by Home, Browse, Search, History, and review entry points.
struct LessonView: View {
    let route: LessonRoute
    let dependencies: AppDependencies
    @ObservedObject private var userStateStore: LocalUserStateStore
    private let openingIntent: SymbolOpenIntent
    @State private var position: SymbolJourneyPosition
    @State private var entryMode: SymbolEntryMode
    @State private var showingAbout = false
    @State private var showingShareSheet = false
    @State private var showingCorpusComplete = false

    init(route: LessonRoute, dependencies: AppDependencies) {
        self.route = route
        self.dependencies = dependencies
        _userStateStore = ObservedObject(wrappedValue: dependencies.userStateStore)
        openingIntent = dependencies.navigationState.symbolOpenIntent ?? .view
        let savedState = dependencies.userStateStore.state.lessonStates[route.sharedCharacterID]
        let savedPosition = savedState?.lastPosition
        // Browse/search entries are fresh museum visits; only an explicit resume may use saved progress.
        let requestedPosition: SymbolJourneyPosition = openingIntent == .view
            ? .origin
            : (route.startingPosition ?? savedPosition ?? .origin)
        // Legacy supporting sections are no longer part of the primary flow; resume them at Modern.
        let normalizedPosition: SymbolJourneyPosition
        switch requestedPosition.section {
        case .structure, .summary, .usage:
            normalizedPosition = SymbolJourneyPosition(section: .today)
        case .evolution, .today:
            normalizedPosition = requestedPosition.stageID == "today"
                ? SymbolJourneyPosition(section: .today)
                : requestedPosition
        }
        _position = State(initialValue: normalizedPosition)
        let mode: SymbolEntryMode
        if dependencies.navigationState.symbolOpenIntent == .review || dependencies.navigationState.symbolOpenIntent == .reviewFromBrowse {
            mode = .review
        } else {
            mode = .journey
        }
        _entryMode = State(initialValue: mode)
    }

    private var sharedCharacter: SharedCharacterRecord? {
        try? dependencies.corpusRepository.sharedCharacter(id: route.sharedCharacterID)
    }

    private var learnedRecords: [SharedCharacterRecord] {
        dependencies.sharedCharacters.filter {
            userStateStore.state.lessonStates[$0.id]?.progressStatus == .learned
        }
    }

    var body: some View {
        Group {
            if showingCorpusComplete, let record = sharedCharacter {
                CompletionView(
                    record: record,
                    onReturnHome: {
                        showingCorpusComplete = false
                        dependencies.navigationState.selectedTab = .home
                    },
                    onRevisit: {
                        showingCorpusComplete = false
                        entryMode = .revisit
                    }
                )
            } else if let record = sharedCharacter {
                switch entryMode {
                case .journey:
                    journeyContent(record: record)
                case .revisit:
                    RevisitEntryView(
                        record: record,
                        learnedAt: userStateStore.state.lessonStates[record.id]?.learnedAt,
                        onRevisit: {
                            position = .origin
                            entryMode = .journey
                        },
                        onReview: {
                            entryMode = .review
                        },
                        onUsage: {
                            entryMode = .usage
                        }
                    )
                case .review:
                    QuickReviewView(
                        records: learnedRecords,
                        distractorRecords: dependencies.sharedCharacters,
                        focusSelection: userStateStore.state.focusSelection,
                        onOpenJourney: {
                            position = .origin
                            entryMode = .journey
                        },
                        onFinish: {
                            dependencies.navigationState.selectedTab = openingIntent == .reviewFromBrowse ? .browse : .home
                        }
                    )
                case .usage:
                    ScrollView {
                        UsageExamplesView(record: record, focusSelection: userStateStore.state.focusSelection)
                            .padding(AppSpacing.spacePage)
                    }
                    .scrollIndicators(.hidden)
                }
            } else {
                ContentUnavailableView("Symbol Unavailable", systemImage: "exclamationmark.triangle")
            }
        }
        .navigationTitle(entryMode == .review ? "Quick Review" : (sharedCharacter.map { "\(navigationMeaning(for: $0)) · \($0.coreCharacter)" } ?? "Symbol"))
        .navigationBarTitleDisplayMode(.inline)
        .background(AppColors.appBackground.ignoresSafeArea())
        .tint(AppColors.accentPrimary)
        .toolbar {
            if entryMode != .review {
                if openingIntent == .view || openingIntent == .reviewFromBrowse {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            dependencies.navigationState.selectedTab = .browse
                        } label: {
                            Label("Browse", systemImage: "chevron.left")
                        }
                        .accessibilityLabel("Back to Browse")
                    }
                } else {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            dependencies.navigationState.selectedTab = .home
                        } label: {
                            Label("Home", systemImage: "chevron.left")
                        }
                        .accessibilityLabel("Back to Home")
                    }
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        toggleFavorite()
                    } label: {
                        Image(systemName: isFavorite ? "star.fill" : "star")
                    }
                    .accessibilityLabel(isFavorite ? "Remove from Favorites" : "Add to Favorites")

                    IconActionButton(systemName: "ellipsis", accessibilityLabel: "About this character") {
                        showingAbout = true
                    }
                }
            }
        }
        .sheet(isPresented: $showingAbout) {
            if let record = sharedCharacter {
                CharacterAboutSheet(
                    record: record,
                    isReviewLater: isReviewLater,
                    onToggleReviewLater: toggleReviewLater,
                    onShare: {
                        showingAbout = false
                        showingShareSheet = true
                    },
                    onMarkLearned: markLearnedAndOpenNext
                )
            }
        }
        .sheet(isPresented: $showingShareSheet) {
            ActivityShareSheet(items: [shareText])
        }
        .alert("Journey complete", isPresented: $showingCorpusComplete) {
            Button("Done", role: .cancel) {}
        } message: {
            Text("You have completed the installed editorial sequence.")
        }
        .onAppear {
            // Direct viewing and stage context must not create progress; start/resume are meaningful entry actions.
            if openingIntent == .start || openingIntent == .resume {
                persistPositionIfNeeded()
            }
        }
    }

    /// Keeps concise navigation labels separate from fuller editorial meanings used in lesson content.
    private func navigationMeaning(for record: SharedCharacterRecord) -> String {
        let primaryMeaning = record.primarySharedMeaning
        let historicalQualifierRemoved = primaryMeaning
            .split(separator: "(", maxSplits: 1, omittingEmptySubsequences: true)
            .first
            .map(String.init) ?? primaryMeaning
        return historicalQualifierRemoved
            .split(separator: "/", maxSplits: 1, omittingEmptySubsequences: true)
            .first
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).capitalized }
            ?? primaryMeaning.capitalized
    }

    /// The historical spine and Modern/Usage endpoints share one horizontally swipeable museum pager.
    private func journeyContent(record: SharedCharacterRecord) -> some View {
        CharacterEvolutionView(
            record: record,
            focusSelection: userStateStore.state.focusSelection,
            completionTitle: dependencies.nextSharedCharacter(after: record.id) == nil ? "Complete Symbol" : "Next Symbol",
            onComplete: markLearnedAndOpenNext,
            selectedStageID: Binding(
                get: { position.section == .today ? normalizedModernStageID(position.stageID) : (position.stageID ?? "origin") },
                set: { stageID in
                    if openingIntent == .view {
                        // Browse/search inspection may scroll freely without creating progress.
                        position = isModernStageID(stageID)
                            ? SymbolJourneyPosition(section: .today, stageID: stageID)
                            : SymbolJourneyPosition(section: .evolution, stageID: stageID)
                    } else {
                        selectStage(stageID)
                    }
                }
            )
        )
    }

    private func selectStage(_ stageID: String) {
        if isModernStageID(stageID) {
            position = SymbolJourneyPosition(section: .today, stageID: stageID)
            persistPositionIfNeeded()
            return
        }
        position = SymbolJourneyPosition(section: .evolution, stageID: stageID)
        persistPositionIfNeeded()
    }

    /// Keeps positions written by the previous Today endpoint compatible with the Modern/Usage split.
    private func normalizedModernStageID(_ stageID: String?) -> String {
        guard let stageID, !stageID.isEmpty else { return "modern" }
        if stageID == "today" { return "modern" }
        if stageID.hasPrefix("today-") {
            return "usage-\(stageID.dropFirst("today-".count))"
        }
        return stageID
    }

    /// Modern and Usage pages share the `.today` persistence section for backwards-compatible state storage.
    private func isModernStageID(_ stageID: String) -> Bool {
        stageID == "modern" || stageID.hasPrefix("usage-") || stageID == "today" || stageID.hasPrefix("today-")
    }

    private func persistPositionIfNeeded() {
        // Meaningful start/resume or in-journey navigation owns the active journey state.
        userStateStore.setCurrentCharacter(route.sharedCharacterID)
        userStateStore.updateLessonState(sharedCharacterID: route.sharedCharacterID) { state in
            state.markInProgress(at: position)
        }
    }

    private var isFavorite: Bool {
        userStateStore.state.lessonStates[route.sharedCharacterID]?.isStarred == true
    }

    private var isReviewLater: Bool {
        userStateStore.state.lessonStates[route.sharedCharacterID]?.isReviewLater == true
    }

    private func toggleFavorite() {
        userStateStore.updateLessonState(sharedCharacterID: route.sharedCharacterID) { state in
            state.setStarred(!isFavorite)
        }
    }

    private func toggleReviewLater() {
        userStateStore.updateLessonState(sharedCharacterID: route.sharedCharacterID) { state in
            state.setReviewLater(!isReviewLater)
        }
    }

    /// Keeps sharing text-first and offline; no generated image or network dependency is introduced.
    private var shareText: String {
        guard let record = sharedCharacter else { return "Script Roots" }
        let stages = record.history.stages.compactMap { stage in
            stage.form.map { "\(stage.stage): \($0)" }
        }
        return ([
            "Script Roots",
            "\(record.coreCharacter) · \(record.primarySharedMeaning.capitalized)",
            record.recognitionTakeaway,
            stages.joined(separator: " → ")
        ] as [String]).filter { !$0.isEmpty }.joined(separator: "\n")
    }

    /// Completion remains explicit and preserves independent Favorite and Review Later state.
    private func markLearnedAndOpenNext() {
        showingAbout = false
        userStateStore.updateLessonState(sharedCharacterID: route.sharedCharacterID) { state in
            state.markLearned()
        }
        // A single restrained success cue acknowledges completion without gamifying the journey.
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        guard let next = dependencies.nextSharedCharacter(after: route.sharedCharacterID) else {
            showingCorpusComplete = true
            return
        }
        dependencies.navigationState.openSymbol(next.id, intent: .start)
    }
}

/// Calm completion state for the final installed record; completion is recognition, not a score.
private struct CompletionView: View {
    let record: SharedCharacterRecord
    let onReturnHome: () -> Void
    let onRevisit: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.spaceLg) {
                Text("JOURNEY COMPLETE")
                    .font(AppTypography.conceptLabel)
                    .tracking(1.4)
                    .foregroundStyle(AppColors.learned)
                Text(record.coreCharacter)
                    .font(.system(size: 128, design: .serif))
                    .foregroundStyle(AppColors.textPrimary)
                    .accessibilityLabel("Completed Shared Character \(record.coreCharacter)")
                Text("Well done")
                    .font(AppTypography.exhibitHeading)
                    .foregroundStyle(AppColors.textPrimary)
                Text("You have completed the journey of \(record.primarySharedMeaning.capitalized).")
                    .font(AppTypography.body)
                    .foregroundStyle(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 320)
                HStack(spacing: AppSpacing.spaceXl) {
                    completionMetric(value: "\(record.history.stages.count + 1)", label: "Stages")
                    completionMetric(value: "\(FocusTrack.allCases.count)", label: "Tracks")
                }
                VStack(spacing: AppSpacing.spaceSm) {
                    PrimaryActionButton("Return Home", action: onReturnHome)
                    SecondaryActionButton("Revisit \(record.primarySharedMeaning.capitalized)", action: onRevisit)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(AppSpacing.spacePage)
        }
        .scrollIndicators(.hidden)
    }

    private func completionMetric(value: String, label: String) -> some View {
        VStack(spacing: AppSpacing.space2xs) {
            Text(value)
                .font(AppTypography.sectionHeading)
                .foregroundStyle(AppColors.textPrimary)
            Text(label)
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.textSecondary)
        }
    }
}

/// Entry presentation is separate from progress so learned Symbols can be revisited without restarting.
private enum SymbolEntryMode {
    case journey
    case revisit
    case review
    case usage
}

/// Learned entry surface for a collected Symbol; it does not mutate progress on display.
private struct RevisitEntryView: View {
    let record: SharedCharacterRecord
    let learnedAt: Date?
    let onRevisit: () -> Void
    let onReview: () -> Void
    let onUsage: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.spaceLg) {
                Text("LEARNED")
                    .font(AppTypography.conceptLabel)
                    .tracking(1.4)
                    .foregroundStyle(AppColors.learned)
                Text(record.primarySharedMeaning.uppercased())
                    .font(AppTypography.stageTitle)
                    .foregroundStyle(AppColors.textPrimary)
                Text(record.coreCharacter)
                    .font(.system(size: 112, design: .serif))
                    .foregroundStyle(AppColors.textPrimary)
                    .accessibilityLabel("Modern form \(record.coreCharacter) of \(record.primarySharedMeaning)")
                Text("This Shared Character is part of what you know. Explore it again whenever you like.")
                    .font(AppTypography.body)
                    .foregroundStyle(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 320)
                if let learnedAt {
                    Text("Completed \(learnedAt.formatted(date: .abbreviated, time: .omitted))")
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColors.textTertiary)
                }
                VStack(spacing: AppSpacing.spaceSm) {
                    PrimaryActionButton("Revisit Journey", action: onRevisit)
                    SecondaryActionButton("Quick Review", action: onReview)
                    Button("View Usage", action: onUsage)
                        .font(AppTypography.body)
                        .foregroundStyle(AppColors.textSecondary)
                        .frame(minHeight: 44)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(AppSpacing.spacePage)
        }
        .scrollIndicators(.hidden)
    }
}

/// Recognition-oriented review tests one learned Symbol at a time without changing learner state.
private struct QuickReviewView: View {
    let onOpenJourney: () -> Void
    let onFinish: () -> Void
    @State private var cards: [QuickReviewCard]
    @State private var cardIndex = 0
    @State private var selectedOptionID: String?

    init(
        records: [SharedCharacterRecord],
        distractorRecords: [SharedCharacterRecord],
        focusSelection: FocusTrackSelection,
        onOpenJourney: @escaping () -> Void,
        onFinish: @escaping () -> Void
    ) {
        self.onOpenJourney = onOpenJourney
        self.onFinish = onFinish
        _cards = State(initialValue: QuickReviewCard.makeSession(
            records: records,
            distractorRecords: distractorRecords,
            focusSelection: focusSelection
        ))
    }

    private var currentCard: QuickReviewCard? {
        cards.indices.contains(cardIndex) ? cards[cardIndex] : nil
    }

    private var hasAnswered: Bool {
        selectedOptionID != nil
    }

    var body: some View {
        if let currentCard {
            ScrollView {
                VStack(spacing: AppSpacing.spaceLg) {
                    Text("QUICK REVIEW")
                        .font(AppTypography.conceptLabel)
                        .tracking(1.4)
                        .foregroundStyle(AppColors.textSecondary)
                    Text("SYMBOL \(cardIndex + 1) OF \(cards.count)")
                        .font(AppTypography.metadata)
                        .foregroundStyle(AppColors.textSecondary)
                    Text(currentCard.question)
                        .font(AppTypography.stageTitle)
                        .foregroundStyle(AppColors.textPrimary)
                        .multilineTextAlignment(.center)
                    if currentCard.promptIsSymbol {
                        ArtifactField {
                            Text(currentCard.prompt)
                                .font(.system(size: 112, design: .serif))
                                .foregroundStyle(AppColors.artifactInk)
                                .frame(maxWidth: .infinity, minHeight: 190)
                        }
                    } else {
                        GroupedSurface {
                            Text(currentCard.prompt)
                                .font(AppTypography.exhibitHeading)
                                .foregroundStyle(AppColors.textPrimary)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity, minHeight: 96)
                        }
                    }
                    VStack(spacing: AppSpacing.spaceXs) {
                        ForEach(currentCard.options) { option in
                            Button {
                                guard !hasAnswered else { return }
                                selectedOptionID = option.id
                            } label: {
                                HStack {
                                    optionText(option, for: currentCard)
                                    Spacer()
                                    if hasAnswered && option.id == currentCard.correctOptionID {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundStyle(AppColors.learned)
                                    } else if hasAnswered && option.id == selectedOptionID {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundStyle(AppColors.accentPrimary)
                                    }
                                }
                                .frame(
                                    maxWidth: .infinity,
                                    minHeight: currentCard.optionsAreSymbols ? 76 : 52,
                                    alignment: .leading
                                )
                                .padding(.horizontal, AppSpacing.spaceSm)
                                .background(optionBackground(option, for: currentCard))
                                .clipShape(RoundedRectangle(cornerRadius: AppRadius.small))
                                .overlay {
                                    RoundedRectangle(cornerRadius: AppRadius.small)
                                        .stroke(AppColors.separator, lineWidth: 1)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    if hasAnswered {
                        if selectedOptionID != currentCard.correctOptionID {
                            SecondaryActionButton("Check this Symbol", action: onOpenJourney)
                        }
                        PrimaryActionButton(cardIndex + 1 < cards.count ? "Next Symbol" : "Finish Review", action: advance)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(AppSpacing.spacePage)
            }
            .scrollIndicators(.hidden)
        } else {
            ContentUnavailableView(
                "No Learned Symbols",
                systemImage: "checkmark.circle",
                description: Text("Complete a Symbol Journey to begin Quick Review.")
            )
        }
    }

    private func optionBackground(_ option: QuickReviewOption, for card: QuickReviewCard) -> Color {
        guard hasAnswered else { return AppColors.surfaceElevated }
        if option.id == card.correctOptionID { return AppColors.learned.opacity(0.14) }
        if option.id == selectedOptionID { return AppColors.accentPrimary.opacity(0.12) }
        return AppColors.surfaceElevated
    }

    @ViewBuilder
    private func optionText(_ option: QuickReviewOption, for card: QuickReviewCard) -> some View {
        if card.optionsAreSymbols {
            Text(option.text)
                .font(.system(size: 42, design: .serif))
                .foregroundStyle(AppColors.textPrimary)
                .multilineTextAlignment(.leading)
        } else {
            Text(option.text)
                .font(AppTypography.body.weight(.semibold))
                .foregroundStyle(AppColors.textPrimary)
                .multilineTextAlignment(.leading)
        }
    }

    private func advance() {
        guard cardIndex + 1 < cards.count else {
            onFinish()
            return
        }
        cardIndex += 1
        selectedOptionID = nil
    }
}

private struct QuickReviewCard: Identifiable {
    let id: String
    let prompt: String
    let question: String
    let options: [QuickReviewOption]
    let correctOptionID: String
    let promptIsSymbol: Bool
    let optionsAreSymbols: Bool

    private enum QuestionKind {
        case meaningFromSymbol
        case symbolFromMeaning
        case targetLanguageForm
    }

    static func makeSession(
        records: [SharedCharacterRecord],
        distractorRecords: [SharedCharacterRecord],
        focusSelection: FocusTrackSelection
    ) -> [QuickReviewCard] {
        let activeTracks = focusSelection.selectedTracks
        var questionKinds: [QuestionKind] = [.meaningFromSymbol, .symbolFromMeaning]
        if !activeTracks.isEmpty {
            questionKinds.append(.targetLanguageForm)
        }
        questionKinds = questionKinds.shuffled()

        return records.shuffled().enumerated().map { index, record in
            let kind = questionKinds[index % questionKinds.count]
            switch kind {
            case .meaningFromSymbol:
                return meaningCard(record: record, distractorRecords: distractorRecords)
            case .symbolFromMeaning:
                return symbolCard(record: record, distractorRecords: distractorRecords)
            case .targetLanguageForm:
                let track = activeTracks[index % activeTracks.count]
                return targetLanguageCard(record: record, distractorRecords: distractorRecords, track: track)
            }
        }
    }

    private static func meaningCard(
        record: SharedCharacterRecord,
        distractorRecords: [SharedCharacterRecord]
    ) -> QuickReviewCard {
        let correctOption = QuickReviewOption(id: record.id, text: record.primarySharedMeaning.capitalized)
        let distractors = distractorRecords
            .filter { $0.id != record.id && $0.primarySharedMeaning != record.primarySharedMeaning }
            .shuffled()
            .prefix(2)
            .map { QuickReviewOption(id: "\(record.id)-\($0.id)", text: $0.primarySharedMeaning.capitalized) }
        return QuickReviewCard(
            id: record.id,
            prompt: record.coreCharacter,
            question: "What does this symbol mean?",
            options: ([correctOption] + distractors).shuffled(),
            correctOptionID: correctOption.id,
            promptIsSymbol: true,
            optionsAreSymbols: false
        )
    }

    private static func symbolCard(
        record: SharedCharacterRecord,
        distractorRecords: [SharedCharacterRecord]
    ) -> QuickReviewCard {
        let correctOption = QuickReviewOption(id: record.id, text: record.coreCharacter)
        let distractors = distractorRecords
            .filter { $0.id != record.id && $0.primarySharedMeaning != record.primarySharedMeaning }
            .shuffled()
            .prefix(2)
            .map { QuickReviewOption(id: "\(record.id)-\($0.id)", text: $0.coreCharacter) }
        return QuickReviewCard(
            id: record.id,
            prompt: record.primarySharedMeaning.capitalized,
            question: "Choose the symbol for this meaning:",
            options: ([correctOption] + distractors).shuffled(),
            correctOptionID: correctOption.id,
            promptIsSymbol: false,
            optionsAreSymbols: true
        )
    }

    private static func targetLanguageCard(
        record: SharedCharacterRecord,
        distractorRecords: [SharedCharacterRecord],
        track: FocusTrack
    ) -> QuickReviewCard {
        let correctAnswer = targetForm(for: record, track: track)
        let correctOption = QuickReviewOption(id: record.id, text: correctAnswer)
        let distractors = distractorRecords
            .filter { $0.id != record.id && targetForm(for: $0, track: track) != correctAnswer }
            .shuffled()
            .prefix(2)
            .map {
                QuickReviewOption(
                    id: "\(record.id)-\($0.id)",
                    text: targetForm(for: $0, track: track)
                )
            }
        return QuickReviewCard(
            id: record.id,
            prompt: record.primarySharedMeaning.capitalized,
            question: "How is this written in \(track.title)?",
            options: ([correctOption] + distractors).shuffled(),
            correctOptionID: correctOption.id,
            promptIsSymbol: false,
            optionsAreSymbols: true
        )
    }

    private static func targetForm(for record: SharedCharacterRecord, track: FocusTrack) -> String {
        switch track {
        case .simplifiedChinese:
            return record.focusCoverage.simplifiedChinese.form
        case .traditionalChinese:
            return record.focusCoverage.traditionalChinese.form
        case .japanese:
            return record.focusCoverage.japanese.form
        case .korean:
            return record.focusCoverage.korean.semanticEquivalents.first?.nativeReading
                ?? record.focusCoverage.korean.variants.first?.form
                ?? record.focusCoverage.korean.form
        }
    }
}

private struct QuickReviewOption: Identifiable {
    let id: String
    let text: String
}

/// Secondary information sheet keeps sources, provenance, and quiet actions out of the exhibit chrome.
private struct CharacterAboutSheet: View {
    let record: SharedCharacterRecord
    let isReviewLater: Bool
    let onToggleReviewLater: () -> Void
    let onShare: () -> Void
    let onMarkLearned: () -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section("About this character") {
                    Text(record.recognitionTakeaway)
                    Text(record.visuals.note).font(AppTypography.caption).foregroundStyle(AppColors.textSecondary)
                }
                Section("Character structure") {
                    Text(record.structure.summary)
                        .font(AppTypography.body)
                    if let caveat = record.structure.caveat {
                        Text(caveat)
                            .font(AppTypography.caption)
                            .foregroundStyle(AppColors.textSecondary)
                    }
                }
                Section("Actions") {
                    Button {
                        onToggleReviewLater()
                    } label: {
                        Label(
                            isReviewLater ? "Remove from Review Later" : "Review Later",
                            systemImage: isReviewLater ? "note.text" : "note"
                        )
                    }
                    Button {
                        dismiss()
                        onShare()
                    } label: {
                        Label("Share Symbol", systemImage: "square.and.arrow.up")
                    }
                    Button("Mark as Learned", action: onMarkLearned)
                        .foregroundStyle(AppColors.learned)
                }
            }
            .navigationTitle(record.coreCharacter)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .tint(AppColors.accentPrimary)
    }
}

/// Presents the system share sheet without coupling the lesson to online services.
private struct ActivityShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
