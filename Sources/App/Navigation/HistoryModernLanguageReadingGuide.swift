import SwiftUI

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

                HistoryScriptGuideView(guideID: guide.id)

                Divider()
                    .overlay(AppColors.separator)

                Text("Read the examples")
                    .font(AppTypography.body.weight(.semibold))
                    .foregroundStyle(AppColors.textPrimary)

                ForEach(guide.examples) { example in
                    VStack(alignment: .leading, spacing: 3) {
                        Text(example.written)
                            .font(CJKFontRole.museumRegular.font(size: 28))
                            .foregroundStyle(AppColors.historyCharacterInk)

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

/// Native, offline pronunciation references keep the notation used in the lesson
/// understandable without bundling copied third-party chart images.
private struct HistoryScriptGuideView: View {
    let guideID: String

    @ViewBuilder
    var body: some View {
        switch guideID {
        case "mainland-mandarin", "taiwan-mandarin":
            MandarinToneGuide()
        case "hong-kong-cantonese":
            JyutpingToneGuide()
        case "japanese-reading":
            KanaReadingGuide()
        case "korean-reading":
            HangulReadingGuide()
        default:
            EmptyView()
        }
    }
}

private struct MandarinToneGuide: View {
    private let tones = [
        ("mā", "1 · high and level"),
        ("má", "2 · rising"),
        ("mǎ", "3 · low, then rising"),
        ("mà", "4 · falling sharply"),
        ("ma", "neutral · short and light")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.spaceSm) {
            Text("Mandarin tone marks")
                .font(AppTypography.body.weight(.semibold))
                .foregroundStyle(AppColors.textPrimary)
            Text("The tone belongs to each spoken syllable. In Pinyin, the mark sits above the main vowel; it is pronunciation information, not an added mark on the Hanzi character.")
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: AppSpacing.spaceXs) {
                ForEach(Array(tones.enumerated()), id: \.offset) { _, tone in
                    VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
                        Text(tone.0)
                            .font(AppTypography.body.weight(.semibold))
                            .foregroundStyle(AppColors.accentPrimary)
                        Text(tone.1)
                            .font(AppTypography.caption)
                            .foregroundStyle(AppColors.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(AppSpacing.spaceXs)
                    .background(AppColors.artifactField)
                    .clipShape(RoundedRectangle(cornerRadius: AppRadius.small))
                }
            }
            Text("For a word, read one Pinyin syllable for each character. For example, 月 is yuè: the accent marks the falling fourth tone on that syllable.")
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.textTertiary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(AppSpacing.spaceSm)
        .background(AppColors.surfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.small))
    }
}

private struct JyutpingToneGuide: View {
    private let tones = [
        ("1", "high and level"),
        ("2", "high rising"),
        ("3", "mid and level"),
        ("4", "low falling"),
        ("5", "low rising"),
        ("6", "low and level")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.spaceSm) {
            Text("Jyutping tone numbers")
                .font(AppTypography.body.weight(.semibold))
                .foregroundStyle(AppColors.textPrimary)
            Text("The number is written after each Cantonese syllable. Keep it when reading the lesson, but do not pronounce the number as a word. The descriptions below are a learner-friendly pitch guide.")
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: AppSpacing.spaceXs) {
                ForEach(Array(tones.enumerated()), id: \.offset) { _, tone in
                    VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
                        Text(tone.0)
                            .font(AppTypography.body.weight(.semibold))
                            .foregroundStyle(AppColors.accentPrimary)
                        Text(tone.1)
                            .font(AppTypography.caption)
                            .foregroundStyle(AppColors.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(AppSpacing.spaceXs)
                    .background(AppColors.artifactField)
                    .clipShape(RoundedRectangle(cornerRadius: AppRadius.small))
                }
            }
            Text("For example, jyut6 means the syllable jyut with tone 6. The number belongs to that syllable, not to the written character as a separate symbol.")
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.textTertiary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(AppSpacing.spaceSm)
        .background(AppColors.surfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.small))
    }
}

private struct KanaReadingGuide: View {
    private struct KanaCell {
        let hiragana: String
        let katakana: String
        let romaji: String
    }

    private struct KanaRow: Identifiable {
        let id: String
        let label: String
        let cells: [KanaCell]
    }

    private struct CombinationExample: Identifiable {
        let id: String
        let hiragana: String
        let katakana: String
        let romaji: String
    }

    // Five vowel columns make the basic Gojūon pattern recognizable at a glance.
    private let soundRows = [
        KanaRow(id: "vowels", label: "Vowels", cells: [
            KanaCell(hiragana: "あ", katakana: "ア", romaji: "a"),
            KanaCell(hiragana: "い", katakana: "イ", romaji: "i"),
            KanaCell(hiragana: "う", katakana: "ウ", romaji: "u"),
            KanaCell(hiragana: "え", katakana: "エ", romaji: "e"),
            KanaCell(hiragana: "お", katakana: "オ", romaji: "o")
        ]),
        KanaRow(id: "k", label: "K", cells: [
            KanaCell(hiragana: "か", katakana: "カ", romaji: "ka"),
            KanaCell(hiragana: "き", katakana: "キ", romaji: "ki"),
            KanaCell(hiragana: "く", katakana: "ク", romaji: "ku"),
            KanaCell(hiragana: "け", katakana: "ケ", romaji: "ke"),
            KanaCell(hiragana: "こ", katakana: "コ", romaji: "ko")
        ]),
        KanaRow(id: "s", label: "S", cells: [
            KanaCell(hiragana: "さ", katakana: "サ", romaji: "sa"),
            KanaCell(hiragana: "し", katakana: "シ", romaji: "shi"),
            KanaCell(hiragana: "す", katakana: "ス", romaji: "su"),
            KanaCell(hiragana: "せ", katakana: "セ", romaji: "se"),
            KanaCell(hiragana: "そ", katakana: "ソ", romaji: "so")
        ]),
        KanaRow(id: "t", label: "T", cells: [
            KanaCell(hiragana: "た", katakana: "タ", romaji: "ta"),
            KanaCell(hiragana: "ち", katakana: "チ", romaji: "chi"),
            KanaCell(hiragana: "つ", katakana: "ツ", romaji: "tsu"),
            KanaCell(hiragana: "て", katakana: "テ", romaji: "te"),
            KanaCell(hiragana: "と", katakana: "ト", romaji: "to")
        ]),
        KanaRow(id: "n", label: "N", cells: [
            KanaCell(hiragana: "な", katakana: "ナ", romaji: "na"),
            KanaCell(hiragana: "に", katakana: "ニ", romaji: "ni"),
            KanaCell(hiragana: "ぬ", katakana: "ヌ", romaji: "nu"),
            KanaCell(hiragana: "ね", katakana: "ネ", romaji: "ne"),
            KanaCell(hiragana: "の", katakana: "ノ", romaji: "no")
        ]),
        KanaRow(id: "h", label: "H", cells: [
            KanaCell(hiragana: "は", katakana: "ハ", romaji: "ha"),
            KanaCell(hiragana: "ひ", katakana: "ヒ", romaji: "hi"),
            KanaCell(hiragana: "ふ", katakana: "フ", romaji: "fu"),
            KanaCell(hiragana: "へ", katakana: "ヘ", romaji: "he"),
            KanaCell(hiragana: "ほ", katakana: "ホ", romaji: "ho")
        ]),
        KanaRow(id: "m", label: "M", cells: [
            KanaCell(hiragana: "ま", katakana: "マ", romaji: "ma"),
            KanaCell(hiragana: "み", katakana: "ミ", romaji: "mi"),
            KanaCell(hiragana: "む", katakana: "ム", romaji: "mu"),
            KanaCell(hiragana: "め", katakana: "メ", romaji: "me"),
            KanaCell(hiragana: "も", katakana: "モ", romaji: "mo")
        ]),
        KanaRow(id: "y", label: "Y", cells: [
            KanaCell(hiragana: "や", katakana: "ヤ", romaji: "ya"),
            KanaCell(hiragana: "·", katakana: "·", romaji: ""),
            KanaCell(hiragana: "ゆ", katakana: "ユ", romaji: "yu"),
            KanaCell(hiragana: "·", katakana: "·", romaji: ""),
            KanaCell(hiragana: "よ", katakana: "ヨ", romaji: "yo")
        ]),
        KanaRow(id: "r", label: "R", cells: [
            KanaCell(hiragana: "ら", katakana: "ラ", romaji: "ra"),
            KanaCell(hiragana: "り", katakana: "リ", romaji: "ri"),
            KanaCell(hiragana: "る", katakana: "ル", romaji: "ru"),
            KanaCell(hiragana: "れ", katakana: "レ", romaji: "re"),
            KanaCell(hiragana: "ろ", katakana: "ロ", romaji: "ro")
        ]),
        KanaRow(id: "w", label: "W", cells: [
            KanaCell(hiragana: "わ", katakana: "ワ", romaji: "wa"),
            KanaCell(hiragana: "·", katakana: "·", romaji: ""),
            KanaCell(hiragana: "·", katakana: "·", romaji: ""),
            KanaCell(hiragana: "·", katakana: "·", romaji: ""),
            KanaCell(hiragana: "を", katakana: "ヲ", romaji: "wo")
        ]),
        KanaRow(id: "n-final", label: "Nasal", cells: [
            KanaCell(hiragana: "ん", katakana: "ン", romaji: "n"),
            KanaCell(hiragana: "·", katakana: "·", romaji: ""),
            KanaCell(hiragana: "·", katakana: "·", romaji: ""),
            KanaCell(hiragana: "·", katakana: "·", romaji: ""),
            KanaCell(hiragana: "·", katakana: "·", romaji: "")
        ])
    ]

    private let combinationExamples = [
        CombinationExample(id: "kya", hiragana: "き + ゃ → きゃ", katakana: "キ + ャ → キャ", romaji: "kya"),
        CombinationExample(id: "shu", hiragana: "し + ゅ → しゅ", katakana: "シ + ュ → シュ", romaji: "shu"),
        CombinationExample(id: "cho", hiragana: "ち + ょ → ちょ", katakana: "チ + ョ → チョ", romaji: "cho"),
        CombinationExample(id: "nya", hiragana: "に + ゃ → にゃ", katakana: "ニ + ャ → ニャ", romaji: "nya"),
        CombinationExample(id: "ryo", hiragana: "り + ょ → りょ", katakana: "リ + ョ → リョ", romaji: "ryo")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.spaceSm) {
            Text("Kana sound pattern")
                .font(AppTypography.body.weight(.semibold))
                .foregroundStyle(AppColors.textPrimary)
            Text("Hiragana and katakana use the same sound pattern in two scripts. This compact table shows how the rows work; Romaji is only a reading aid, not English pronunciation.")
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
            Text("Basic sound chart")
                .font(AppTypography.metadata.weight(.semibold))
                .foregroundStyle(AppColors.textPrimary)
            Text("The Vowels row shows the five standalone vowel sounds. Each later row combines a consonant family with those vowels; every cell shows Hiragana, Katakana, then Romaji in the order a · i · u · e · o.")
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
            soundTable(soundRows)
            Text("How sounds are built")
                .font(AppTypography.metadata.weight(.semibold))
                .foregroundStyle(AppColors.textPrimary)
            Text("Each basic kana in the chart has its own sound. A small ゃ・ゅ・ょ then combines with the preceding i-row kana to make one contracted sound. Dakuten ゛ voices a sound, handakuten ゜ changes the は-row to a p-sound, small っ doubles the next consonant, and ー lengthens a katakana vowel.")
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
            VStack(alignment: .leading, spacing: AppSpacing.spaceSm) {
                ForEach(combinationExamples) { example in
                    VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
                        Text(example.hiragana)
                            .font(CJKFontRole.japanese.font(size: 16))
                        Text(example.katakana)
                            .font(CJKFontRole.japanese.font(size: 16))
                            .foregroundStyle(AppColors.textSecondary)
                        Text(example.romaji)
                            .font(AppTypography.metadata)
                            .foregroundStyle(AppColors.accentPrimary)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Text("Common notes: し is shi, ち is chi, つ is tsu, ふ is fu, and を is usually pronounced o as a particle. Katakana also has extra spellings for imported words; those are combinations, not a second sound system.")
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.textTertiary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(AppSpacing.spaceSm)
        .background(AppColors.surfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.small))
    }

    private func soundTable(_ rows: [KanaRow]) -> some View {
        VStack(spacing: 0) {
            LazyVGrid(columns: kanaChartColumns, alignment: .leading, spacing: 0) {
                tableCell("Row", width: 64)
                ForEach(["a", "i", "u", "e", "o"], id: \.self) { vowel in
                    centeredTableCell(vowel)
                }
            }
            .font(AppTypography.metadata.weight(.semibold))
            .foregroundStyle(AppColors.textSecondary)
            ForEach(rows) { row in
                LazyVGrid(columns: kanaChartColumns, alignment: .leading, spacing: 0) {
                    tableCell(row.label, width: 64)
                    ForEach(row.cells.indices, id: \.self) { index in
                        kanaCell(row.cells[index])
                    }
                }
                .padding(.vertical, AppSpacing.space2xs)
                .font(AppTypography.metadata)
                .foregroundStyle(AppColors.textPrimary)
                Divider()
            }
        }
    }

    /// The header and every data row share these six columns so vowel labels stay over their cells.
    private var kanaChartColumns: [GridItem] {
        [GridItem(.fixed(64), spacing: AppSpacing.space2xs)]
            + Array(repeating: GridItem(.flexible(), spacing: AppSpacing.space2xs), count: 5)
    }

    private func kanaCell(_ cell: KanaCell) -> some View {
        VStack(spacing: 0) {
            Text(cell.hiragana)
                .font(CJKFontRole.japanese.font(size: 17))
            Text(cell.katakana)
                .font(CJKFontRole.japanese.font(size: 17))
                .foregroundStyle(AppColors.textSecondary)
            Text(cell.romaji.isEmpty ? " " : cell.romaji)
                .font(AppTypography.metadata)
                .foregroundStyle(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity, minHeight: 52, alignment: .top)
    }

    @ViewBuilder
    private func tableCell(_ text: String, width: CGFloat? = nil) -> some View {
        if let width {
            Text(text)
                .frame(width: width, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
        } else {
            Text(text)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    /// Centers vowel labels over the centered kana in each sound-table column.
    private func centeredTableCell(_ text: String) -> some View {
        Text(text)
            .frame(maxWidth: .infinity, alignment: .center)
            .fixedSize(horizontal: false, vertical: true)
    }
}

private struct HangulReadingGuide: View {
    private let consonants = [("ㄱ", "g/k"), ("ㄴ", "n"), ("ㄷ", "d/t"), ("ㄹ", "r/l"), ("ㅁ", "m"), ("ㅂ", "b/p"), ("ㅅ", "s"), ("ㅇ", "silent/ng"), ("ㅈ", "j"), ("ㅎ", "h")]
    private let vowels = [("ㅏ", "a"), ("ㅓ", "eo"), ("ㅗ", "o"), ("ㅜ", "u"), ("ㅡ", "eu"), ("ㅣ", "i")]

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.spaceSm) {
            Text("Hangul letters become syllable blocks")
                .font(AppTypography.body.weight(.semibold))
                .foregroundStyle(AppColors.textPrimary)
            Text("Hangul is an alphabet, not a one-symbol-per-syllable system. Letters combine into blocks: an initial consonant, a vowel, and sometimes a final consonant.")
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
            HStack(alignment: .top, spacing: AppSpacing.spaceMd) {
                VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
                    Text("Consonants").font(AppTypography.metadata.weight(.semibold))
                    ForEach(Array(consonants.enumerated()), id: \.offset) { _, item in
                        Text("\(item.0)  \(item.1)").font(AppTypography.caption)
                    }
                }
                VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
                    Text("Vowels").font(AppTypography.metadata.weight(.semibold))
                    ForEach(Array(vowels.enumerated()), id: \.offset) { _, item in
                        Text("\(item.0)  \(item.1)").font(AppTypography.caption)
                    }
                }
            }
            .foregroundStyle(AppColors.textPrimary)
            VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
                Text("Block examples").font(AppTypography.metadata.weight(.semibold))
                Text("가 = ㄱ + ㅏ = ga")
                Text("산 = ㅅ + ㅏ + ㄴ = san")
                Text("한글 = 한 + 글")
            }
            .font(AppTypography.caption)
            .foregroundStyle(AppColors.textPrimary)
            Text("The romanization is an aid: ㅇ is silent at the start but ng at the end, ㄹ is shown as r/l, and ㅓ eo and ㅡ eu are not ordinary English vowel spellings.")
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.textTertiary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(AppSpacing.spaceSm)
        .background(AppColors.surfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.small))
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
