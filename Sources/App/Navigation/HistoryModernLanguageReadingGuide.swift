/// Learner-facing explanation of how each modern writing tradition is read in the app.
/// History-only: Symbol/Today data remains authoritative and unchanged.
private struct HistoryModernReadingGuide: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let facts: [HistoryModernReadingFact]
    let examples: [HistoryModernReadingExample]

    static func guides(for branchID: String) -> [HistoryModernReadingGuide] {
        switch branchID {
        case "traditionalChinese":
            return [taiwanMandarin, hongKongCantonese]
        case "simplifiedChinese":
            return [mainlandMandarin]
        case "japanese":
            return [japanese]
        case "korean":
            return [korean]
        default:
            return []
        }
    }

    private static let mainlandMandarin = HistoryModernReadingGuide(
        id: "mainland-mandarin",
        title: "Mainland Mandarin — Simplified Chinese",
        subtitle: "Simplified Hanzi · Hanyu Pinyin · Mandarin tones",
        facts: [
            HistoryModernReadingFact(
                id: "mainland-writing",
                title: "What you are looking at",
                detail: "Modern written Mandarin in mainland China normally uses Simplified Chinese characters. Simplification changed some character forms, while many characters were never changed at all.",
                artworkAssetName: "HistoryModern_MainlandSimplified",
                artworkAccessibilityLabel: "Traditional and Simplified forms of the same Chinese character shown side by side"
            ),
            HistoryModernReadingFact(
                id: "mainland-pronunciation",
                title: "How pronunciation is shown",
                detail: "Chinese characters are not an alphabet, so the shape alone does not tell a beginner exactly how a modern word is pronounced. In this app, Hanyu Pinyin is the pronunciation guide: 月 is yuè and 山 is shān."
            ),
            HistoryModernReadingFact(
                id: "mainland-tones",
                title: "What the marks over the vowels mean",
                detail: "Mandarin uses lexical tone. Pinyin marks the four main tones with ā, á, ǎ, and à; an unmarked syllable can represent the neutral tone. The mark belongs to the pronunciation guide, not to the written Chinese character.",
                artworkAssetName: "HistoryModern_MandarinTones",
                artworkAccessibilityLabel: "Abstract rising and falling water patterns representing Mandarin tone contours"
            ),
            HistoryModernReadingFact(
                id: "mainland-sandhi",
                title: "Why a familiar character can sound different in a phrase",
                detail: "Some syllables change tone in connected speech. A common example is 一: its citation reading is yī, but in teaching examples the app may show yí or yì when that reflects the pronunciation heard in the phrase. The written character itself does not change."
            ),
            HistoryModernReadingFact(
                id: "mainland-lessons",
                title: "How to read our lessons",
                detail: "Read the Hanzi as the real written Chinese. Treat the Pinyin beneath or beside it as pronunciation support, and the English as meaning support. Pinyin is not a second version of the Chinese sentence."
            )
        ],
        examples: [
            HistoryModernReadingExample(id: "mainland-moon", written: "月", readingAid: "yuè", meaning: "moon / month", note: nil),
            HistoryModernReadingExample(id: "mainland-mountain", written: "山", readingAid: "shān", meaning: "mountain", note: nil),
            HistoryModernReadingExample(id: "mainland-one", written: "一个", readingAid: "yí ge", meaning: "one item", note: "A learner-facing pronunciation that reflects the spoken tone change of 一.")
        ]
    )

    private static let taiwanMandarin = HistoryModernReadingGuide(
        id: "taiwan-mandarin",
        title: "Taiwan Mandarin — Traditional Chinese",
        subtitle: "Traditional Hanzi · Mandarin pronunciation",
        facts: [
            HistoryModernReadingFact(
                id: "taiwan-writing",
                title: "Traditional characters do not name a different spoken language by themselves",
                detail: "Taiwan normally writes Mandarin with Traditional Chinese characters. The written forms can differ from mainland Simplified Chinese, but the language represented in this track is Mandarin.",
                artworkAssetName: "HistoryModern_TaiwanTraditional",
                artworkAccessibilityLabel: "Traditional Chinese character written with brush and ink"
            ),
            HistoryModernReadingFact(
                id: "taiwan-pinyin",
                title: "Why our app still shows Pinyin",
                detail: "For consistency across international learners, this app writes Taiwan Mandarin pronunciation in Hanyu Pinyin with tone marks. The tone marks work in the same way as in the Mainland Mandarin track."
            ),
            HistoryModernReadingFact(
                id: "taiwan-zhuyin",
                title: "What Zhuyin is",
                detail: "Learners in Taiwan commonly encounter Zhuyin, also called Bopomofo, a dedicated phonetic system. Taiwan Ministry of Education dictionaries present Zhuyin together with Hanyu Pinyin. Our lessons keep Pinyin as the main romanization while this History page explains the locally important system."
            ),
            HistoryModernReadingFact(
                id: "taiwan-regional",
                title: "Regional standards still matter",
                detail: "Taiwan and Hong Kong both preserve Traditional Chinese, but preferred character variants, vocabulary, typography, and pronunciation are not always the same. Traditional Chinese is therefore a broad written tradition with regional standards, not one single spoken pronunciation."
            ),
            HistoryModernReadingFact(
                id: "taiwan-lessons",
                title: "How to read our lessons",
                detail: "Read the Traditional Hanzi as the real written form. Read the tone-marked Pinyin as the Mandarin pronunciation guide. Do not expect the same Traditional character to have the same pronunciation in the Hong Kong Cantonese track."
            )
        ],
        examples: [
            HistoryModernReadingExample(id: "taiwan-moon", written: "月", readingAid: "yuè", meaning: "moon / month", note: "In Taiwan, a learner may also encounter the Zhuyin spelling ㄩㄝˋ."),
            HistoryModernReadingExample(id: "taiwan-one", written: "一個", readingAid: "yí ge", meaning: "one item", note: nil),
            HistoryModernReadingExample(id: "taiwan-sentence", written: "我要一個。", readingAid: "Wǒ yào yí ge.", meaning: "I want one.", note: nil)
        ]
    )

    private static let hongKongCantonese = HistoryModernReadingGuide(
        id: "hong-kong-cantonese",
        title: "Hong Kong Cantonese — Traditional Chinese",
        subtitle: "Traditional Hanzi · Cantonese pronunciation · Jyutping",
        facts: [
            HistoryModernReadingFact(
                id: "hk-context",
                title: "The characters may look familiar, but the spoken language is different",
                detail: "Hong Kong commonly uses Traditional Chinese characters, while Cantonese is a major local spoken Chinese language. A character such as 月 can therefore keep the same written form while being pronounced very differently from Mandarin.",
                artworkAssetName: "HistoryModern_HongKongCantonese",
                artworkAccessibilityLabel: "Hong Kong harbour scene representing the Cantonese language environment"
            ),
            HistoryModernReadingFact(
                id: "hk-jyutping",
                title: "Why the romanization has numbers",
                detail: "This app uses Jyutping, the Cantonese romanization system developed by the Linguistic Society of Hong Kong. A number from 1 to 6 is written at the end of each syllable to identify its tone: 月 is jyut6 and 山 is saan1.",
                artworkAssetName: "HistoryModern_HongKongTones",
                artworkAccessibilityLabel: "Six bells over Hong Kong harbour representing the six Jyutping tone numbers"
            ),
            HistoryModernReadingFact(
                id: "hk-number",
                title: "The number is not spoken",
                detail: "In jyut6, the 6 is a tone label. You do not say the word “six.” The number tells you the tone category of that syllable, just as the accent mark in Mandarin Pinyin carries tone information."
            ),
            HistoryModernReadingFact(
                id: "hk-writing",
                title: "Written Cantonese and formal written Chinese can differ",
                detail: "Hong Kong readers encounter both broadly shared formal written Chinese and writing that represents everyday Cantonese more directly. Our Hong Kong examples use natural Cantonese wording where that helps show how the character lives in the spoken language."
            ),
            HistoryModernReadingFact(
                id: "hk-lessons",
                title: "How to read our lessons",
                detail: "Read the Traditional characters as the real written text. Read Jyutping as pronunciation support. Keep every tone number: removing it would remove meaningful pronunciation information."
            )
        ],
        examples: [
            HistoryModernReadingExample(id: "hk-moon", written: "月", readingAid: "jyut6", meaning: "moon / month", note: "6 is the Jyutping tone number."),
            HistoryModernReadingExample(id: "hk-mountain", written: "山", readingAid: "saan1", meaning: "mountain", note: "1 is the Jyutping tone number."),
            HistoryModernReadingExample(id: "hk-sentence", written: "我去行山。", readingAid: "ngo5 heoi3 haang4 saan1.", meaning: "I go hiking.", note: nil)
        ]
    )

    private static let japanese = HistoryModernReadingGuide(
        id: "japanese-reading",
        title: "How modern Japanese is written and read",
        subtitle: "Kanji + hiragana + katakana · furigana when pronunciation needs help",
        facts: [
            HistoryModernReadingFact(
                id: "jp-mixed",
                title: "Japanese normally mixes writing systems",
                detail: "A normal Japanese sentence can contain kanji, hiragana, and katakana together. They are not three competing versions of the same language: each has different jobs inside modern Japanese writing."
            ),
            HistoryModernReadingFact(
                id: "jp-kanji",
                title: "Kanji",
                detail: "Kanji are Chinese characters adapted to Japanese. A kanji can have on’yomi, readings historically connected with Chinese pronunciation, and kun’yomi, readings associated with native Japanese words. Only useful current readings belong on our learner page; rare or specialized readings remain internal.",
                artworkAssetName: "HistoryModern_JapaneseKanji",
                artworkAccessibilityLabel: "Japanese kanji written with brush and ink"
            ),
            HistoryModernReadingFact(
                id: "jp-hiragana",
                title: "Hiragana",
                detail: "Hiragana is a phonetic syllabary with rounded forms. It writes grammatical endings, particles, many native words, and pronunciation guidance. Historically, hiragana developed from highly cursive ways of writing Chinese characters for their sound.",
                artworkAssetName: "HistoryModern_JapaneseHiragana",
                artworkAccessibilityLabel: "Large hiragana character in flowing brush style"
            ),
            HistoryModernReadingFact(
                id: "jp-katakana",
                title: "Katakana",
                detail: "Katakana is another phonetic syllabary, visually more angular. It developed from abbreviated pieces of characters and today is especially common for foreign loanwords, sound-symbolic words, emphasis, and some specialist vocabulary.",
                artworkAssetName: "HistoryModern_JapaneseKatakana",
                artworkAccessibilityLabel: "Large angular katakana character written with a brush"
            ),
            HistoryModernReadingFact(
                id: "jp-furigana",
                title: "Furigana is a reading aid, not a second sentence",
                detail: "Kanji do not always reveal which Japanese reading is intended. Small kana can therefore be printed above or beside kanji as furigana. In this app the natural Japanese text appears once; furigana is attached to the kanji as subordinate pronunciation guidance rather than shown as a second equal sentence.",
                artworkAssetName: "HistoryModern_JapaneseFurigana",
                artworkAccessibilityLabel: "Japanese kanji with small hiragana furigana positioned above it"
            ),
            HistoryModernReadingFact(
                id: "jp-romaji",
                title: "Why we also show romaji",
                detail: "Romaji writes Japanese pronunciation with the Latin alphabet. It is a beginner aid for users who cannot yet read kana. A fluent Japanese reader normally relies on the Japanese text itself, not the romaji."
            ),
            HistoryModernReadingFact(
                id: "jp-lessons",
                title: "How to read our lessons",
                detail: "The first line gives the modern Japanese kanji form and a useful primary reading. Other useful On/Kun readings follow underneath, and every displayed reading has a genuine current example. Examples keep natural Japanese spelling; furigana explains kanji pronunciation and Hepburn romanization remains a secondary learner aid."
            )
        ],
        examples: [
            HistoryModernReadingExample(id: "jp-tree", written: "木", readingAid: "き · ki", meaning: "tree / wood", note: "A kun’yomi example."),
            HistoryModernReadingExample(id: "jp-thursday", written: "木曜日", readingAid: "もくようび · mokuyōbi", meaning: "Thursday", note: "The word remains naturally written 木曜日; the kana is pronunciation guidance."),
            HistoryModernReadingExample(id: "jp-sentence", written: "木の机です。", readingAid: "ki no tsukue desu.", meaning: "It is a wooden desk.", note: "Natural Japanese mixes kanji and hiragana.")
        ]
    )

    private static let korean = HistoryModernReadingGuide(
        id: "korean-reading",
        title: "How modern Korean connects Hangul and Hanja",
        subtitle: "Hangul is the everyday script · Hanja preserves the character tradition",
        facts: [
            HistoryModernReadingFact(
                id: "kr-hangul",
                title: "Modern Korean is primarily written in Hangul",
                detail: "Hangul is an alphabet designed for Korean. Individual consonant and vowel letters are grouped into square-looking syllable blocks, so 월 is one written syllable even though it is built from alphabetic elements."
            ),
            HistoryModernReadingFact(
                id: "kr-hanja-reading",
                title: "Hanja did not simply turn into new-shaped characters",
                detail: "Hanja are Chinese characters used in Korea’s historical writing tradition. The major modern change is that Korean pronunciation is normally written in Hangul. For example, the Hanja 漢 has the Korean reading 한, and 月 has the Korean Hanja reading 월.",
                artworkAssetName: "HistoryModern_KoreanHanjaHangul",
                artworkAccessibilityLabel: "A Hanja character shown beside its Korean Hangul reading in a Korean historical setting"
            ),
            HistoryModernReadingFact(
                id: "kr-equivalent",
                title: "A Hanja reading and a native Korean equivalent are different things",
                detail: "For 月, 월 is the established Sino-Korean reading of the character. 달 is a native Korean word meaning moon or month. Our lessons show the Hanja and its Korean reading first; a useful Korean equivalent appears underneath as separate vocabulary."
            ),
            HistoryModernReadingFact(
                id: "kr-modern-vocab",
                title: "Why Hanja still matters when modern text is mostly Hangul",
                detail: "A large part of Korean vocabulary is Sino-Korean. Modern words are normally written in Hangul, such as 월요일 for Monday, even when their vocabulary historically corresponds to Hanja. Seeing the Hanja makes those older lexical relationships visible."
            ),
            HistoryModernReadingFact(
                id: "kr-romanization",
                title: "How romanization works in our lessons",
                detail: "The Latin spelling follows Revised Romanization of Korean. It is pronunciation support, not Korean orthography. The real modern Korean writing remains Hangul."
            ),
            HistoryModernReadingFact(
                id: "kr-lessons",
                title: "How to read our lessons",
                detail: "Start with the Hanja line: character, Korean Hanja reading in Hangul, then romanization. Treat native Korean equivalents as separate vocabulary rather than as alternate readings of the Hanja."
            )
        ],
        examples: [
            HistoryModernReadingExample(id: "kr-moon-reading", written: "月", readingAid: "월 · wol", meaning: "Hanja reading", note: "월 is the Korean reading of 月."),
            HistoryModernReadingExample(id: "kr-moon-native", written: "달", readingAid: "dal", meaning: "moon / month", note: "Native Korean equivalent; not the reading of 月."),
            HistoryModernReadingExample(id: "kr-monday", written: "월요일", readingAid: "woryoil", meaning: "Monday", note: "Modern Korean normally writes the Sino-Korean word in Hangul.")
        ]
    )
}

private struct HistoryModernReadingFact: Identifiable {
    let id: String
    let title: String
    let detail: String
    let artworkAssetName: String?
    let artworkAccessibilityLabel: String?

    init(
        id: String,
        title: String,
        detail: String,
        artworkAssetName: String? = nil,
        artworkAccessibilityLabel: String? = nil
    ) {
        self.id = id
        self.title = title
        self.detail = detail
        self.artworkAssetName = artworkAssetName
        self.artworkAccessibilityLabel = artworkAccessibilityLabel
    }
}

private struct HistoryModernReadingExample: Identifiable {
    let id: String
    let written: String
    let readingAid: String
    let meaning: String
    let note: String?
}

/// Placed after the existing historical/divergence copy and before the Shared Character links.
struct HistoryModernReadingGuideSection: View {
    let branch: HistoryModernBranch

    private var guides: [HistoryModernReadingGuide] {
        HistoryModernReadingGuide.guides(for: branch.id)
    }

    var body: some View {
        if !guides.isEmpty {
            VStack(alignment: .leading, spacing: AppSpacing.spaceMd) {
                VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
                    Text("HOW TO READ THIS IN THE APP")
                        .font(AppTypography.conceptLabel)
                        .tracking(1.2)
                        .foregroundStyle(AppColors.accentPrimary)
                    Text("Modern writing and pronunciation")
                        .font(AppTypography.sectionHeading)
                        .foregroundStyle(AppColors.textPrimary)
                    Text("The historical character tradition is only part of the story. These guides explain what the modern writing on our lesson pages means and how to use the pronunciation aids.")
                        .font(AppTypography.body)
                        .foregroundStyle(AppColors.textSecondary)
                }

                ForEach(guides) { guide in
                    HistoryModernReadingGuideCard(guide: guide)
                }
            }
        }
    }
}

private struct HistoryModernReadingGuideCard: View {
    let guide: HistoryModernReadingGuide

    var body: some View {
        GroupedSurface {
            VStack(alignment: .leading, spacing: AppSpacing.spaceMd) {
                VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
                    Text(guide.title)
                        .font(AppTypography.sectionHeading)
                        .foregroundStyle(AppColors.textPrimary)

                    Text(guide.subtitle)
                        .font(AppTypography.metadata.weight(.semibold))
                        .foregroundStyle(AppColors.accentPrimary)
                }

                ForEach(guide.facts) { fact in
                    VStack(alignment: .leading, spacing: AppSpacing.spaceXs) {
                        Text(fact.title)
                            .font(AppTypography.body.weight(.semibold))
                            .foregroundStyle(AppColors.textPrimary)

                        if let assetName = fact.artworkAssetName {
                            HistoryModernReadingArtworkView(
                                assetName: assetName,
                                accessibilityLabel: fact.artworkAccessibilityLabel ?? fact.title
                            )
                        }

                        Text(fact.detail)
                            .font(AppTypography.body)
                            .foregroundStyle(AppColors.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    if fact.id != guide.facts.last?.id {
                        Divider()
                            .overlay(AppColors.separator)
                    }
                }

                Divider()
                    .overlay(AppColors.separator)

                Text("Read the examples")
                    .font(AppTypography.body.weight(.semibold))
                    .foregroundStyle(AppColors.textPrimary)

                ForEach(guide.examples) { example in
                    VStack(alignment: .leading, spacing: 3) {
                        Text(example.written)
                            .font(CJKFontRole.museumRegular.font(size: 28))
                            .foregroundStyle(AppColors.artifactInk)

                        Text(example.readingAid)
                            .font(AppTypography.metadata.weight(.semibold))
                            .foregroundStyle(AppColors.accentPrimary)

                        Text(example.meaning)
                            .font(AppTypography.caption)
                            .foregroundStyle(AppColors.textSecondary)

                        if let note = example.note {
                            Text(note)
                                .font(AppTypography.caption)
                                .foregroundStyle(AppColors.textTertiary)
                        }
                    }
                    .padding(.vertical, AppSpacing.space2xs)
                }
            }
        }
    }
}

/// Artwork remains independent of explanatory copy.
/// The image itself contains no English labels or app UI; SwiftUI provides the title and explanation.
private struct HistoryModernReadingArtworkView: View {
    let assetName: String
    let accessibilityLabel: String

    var body: some View {
        Image(assetName)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
            .frame(maxHeight: 228)
            .padding(AppSpacing.spaceXs)
            .background(AppColors.artifactField)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.small))
            .overlay {
                RoundedRectangle(cornerRadius: AppRadius.small)
                    .stroke(AppColors.separator, lineWidth: 1)
            }
            .accessibilityLabel(accessibilityLabel)
            .allowsHitTesting(false)
    }
}
