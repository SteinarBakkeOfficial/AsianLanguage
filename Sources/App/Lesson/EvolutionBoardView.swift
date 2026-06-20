import SwiftUI

/// Reference-led board that makes symbol evolution visible on the first lesson screen.
struct EvolutionBoardView: View {
    /// Bundled Shared Character record being studied.
    let record: SharedCharacterRecord

    /// Focus tracks currently enabled by the learner.
    let focusSelection: FocusTrackSelection

    /// Canonical script path shown in the board.
    private let canonicalStages: [(id: String, title: String, subtitle: String)] = [
        ("oracleBone", "Oracle Bone Script", "甲骨文"),
        ("bronze", "Bronze Script", "金文"),
        ("seal", "Seal Script", "篆書"),
        ("clerical", "Clerical Script", "隸書"),
        ("regular", "Regular Script", "楷書")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            boardHeader
            originIdeaCard
            stageTable
            ModernFormsComparisonView(record: record, focusSelection: focusSelection)
            timelineStrip
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(red: 0.99, green: 0.96, blue: 0.88))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.brown.opacity(0.35), lineWidth: 1)
        )
    }

    /// Title treatment matching the reference infographic direction.
    private var boardHeader: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Evolution of \(record.coreSharedMeaning.capitalized)")
                .font(.title2.weight(.bold))
                .foregroundStyle(Color.brown)
            Text("From an original picture idea to modern Chinese, Korean, and Japanese forms")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
        }
    }

    /// Original object idea shown before the writing stages.
    private var originIdeaCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center, spacing: 12) {
                SymbolPictogramView(recordID: record.id, fallbackCharacter: record.coreCharacter)
                    .frame(width: 132)

                VStack(alignment: .leading, spacing: 6) {
                    Text("Original picture idea")
                        .font(.headline)
                    Text(record.history.originAnchor)
                        .font(.subheadline)
                    Text(soundSummary)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Color.blue)
                }
            }
        }
        .padding(10)
        .background(Color.white.opacity(0.62))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    /// Full vertical evolution table: number, stage, glyph, and explanation.
    private var stageTable: some View {
        VStack(spacing: 0) {
            ForEach(canonicalStages.indices, id: \.self) { index in
                let canonicalStage = canonicalStages[index]
                let stage = record.history.stages.first { $0.stage == canonicalStage.id }
                evolutionRow(
                    stage: stage,
                    number: index + 1,
                    stageID: canonicalStage.id,
                    title: canonicalStage.title,
                    subtitle: canonicalStage.subtitle
                )
                if index != canonicalStages.count - 1 {
                    Divider()
                }
            }
        }
        .background(Color.white.opacity(0.70))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.brown.opacity(0.25), lineWidth: 1)
        )
    }

    /// One historical row, always showing a visible draft glyph rather than repeating blanks.
    private func evolutionRow(
        stage: HistoricalStage?,
        number: Int,
        stageID: String,
        title: String,
        subtitle: String
    ) -> some View {
        HStack(alignment: .top, spacing: 10) {
            VStack(spacing: 8) {
                Text("\(number)")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(width: 34, height: 34)
                    .background(Circle().fill(Color.green))
                Text(title)
                    .font(.caption.weight(.semibold))
                    .multilineTextAlignment(.center)
                Text(subtitle)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .frame(width: 86)

            DraftEvolutionGlyphView(
                recordID: record.id,
                stageID: stageID,
                modernForm: stage?.form ?? record.coreCharacter,
                assetRef: stage?.assetRef
            )
            .frame(width: 96, height: 104)

            VStack(alignment: .leading, spacing: 6) {
                Text(stage?.changeNoteFromPrevious ?? "A picture-like starting point for the idea behind \(record.coreCharacter).")
                    .font(.subheadline)
                Text(stage?.historicalSound ?? "Sound: modern readings are compared below.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                if let assetRef = stage?.assetRef {
                    Text("Visual source attached: \(assetRef)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                } else if stageID != "regular" {
                    Text("Draft visual sketch for testing; final source-backed redraw still needed.")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 8)
    }

    /// Bottom mini-timeline like the reference images.
    private var timelineStrip: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                SymbolPictogramView(recordID: record.id, fallbackCharacter: record.coreCharacter)
                    .frame(width: 64, height: 54)
                timelineArrow
                ForEach(canonicalStages.indices, id: \.self) { index in
                    let stage = canonicalStages[index]
                    VStack(spacing: 4) {
                        DraftEvolutionGlyphView(
                            recordID: record.id,
                            stageID: stage.id,
                            modernForm: record.coreCharacter,
                            assetRef: record.history.stages.first { $0.stage == stage.id }?.assetRef
                        )
                        .frame(width: 54, height: 54)
                        Text(stage.id == "oracleBone" ? "oracle" : stage.id)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    timelineArrow
                }
                Text("modern\nforms")
                    .font(.caption.weight(.semibold))
                    .multilineTextAlignment(.center)
            }
            .padding(8)
        }
        .background(Color.white.opacity(0.62))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    /// Compact arrow between timeline items.
    private var timelineArrow: some View {
        Image(systemName: "arrow.right")
            .font(.caption.weight(.bold))
            .foregroundStyle(.secondary)
    }

    /// Modern sound summary from all focus tracks.
    private var soundSummary: String {
        let mandarin = record.focusCoverage.simplifiedChinese.readings.map(\.value).joined(separator: " / ")
        let japanese = record.focusCoverage.japanese.readings.map(\.value).joined(separator: " / ")
        let korean = record.focusCoverage.korean.readings.map(\.value).joined(separator: " / ")
        return "Modern sound: Mandarin \(mandarin); Japanese \(japanese); Korean \(korean)"
    }
}

/// Visible draft historical glyph. This avoids showing the same regular character for every stage.
struct DraftEvolutionGlyphView: View {
    /// Corpus id used for draft per-symbol stage sketches.
    let recordID: String

    /// Canonical stage id.
    let stageID: String

    /// Modern fallback form for regular script.
    let modernForm: String

    /// Optional source-backed asset reference label.
    let assetRef: String?

    var body: some View {
        VStack(spacing: 4) {
            Text(glyphText)
                .font(.system(size: glyphText.contains("\n") ? 25 : 46, weight: .semibold, design: .serif))
                .minimumScaleFactor(0.6)
                .lineLimit(3)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            if assetRef != nil {
                Text("source")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(Color.green)
            } else if stageID != "regular" {
                Text("draft")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(6)
        .background(Color(red: 0.98, green: 0.94, blue: 0.84))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.brown.opacity(0.28), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    /// Per-stage draft signs chosen to make simplification visible during testing.
    private var glyphText: String {
        switch (recordID, stageID) {
        case ("tree", "oracleBone"): return "╱│╲\n╱│╲"
        case ("tree", "bronze"): return "╭┼╮\n╰┼╯"
        case ("tree", "seal"): return "丰\n│"
        case ("tree", "clerical"): return "木"
        case ("day", "oracleBone"): return "◎"
        case ("day", "bronze"): return "▣"
        case ("day", "seal"): return "日"
        case ("moon", "oracleBone"): return "☾"
        case ("moon", "bronze"): return "月"
        case ("person", "oracleBone"): return "𠆢"
        case ("person", "bronze"): return "入"
        case ("big", "oracleBone"): return "人\n一"
        case ("big", "bronze"): return "大"
        case ("small", "oracleBone"): return "丶  丶\n  丶"
        case ("small", "bronze"): return "小"
        case ("mountain", "oracleBone"): return "∧∧∧"
        case ("mountain", "bronze"): return "山"
        case ("water", "oracleBone"): return "≈\n│\n≈"
        case ("water", "bronze"): return "氺"
        case ("fire", "oracleBone"): return "∧\n火"
        case ("fire", "bronze"): return "灬"
        case ("mouth", "oracleBone"): return "□"
        case ("mouth", "bronze"): return "▢"
        case ("eye", "oracleBone"): return "◉"
        case ("eye", "bronze"): return "目"
        default:
            return stageID == "regular" || stageID == "clerical" || stageID == "seal" ? modernForm : "〰"
        }
    }
}
