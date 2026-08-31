import Combine
import Foundation

/// Local JSON-backed store for writable user progress and preferences.
final class LocalUserStateStore: ObservableObject {
    /// Published state snapshot observed by SwiftUI screens.
    @Published private(set) var state: AppUserState

    /// Optional persistence location; nil keeps the store in memory for previews and tests.
    private let fileURL: URL?

    /// Encoder used for the local JSON state file.
    private let encoder: JSONEncoder

    /// Decoder used for the local JSON state file.
    private let decoder: JSONDecoder

    /// Creates a store from an optional JSON file URL.
    init(
        fileURL: URL?,
        initialState: AppUserState = .empty,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.fileURL = fileURL
        self.encoder = encoder
        self.decoder = decoder
        self.state = Self.loadState(fileURL: fileURL, decoder: decoder) ?? initialState
    }

    /// Store used by the app on device.
    static func live() -> LocalUserStateStore {
        LocalUserStateStore(fileURL: defaultStateFileURL())
    }

    /// In-memory store used by previews and lightweight shell construction.
    static func preview(initialState: AppUserState = .empty) -> LocalUserStateStore {
        LocalUserStateStore(fileURL: nil, initialState: initialState)
    }

    /// Persists a full focus-track selection change.
    func setFocusSelection(_ focusSelection: FocusTrackSelection) {
        state.focusSelection = focusSelection
        save()
    }

    /// Persists one focus-track toggle while keeping at least one track selected.
    func setFocusTrack(_ focusTrack: FocusTrack, isSelected: Bool) {
        state.focusSelection.set(focusTrack, isSelected: isSelected)
        save()
    }

    /// Persists the character Home and Symbol should resume by default.
    func setCurrentCharacter(_ sharedCharacterID: String?) {
        state.currentCharacterID = sharedCharacterID
        save()
    }

    /// Persists a display preference without affecting learning state.
    func setAppearancePreference(_ preference: AppearancePreference) {
        state.appearancePreference = preference
        save()
    }

    /// Marks the minimal onboarding gate complete without requiring an account.
    func completeOnboarding() {
        state.hasSeenIntro = true
        state.hasChosenFocusLanguages = true
        state.hasCompletedOnboarding = true
        save()
    }

    /// Records that the learner has seen the visual premise without completing setup.
    func markIntroSeen() {
        state.hasSeenIntro = true
        save()
    }

    /// Persists onboarding focus setup while retaining all four tracks by default.
    func markFocusLanguagesChosen() {
        state.hasChosenFocusLanguages = true
        save()
    }

    /// Marks the first canonical Symbol as started and completes onboarding.
    func markFirstSymbolStarted() {
        state.hasStartedFirstSymbol = true
        state.hasCompletedOnboarding = true
        save()
    }

    /// Updates one lesson state through a mutation closure and persists the snapshot.
    func updateLessonState(
        sharedCharacterID: String,
        mutate: (inout LessonUserState) -> Void
    ) {
        var lessonState = state.lessonStates[sharedCharacterID] ?? LessonUserState(sharedCharacterID: sharedCharacterID)
        mutate(&lessonState)
        state.lessonStates[sharedCharacterID] = lessonState
        if lessonState.progressStatus == .inProgress {
            state.activeJourneySymbolID = sharedCharacterID
        } else if lessonState.progressStatus == .learned,
                  state.activeJourneySymbolID == sharedCharacterID {
            state.activeJourneySymbolID = nil
        }
        save()
    }

    /// Clears learning progress while retaining preferences and onboarding state.
    func resetLearningProgress() {
        state.lessonStates = [:]
        state.currentCharacterID = nil
        state.activeJourneySymbolID = nil
        save()
    }

    /// Clears all locally persisted state, including preferences.
    func resetAllPreferences() {
        state = .empty
        save()
    }

    /// Legacy API retained for migration callers; new UI uses explicit reset methods.
    func reset() {
        resetAllPreferences()
    }

    /// Returns the persisted local state file path for app runs.
    private static func defaultStateFileURL() -> URL {
        let directory = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("AsianLanguage", isDirectory: true)
        return directory.appendingPathComponent("user-state.json")
    }

    /// Loads a previously persisted state snapshot when one exists.
    private static func loadState(fileURL: URL?, decoder: JSONDecoder) -> AppUserState? {
        guard let fileURL, FileManager.default.fileExists(atPath: fileURL.path) else {
            return nil
        }

        do {
            let data = try Data(contentsOf: fileURL)
            return try decoder.decode(AppUserState.self, from: data)
        } catch {
            return nil
        }
    }

    /// Writes the current snapshot to disk when this store has a file URL.
    private func save() {
        guard let fileURL else {
            return
        }

        do {
            try FileManager.default.createDirectory(
                at: fileURL.deletingLastPathComponent(),
                withIntermediateDirectories: true
            )
            let data = try encoder.encode(state)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            assertionFailure("Failed to save local user state: \(error)")
        }
    }
}
