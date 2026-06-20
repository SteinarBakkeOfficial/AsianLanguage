import SwiftUI

/// Guided six-step Shared Character lesson shell.
struct LessonView: View {
    /// Route selected from Home, Search, Browse, Saved, or related lesson entry points.
    let route: LessonRoute

    /// Shared app dependencies used to resolve corpus and user state.
    let dependencies: AppDependencies

    /// Local state store used to persist resume and learned status.
    @ObservedObject private var userStateStore: LocalUserStateStore

    /// Current visible lesson step.
    @State private var selectedStep: LessonStep

    /// Steps visited in this lesson session; persisted through user state as progress matures.
    @State private var visitedSteps: Set<LessonStep>

    /// Route opened after completing the current Shared Character.
    @State private var nextLessonRoute: LessonRoute?

    /// Creates a lesson view at the routed starting step.
    init(route: LessonRoute, dependencies: AppDependencies) {
        let startingStep = route.startingStep ?? .origin
        self.route = route
        self.dependencies = dependencies
        _userStateStore = ObservedObject(wrappedValue: dependencies.userStateStore)
        _selectedStep = State(initialValue: startingStep)
        _visitedSteps = State(initialValue: [startingStep])
    }

    /// Bundled corpus record for this route, if the draft resource can be decoded.
    private var sharedCharacter: SharedCharacterRecord? {
        try? dependencies.corpusRepository.sharedCharacter(id: route.sharedCharacterID)
    }

    var body: some View {
        let record = sharedCharacter
        let lessonState = userStateStore.state.lessonStates[route.sharedCharacterID]

        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                heroSection(record: record)
                stepRail
                contentPanel(record: record)
                lessonActions(lessonState: lessonState)
            }
            .padding()
        }
        .navigationTitle(record?.coreCharacter ?? "Lesson")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            startLessonIfNeeded()
        }
    }

    /// Hero area mirrors the reference idea: original meaning, main symbol, and sound snapshot.
    private func heroSection(record: SharedCharacterRecord?) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center, spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("New Symbol")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                    Text(record?.coreSharedMeaning.capitalized ?? "Shared Character")
                        .font(.title2.weight(.bold))
                    Text(record?.history.originAnchor ?? "Historical origin notes will appear here.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(4)
                }

                Spacer()

                Text(record?.coreCharacter ?? route.sharedCharacterID)
                    .font(.system(size: 74, weight: .regular, design: .serif))
                    .frame(width: 108, height: 108)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.accentColor.opacity(0.45), lineWidth: 1)
                    )
            }

            if let record {
                Text(soundSummary(for: record))
                    .font(.subheadline.weight(.semibold))
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.blue.opacity(0.10))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .padding(14)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    /// Horizontal guided-step rail, preserving the agreed six-step lesson flow.
    private var stepRail: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(LessonStep.allCases) { step in
                    Button {
                        selectStep(step)
                    } label: {
                        VStack(spacing: 6) {
                            Text(step.title)
                                .font(.caption.weight(step == selectedStep ? .bold : .regular))
                            Circle()
                                .fill(progressColor(for: step))
                                .frame(width: 8, height: 8)
                        }
                        .frame(minWidth: 86)
                        .padding(.vertical, 8)
                    }
                    .buttonStyle(.bordered)
                    .disabled(!canSelectStep(step))
                }
            }
        }
    }

    /// Framed lesson content area for the active step.
    private func contentPanel(record: SharedCharacterRecord?) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(selectedStep.title)
                .font(.title3.weight(.semibold))
            stepContent(record: record)
        }
        .padding(14)
        .background(Color(.systemBackground))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.secondary.opacity(0.25), lineWidth: 1)
        )
    }

    /// Action cluster for progress and saved-state changes.
    private func lessonActions(lessonState: LessonUserState?) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            if selectedStep != .summary {
                Button("Continue") {
                    continueToNextStep()
                }
                .buttonStyle(.borderedProminent)
            }

            HStack {
                Button("Restart lesson") {
                    restartLesson()
                }

                Button(lessonState?.isReviewLater == true ? "Remove Review" : "Review later") {
                    toggleReviewLater()
                }

                Button(lessonState?.isStarred == true ? "Unfavorite" : "Favorite") {
                    toggleFavorite()
                }
            }
            .buttonStyle(.bordered)

            Button("Mark as Learned") {
                markLearnedAndPrepareNextSymbol()
            }
            .buttonStyle(.borderedProminent)

            if let nextLessonRoute {
                NavigationLink("Next Symbol", value: nextLessonRoute)
                    .buttonStyle(.borderedProminent)
            }
        }
    }

    /// Selects and persists a step when it is reachable from the current session.
    private func selectStep(_ step: LessonStep) {
        guard canSelectStep(step) || step == selectedStep else {
            return
        }

        selectedStep = step
        visitedSteps.insert(step)
        userStateStore.updateLessonState(sharedCharacterID: route.sharedCharacterID) { state in
            state.markInProgress(at: step)
        }
    }

    /// Restarts the lesson at Origin and records the new resume point.
    private func restartLesson() {
        visitedSteps = [.origin]
        selectedStep = .origin
        userStateStore.updateLessonState(sharedCharacterID: route.sharedCharacterID) { state in
            state.markInProgress(at: .origin)
        }
        nextLessonRoute = nil
    }

    /// Toggles review-later state for the lesson and keeps it exclusive with learned.
    private func toggleReviewLater() {
        let isCurrentlyReviewLater = userStateStore.state.lessonStates[route.sharedCharacterID]?.isReviewLater == true
        userStateStore.updateLessonState(sharedCharacterID: route.sharedCharacterID) { state in
            state.setReviewLater(!isCurrentlyReviewLater)
        }
    }

    /// Toggles favorite state independently from progress.
    private func toggleFavorite() {
        let isCurrentlyStarred = userStateStore.state.lessonStates[route.sharedCharacterID]?.isStarred == true
        userStateStore.updateLessonState(sharedCharacterID: route.sharedCharacterID) { state in
            state.setStarred(!isCurrentlyStarred)
        }
    }

    /// Advances to the next guided step when one remains.
    private func continueToNextStep() {
        guard let selectedIndex = LessonStep.allCases.firstIndex(of: selectedStep) else {
            return
        }

        let nextIndex = LessonStep.allCases.index(after: selectedIndex)
        guard nextIndex < LessonStep.allCases.endIndex else {
            return
        }

        selectStep(LessonStep.allCases[nextIndex])
    }

    /// Marks the lesson learned and exposes the next symbol in teaching order when available.
    private func markLearnedAndPrepareNextSymbol() {
        userStateStore.updateLessonState(sharedCharacterID: route.sharedCharacterID) { state in
            state.markLearned()
        }

        nextLessonRoute = dependencies
            .nextSharedCharacter(after: route.sharedCharacterID)
            .map { LessonRoute(sharedCharacterID: $0.id, startingStep: .origin) }
    }

    /// Starts a lesson only when it is not already learned.
    private func startLessonIfNeeded() {
        let currentStatus = userStateStore.state.lessonStates[route.sharedCharacterID]?.progressStatus
        guard currentStatus != .learned else {
            return
        }

        selectStep(selectedStep)
    }

    /// Allows current, visited, and immediately next steps while keeping future steps locked.
    private func canSelectStep(_ step: LessonStep) -> Bool {
        guard let stepIndex = LessonStep.allCases.firstIndex(of: step),
              let selectedIndex = LessonStep.allCases.firstIndex(of: selectedStep) else {
            return false
        }

        return visitedSteps.contains(step) || stepIndex <= selectedIndex + 1
    }

    /// Visual status for the step progress controls.
    private func progressColor(for step: LessonStep) -> Color {
        if step == selectedStep {
            return .accentColor
        }
        if visitedSteps.contains(step) {
            return .secondary
        }
        return .clear
    }

    /// Compact modern sound summary for the hero card.
    private func soundSummary(for record: SharedCharacterRecord) -> String {
        let simplified = record.focusCoverage.simplifiedChinese.readings.map(\.value).joined(separator: " / ")
        let traditional = record.focusCoverage.traditionalChinese.readings.map(\.value).joined(separator: " / ")
        let japanese = record.focusCoverage.japanese.readings.map(\.value).joined(separator: " / ")
        let korean = record.focusCoverage.korean.readings.map(\.value).joined(separator: " / ")
        return "Sound: Mandarin \(simplified); Traditional \(traditional); Japanese \(japanese); Korean Hanja \(korean)"
    }

    /// Displays source transparency in the Summary step, linking URL-backed sources when available.
    private func sourceRow(_ source: CorpusSource) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            if let urlText = source.url, let url = URL(string: urlText) {
                Link(source.label, destination: url)
                    .font(.caption.weight(.semibold))
            } else {
                Text(source.label)
                    .font(.caption.weight(.semibold))
            }
            Text(source.citation)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    /// Renders the current lesson step from the bundled corpus record.
    @ViewBuilder
    private func stepContent(record: SharedCharacterRecord?) -> some View {
        switch selectedStep {
        case .origin:
            if let record {
                CharacterEvolutionView(history: record.history, fallbackForm: record.coreCharacter)
            } else {
                Text("Origin notes will appear here.")
            }
        case .character:
            if let record {
                VStack(alignment: .leading, spacing: 12) {
                    Text(record.coreCharacter)
                        .font(.system(size: 72, weight: .regular, design: .serif))
                    Text(record.coreSharedMeaning.capitalized)
                        .font(.headline)
                    Text(record.recognitionTakeaway)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            } else {
                Text("Character notes will appear here.")
            }
        case .modernForms:
            if let record {
                ModernFormsComparisonView(record: record, focusSelection: userStateStore.state.focusSelection)
            } else {
                Text("Modern forms will appear here.")
            }
        case .structure:
            if let record {
                VStack(alignment: .leading, spacing: 12) {
                    Text(record.structure.summary)
                    ForEach(record.structure.components, id: \.self) { component in
                        VStack(alignment: .leading, spacing: 2) {
                            Text(component.label)
                                .font(.headline)
                            Text("\(component.role): \(component.meaningHint)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    if let caveat = record.structure.caveat {
                        Text(caveat)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            } else {
                Text("Structure notes will appear here.")
            }
        case .usage:
            if let record {
                UsageExamplesView(record: record, focusSelection: userStateStore.state.focusSelection)
            } else {
                Text("Usage examples will appear here.")
            }
        case .summary:
            if let record {
                VStack(alignment: .leading, spacing: 12) {
                    Text(record.recognitionTakeaway)
                    Text("Sources / Notes")
                        .font(.headline)
                    ForEach(record.sources, id: \.self) { source in
                        sourceRow(source)
                    }
                    ForEach(record.notes, id: \.self) { note in
                        Text(note)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            } else {
                Text("Recognition takeaway will appear here.")
            }
        }
    }
}
