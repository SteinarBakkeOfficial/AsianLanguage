import SwiftUI

/// Canonical Symbol Journey host shared by Home, Browse, Search, History, and review entry points.
struct LessonView: View {
    let route: LessonRoute
    let dependencies: AppDependencies
    @ObservedObject private var userStateStore: LocalUserStateStore
    private let openingIntent: SymbolOpenIntent
    @State private var position: SymbolJourneyPosition
    @State private var entryMode: SymbolEntryMode
    @State private var showingAbout = false
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
        // Legacy supporting sections are no longer part of the primary flow; resume them at Today.
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
                        record: record,
                        onOpenJourney: {
                            position = .origin
                            entryMode = .journey
                        },
                        onFinish: {
                            if let next = dependencies.nextReviewLater(after: route.sharedCharacterID) {
                                let nextIntent: SymbolOpenIntent = openingIntent == .reviewFromBrowse ? .reviewFromBrowse : .review
                                dependencies.navigationState.openSymbol(next.id, intent: nextIntent)
                            } else {
                                dependencies.navigationState.selectedTab = openingIntent == .reviewFromBrowse ? .browse : .home
                            }
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
        .navigationTitle(sharedCharacter?.coreCharacter ?? "Symbol")
        .navigationBarTitleDisplayMode(.inline)
        .background(AppColors.appBackground.ignoresSafeArea())
        .tint(AppColors.accentPrimary)
        .toolbar {
            if openingIntent == .view || openingIntent == .reviewFromBrowse {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dependencies.navigationState.selectedTab = .browse
                    } label: {
                        Label("Browse", systemImage: "chevron.left")
                    }
                    .accessibilityLabel("Back to Browse")
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                IconActionButton(systemName: "ellipsis", accessibilityLabel: "About this character") {
                    showingAbout = true
                }
            }
        }
        .sheet(isPresented: $showingAbout) {
            if let record = sharedCharacter {
                CharacterAboutSheet(
                    record: record,
                    userStateStore: userStateStore,
                    onMarkLearned: markLearnedAndOpenNext
                )
            }
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

    /// The historical spine and Today endpoint share one horizontally swipeable museum pager.
    private func journeyContent(record: SharedCharacterRecord) -> some View {
        CharacterEvolutionView(
            record: record,
            focusSelection: userStateStore.state.focusSelection,
            completionTitle: dependencies.nextSharedCharacter(after: record.id) == nil ? "Complete Symbol" : "Next Symbol",
            onComplete: markLearnedAndOpenNext,
            selectedStageID: Binding(
                get: { position.section == .today ? (position.stageID ?? "today") : (position.stageID ?? "origin") },
                set: { stageID in
                    if openingIntent == .view {
                        // Browse/search inspection may scroll freely without creating progress.
                        position = stageID == "today" || stageID.hasPrefix("today-")
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
        if stageID == "today" || stageID.hasPrefix("today-") {
            position = SymbolJourneyPosition(section: .today, stageID: stageID)
            persistPositionIfNeeded()
            return
        }
        position = SymbolJourneyPosition(section: .evolution, stageID: stageID)
        persistPositionIfNeeded()
    }

    private func persistPositionIfNeeded() {
        // Meaningful start/resume or in-journey navigation owns the active journey state.
        userStateStore.setCurrentCharacter(route.sharedCharacterID)
        userStateStore.updateLessonState(sharedCharacterID: route.sharedCharacterID) { state in
            state.markInProgress(at: position)
        }
    }

    /// Completion remains explicit and preserves independent Favorite and Review Later state.
    private func markLearnedAndOpenNext() {
        showingAbout = false
        userStateStore.updateLessonState(sharedCharacterID: route.sharedCharacterID) { state in
            state.markLearned()
        }
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
                Text("You have completed the journey of \(record.coreSharedMeaning.capitalized).")
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
                    SecondaryActionButton("Revisit \(record.coreSharedMeaning.capitalized)", action: onRevisit)
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
                Text(record.coreSharedMeaning.uppercased())
                    .font(AppTypography.stageTitle)
                    .foregroundStyle(AppColors.textPrimary)
                Text(record.coreCharacter)
                    .font(.system(size: 112, design: .serif))
                    .foregroundStyle(AppColors.textPrimary)
                    .accessibilityLabel("Modern form \(record.coreCharacter) of \(record.coreSharedMeaning)")
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

/// Recognition-oriented review stays lightweight and always offers the complete journey as an escape hatch.
private struct QuickReviewView: View {
    let record: SharedCharacterRecord
    let onOpenJourney: () -> Void
    let onFinish: () -> Void
    @State private var questionIndex = 0
    @State private var isAnswerVisible = false

    private var questions: [QuickReviewQuestion] {
        var result: [QuickReviewQuestion] = []
        if let reviewStage = record.history.stages.first(where: { $0.form?.isEmpty == false }), let form = reviewStage.form {
            result.append(
                QuickReviewQuestion(
                    id: "historical-form",
                    question: "What character connects to this form?",
                    prompt: form,
                    answer: "\(record.coreCharacter) · \(record.coreSharedMeaning.capitalized)"
                )
            )
        }
        result.append(
            QuickReviewQuestion(
                id: "meaning",
                question: "What idea does this character carry?",
                prompt: record.coreCharacter,
                answer: record.coreSharedMeaning.capitalized
            )
        )
        if let reading = record.focusCoverage.simplifiedChinese.readings.first?.value {
            result.append(
                QuickReviewQuestion(
                    id: "mandarin-reading",
                    question: "How is it read in Mandarin?",
                    prompt: record.coreCharacter,
                    answer: reading
                )
            )
        }
        return Array(result.prefix(3))
    }

    private var currentQuestion: QuickReviewQuestion {
        questions[min(questionIndex, questions.count - 1)]
    }

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.spaceLg) {
                Text("QUICK REVIEW")
                    .font(AppTypography.conceptLabel)
                    .tracking(1.4)
                    .foregroundStyle(AppColors.textSecondary)
                Text("QUESTION \(questionIndex + 1) OF \(questions.count)")
                    .font(AppTypography.metadata)
                    .foregroundStyle(AppColors.textSecondary)
                Text(currentQuestion.question)
                    .font(AppTypography.stageTitle)
                    .foregroundStyle(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                ArtifactField {
                    Text(currentQuestion.prompt)
                        .font(.system(size: 112, design: .serif))
                        .foregroundStyle(AppColors.artifactInk)
                        .frame(maxWidth: .infinity, minHeight: 190)
                }
                if isAnswerVisible {
                    GroupedSurface {
                        Text(currentQuestion.answer)
                            .font(AppTypography.body.weight(.semibold))
                            .frame(maxWidth: .infinity)
                    }
                    PrimaryActionButton(questionIndex + 1 < questions.count ? "Next Question" : "Finish Review") {
                        if questionIndex + 1 < questions.count {
                            questionIndex += 1
                            isAnswerVisible = false
                        } else {
                            onFinish()
                        }
                    }
                } else {
                    SecondaryActionButton("Tap to Reveal") {
                        isAnswerVisible = true
                    }
                }
                Button("Open \(record.coreSharedMeaning.capitalized) Journey", action: onOpenJourney)
                    .font(AppTypography.body)
                    .foregroundStyle(AppColors.accentPrimary)
                    .frame(minHeight: 44)
            }
            .frame(maxWidth: .infinity)
            .padding(AppSpacing.spacePage)
        }
        .scrollIndicators(.hidden)
    }
}

/// One small recognition prompt keeps Quick Review useful without reopening the full museum journey.
private struct QuickReviewQuestion: Identifiable {
    let id: String
    let question: String
    let prompt: String
    let answer: String
}

/// Secondary information sheet keeps sources, provenance, and quiet actions out of the exhibit chrome.
private struct CharacterAboutSheet: View {
    let record: SharedCharacterRecord
    @ObservedObject var userStateStore: LocalUserStateStore
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
                Section("Sources") {
                    ForEach(record.sources, id: \.id) { source in
                        VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
                            Text(source.label)
                            Text(source.citation).font(AppTypography.caption).foregroundStyle(AppColors.textSecondary)
                        }
                    }
                }
                Section("Library") {
                    Button(isFavorite ? "Remove from Favorites" : "Add to Favorites") {
                        userStateStore.updateLessonState(sharedCharacterID: record.id) { state in
                            state.setStarred(!isFavorite)
                        }
                    }
                    Button(isReviewLater ? "Remove from Review Later" : "Save for Review Later") {
                        userStateStore.updateLessonState(sharedCharacterID: record.id) { state in
                            state.setReviewLater(!isReviewLater)
                        }
                    }
                }
                Section("Learning") {
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

    private var isFavorite: Bool {
        userStateStore.state.lessonStates[record.id]?.isStarred == true
    }

    private var isReviewLater: Bool {
        userStateStore.state.lessonStates[record.id]?.isReviewLater == true
    }
}
