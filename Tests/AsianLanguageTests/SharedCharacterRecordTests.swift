import XCTest
@testable import AsianLanguage

/// Tests for the bundled read-only Shared Character model.
final class SharedCharacterRecordTests: XCTestCase {
    /// Verifies the test bundle can decode the same draft record shape used by the app shell.
    func testBundledTreeRecordDecodesIntoFeaturedSummary() throws {
        let repository = BundleCorpusRepository(bundle: Bundle(for: Self.self))

        let record = try repository.sharedCharacter(id: "tree")

        XCTAssertEqual(record.id, "tree")
        XCTAssertEqual(record.coreCharacter, "木")
        XCTAssertEqual(record.featuredSummary.id, "tree")
        XCTAssertEqual(record.featuredSummary.displayForm, "木")
        XCTAssertEqual(record.featuredSummary.actionTitle, "New Symbol")
    }

    /// Ensures required V1 focus tracks are represented in the decoded Swift model.
    func testBundledTreeRecordIncludesAllRequiredFocusTracks() throws {
        let repository = BundleCorpusRepository(bundle: Bundle(for: Self.self))

        let record = try repository.sharedCharacter(id: "tree")

        XCTAssertEqual(record.focusCoverage.simplifiedChinese.form, "木")
        XCTAssertEqual(record.focusCoverage.traditionalChinese.form, "木")
        XCTAssertEqual(record.focusCoverage.japanese.form, "木")
        XCTAssertEqual(record.focusCoverage.korean.form, "木")
    }
}
