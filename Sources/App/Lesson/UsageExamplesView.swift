import SwiftUI

/// Compact word context that completes the Today exhibit without becoming a second lesson page.
struct UsageExamplesView: View {
    let record: SharedCharacterRecord
    let focusSelection: FocusTrackSelection
    let track: FocusTrack?

    init(record: SharedCharacterRecord, focusSelection: FocusTrackSelection, track: FocusTrack? = nil) {
        self.record = record
        self.focusSelection = focusSelection
        self.track = track
    }

    private var visibleTracks: [FocusTrack] {
        if let track { return [track] }
        return focusSelection.selectedTracks
    }

    var body: some View {
        Group {
            if visibleTracks.isEmpty {
                // Museum-only journeys deliberately stop after the historical story.
                EmptyView()
            } else {
                VStack(alignment: .leading, spacing: AppSpacing.spaceSm) {
                    HStack(alignment: .firstTextBaseline) {
                        Text("IN A WORD")
                            .font(AppTypography.conceptLabel)
                            .tracking(1.6)
                            .foregroundStyle(AppColors.textSecondary)
                        Spacer()
                        if let track {
                            Text(track.title)
                                .font(AppTypography.caption)
                                .foregroundStyle(AppColors.textSecondary)
                        }
                    }

                    ForEach(visibleTracks) { visibleTrack in
                        compactWordCard(for: visibleTrack)
                    }
                }
            }
        }
    }

    /// Chooses the data lane while keeping every modern language in the same compact visual frame.
    @ViewBuilder
    private func compactWordCard(for track: FocusTrack) -> some View {
        switch track {
        case .simplifiedChinese:
            wordCard(
                title: "Simplified Chinese",
                form: record.focusCoverage.simplifiedChinese.form,
                translation: laneMeaning(record.focusCoverage.simplifiedChinese.glosses),
                readings: record.focusCoverage.simplifiedChinese.readings,
                semanticEquivalents: record.focusCoverage.simplifiedChinese.semanticEquivalents,
                examples: record.focusCoverage.simplifiedChinese.examples,
                variants: record.focusCoverage.simplifiedChinese.variants,
                fontRole: .simplifiedChinese,
                writtenReadingForm: record.focusCoverage.simplifiedChinese.form,
                ensureBasicSentenceAtEnd: true
            )
        case .traditionalChinese:
            traditionalWordCard(record.focusCoverage.traditionalChinese)
        case .japanese:
            wordCard(
                title: "Japanese",
                form: record.focusCoverage.japanese.form,
                translation: laneMeaning(record.focusCoverage.japanese.glosses),
                readings: record.focusCoverage.japanese.readings,
                semanticEquivalents: record.focusCoverage.japanese.semanticEquivalents,
                examples: record.focusCoverage.japanese.examples,
                variants: record.focusCoverage.japanese.variants,
                fontRole: .japanese,
                ensureBasicSentenceAtEnd: true,
                showsJapaneseFurigana: true
            )
        case .korean:
            koreanWordCard(record.focusCoverage.korean)
        }
    }

    /// Shows up to four real editorial examples without exposing importer placeholders as learner content.
    private func wordCard(
        title: String,
        form: String,
        translation: String,
        readings: [CharacterReading],
        semanticEquivalents: [CharacterReading] = [],
        examples: [UsageExample],
        variants: [ModernFormVariant],
        fontRole: CJKFontRole,
        writtenReadingForm: String? = nil,
        ensureBasicSentenceAtEnd: Bool = false,
        showsJapaneseFurigana: Bool = false
    ) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.spaceXs) {
            Text(title)
                .font(AppTypography.stageTitle)
                .foregroundStyle(AppColors.textPrimary)
            languageFormHeader(
                form: form,
                translation: translation.capitalized,
                readings: readings,
                fontRole: fontRole,
                writtenReadingForm: writtenReadingForm,
                readingGlosses: readings.map { reading in
                    showsJapaneseFurigana
                        ? japaneseReadingGloss(for: reading)
                        : reading.gloss
                },
                showsJapaneseFurigana: showsJapaneseFurigana
            )
            if !semanticEquivalents.isEmpty {
                semanticEquivalentSection(
                    semanticEquivalents,
                    fontRole: fontRole,
                    showsJapaneseFurigana: showsJapaneseFurigana
                )
            }
            Divider()
                .padding(.vertical, AppSpacing.spaceXs)
            ForEach(displayExamples(
                examples,
                variants: variants,
                excludeCoreForm: true,
                ensureBasicSentenceAtEnd: ensureBasicSentenceAtEnd
            ).prefix(4), id: \.text) { example in
                exampleRow(
                    example,
                    fontRole: fontRole,
                    showsJapaneseFurigana: showsJapaneseFurigana
                )
            }
        }
        .padding(.vertical, AppSpacing.spaceSm)
        .padding(.horizontal, AppSpacing.spaceMd)
        .background(AppColors.surfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.surface))
        .overlay {
            RoundedRectangle(cornerRadius: AppRadius.surface)
                .stroke(AppColors.separator, lineWidth: 1)
        }
    }

    /// Presents the modern form with its English meaning before the contextual examples.
    private func languageFormHeader(
        form: String,
        translation: String,
        readings: [CharacterReading],
        fontRole: CJKFontRole,
        writtenReadingForm: String? = nil,
        readingGlosses: [String?] = [],
        showsJapaneseFurigana: Bool = false
    ) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.spaceXs) {
            HStack(alignment: .firstTextBaseline, spacing: AppSpacing.spaceSm) {
                Text(form)
                    .font(fontRole.font(size: 48))
                    .foregroundStyle(AppColors.accentPrimary)
                    .frame(maxWidth: .infinity, minHeight: 58, alignment: .leading)
                    .minimumScaleFactor(0.55)
                    .lineLimit(1)
                    .clipped()
                Text(translation)
                    .font(AppTypography.body.weight(.medium))
                    .foregroundStyle(AppColors.textPrimary)
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            Divider()
                .padding(.vertical, AppSpacing.spaceXs)
            // Reading systems are not unique: Japanese may have several On/Kun readings,
            // and Korean may expose ordinary and sound-law variants.
            ForEach(Array(readings.enumerated()), id: \.offset) { index, reading in
                readingRow(
                    reading,
                    fontRole: fontRole,
                    writtenForm: writtenReadingForm,
                    englishGloss: readingGlosses.indices.contains(index) ? readingGlosses[index] : nil,
                    showsJapaneseFurigana: showsJapaneseFurigana,
                    fallbackJapaneseWrittenForm: form
                )
            }
        }
    }

    /// Keeps each reading together, with romanization beneath its native reading where available.
    @ViewBuilder
    private func readingRow(
        _ reading: CharacterReading,
        fontRole: CJKFontRole,
        writtenForm: String? = nil,
        englishGloss: String? = nil,
        showsJapaneseFurigana: Bool = false,
        fallbackJapaneseWrittenForm: String? = nil
    ) -> some View {
        if showsJapaneseFurigana {
            japaneseReadingRow(
                reading,
                fallbackWrittenForm: fallbackJapaneseWrittenForm,
                englishGloss: englishGloss
            )
        } else {
            let parts = displayReadingParts(reading, writtenForm: writtenForm)
            VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
                Text(readingLabel(reading))
                    .font(AppTypography.metadata)
                    .foregroundStyle(AppColors.textSecondary)
                HStack(alignment: .firstTextBaseline, spacing: AppSpacing.spaceSm) {
                    Text(parts.script)
                        .font(fontRole.font(size: 22).weight(.medium))
                        .foregroundStyle(AppColors.textPrimary)
                    Spacer(minLength: AppSpacing.spaceSm)
                    if let englishGloss, !englishGloss.isEmpty {
                        Text(englishGloss)
                            .font(AppTypography.caption)
                            .foregroundStyle(AppColors.textSecondary)
                            .multilineTextAlignment(.trailing)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    PronunciationButton(reading: reading)
                }
                if let romanization = parts.romanization {
                    Text(romanization)
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    /// Shows the actual Japanese word, its furigana, and its romanization as separate layers.
    /// A Kun reading such as 下がる is a lexical reading/use, not a semantic-equivalent label.
    private func japaneseReadingRow(
        _ reading: CharacterReading,
        fallbackWrittenForm: String?,
        englishGloss: String?,
        showsLabel: Bool = true
    ) -> some View {
        let writtenForm = reading.writtenForm ?? fallbackWrittenForm ?? reading.nativeReading ?? reading.value
        let furigana = reading.furigana ?? reading.nativeReading
        return VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
            if showsLabel {
                Text(readingLabel(reading))
                    .font(AppTypography.metadata)
                    .foregroundStyle(AppColors.textSecondary)
            }
            HStack(alignment: .bottom, spacing: AppSpacing.spaceSm) {
                if let furigana, !furigana.isEmpty {
                    Text(furigana)
                        .font(CJKFontRole.japanese.font(size: 10))
                        .foregroundStyle(AppColors.textSecondary)
                        .frame(minHeight: 14, alignment: .bottom)
                } else {
                    Color.clear.frame(height: 14)
                }
                Spacer(minLength: AppSpacing.spaceSm)
            }
            HStack(alignment: .firstTextBaseline, spacing: AppSpacing.spaceSm) {
                Text(writtenForm)
                    .font(CJKFontRole.japanese.font(size: 22).weight(.medium))
                    .foregroundStyle(AppColors.textPrimary)
                Spacer(minLength: AppSpacing.spaceSm)
                if let englishGloss, !englishGloss.isEmpty {
                    Text(englishGloss)
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColors.textSecondary)
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                PronunciationButton(reading: reading)
            }
            if let romanization = reading.romanization, !romanization.isEmpty {
                Text(romanization)
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    /// Shows a Korean native equivalent as its own semantic relationship, not as another Hanja reading.
    private func koreanEquivalentRow(_ equivalent: CharacterReading) -> some View {
        let parts = displayReadingParts(equivalent)
        return HStack(alignment: .top, spacing: AppSpacing.spaceSm) {
            VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
                HStack(alignment: .firstTextBaseline, spacing: AppSpacing.spaceSm) {
                    Text(parts.script)
                        .font(CJKFontRole.korean.font(size: 22).weight(.medium))
                        .foregroundStyle(AppColors.textPrimary)
                    Spacer(minLength: AppSpacing.spaceSm)
                    if let gloss = equivalent.gloss, !gloss.isEmpty {
                        Text(gloss)
                            .font(AppTypography.caption)
                            .foregroundStyle(AppColors.textSecondary)
                            .multilineTextAlignment(.trailing)
                    }
                }
                if let romanization = parts.romanization {
                    Text(romanization)
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            PronunciationButton(reading: equivalent)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    /// Shows a verified lexical equivalent above the context examples without presenting it as another reading.
    private func semanticEquivalentSection(
        _ equivalents: [CharacterReading],
        fontRole: CJKFontRole,
        showsJapaneseFurigana: Bool = false
    ) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
            Text("Equivalent")
                .font(AppTypography.metadata)
                .foregroundStyle(AppColors.textSecondary)
            ForEach(Array(equivalents.enumerated()), id: \.offset) { _, equivalent in
                if showsJapaneseFurigana {
                    japaneseReadingRow(
                        equivalent,
                        fallbackWrittenForm: nil,
                        englishGloss: equivalent.gloss,
                        showsLabel: false
                    )
                } else {
                    semanticEquivalentRow(equivalent, fontRole: fontRole)
                }
            }
        }
    }

    /// Renders a language-specific lexical equivalent with its own English meaning and pronunciation.
    private func semanticEquivalentRow(
        _ equivalent: CharacterReading,
        fontRole: CJKFontRole
    ) -> some View {
        let parts = displayReadingParts(equivalent)
        return HStack(alignment: .top, spacing: AppSpacing.spaceSm) {
            VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
                HStack(alignment: .firstTextBaseline, spacing: AppSpacing.spaceSm) {
                    Text(parts.script)
                        .font(fontRole.font(size: 22).weight(.medium))
                        .foregroundStyle(AppColors.textPrimary)
                    Spacer(minLength: AppSpacing.spaceSm)
                    if let gloss = equivalent.gloss, !gloss.isEmpty {
                        Text(gloss)
                            .font(AppTypography.caption)
                            .foregroundStyle(AppColors.textSecondary)
                            .multilineTextAlignment(.trailing)
                    }
                }
                if let romanization = parts.romanization {
                    Text(romanization)
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            PronunciationButton(reading: equivalent)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    /// Uses established linguistic labels instead of flattening distinct reading systems into one caption.
    private func readingLabel(_ reading: CharacterReading) -> String {
        let normalized = reading.system.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if normalized == "on" || normalized == "onyomi" { return "On · Sino-Japanese" }
        if normalized == "kun" || normalized == "kunyomi" { return "Kun · Native" }
        if normalized == "hanja" { return "Hanja · Sino-Korean" }
        if normalized == "hanja · word-initial form" { return "Hanja · Initial" }
        if normalized.hasPrefix("hanja · ") {
            return "Hanja · " + String(reading.system.dropFirst("hanja · ".count))
        }
        if normalized == "native korean" || normalized == "everyday korean" {
            return "Everyday Korean"
        }
        if normalized.hasPrefix("native korean · ") || normalized.hasPrefix("everyday korean · ") {
            let separator = reading.system.firstIndex(of: "·")
            let detail = separator.map {
                String(reading.system[reading.system.index(after: $0)...])
                    .trimmingCharacters(in: .whitespacesAndNewlines)
            } ?? ""
            return detail.isEmpty ? "Everyday Korean" : "Everyday Korean · \(detail)"
        }
        return reading.system.capitalized
    }

    /// Splits the current editorial display form from optional romanization without changing the stored value.
    private func displayReadingParts(_ value: String) -> (script: String, romanization: String?) {
        let emDashParts = value.components(separatedBy: " — ")
        if emDashParts.count == 2 {
            return (emDashParts[0], emDashParts[1])
        }
        let parentheticalParts = value.split(separator: "(", maxSplits: 1, omittingEmptySubsequences: true)
        if parentheticalParts.count == 2 {
            return (
                String(parentheticalParts[0]).trimmingCharacters(in: .whitespaces),
                String(parentheticalParts[1]).trimmingCharacters(in: CharacterSet(charactersIn: ") "))
            )
        }
        let slashParts = value.components(separatedBy: " / ")
        if slashParts.count == 2 {
            return (slashParts[0], slashParts[1])
        }
        return (value, nil)
    }

    /// Prefers structured V3.3 reading fields while keeping older records readable.
    private func displayReadingParts(_ reading: CharacterReading) -> (script: String, romanization: String?) {
        if let nativeReading = reading.nativeReading, !nativeReading.isEmpty {
            return (nativeReading, reading.romanization)
        }
        return displayReadingParts(reading.value)
    }

    /// Chinese pronunciation rows must show the written Han character first;
    /// the stored Pinyin or Jyutping remains the pronunciation beneath it.
    private func displayReadingParts(
        _ reading: CharacterReading,
        writtenForm: String?
    ) -> (script: String, romanization: String?) {
        guard let writtenForm, !writtenForm.isEmpty else {
            return displayReadingParts(reading)
        }
        return (writtenForm, reading.romanization ?? reading.value)
    }

    /// Shows only the reviewed gloss for this specific reading; a shared Symbol meaning
    /// must never be substituted for an unreviewed multi-sense reading.
    private func japaneseReadingGloss(for reading: CharacterReading) -> String? {
        reading.gloss
    }

    /// Keeps the top row specific to the selected language lane instead of copying the
    /// entire shared meaning set onto every target-language page.
    private func laneMeaning(_ glosses: [String]) -> String {
        glosses
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .joined(separator: " / ")
    }

    /// Removes only exact Korean duplicates of the top form or Hanja reading; distinct native vocabulary remains visible.
    private func visibleKoreanEquivalents(_ coverage: StandardFocusCoverage) -> [CharacterReading] {
        let primaryForms = Set(
            [coverage.form] + coverage.readings.map { displayReadingParts($0).script }
        )
        return coverage.semanticEquivalents.filter {
            !primaryForms.contains(displayReadingParts($0).script)
        }
    }

    /// Korean keeps the Hanja form and an explicit native-script variant together on the Usage page.
    private func koreanWordCard(_ coverage: StandardFocusCoverage) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.spaceXs) {
            Text("Korean")
                .font(AppTypography.stageTitle)
                .foregroundStyle(AppColors.textPrimary)
            languageFormHeader(
                form: coverage.form,
                translation: laneMeaning(coverage.glosses).capitalized,
                readings: coverage.readings,
                fontRole: .korean,
                readingGlosses: coverage.readings.map { $0.gloss }
            )
            let equivalents = visibleKoreanEquivalents(coverage)
            if !equivalents.isEmpty {
                VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
                    Text("Native Korean")
                        .font(AppTypography.metadata)
                        .foregroundStyle(AppColors.textSecondary)
                    ForEach(Array(equivalents.enumerated()), id: \.offset) { _, equivalent in
                        koreanEquivalentRow(equivalent)
                    }
                }
            }
            ForEach(coverage.variants, id: \.id) { variant in
                VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
                    Text(variant.writingSystem ?? "Native Korean")
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColors.textSecondary)
                    HStack(alignment: .firstTextBaseline, spacing: AppSpacing.spaceSm) {
                        Text(variant.form)
                            .font(CJKFontRole.korean.font(size: 22).weight(.semibold))
                            .foregroundStyle(AppColors.textPrimary)
                        Spacer(minLength: AppSpacing.spaceSm)
                        if let gloss = variant.readings.first?.gloss, !gloss.isEmpty {
                            Text(gloss)
                                .font(AppTypography.caption)
                                .foregroundStyle(AppColors.textSecondary)
                                .multilineTextAlignment(.trailing)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                    ForEach(Array(variant.readings.enumerated()), id: \.offset) { _, reading in
                        readingRow(
                            reading,
                            fontRole: .korean,
                            englishGloss: reading.gloss
                        )
                    }
                }
            }
            Divider()
                .padding(.vertical, AppSpacing.spaceXs)
            ForEach(displayExamples(
                coverage.examples,
                variants: coverage.variants,
                excludedExampleRoles: ["semanticEquivalent"],
                ensureBasicSentenceAtEnd: true
            ).prefix(4), id: \.text) { example in
                exampleRow(example, fontRole: .korean)
            }
        }
        .padding(.vertical, AppSpacing.spaceSm)
        .padding(.horizontal, AppSpacing.spaceMd)
        .background(AppColors.surfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.surface))
        .overlay {
            RoundedRectangle(cornerRadius: AppRadius.surface)
                .stroke(AppColors.separator, lineWidth: 1)
        }
    }

    /// Places the native word and English meaning on one line, with romanization underneath.
    @ViewBuilder
    private func exampleRow(
        _ example: UsageExample,
        fontRole: CJKFontRole,
        showsJapaneseFurigana: Bool = false
    ) -> some View {
        if showsJapaneseFurigana {
            japaneseExampleRow(example)
        } else {
            VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
                HStack(alignment: .firstTextBaseline, spacing: AppSpacing.spaceSm) {
                    Text(example.text)
                        .font(fontRole.font(size: 19).weight(.semibold))
                        .foregroundStyle(AppColors.textPrimary)
                    Spacer(minLength: AppSpacing.spaceSm)
                    Text(example.translation)
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColors.textSecondary)
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                if let reading = example.reading, !reading.isEmpty {
                    Text(reading)
                        .font(AppTypography.metadata)
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    /// Matches the approved Japanese hierarchy: natural Kanji, attached kana, romaji, then English.
    private func japaneseExampleRow(_ example: UsageExample) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
            // Furigana sits above the Kanji; align the English gloss with the
            // actual written word at the bottom of the Japanese word block.
            HStack(alignment: .bottom, spacing: AppSpacing.spaceSm) {
                japaneseWrittenExample(example)
                Spacer(minLength: AppSpacing.spaceSm)
                Text(example.translation)
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textSecondary)
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            if let reading = example.reading, !reading.isEmpty {
                Text(reading)
                    .font(AppTypography.metadata)
                    .foregroundStyle(AppColors.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    /// Renders structured furigana above the natural Japanese spelling without replacing the Kanji.
    @ViewBuilder
    private func japaneseWrittenExample(_ example: UsageExample) -> some View {
        if example.exampleLevel == .sentence {
            VStack(alignment: .leading, spacing: 0) {
                if let kanaReading = example.kanaReading, !kanaReading.isEmpty {
                    Text(kanaReading)
                        .font(CJKFontRole.japanese.font(size: 10))
                        .foregroundStyle(AppColors.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Text(example.text)
                    .font(CJKFontRole.japanese.font(size: 17).weight(.semibold))
                    .foregroundStyle(AppColors.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        } else if !example.furiganaSegments.isEmpty {
            HStack(alignment: .bottom, spacing: 0) {
                ForEach(Array(example.furiganaSegments.enumerated()), id: \.offset) { _, segment in
                    VStack(spacing: 0) {
                        if let reading = segment.reading, !reading.isEmpty {
                            Text(reading)
                                .font(CJKFontRole.japanese.font(size: 10))
                                .foregroundStyle(AppColors.textSecondary)
                                .frame(minHeight: 14, alignment: .bottom)
                        } else {
                            Color.clear
                                .frame(height: 14)
                        }
                        Text(segment.text)
                            .font(CJKFontRole.japanese.font(size: 17).weight(.semibold))
                            .foregroundStyle(AppColors.textPrimary)
                    }
                }
            }
            // Keep each Japanese word at its intrinsic character spacing; without this,
            // a flexible parent can spread furigana segments across the whole row.
            .fixedSize(horizontal: true, vertical: false)
        } else if let kanaReading = example.kanaReading, !kanaReading.isEmpty {
            VStack(spacing: 0) {
                Text(kanaReading)
                    .font(CJKFontRole.japanese.font(size: 10))
                    .foregroundStyle(AppColors.textSecondary)
                Text(example.text)
                    .font(CJKFontRole.japanese.font(size: 17).weight(.semibold))
                    .foregroundStyle(AppColors.textPrimary)
            }
        } else {
            Text(example.text)
                .font(CJKFontRole.japanese.font(size: 17).weight(.semibold))
                .foregroundStyle(AppColors.textPrimary)
        }
    }

    /// Keeps Taiwan and Hong Kong usage visibly distinct while retaining one Traditional page.
    private func traditionalWordCard(_ coverage: TraditionalChineseCoverage) -> some View {
        let hasTaiwanContent = !coverage.taiwanReadings.isEmpty || !coverage.taiwanExamples.isEmpty
        let hasHongKongContent = !coverage.hongKongReadings.isEmpty || !coverage.hongKongExamples.isEmpty

        return VStack(alignment: .leading, spacing: AppSpacing.spaceXs) {
            Text("Traditional Chinese")
                .font(AppTypography.stageTitle)
                .foregroundStyle(AppColors.textPrimary)
            languageFormHeader(
                form: coverage.form,
                translation: laneMeaning(coverage.glosses).capitalized,
                readings: [],
                fontRole: .traditionalChinese
            )
            if hasTaiwanContent {
                regionalExamples(title: "Taiwan · Mandarin / Pinyin", writtenForm: coverage.form, readings: coverage.taiwanReadings, equivalents: coverage.taiwanSemanticEquivalents, examples: coverage.taiwanExamples, showTopDivider: false)
            }
            if hasHongKongContent {
                regionalExamples(title: "Hong Kong · Cantonese / Jyutping", writtenForm: coverage.form, readings: coverage.hongKongReadings, equivalents: coverage.hongKongSemanticEquivalents, examples: coverage.hongKongExamples, showTopDivider: hasTaiwanContent)
            }
        }
        .padding(.vertical, AppSpacing.spaceSm)
        .padding(.horizontal, AppSpacing.spaceMd)
        .background(AppColors.surfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.surface))
        .overlay {
            RoundedRectangle(cornerRadius: AppRadius.surface)
                .stroke(AppColors.separator, lineWidth: 1)
        }
    }

    /// Renders up to four useful context entries for one Traditional Chinese region.
    private func regionalExamples(
        title: String,
        writtenForm: String,
        readings: [CharacterReading],
        equivalents: [CharacterReading] = [],
        examples: [UsageExample],
        showTopDivider: Bool
    ) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
            if showTopDivider {
                Divider()
                    .padding(.vertical, AppSpacing.spaceXs)
            }
            Text(title)
                .font(AppTypography.body.weight(.semibold))
                .foregroundStyle(AppColors.textPrimary)
            ForEach(Array(readings.enumerated()), id: \.offset) { _, reading in
                readingRow(
                    reading,
                    fontRole: .traditionalChinese,
                    writtenForm: writtenForm,
                    englishGloss: reading.gloss
                )
            }
            if !equivalents.isEmpty {
                semanticEquivalentSection(equivalents, fontRole: .traditionalChinese)
                if !examples.isEmpty {
                    Divider()
                        .padding(.vertical, AppSpacing.space2xs)
                }
            } else if !readings.isEmpty && !examples.isEmpty {
                Divider()
                    .padding(.vertical, AppSpacing.space2xs)
            }
            ForEach(displayExamples(
                examples,
                excludeCoreForm: true,
                ensureBasicSentenceAtEnd: true
            ).prefix(4), id: \.text) { example in
                exampleRow(example, fontRole: .traditionalChinese)
            }
        }
    }

    /// Keeps learner-facing examples real while allowing future reviewed entries to expand to four naturally.
    private func displayExamples(
        _ examples: [UsageExample],
        variants: [ModernFormVariant] = [],
        excludedExampleRoles: [String] = [],
        excludeCoreForm: Bool = false,
        ensureBasicSentenceAtEnd: Bool = false
    ) -> [UsageExample] {
        var result: [UsageExample] = []
        for example in examples + variants.flatMap(\.examples) {
            let translation = example.translation.lowercased()
            let isPlaceholder = translation.contains("pending")
                || translation.contains("core character reference")
                || example.text.contains("·")
                || example.text.contains("…")
            guard !isPlaceholder,
                  (!excludeCoreForm || example.exampleLevel != .coreForm),
                  !(example.exampleRole.map { excludedExampleRoles.contains($0) } ?? false),
                  !result.contains(where: { $0.text == example.text }) else { continue }
            result.append(example)
        }
        guard ensureBasicSentenceAtEnd,
              let sentenceIndex = result.firstIndex(where: { $0.exampleLevel == .sentence }) else {
            return result
        }
        let sentence = result.remove(at: sentenceIndex)
        return Array(result.prefix(3)) + [sentence]
    }
}
