# CJK Font and Modern-Forms Rendering Contract

Status: implemented typography foundation for the 126-record V1 runtime; historical content remains a separate rights/publication gate.

Date: 2026-09-03

## V1 museum boundary

The current V1 target is the **126-character complete-evolution selection** in [`content/research/zdic-v1-complete-manifest.json`](../../content/research/zdic-v1-complete-manifest.json). Every selected record has a ZDIC image for Oracle Bone, Bronze, Small Seal, and Clerical. The remaining 22 records from the 148-character intake remain research candidates and are not in V1.

The primary journey is:

`Origin / Illustration → Oracle Bone → Bronze → Small Seal → Clerical`

Regular Script and modern language forms follow as separate presentation layers.

## One identity, locale-specific forms

The app must not treat all Han characters as one universal visual glyph. A shared character identity and a rendered form are different concepts:

- One inherited identity may render differently under Chinese, Japanese, and Korean font conventions while retaining the same Unicode scalar.
- A modern orthography may use a different encoded character, such as Traditional `龍`, Simplified `龙`, and Japanese `竜`. These are explicit language/orthography forms, not font substitutions.
- Readings belong to language records. They must not be inferred from the displayed Han glyph.

Conceptually, each record owns:

```text
CharacterFamily
  historicalIdentity
  museumStages[]
  modernForms
    zh-Hant-TW: surface, locale
    zh-Hans: surface, locale
    ja-JP: kanji, locale, readings[], kanaReadings[]
    ko-KR: hanja, locale, hangulReadings[]
```

Use explicit script-role metadata where useful: `hanzi`, `kanji`, `hanja`, `hiragana`, `katakana`, and `hangul`.

## Regular Script / 楷書

Use CNS11643 **正楷體 / Regular Kai** as the consistent pedagogical rendering for the final Regular Script stage. It is a modern standardized Kai reference rendering, not an archaeological facsimile of one particular inscription or manuscript.

Source: [CNS11643](https://www.cns11643.gov.tw/), official [`Fonts_Kai.zip`](https://www.cns11643.gov.tw/opendata/Fonts_Kai.zip), downloaded 2026-09-03. The bundled BMP deployment face is `TW-Kai-98_1.ttf`; source and authorization details are recorded in [`Resources/Fonts/SOURCE-CJK.md`](../../Resources/Fonts/SOURCE-CJK.md).

Do not copy Regular Script glyphs from ZDIC. Do not present the Kai font as historical evidence.

## Modern / Used Today forms

After Clerical, show **Used Today** as a branching comparison:

- `zh-Hans`: Simplified Chinese, locale `zh-Hans`.
- `zh-Hant-TW`: Traditional Chinese Taiwan conventions, locale `zh-Hant-TW`.
- `ja-JP`: Japanese Kanji with Japanese glyph conventions, plus Hiragana/Katakana readings and normal Japanese examples.
- `ko-KR`: Korean Hanja with Korean glyph conventions, plus Hangul readings and contemporary Hangul examples.

Do not show a sequence such as `龍 → 龙 → 竜` as if it were historical evolution. It is a set of parallel modern orthographic outcomes from a shared history.

The Today panel should therefore show the modern surface form, script role, locale, readings, and examples together. Japanese is not Kanji-only, and Korean is not Hanja-only.

## Font roles

- Museum Regular Script: CNS11643 Kai.
- Modern Chinese, Japanese, and Korean Han glyphs: localized Adobe Source Han Serif variants.
- Native UI and metadata: the iOS system sans-serif design system initially; Source Han Sans is optional for a later fully controlled text layer.

Sources:

- [Adobe Source Han Serif](https://github.com/adobe-fonts/source-han-serif)
- [Adobe Source Han Sans](https://github.com/adobe-fonts/source-han-sans)

Use only the deployment files and weights the app needs. Do not bundle every weight, variable font, OTC, and language package by default. Preserve SIL Open Font License 1.1 and copyright files for Source Han packages.

## Museum renderer contract

The Regular Script and modern glyph renderers must share deterministic presentation rules:

- identical outer canvas dimensions;
- transparent or app-controlled background;
- consistent ink color and padding philosophy;
- intentional locale font selection;
- visible-ink optical bounding-box fitting and optical centering;
- no baked-in labels;
- limited, documented overrides only for exceptional glyphs.

Historical SVGs remain separately source-backed assets. The font renderer must never silently substitute a modern glyph for a missing historical stage.

## Rights and About / Method

About / Method now links and describes the source roles:

- ZDIC is the primary historical visual reference for the four museum stages. Copied ZDIC assets remain research-only until reuse permission is confirmed or cleared/public-domain replacements are acquired.
- CNS11643 Kai is the Regular Script reference and requires its official notice.
- Source Han Serif is the modern localized Han-glyph reference and its SIL Open Font License material is bundled in `Resources/Fonts/OFL-SourceHanSerif.txt`.

No source is commercially cleared merely because it is downloadable or attributed.

The selected font faces are bundled locally. The lightweight UI faces register at launch; the larger Kai and Source Han faces register on demand when Symbol/Today content is opened, keeping launch responsive without changing the approved typography or offline behavior. ZDIC historical images remain research-only and are not made commercially redistributable by this font change.

## QA fixture

Before release, compare `骨`, `直`, `令`, `門`, `國`, `龍`, `黑`, `海`, `學`, and `學/学` across Taiwan, Simplified Chinese, Japanese, and Korean, alongside `山`, `木`, `火`, `水`, `日`, `月`, and `人`. The fixture must verify that Japanese and Korean do not accidentally fall back to Chinese regional glyphs and that native Japanese kana and Korean Hangul remain visible where required.
