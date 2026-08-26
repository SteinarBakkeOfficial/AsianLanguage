import XCTest
@testable import AsianLanguage

/// Tests for local-only progress, migration, and exact journey position.
final class UserStateTests: XCTestCase {
    func testAllFocusTracksAreEnabledByDefault() {
        XCTAssertEqual(Set(FocusTrackSelection.all.selectedTracks), Set(FocusTrack.allCases))
    }

    func testResumeRouteUsesExactJourneyPosition() {
        let store = LocalUserStateStore.preview()
        let position = SymbolJourneyPosition(section: .evolution, stageID: "bronze")

        store.updateLessonState(sharedCharacterID: "fire") { state in
            state.markInProgress(at: position)
        }

        XCTAssertEqual(store.state.resumeLessonRoute?.startingPosition, position)
    }

    func testLearnedStateSurvivesOrdinaryNavigation() {
        var state = LessonUserState(sharedCharacterID: "fire")
        state.markLearned()
        state.markInProgress(at: SymbolJourneyPosition(section: .evolution, stageID: "bronze"))

        XCTAssertEqual(state.progressStatus, .learned)
    }

    func testLegacyStepDecodesToJourneyPosition() throws {
        let json = #"{"sharedCharacterID":"tree","progressStatus":"inProgress","lastVisitedStep":"usage","visitedSteps":["origin","usage"],"isStarred":false,"isReviewLater":false}"#
        let state = try JSONDecoder().decode(LessonUserState.self, from: Data(json.utf8))

        XCTAssertEqual(state.lastPosition?.section, .usage)
    }

    func testLearnedCanRemainInReviewLater() {
        var state = LessonUserState(sharedCharacterID: "fire")
        state.setReviewLater(true)
        state.markLearned()

        XCTAssertEqual(state.progressStatus, .learned)
        XCTAssertTrue(state.isReviewLater)
    }

    func testCurrentCharacterWinsResumeSelection() {
        let store = LocalUserStateStore.preview()
        store.updateLessonState(sharedCharacterID: "fire") { $0.markInProgress(at: .origin) }
        store.updateLessonState(sharedCharacterID: "water") { $0.markInProgress(at: SymbolJourneyPosition(section: .evolution, stageID: "bronze")) }
        store.setCurrentCharacter("fire")

        XCTAssertEqual(store.state.resumeLessonRoute?.sharedCharacterID, "fire")
    }

    func testFavoriteAndReviewLaterDoNotChangeProgress() {
        var state = LessonUserState(sharedCharacterID: "fire")
        state.markLearned()
        state.setStarred(true)
        state.setReviewLater(true)

        XCTAssertEqual(state.progressStatus, .learned)
        XCTAssertTrue(state.isStarred)
        XCTAssertTrue(state.isReviewLater)
    }
}
