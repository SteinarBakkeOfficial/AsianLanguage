import SwiftUI

/// Reusable visual treatment for the selected historical evolution stages.
struct CharacterEvolutionView: View {
    /// Source-backed history data from the bundled Shared Character record.
    let history: CharacterHistory

    /// Regular modern character used when a stage has no source-backed drawing yet.
    let fallbackForm: String

    /// Canonical script path agreed for symbol evolution lessons.
    private let canonicalStages: [(id: String, title: String, subtitle: String)] = [
        ("oracleBone", "Oracle Bone Script", "甲骨文"),
        ("bronze", "Bronze Script", "金文"),
        ("seal", "Seal Script", "篆書"),
        ("clerical", "Clerical Script", "隸書"),
        ("regular", "Regular Script", "楷書")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(history.originAnchor)
                .font(.subheadline)

            ForEach(canonicalStages.indices, id: \.self) { index in
                let canonicalStage = canonicalStages[index]
                let stage = history.stages.first { $0.stage == canonicalStage.id }
                stageCard(
                    stage: stage,
                    stageNumber: index + 1,
                    title: canonicalStage.title,
                    subtitle: canonicalStage.subtitle,
                    isFirst: index == canonicalStages.startIndex
                )
            }
        }
    }

    /// Visual stage card for the editorial history spine.
    private func stageCard(
        stage: HistoricalStage?,
        stageNumber: Int,
        title: String,
        subtitle: String,
        isFirst: Bool
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                Text("\(stageNumber)")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(width: 34, height: 34)
                    .background(Circle().fill(Color.accentColor))

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            HStack(alignment: .top, spacing: 12) {
                Text(stage?.form ?? (title == "Regular Script" ? fallbackForm : ""))
                    .font(.system(size: 48, weight: .regular, design: .serif))
                    .frame(width: 86, height: 86)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.secondary.opacity(0.35), lineWidth: 1)
                    )

                VStack(alignment: .leading, spacing: 6) {
                    if let stage {
                        Text(stage.changeNoteFromPrevious ?? "First available historical anchor for this source-backed seed record.")
                            .font(.subheadline)
                        Text(stage.historicalSound ?? "Sound: source-backed historical sound not added yet.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("Certainty: \(stage.certainty.capitalized)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    } else {
                        Text("Source-backed historical drawing and explanation needed for this stage.")
                            .font(.subheadline)
                        Text("This draft gap keeps the agreed evolution path visible while final redraws are sourced.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            if let assetRef = stage?.assetRef {
                Text("Draft visual reference: \(assetRef)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
