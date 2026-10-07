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

    func testSequenceReturnsNextItemWithoutApplyingGlobalLearnedFiltering() {
        let sequence = SymbolSequence(
            id: "favorites",
            title: "Favorites",
            recordIDs: ["water", "tree", "mountain"]
        )

        XCTAssertEqual(sequence.nextRecordID(after: "water"), "tree")
        XCTAssertEqual(sequence.nextRecordID(after: "tree"), "mountain")
        XCTAssertNil(sequence.nextRecordID(after: "mountain"))
    }

    func testRoutePreservesSequenceContext() {
        let sequence = SymbolSequence(id: "collection", title: "Nature", recordIDs: ["water", "tree"])
        let route = LessonRoute(sharedCharacterID: "water", sequence: sequence)

        XCTAssertEqual(route.sequence, sequence)
    }
}
