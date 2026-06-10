import XCTest
@testable import AsianLanguage

/// Tests for stable lesson routing contracts used by Home and future discovery surfaces.
final class LessonRouteTests: XCTestCase {
    /// Keeps the default Home route pinned to the first guided lesson step.
    func testFeaturedLessonRouteStartsAtOrigin() {
        let route = LessonRoute(sharedCharacterID: "tree", startingStep: .origin)

        XCTAssertEqual(route.sharedCharacterID, "tree")
        XCTAssertEqual(route.startingStep, .origin)
    }

    /// Guards the persisted lesson-step order used by progress UI and future resume state.
    func testLessonStepOrderMatchesGuidedFlow() {
        let titles = LessonStep.allCases.map(\.title)

        XCTAssertEqual(
            titles,
            ["Origin", "Character", "Modern Forms", "Structure", "Usage", "Summary"]
        )
    }
}
