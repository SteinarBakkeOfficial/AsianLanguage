import SwiftUI

/// Reusable visual treatment for the selected historical evolution stages.
struct CharacterEvolutionView: View {
    /// Source-backed history data from the bundled Shared Character record.
    let history: CharacterHistory

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(history.originAnchor)
                .font(.subheadline)

            ForEach(history.stages.indices, id: \.self) { index in
                let stage = history.stages[index]

                HStack(alignment: .top, spacing: 12) {
                    Text(stage.form ?? "Asset")
                        .font(.system(size: 32, weight: .regular, design: .serif))
                        .frame(width: 64, alignment: .center)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(stage.label)
                            .font(.headline)
                        if let assetRef = stage.assetRef {
                            Text(assetRef)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        if let changeNoteFromPrevious = stage.changeNoteFromPrevious {
                            Text(changeNoteFromPrevious)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Text(stage.certainty.capitalized)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
}
