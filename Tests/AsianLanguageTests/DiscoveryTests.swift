import XCTest
@testable import AsianLanguage

/// Tests for offline bundled-corpus discovery.
final class DiscoveryTests: XCTestCase {
    /// Verifies search finds the tree record by an English partial gloss.
    func testSearchFindsRecordByPartialGloss() throws {
        let repository = BundleCorpusRepository(bundle: Bundle(for: Self.self))
        let record = try repository.sharedCharacter(id: "tree")
        let index = SharedCharacterSearchIndex(records: [record])

        let results = index.search("wood")

        XCTAssertEqual(results.map(\.id), ["tree"])
    }

    /// Verifies search finds the tree record by a language reading.
    func testSearchFindsRecordByReading() throws {
        let repository = BundleCorpusRepository(bundle: Bundle(for: Self.self))
        let record = try repository.sharedCharacter(id: "tree")
        let index = SharedCharacterSearchIndex(records: [record])

        let results = index.search("moku")

        XCTAssertEqual(results.map(\.id), ["tree"])
    }
}
