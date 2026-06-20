import Foundation

/// Durable progress status for one Shared Character lesson.
enum LessonProgressStatus: String, CaseIterable, Identifiable, Codable {
    case unseen
    case inProgress
    case learned

    /// Stable identifier for future filters and persistence-backed lists.
    var id: String { rawValue }
}

/// Local writable state for one Shared Character lesson.
struct LessonUserState: Codable, Hashable {
    /// Stable corpus identifier for the lesson this state belongs to.
    let sharedCharacterID: String

    /// Learner progress through the lesson.
    var progressStatus: LessonProgressStatus

    /// Last visited guided step, used for resume behavior.
    var lastVisitedStep: LessonStep?

    /// Steps visited in the current local lesson session.
    var visitedSteps: [LessonStep]

    /// Favorites flag; intentionally independent from retention state.
    var isStarred: Bool

    /// Review-later flag; marking learned clears this flag.
    var isReviewLater: Bool

    /// Modification timestamp used to choose the most recent in-progress lesson.
    var updatedAt: Date

    /// Creates empty local state for a bundled Shared Character.
    init(sharedCharacterID: String, updatedAt: Date = Date()) {
        self.sharedCharacterID = sharedCharacterID
        self.progressStatus = .unseen
        self.lastVisitedStep = nil
        self.visitedSteps = []
        self.isStarred = false
        self.isReviewLater = false
        self.updatedAt = updatedAt
    }

    /// Marks the lesson as started or resumed at a specific step.
    mutating func markInProgress(at step: LessonStep, updatedAt: Date = Date()) {
        progressStatus = .inProgress
        lastVisitedStep = step
        if !visitedSteps.contains(step) {
            visitedSteps.append(step)
        }
        self.updatedAt = updatedAt
    }

    /// Marks the lesson learned and clears review-later because those states are exclusive.
    mutating func markLearned(updatedAt: Date = Date()) {
        progressStatus = .learned
        isReviewLater = false
        self.updatedAt = updatedAt
    }

    /// Updates the review-later flag and clears learned progress when review is requested.
    mutating func setReviewLater(_ isReviewLater: Bool, updatedAt: Date = Date()) {
        self.isReviewLater = isReviewLater
        if isReviewLater && progressStatus == .learned {
            progressStatus = .unseen
        }
        self.updatedAt = updatedAt
    }

    /// Updates the favorites flag independently from progress and retention state.
    mutating func setStarred(_ isStarred: Bool, updatedAt: Date = Date()) {
        self.isStarred = isStarred
        self.updatedAt = updatedAt
    }
}

/// Root local-only user state persisted on device.
struct AppUserState: Codable, Equatable {
    /// Preferred focus lanes for lesson examples and settings.
    var focusSelection: FocusTrackSelection

    /// Per-lesson local state keyed by Shared Character corpus id.
    var lessonStates: [String: LessonUserState]

    /// Installed corpus label captured with local progress for future migrations.
    var installedCorpusName: String

    /// Empty default state for first launch and reset.
    static let empty = AppUserState(
        focusSelection: .all,
        lessonStates: [:],
        installedCorpusName: "Draft V1 Corpus"
    )

    /// Compatibility keys for migrating earlier single-focus local state.
    private enum CodingKeys: String, CodingKey {
        case focusSelection
        case focusTrack
        case lessonStates
        case installedCorpusName
    }

    /// Legacy single-focus values previously stored before multi-select focus tracks.
    private enum LegacyFocusTrack: String, Codable {
        case all
        case simplifiedChinese
        case traditionalChinese
        case japanese
        case korean

        /// Converts old single-focus state to the current multi-select model.
        var migratedSelection: FocusTrackSelection {
            switch self {
            case .all:
                return .all
            case .simplifiedChinese:
                return FocusTrackSelection(selectedTracks: [.simplifiedChinese])
            case .traditionalChinese:
                return FocusTrackSelection(selectedTracks: [.traditionalChinese])
            case .japanese:
                return FocusTrackSelection(selectedTracks: [.japanese])
            case .korean:
                return FocusTrackSelection(selectedTracks: [.korean])
            }
        }
    }

    /// Decodes current state and migrates old single-focus preferences when present.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let focusSelection = try container.decodeIfPresent(FocusTrackSelection.self, forKey: .focusSelection) {
            self.focusSelection = focusSelection
        } else if let legacyFocusTrack = try container.decodeIfPresent(LegacyFocusTrack.self, forKey: .focusTrack) {
            self.focusSelection = legacyFocusTrack.migratedSelection
        } else {
            self.focusSelection = .all
        }
        self.lessonStates = try container.decodeIfPresent([String: LessonUserState].self, forKey: .lessonStates) ?? [:]
        self.installedCorpusName = try container.decodeIfPresent(String.self, forKey: .installedCorpusName) ?? "Draft V1 Corpus"
    }

    /// Creates app state for tests and previews.
    init(
        focusSelection: FocusTrackSelection,
        lessonStates: [String: LessonUserState],
        installedCorpusName: String
    ) {
        self.focusSelection = focusSelection
        self.lessonStates = lessonStates
        self.installedCorpusName = installedCorpusName
    }

    /// Most recently updated in-progress route, if one exists.
    var resumeLessonRoute: LessonRoute? {
        lessonStates.values
            .filter { $0.progressStatus == .inProgress }
            .sorted { $0.updatedAt > $1.updatedAt }
            .first
            .map {
                LessonRoute(
                    sharedCharacterID: $0.sharedCharacterID,
                    startingStep: $0.lastVisitedStep ?? .origin
                )
            }
    }
}
