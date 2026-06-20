import XCTest
@testable import AsianLanguage

/// Tests for local-only progress and preference state.
final class UserStateTests: XCTestCase {
    /// Verifies focus language toggles survive through the public store interface.
    func testStorePersistsFocusTrackSelectionInMemory() {
        let store = LocalUserStateStore.preview()

        store.setFocusTrack(.traditionalChinese, isSelected: false)

        XCTAssertFalse(store.state.focusSelection.contains(.traditionalChinese))
        XCTAssertTrue(store.state.focusSelection.contains(.japanese))
    }

    /// Ensures Home can resume the most recently updated in-progress lesson.
    func testResumeRouteUsesMostRecentInProgressLesson() {
        let older = Date(timeIntervalSince1970: 10)
        let newer = Date(timeIntervalSince1970: 20)
        let store = LocalUserStateStore.preview()

        store.updateLessonState(sharedCharacterID: "older") { state in
            state.markInProgress(at: .character, updatedAt: older)
        }
        store.updateLessonState(sharedCharacterID: "tree") { state in
            state.markInProgress(at: .usage, updatedAt: newer)
        }

        XCTAssertEqual(store.state.resumeLessonRoute?.sharedCharacterID, "tree")
        XCTAssertEqual(store.state.resumeLessonRoute?.startingStep, .usage)
    }

    /// Guards the V1 rule that learned and review-later are mutually exclusive.
    func testMarkLearnedClearsReviewLater() {
        var state = LessonUserState(sharedCharacterID: "tree")

        state.setReviewLater(true)
        state.markLearned()

        XCTAssertEqual(state.progressStatus, .learned)
        XCTAssertFalse(state.isReviewLater)
    }
}
