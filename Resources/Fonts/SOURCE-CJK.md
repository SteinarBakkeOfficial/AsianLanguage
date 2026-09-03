# Script Roots CJK font sources

These are the exact deployment faces bundled for the local prototype. The app uses the embedded font names listed below, not platform fallback, for major Regular Script and Used Today glyphs.

## CNS11643 Kai

- File: `TW-Kai-98_1.ttf`
- Original package: `Fonts_Kai.zip`
- Source: <https://www.cns11643.gov.tw/opendata/Fonts_Kai.zip>
- Source and authorization page: <https://www.cns11643.gov.tw/pageView.jsp?ID=59&SN=&la=0&lang=tw>
- Role: modern standardized Kai reference for the Regular Script endpoint
- Package downloaded: 2026-09-03

The Kai face is a consistent modern reference rendering. It is not presented as an archaeological inscription. The CNS11643 authorization page permits use under the Government Data Open License 1.0 or SIL Open Font License 1.1 and requires source attribution; the source page and its terms remain the authority.

## Adobe Source Han Serif

- Release: 2.003R
- Source repository/release: <https://github.com/adobe-fonts/source-han-serif/releases/tag/2.003R>
- License: SIL Open Font License 1.1, included in `OFL-SourceHanSerif.txt`
- Package download date: 2026-09-03

| App role | Bundled file | Original release package | Embedded font name |
| --- | --- | --- | --- |
| Japanese Kanji and Japanese native text | `SourceHanSerifJP-Regular.otf` | `07_SourceHanSerifJ.zip` / `SourceHanSerif-Regular.otf` | `SourceHanSerif-Regular` |
| Korean Hanja and Korean native text | `SourceHanSerifKR-Regular.otf` | `08_SourceHanSerifK.zip` / `SourceHanSerifK-Regular.otf` | `SourceHanSerifK-Regular` |
| Simplified Chinese | `SourceHanSerifSC-Regular.otf` | `09_SourceHanSerifSC.zip` / `SourceHanSerifSC-Regular.otf` | `SourceHanSerifSC-Regular` |
| Traditional Chinese Taiwan | `SourceHanSerifTC-Regular.otf` | `10_SourceHanSerifTC.zip` / `SourceHanSerifTC-Regular.otf` | `SourceHanSerifTC-Regular` |

Only the Regular faces are bundled initially. The full release packages, other weights, variable fonts, and Source Han Sans are not bundled.
