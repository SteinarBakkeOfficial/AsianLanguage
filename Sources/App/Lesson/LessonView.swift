import SwiftUI

/// Structural Symbol Journey host; final visual composition is supplied by the approved Fire design.
struct LessonView: View {
    let route: LessonRoute
    let dependencies: AppDependencies
    @ObservedObject private var userStateStore: LocalUserStateStore
    @State private var position: SymbolJourneyPosition
    @State private var showingCorpusComplete = false

    init(route: LessonRoute, dependencies: AppDependencies) {
        self.route = route
        self.dependencies = dependencies
        _userStateStore = ObservedObject(wrappedValue: dependencies.userStateStore)
        let savedPosition = dependencies.userStateStore.state.lessonStates[route.sharedCharacterID]?.lastPosition
        _position = State(initialValue: route.startingPosition ?? savedPosition ?? .origin)
    }

    private var sharedCharacter: SharedCharacterRecord? {
        try? dependencies.corpusRepository.sharedCharacter(id: route.sharedCharacterID)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                if let record = sharedCharacter {
                    Text(record.coreSharedMeaning.capitalized)
                        .font(.title2.weight(.bold))
                    journeyContent(record: record)
                    journeyControls(record: record)
                    lessonActions
                } else {
                    ContentUnavailableView("Symbol Unavailable", systemImage: "exclamationmark.triangle")
                }
            }
            .padding()
        }
        .navigationTitle(sharedCharacter?.coreCharacter ?? "Symbol")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Corpus complete", isPresented: $showingCorpusComplete) {
            Button("Done", role: .cancel) {}
        } message: {
            Text("You have reached the end of the installed editorial sequence.")
        }
        .onAppear { persistPositionIfNeeded() }
    }

    /// Displays one primary journey section without reinstating the obsolete six-step rail.
    @ViewBuilder
    private func journeyContent(record: SharedCharacterRecord) -> some View {
        switch position.section {
        case .evolution:
            CharacterEvolutionView(
                record: record,
                focusSelection: userStateStore.state.focusSelection,
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

    /// Neutral structural representation of Character structure until the approved design exists.
    private func structureContent(record: SharedCharacterRecord) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Character structure").font(.headline)
            Text(record.structure.summary)
            ForEach(record.structure.components, id: \.self) { component in
                VStack(alignment: .leading, spacing: 2) {
                    Text(component.label).font(.headline)
                    Text("\(component.role): \(component.meaningHint)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            if let caveat = record.structure.caveat {
                Text(caveat).font(.caption).foregroundStyle(.secondary)
            }
        }
    }

    /// Summary content remains available as an internal content phase.
    private func summaryContent(record: SharedCharacterRecord) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(record.recognitionTakeaway)
            Text("Sources / Notes").font(.headline)
            ForEach(record.notes, id: \.self) { Text($0).font(.caption).foregroundStyle(.secondary) }
            ForEach(record.sources) { source in
                if let urlString = source.url, let url = URL(string: urlString) {
                    Link(source.label, destination: url)
                } else {
                    Text(source.label).font(.caption).foregroundStyle(.secondary)
                }
            }
        }
    }

    /// Advances within the Symbol Journey, then through the supporting content phases.
    private func journeyControls(record: SharedCharacterRecord) -> some View {
        HStack {
            Button("Continue") { advance(record: record) }
                .buttonStyle(.borderedProminent)
            Text(positionLabel(record: record))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var lessonActions: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Button("Restart lesson") { restartLesson() }
                Button(userStateStore.state.lessonStates[route.sharedCharacterID]?.isReviewLater == true ? "Remove Review" : "Review later") {
                    toggleReviewLater()
                }
                Button(userStateStore.state.lessonStates[route.sharedCharacterID]?.isStarred == true ? "Unfavorite" : "Favorite") {
                    toggleFavorite()
                }
            }
            .buttonStyle(.bordered)

            Button("Mark as Learned") { markLearnedAndOpenNext() }
                .buttonStyle(.borderedProminent)
        }
    }

    private func selectStage(_ stageID: String) {
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
        ids.append("modernForms")
        var uniqueIDs: [String] = []
        for id in ids where !uniqueIDs.contains(id) {
            uniqueIDs.append(id)
        }
        return uniqueIDs
    }

    private func positionLabel(record: SharedCharacterRecord) -> String {
        if position.section == .evolution { return position.stageID ?? "origin" }
        return position.section.rawValue
    }

    private func persistPositionIfNeeded() {
        // Keep Home's resumable target explicit instead of deriving it from corpus order.
        userStateStore.setCurrentCharacter(route.sharedCharacterID)
        userStateStore.updateLessonState(sharedCharacterID: route.sharedCharacterID) { state in
            state.markInProgress(at: position)
        }
    }

    private func restartLesson() {
        position = .origin
        userStateStore.updateLessonState(sharedCharacterID: route.sharedCharacterID) { state in
            state.restart()
        }
    }

    private func toggleReviewLater() {
        let current = userStateStore.state.lessonStates[route.sharedCharacterID]?.isReviewLater == true
        userStateStore.updateLessonState(sharedCharacterID: route.sharedCharacterID) { $0.setReviewLater(!current) }
    }

    private func toggleFavorite() {
        let current = userStateStore.state.lessonStates[route.sharedCharacterID]?.isStarred == true
        userStateStore.updateLessonState(sharedCharacterID: route.sharedCharacterID) { $0.setStarred(!current) }
    }

    private func markLearnedAndOpenNext() {
        userStateStore.updateLessonState(sharedCharacterID: route.sharedCharacterID) { $0.markLearned() }
        guard let next = dependencies.nextSharedCharacter(after: route.sharedCharacterID) else {
            showingCorpusComplete = true
            return
        }
        dependencies.navigationState.openSymbol(
            LessonRoute(sharedCharacterID: next.id, startingPosition: .origin)
        )
    }
}
