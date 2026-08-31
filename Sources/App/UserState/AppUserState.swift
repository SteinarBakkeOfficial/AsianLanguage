import Foundation

/// Durable progress status for one Shared Character.
enum LessonProgressStatus: String, CaseIterable, Identifiable, Codable {
    case unseen
    case inProgress
    case learned

    var id: String { rawValue }
}

/// Device appearance preference; the app maps this to SwiftUI's color-scheme API.
enum AppearancePreference: String, CaseIterable, Codable, Identifiable {
    case system
    case light
    case dark

    var id: String { rawValue }
}

/// Local writable state for one Shared Character Symbol Journey.
struct LessonUserState: Codable, Hashable {
    let sharedCharacterID: String
    var progressStatus: LessonProgressStatus
    var lastPosition: SymbolJourneyPosition?
    var visitedPositions: [SymbolJourneyPosition]
    var isStarred: Bool
    var isReviewLater: Bool
    var updatedAt: Date
    var learnedAt: Date?

    private enum CodingKeys: String, CodingKey {
        case sharedCharacterID
        case progressStatus
        case lastPosition
        case visitedPositions
        case lastVisitedStep
        case visitedSteps
        case isStarred
        case isReviewLater
        case updatedAt
        case learnedAt
    }

    init(sharedCharacterID: String, updatedAt: Date = Date()) {
        self.sharedCharacterID = sharedCharacterID
        self.progressStatus = .unseen
        self.lastPosition = nil
        self.visitedPositions = []
        self.isStarred = false
        self.isReviewLater = false
        self.updatedAt = updatedAt
        self.learnedAt = nil
    }

    /// Decodes the current exact-position state and migrates the former LessonStep state.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sharedCharacterID = try container.decode(String.self, forKey: .sharedCharacterID)
        self.progressStatus = try container.decodeIfPresent(LessonProgressStatus.self, forKey: .progressStatus) ?? .unseen
        self.isStarred = try container.decodeIfPresent(Bool.self, forKey: .isStarred) ?? false
        self.isReviewLater = try container.decodeIfPresent(Bool.self, forKey: .isReviewLater) ?? false
        self.updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt) ?? Date()
        self.learnedAt = try container.decodeIfPresent(Date.self, forKey: .learnedAt)

        if let lastPosition = try container.decodeIfPresent(SymbolJourneyPosition.self, forKey: .lastPosition) {
            self.lastPosition = lastPosition
            self.visitedPositions = try container.decodeIfPresent([SymbolJourneyPosition].self, forKey: .visitedPositions) ?? [lastPosition]
        } else if let legacyStep = try container.decodeIfPresent(LessonStep.self, forKey: .lastVisitedStep) {
            let position = SymbolJourneyPosition.fromLegacy(legacyStep)
            self.lastPosition = position
            let legacySteps = try container.decodeIfPresent([LessonStep].self, forKey: .visitedSteps) ?? [legacyStep]
            self.visitedPositions = legacySteps.map(SymbolJourneyPosition.fromLegacy)
        } else {
            self.lastPosition = nil
            self.visitedPositions = []
        }
    }

    /// Encodes only the current exact-position schema; legacy keys are decode-only.
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(sharedCharacterID, forKey: .sharedCharacterID)
        try container.encode(progressStatus, forKey: .progressStatus)
        try container.encodeIfPresent(lastPosition, forKey: .lastPosition)
        try container.encode(visitedPositions, forKey: .visitedPositions)
        try container.encode(isStarred, forKey: .isStarred)
        try container.encode(isReviewLater, forKey: .isReviewLater)
        try container.encode(updatedAt, forKey: .updatedAt)
        try container.encodeIfPresent(learnedAt, forKey: .learnedAt)
    }

    /// Records ordinary navigation without silently downgrading a learned lesson.
    mutating func markInProgress(at position: SymbolJourneyPosition, updatedAt: Date = Date()) {
        guard progressStatus != .learned else { return }
        progressStatus = .inProgress
        learnedAt = nil
        lastPosition = position
        if !visitedPositions.contains(position) {
            visitedPositions.append(position)
        }
        self.updatedAt = updatedAt
    }

    /// Explicitly restarts a lesson and therefore intentionally clears Learned.
    mutating func restart(at position: SymbolJourneyPosition = .origin, updatedAt: Date = Date()) {
        progressStatus = .inProgress
        lastPosition = position
        visitedPositions = [position]
        self.updatedAt = updatedAt
    }

    /// Marks completion without changing independent Favorite or Review Later intent.
    mutating func markLearned(updatedAt: Date = Date()) {
        progressStatus = .learned
        learnedAt = updatedAt
        self.updatedAt = updatedAt
    }

    /// Explicitly requests Review Later without changing completion state.
    mutating func setReviewLater(_ isReviewLater: Bool, updatedAt: Date = Date()) {
        self.isReviewLater = isReviewLater
        self.updatedAt = updatedAt
    }

    /// Updates Favorites independently from progress and Review later state.
    mutating func setStarred(_ isStarred: Bool, updatedAt: Date = Date()) {
        self.isStarred = isStarred
        self.updatedAt = updatedAt
    }
}

/// Root local-only user state persisted on device.
struct AppUserState: Codable, Equatable {
    var focusSelection: FocusTrackSelection
    var lessonStates: [String: LessonUserState]
    var installedCorpusName: String
    var currentCharacterID: String?
    /// The unfinished journey Home should resume; this is distinct from the last selected Symbol.
    var activeJourneySymbolID: String?
    var appearancePreference: AppearancePreference
    var hasCompletedOnboarding: Bool
    /// Onboarding milestones allow interrupted first-launch flows to resume safely.
    var hasSeenIntro: Bool
    var hasChosenFocusLanguages: Bool
    var hasStartedFirstSymbol: Bool

    static let empty = AppUserState(
        focusSelection: .all,
        lessonStates: [:],
        installedCorpusName: "Draft V1 Corpus",
        currentCharacterID: nil,
        activeJourneySymbolID: nil,
        appearancePreference: .system,
        hasCompletedOnboarding: false,
        hasSeenIntro: false,
        hasChosenFocusLanguages: false,
        hasStartedFirstSymbol: false
    )

    private enum CodingKeys: String, CodingKey {
        case focusSelection
        case focusTrack
        case lessonStates
        case installedCorpusName
        case currentCharacterID
        case activeJourneySymbolID
        case appearancePreference
        case hasCompletedOnboarding
        case hasSeenIntro
        case hasChosenFocusLanguages
        case hasStartedFirstSymbol
    }

    private enum LegacyFocusTrack: String, Codable {
        case all
        case simplifiedChinese
        case traditionalChinese
        case japanese
        case korean

        var migratedSelection: FocusTrackSelection {
            switch self {
            case .all: return .all
            case .simplifiedChinese: return FocusTrackSelection(selectedTracks: [.simplifiedChinese])
            case .traditionalChinese: return FocusTrackSelection(selectedTracks: [.traditionalChinese])
            case .japanese: return FocusTrackSelection(selectedTracks: [.japanese])
            case .korean: return FocusTrackSelection(selectedTracks: [.korean])
            }
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let focusSelection = try container.decodeIfPresent(FocusTrackSelection.self, forKey: .focusSelection) {
            self.focusSelection = focusSelection
        } else if let legacy = try container.decodeIfPresent(LegacyFocusTrack.self, forKey: .focusTrack) {
            self.focusSelection = legacy.migratedSelection
        } else {
            self.focusSelection = .all
        }
        self.lessonStates = try container.decodeIfPresent([String: LessonUserState].self, forKey: .lessonStates) ?? [:]
        self.installedCorpusName = try container.decodeIfPresent(String.self, forKey: .installedCorpusName) ?? "Draft V1 Corpus"
        self.currentCharacterID = try container.decodeIfPresent(String.self, forKey: .currentCharacterID)
        self.activeJourneySymbolID = try container.decodeIfPresent(String.self, forKey: .activeJourneySymbolID) ?? self.currentCharacterID
        self.appearancePreference = try container.decodeIfPresent(AppearancePreference.self, forKey: .appearancePreference) ?? .system
        self.hasCompletedOnboarding = try container.decodeIfPresent(Bool.self, forKey: .hasCompletedOnboarding) ?? false
        self.hasSeenIntro = try container.decodeIfPresent(Bool.self, forKey: .hasSeenIntro) ?? self.hasCompletedOnboarding
        self.hasChosenFocusLanguages = try container.decodeIfPresent(Bool.self, forKey: .hasChosenFocusLanguages) ?? self.hasCompletedOnboarding
        self.hasStartedFirstSymbol = try container.decodeIfPresent(Bool.self, forKey: .hasStartedFirstSymbol) ?? false
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(focusSelection, forKey: .focusSelection)
        try container.encode(lessonStates, forKey: .lessonStates)
        try container.encode(installedCorpusName, forKey: .installedCorpusName)
        try container.encodeIfPresent(currentCharacterID, forKey: .currentCharacterID)
        try container.encodeIfPresent(activeJourneySymbolID, forKey: .activeJourneySymbolID)
        try container.encode(appearancePreference, forKey: .appearancePreference)
        try container.encode(hasCompletedOnboarding, forKey: .hasCompletedOnboarding)
        try container.encode(hasSeenIntro, forKey: .hasSeenIntro)
        try container.encode(hasChosenFocusLanguages, forKey: .hasChosenFocusLanguages)
        try container.encode(hasStartedFirstSymbol, forKey: .hasStartedFirstSymbol)
    }

    init(
        focusSelection: FocusTrackSelection,
        lessonStates: [String: LessonUserState],
        installedCorpusName: String,
        currentCharacterID: String? = nil,
        activeJourneySymbolID: String? = nil,
        appearancePreference: AppearancePreference = .system,
        hasCompletedOnboarding: Bool = false,
        hasSeenIntro: Bool = false,
        hasChosenFocusLanguages: Bool = false,
        hasStartedFirstSymbol: Bool = false
    ) {
        self.focusSelection = focusSelection
        self.lessonStates = lessonStates
        self.installedCorpusName = installedCorpusName
        self.currentCharacterID = currentCharacterID
        self.activeJourneySymbolID = activeJourneySymbolID ?? currentCharacterID
        self.appearancePreference = appearancePreference
        self.hasCompletedOnboarding = hasCompletedOnboarding
        self.hasSeenIntro = hasSeenIntro || hasCompletedOnboarding
        self.hasChosenFocusLanguages = hasChosenFocusLanguages || hasCompletedOnboarding
        self.hasStartedFirstSymbol = hasStartedFirstSymbol
    }

    /// Most recently updated in-progress route, if one exists.
    var resumeLessonRoute: LessonRoute? {
        if let activeJourneySymbolID,
           let current = lessonStates[activeJourneySymbolID],
           current.progressStatus == .inProgress {
            return LessonRoute(sharedCharacterID: current.sharedCharacterID, startingPosition: current.lastPosition ?? .origin)
        }

        return lessonStates.values
            .filter { $0.progressStatus == .inProgress }
            .sorted { $0.updatedAt > $1.updatedAt }
            .first
            .map { LessonRoute(sharedCharacterID: $0.sharedCharacterID, startingPosition: $0.lastPosition ?? .origin) }
    }
}
