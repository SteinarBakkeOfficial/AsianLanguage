# Symbol Source Plan

## Goal

Preserve the agreed source strategy, starter symbol set, and broader candidate pool for the `Shared Character` evolution experience.

## Source Roles

The app's core asset and content work should treat symbol evolution as the key data pipeline. Most V1 visual assets are expected to be historical symbol assets, plus a small number of normal UI assets such as icons or buttons.

### Dong Chinese

Primary role: origin explanations, component decomposition, stage presence, and source cross-checking.

Useful fields observed:

- original or core meaning
- concise origin explanation
- component breakdown
- component role labels such as `iconic`, `meaning`, `sound`, and `remnant`
- stage where a component appears or becomes meaningful
- stage labels and dates for Oracle, Bronze, Seal, Clerical, and Regular
- modern Mandarin words and definitions
- source list and license information

Example findings:

- `天`: original meaning `head`; depicts a person `大` with an emphasized head, with meaning shifted to `top`, `high`, and `sky`.
- `休`: depicts a person `亻` resting under a tree `木`.
- `明`: originally moonlight `月` through a window `囧`; the window component was later reanalyzed as `日`.
- `男`: combines field `田` and plow/power `力`.
- `家`: roof `宀` as meaning component with a sound/remnant component from `豭`.

Use Dong Chinese text as a reference and editorial model. Rewrite app-facing copy in our own voice unless we intentionally accept Creative Commons Attribution-ShareAlike obligations.

### Wikimedia Commons Ancient Chinese Characters

Primary role: clean historical glyph visuals, especially SVG files.

Useful file pattern:

- `https://commons.wikimedia.org/wiki/File:{character}-oracle.svg`
- `https://commons.wikimedia.org/wiki/File:{character}-bronze.svg`
- `https://commons.wikimedia.org/wiki/File:{character}-bigseal.svg`
- `https://commons.wikimedia.org/wiki/File:{character}-seal.svg`

Example findings:

- `馬`: Oracle, Bronze, Big Seal, and Seal SVGs are available.
- `木`: Oracle, Bronze, Big Seal, and Seal SVGs are available.

The Commons Ancient Chinese Characters pages often list related variants beyond the basic four stages, including alternate oracle forms, dated bronze variants, slip/silk forms, clerical forms, and regular forms. Prefer Commons SVGs for bundled glyph assets when available because they are cleaner and easier to track per file.

### Modern Focus Languages

Modern focus-track content does not need origin or depiction history. It needs modern written forms, readings, and usage examples.

Likely source roles:

- Mandarin and Traditional Chinese: CC-CEDICT, Wiktionary, Unihan, Dong Chinese, or suitable Chinese dictionaries
- Japanese: Wiktionary, Jisho, Kanjipedia, or suitable kanji dictionaries
- Korean Hanja: Wiktionary, Naver Hanja, Unihan, or suitable Korean dictionaries

Modern sections should stay simpler than the origin/evolution section: form, sound/readings, and usage examples.

## Coverage Check

A candidate set of 186 symbols was checked against Dong Chinese pages and common Wikimedia Commons ACC SVG URL patterns.

Results:

- Dong Chinese pages found: `186 / 186`
- Dong Chinese had at least one tested stage image: `183 / 186`
- Dong Chinese had all four tested stage images: `97 / 186`
- Commons had at least one tested SVG: `118 / 186`
- Commons had all four tested SVGs: `73 / 186`

This is enough material to proceed with a real V1 content pipeline. The remaining work is editorial selection, source recording, asset intake, and review.

## First 50 Proof Set

Use this set to prove the JSON/content format and source-backed evolution flow before scaling further.

Selection principles:

- easy concepts
- visually teachable origin or component structure
- radical/basic-character value where possible
- useful today across Mandarin, Traditional Chinese, Japanese, and Korean
- strong likelihood of Dong Chinese source coverage and Commons historical glyph coverage
- first-run learner appeal: prioritize concrete visual symbols before abstract counting concepts

First 50, ordered for learner engagement:

1. `火` fire
2. `水` water
3. `山` mountain
4. `木` tree / wood
5. `日` sun / day
6. `月` moon / month
7. `雨` rain
8. `川` river
9. `田` field
10. `土` earth / soil
11. `天` sky
12. `馬` horse
13. `鳥` bird
14. `魚` fish
15. `牛` cow
16. `羊` sheep
17. `犬` dog
18. `人` person
19. `大` big
20. `女` woman
21. `子` child
22. `父` father
23. `母` mother
24. `目` eye
25. `耳` ear
26. `口` mouth
27. `手` hand
28. `足` foot
29. `心` heart
30. `王` king
31. `玉` jade
32. `石` stone
33. `刀` knife
34. `力` power
35. `文` writing / pattern
36. `金` metal / gold
37. `中` middle
38. `上` up
39. `下` down
40. `小` small
41. `一` one
42. `二` two
43. `三` three
44. `四` four
45. `五` five
46. `六` six
47. `七` seven
48. `八` eight
49. `九` nine
50. `十` ten

The numeric symbols remain in the first 50, but they should not lead the learner experience because they are more abstract. Start with visual objects and body/world symbols that make the evolution concept immediately satisfying.

## Upcoming Candidate Pool

Use this as the intended expansion pool after the first 50 prove the schema and visual flow.

`百 千 方 左 右 風 云 生 出 入 見 言 車 門 長 高 白 黑 赤 青 空 名 先 後 前 外 內 東 西 南 北 本 末 未 林 森 明 休 立 正 止 行 來 去 食 飲 衣 友 兄 弟 新 古 早 少 多 同 有 無 不 平 光 色 花 草 竹 米 貝 貞 元 首 身 自 鼻 牙 角 毛 皮 血 肉 骨 舌 音 書 學 校 道 思 愛 知 家 安 室 主 開 閉 問 聞 間 時 春 夏 秋 冬 海 河 江 湖 島 國 京 都 市 村 町 里 男 老 若 強 弱 低 深 清 暗 直 曲 圓 半 分 合 會 社 寺 院 醫 藥`

Some candidates will need modern-form normalization decisions before publication. For example, Japanese simplified forms such as `学`, `国`, `円`, and `会` may need to be modeled alongside traditional forms `學`, `國`, `圓`, and `會` depending on the underlying shared-character record.

## JSON Content Implications

Each symbol record should be readable and easy to adjust manually.

Recommended source-related fields:

- stable source ids for Dong Chinese, Commons files, and modern dictionaries
- stage-level `assetRef`
- stage-level `sourceUrl`
- optional `artifactAssetRef` for bones, vessels, rubbings, or inscriptions
- component entries with role labels such as `iconic`, `meaning`, `sound`, or `remnant`
- component introduction stage, so the app can explain components in Oracle Bone or whichever later stage first makes them meaningful
- component explanation text
- origin meaning separate from modern shared meaning
- editorial rewrite fields for app-facing copy

## Symbol Page Content Rules

Each symbol page should focus on the symbol being studied, not generic script history.

Stage page sequence:

1. origin image plus earliest available script form, usually Oracle Bone, or split into separate Origin and Oracle pages if the design needs more space
2. Bronze Script image, symbol-specific information, components introduced or clarified at this stage, and sound only when accessible enough to source
3. Seal Script image, symbol-specific information, components introduced or clarified at this stage, and sound only when accessible enough to source
4. Clerical Script image, symbol-specific information, components introduced or clarified at this stage, and sound only when accessible enough to source
5. Regular Script image, symbol-specific information, components introduced or clarified at this stage, and sound only when accessible enough to source
6. modern focus-language pages showing sign/form, sound/readings, usage, and examples

For one-component symbols such as `大`, show that the form itself is the component. For multi-component symbols such as `天`, show the components and clarify where they are visible or introduced in the evolution. Component explanation should follow the source-backed Dong Chinese style, while app-facing copy should be editorially rewritten.

Generic explanations of what Oracle Bone, Bronze, Seal, Clerical, and Regular scripts are belong in a separate `History` or `Method / History` page, not repeated inside every symbol.

Recommended asset decision:

- prefer Commons SVGs for bundled historical glyph assets when available
- use Dong Chinese as a reference and fallback for stage discovery
- mark missing assets visibly; never reuse modern regular script as a fake older stage

## Sequencing Recommendation

Do not implement all 50 records directly into the final UI before the design target is settled.

Recommended sequence:

1. Finish design preparation for the symbol evolution screen enough to lock the visible stage layout, bottom navigation, text density, and image treatment. See `docs/content/symbol-evolution-design-handoff.md`.
2. Implement or revise the JSON/content schema against 3-5 pilot symbols from the first 50.
3. Wire those pilot symbols into the horizontal stage experience.
4. Validate on iPhone/Mac with screenshots against the reference target.
5. Expand to the full first 50 once the schema and screen treatment survive the pilot.

This keeps the key data pipeline moving while avoiding rework if the final visual layout changes.
