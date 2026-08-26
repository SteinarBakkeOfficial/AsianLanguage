import XCTest
@testable import AsianLanguage

/// Tests for exact Symbol Journey routing.
final class LessonRouteTests: XCTestCase {
    func testRouteCarriesExactEvolutionStage() {
        let route = LessonRoute(
            sharedCharacterID: "fire",
            startingPosition: SymbolJourneyPosition(section: .evolution, stageID: "bronze")
        )

        XCTAssertEqual(route.sharedCharacterID, "fire")
        XCTAssertEqual(route.startingPosition?.stageID, "bronze")
    }

    func testLegacyLessonStepMapsToCurrentPosition() {
        let route = LessonRoute(sharedCharacterID: "tree", startingStep: .usage)

        XCTAssertEqual(route.startingPosition?.section, .usage)
    }
}
