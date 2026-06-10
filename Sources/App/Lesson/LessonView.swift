import SwiftUI

/// Guided six-step Shared Character lesson shell.
struct LessonView: View {
    /// Route selected from Home, Search, Browse, or Collections.
    let route: LessonRoute

    /// Shared app dependencies used to resolve corpus and user state.
    let dependencies: AppDependencies

    /// Local state store used to persist resume and learned status.
    @ObservedObject private var userStateStore: LocalUserStateStore

    /// Current visible lesson step.
    @State private var selectedStep: LessonStep

    /// Steps visited in this lesson session; persisted through user state as progress matures.
    @State private var visitedSteps: Set<LessonStep>

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

        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text(record?.coreCharacter ?? route.sharedCharacterID)
                        .font(.system(size: 56, weight: .regular, design: .serif))
                    Text(record?.coreSharedMeaning ?? "Shared Character")
                        .font(.headline)
                    Text(selectedStep.title)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }

            Section("Progress") {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(LessonStep.allCases) { step in
                            Button {
                                selectStep(step)
                            } label: {
                                VStack(spacing: 4) {
                                    Text(step.title)
                                        .font(.caption)
                                    Circle()
                                        .fill(progressColor(for: step))
                                        .frame(width: 8, height: 8)
                                }
                                .frame(minWidth: 72)
                            }
                            .buttonStyle(.bordered)
                            .disabled(!canSelectStep(step))
                        }
                    }
                    .padding(.vertical, 4)
                }
            }

            Section(selectedStep.title) {
                stepContent(record: record)
            }

            Section("Lesson") {
                Button("Restart lesson") {
                    restartLesson()
                }

                Button("Mark as Learned") {
                    userStateStore.updateLessonState(sharedCharacterID: route.sharedCharacterID) { state in
                        state.markLearned()
                    }
                }
            }
        }
        .navigationTitle(record?.coreCharacter ?? "Lesson")
        .onAppear {
            selectStep(selectedStep)
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

    /// Renders the current lesson step from the bundled corpus record.
    @ViewBuilder
    private func stepContent(record: SharedCharacterRecord?) -> some View {
        switch selectedStep {
        case .origin:
            if let record {
                CharacterEvolutionView(history: record.history)
            } else {
                Text("Origin notes will appear here.")
            }
        case .character:
            Text(record?.structure.summary ?? "Character structure notes will appear here.")
        case .modernForms:
            if let record {
                ModernFormsComparisonView(record: record)
            } else {
                Text("Modern forms will appear here.")
            }
        case .structure:
            Text(record?.structure.summary ?? "Structure notes will appear here.")
        case .usage:
            if let record {
                UsageExamplesView(record: record)
            } else {
                Text("Usage examples will appear here.")
            }
        case .summary:
            Text(record?.recognitionTakeaway ?? "Recognition takeaway will appear here.")
        }
    }
}
