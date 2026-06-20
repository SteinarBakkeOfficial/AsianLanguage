import Foundation

/// Read-only repository for bundled Shared Character corpus records.
struct BundleCorpusRepository {
    /// Bundle containing the corpus JSON resources.
    let bundle: Bundle

    /// JSON decoder for corpus records.
    private let decoder: JSONDecoder

    /// Creates a repository for the app bundle by default.
    init(bundle: Bundle = .main, decoder: JSONDecoder = JSONDecoder()) {
        self.bundle = bundle
        self.decoder = decoder
    }

    /// Decodes one bundled Shared Character record by stable corpus identifier.
    func sharedCharacter(id: String) throws -> SharedCharacterRecord {
        let url = bundle.url(forResource: id, withExtension: "json", subdirectory: "Corpus") ??
            bundle.url(forResource: id, withExtension: "json")

        guard let url else {
            throw CorpusRepositoryError.missingBundledRecord(id: id)
        }

        let data = try Data(contentsOf: url)
        return try decoder.decode(SharedCharacterRecord.self, from: data)
    }

    /// Decodes multiple bundled Shared Character records in manifest order.
    func sharedCharacters(ids: [String]) -> [SharedCharacterRecord] {
        ids.compactMap { try? sharedCharacter(id: $0) }
            .sorted { $0.teachingSequence < $1.teachingSequence }
    }
}

/// Errors surfaced by bundled corpus loading.
enum CorpusRepositoryError: Error, Equatable {
    /// The requested record was not present in the app bundle.
    case missingBundledRecord(id: String)
}
