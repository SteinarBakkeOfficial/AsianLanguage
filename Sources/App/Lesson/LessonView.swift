import SwiftUI

/// Canonical Symbol Journey host shared by Home, Browse, Search, History, and review entry points.
struct LessonView: View {
    let route: LessonRoute
    let dependencies: AppDependencies
    @ObservedObject private var userStateStore: LocalUserStateStore
    private let openingIntent: SymbolOpenIntent
    @State private var position: SymbolJourneyPosition
    @State private var entryMode: SymbolEntryMode
    @State private var showingReviewAnswer = false
    @State private var showingSummaryAnswer = false
    @State private var showingAbout = false
    @State private var showingCorpusComplete = false

    init(route: LessonRoute, dependencies: AppDependencies) {
        self.route = route
        self.dependencies = dependencies
        _userStateStore = ObservedObject(wrappedValue: dependencies.userStateStore)
        openingIntent = dependencies.navigationState.symbolOpenIntent ?? .view
        let savedState = dependencies.userStateStore.state.lessonStates[route.sharedCharacterID]
        let savedPosition = savedState?.lastPosition
        let requestedPosition = route.startingPosition ?? savedPosition ?? .origin
        // Today is a host section, even when a direct route names it as a journey endpoint.
        _position = State(initialValue: requestedPosition.stageID == "today" ? SymbolJourneyPosition(section: .today) : requestedPosition)
        let mode: SymbolEntryMode
        if dependencies.navigationState.symbolOpenIntent == .review {
            mode = .review
        } else if dependencies.navigationState.symbolOpenIntent == .view,
                  route.startingPosition == nil,
                  savedState?.progressStatus == .learned {
            mode = .revisit
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
                    if position.section == .evolution {
                        journeyContent(record: record)
                    } else {
                        supportingJourneyContent(record: record)
                    }
                case .revisit:
                    RevisitEntryView(
                        record: record,
                        learnedAt: userStateStore.state.lessonStates[record.id]?.learnedAt,
                        onRevisit: {
                            position = .origin
                            entryMode = .journey
                        },
                        onReview: {
                            showingReviewAnswer = false
                            entryMode = .review
                        },
                        onUsage: {
                            position = SymbolJourneyPosition(section: .usage)
                            entryMode = .journey
                        }
                    )
                case .review:
                    QuickReviewView(
                        record: record,
                        isAnswerVisible: $showingReviewAnswer,
                        onOpenJourney: {
                            position = .origin
                            entryMode = .journey
                        },
                        onContinue: {
                            showingReviewAnswer = false
                        }
                    )
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
            ToolbarItem(placement: .topBarTrailing) {
                IconActionButton(systemName: "ellipsis", accessibilityLabel: "About this character") {
                    showingAbout = true
                }
            }
        }
        .sheet(isPresented: $showingAbout) {
            if let record = sharedCharacter {
                CharacterAboutSheet(record: record, onMarkLearned: markLearnedAndOpenNext)
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

    /// Supporting sections use their own vertical scroll container and no second stage rail.
    private func supportingJourneyContent(record: SharedCharacterRecord) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.spaceLg) {
                journeyContent(record: record)
                journeyControls(record: record)
            }
            .padding(AppSpacing.spacePage)
        }
        .scrollIndicators(.hidden)
    }

    /// Evolution owns the horizontal pager; supporting sections use the same record without another progress rail.
    @ViewBuilder
    private func journeyContent(record: SharedCharacterRecord) -> some View {
        switch position.section {
        case .evolution:
            CharacterEvolutionView(
                record: record,
                focusSelection: userStateStore.state.focusSelection,
                onAdvance: { advance(record: record) },
                selectedStageID: Binding(
                    get: { position.stageID ?? "origin" },
                    set: { selectStage($0) }
                )
            )
        case .today:
            ModernFormsComparisonView(record: record, focusSelection: userStateStore.state.focusSelection)
        case .structure:
            structureContent(record: record)
        case .usage:
            UsageExamplesView(record: record, focusSelection: userStateStore.state.focusSelection)
        case .summary:
            summaryContent(record: record)
        }
    }

    /// Structure is a vertical recap of real stage forms and stage-aware component notes.
    private func structureContent(record: SharedCharacterRecord) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.spaceMd) {
            Text("STRUCTURE")
                .font(AppTypography.conceptLabel)
                .tracking(1.4)
                .foregroundStyle(AppColors.textSecondary)
            Text("How the form settles")
                .font(AppTypography.exhibitHeading)
                .foregroundStyle(AppColors.textPrimary)
            Text(record.structure.summary)
                .font(AppTypography.body)

            LineagePreview(record: record, variant: .contextual)

            if !record.structure.components.isEmpty {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(Array(record.structure.components.enumerated()), id: \.offset) { index, component in
                        VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
                            HStack(alignment: .firstTextBaseline) {
                                Text(component.label)
                                    .font(AppTypography.sectionHeading)
                                    .foregroundStyle(AppColors.textPrimary)
                                Spacer()
                                if let introducedAtStage = component.introducedAtStage {
                                    Text(introducedAtStage)
                                        .font(AppTypography.caption)
                                        .foregroundStyle(AppColors.textSecondary)
                                }
                            }
                            Text("\(component.role): \(component.meaningHint)")
                                .font(AppTypography.body)
                                .foregroundStyle(AppColors.textSecondary)
                            if let explanation = component.explanation {
                                Text(explanation)
                                    .font(AppTypography.caption)
                                    .foregroundStyle(AppColors.textSecondary)
                            }
                        }
                        .padding(.vertical, AppSpacing.spaceMd)
                        if index < record.structure.components.count - 1 {
                            Divider().overlay(AppColors.separator)
                        }
                    }
                }
            }
            if let caveat = record.structure.caveat {
                Text(caveat).font(AppTypography.caption).foregroundStyle(AppColors.textSecondary)
            }
        }
    }

    /// Summary is a recognition recap with one calm reveal interaction and no scoring.
    private func summaryContent(record: SharedCharacterRecord) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.spaceMd) {
            Text("SUMMARY")
                .font(AppTypography.conceptLabel)
                .tracking(1.4)
                .foregroundStyle(AppColors.textSecondary)
            Text("What do you recognize?")
                .font(AppTypography.exhibitHeading)
                .foregroundStyle(AppColors.textPrimary)
            Text("From the original idea to the modern form, what character is at the center of this journey?")
                .font(AppTypography.body)
                .foregroundStyle(AppColors.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
            if showingSummaryAnswer {
                GroupedSurface {
                    VStack(spacing: AppSpacing.space2xs) {
                        Text(record.coreCharacter)
                            .font(.system(size: 72, design: .serif))
                            .foregroundStyle(AppColors.textPrimary)
                        Text(record.coreSharedMeaning.capitalized)
                            .font(AppTypography.body.weight(.semibold))
                            .foregroundStyle(AppColors.textPrimary)
                    }
                    .frame(maxWidth: .infinity)
                }
            } else {
                SecondaryActionButton("Reveal Modern Form") {
                    showingSummaryAnswer = true
                }
            }
            Text(record.recognitionTakeaway)
                .font(AppTypography.body)
            Text("Sources / Notes")
                .font(AppTypography.sectionHeading)
            ForEach(record.notes, id: \.self) { Text($0).font(AppTypography.caption).foregroundStyle(AppColors.textSecondary) }
            ForEach(record.sources) { source in
                if let urlString = source.url, let url = URL(string: urlString) {
                    Link(source.label, destination: url)
                } else {
                    Text(source.label).font(AppTypography.caption).foregroundStyle(AppColors.textSecondary)
                }
            }
        }
    }

    /// Supporting content advances after Today; Evolution uses its own persistent navigator.
    private func journeyControls(record: SharedCharacterRecord) -> some View {
        PrimaryActionButton(position.section == .today ? "Continue to Structure" : "Continue") {
            advance(record: record)
        }
    }

    private func selectStage(_ stageID: String) {
        if stageID == "today" {
            position = SymbolJourneyPosition(section: .today)
            persistPositionIfNeeded()
            return
        }
        position = SymbolJourneyPosition(section: .evolution, stageID: stageID)
        persistPositionIfNeeded()
    }

    private func advance(record: SharedCharacterRecord) {
        if position.section == .evolution {
            let stageIDs = journeyStageIDs(record: record)
            if let stageIndex = stageIDs.firstIndex(of: position.stageID ?? "origin"), stageIndex + 1 < stageIDs.count {
                selectStage(stageIDs[stageIndex + 1])
            } else {
                position = SymbolJourneyPosition(section: .today)
                persistPositionIfNeeded()
            }
            return
        }

        guard let sectionIndex = SymbolJourneySection.allCases.firstIndex(of: position.section),
              sectionIndex + 1 < SymbolJourneySection.allCases.count else { return }
        position = SymbolJourneyPosition(section: SymbolJourneySection.allCases[sectionIndex + 1])
        persistPositionIfNeeded()
    }

    private func journeyStageIDs(record: SharedCharacterRecord) -> [String] {
        var ids = ["origin"]
        ids.append(contentsOf: record.history.stages.map(\.stage).filter { $0 != "origin" && $0 != "modernForms" && $0 != "today" })
        ids.append("today")
        return ids.enumerated().reduce(into: [String]()) { result, item in
            if !result.contains(item.element) { result.append(item.element) }
        }
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
    @Binding var isAnswerVisible: Bool
    let onOpenJourney: () -> Void
    let onContinue: () -> Void

    private var reviewStage: HistoricalStage? {
        record.history.stages.first { stage in
            guard let form = stage.form else { return false }
            return !form.isEmpty
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.spaceLg) {
                Text("QUICK REVIEW")
                    .font(AppTypography.conceptLabel)
                    .tracking(1.4)
                    .foregroundStyle(AppColors.textSecondary)
                Text("What character connects to this form?")
                    .font(AppTypography.stageTitle)
                    .foregroundStyle(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                if let reviewStage, let form = reviewStage.form {
                    ArtifactField {
                        Text(form)
                            .font(.system(size: 112, design: .serif))
                            .foregroundStyle(AppColors.artifactInk)
                            .frame(maxWidth: .infinity, minHeight: 190)
                            .accessibilityLabel("\(reviewStage.label) form")
                    }
                } else {
                    ArtifactField {
                        HistoricalMissingState(
                            title: "Review artwork not yet included",
                            detail: "An approved historical form is required for this recognition prompt."
                        )
                    }
                }
                if isAnswerVisible {
                    GroupedSurface {
                        VStack(spacing: AppSpacing.space2xs) {
                            Text(record.coreCharacter)
                                .font(.system(size: 48, design: .serif))
                            Text(record.coreSharedMeaning.capitalized)
                                .font(AppTypography.body.weight(.semibold))
                        }
                        .frame(maxWidth: .infinity)
                    }
                    PrimaryActionButton("Continue Review", action: onContinue)
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

/// Secondary information sheet keeps sources, provenance, and quiet actions out of the exhibit chrome.
private struct CharacterAboutSheet: View {
    let record: SharedCharacterRecord
    let onMarkLearned: () -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section("About this character") {
                    Text(record.recognitionTakeaway)
                    Text(record.visuals.note).font(AppTypography.caption).foregroundStyle(AppColors.textSecondary)
                }
                Section("Sources") {
                    ForEach(record.sources) { source in
                        VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
                            Text(source.label)
                            Text(source.citation).font(AppTypography.caption).foregroundStyle(AppColors.textSecondary)
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
}
