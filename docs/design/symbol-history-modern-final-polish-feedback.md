# Symbol / History / Modern Language Final Polish Feedback

## Status

This document preserves the complete user-provided polish brief received on 2026-09-04.

It is the approved design and implementation brief for the current surgical polish pass. Implementation has not started. The broader History-page rework is explicitly reserved for the next implementation.

## User-provided brief

# CODEX HANDOFF — SYMBOL / HISTORY / MODERN LANGUAGE FINAL POLISH

We are now in a late-stage polish pass. The current app is largely designed and implemented.

Core instruction: surgical changes only

Please do not redesign or reinterpret finished parts of the app.

Make only the targeted changes described below. Preserve the current:

app architecture
navigation
typography system
colors
spacing language
card language
existing illustrations
overall museum/gallery visual identity

Where possible, modify the existing components rather than replacing them with new systems.

1. New approved Symbol backgrounds

We have now created and approved a new visual asset/reference called:

Symbol_Background_v1

This contains the coordinated background treatment for all six evolution stages:

Origin
Oracle Bone
Bronze
Small Seal
Clerical
Regular

IMPORTANT

Use all six backgrounds, including Origin.

They were designed together intentionally so that every stage has:

matching dimensions
matching color temperature
matching background tone
matching visual weight
matching negative space
consistent transition from one stage to the next

Do not recreate these backgrounds or substitute newly generated artwork.

If Symbol_Background_v1 currently exists as one six-panel reference sheet, extract/crop the six corresponding panels into individual production assets while preserving the artwork exactly.

Do not redraw them.

2. How the backgrounds should be used

The background is the environment.

The symbol-specific content goes on top of it.

Origin

Use:

Origin background + existing symbol-specific illustration

Examples:

Water background + Water illustration
Fire background + Fire illustration
Tree background + Tree illustration
Person background + Person illustration

The Origin background itself is intentionally subtle and mostly empty. This is correct.

Its purpose is to make Origin visually belong to the same exhibit sequence as the later stages.

For composite/pictographic constructions, retain the approved component illustrations so that separate meaningful components can still be understood visually.

Oracle Bone

Use:

Oracle background + correct Oracle glyph

Bronze

Use:

Bronze background + correct Bronze glyph

Small Seal

Use:

Small Seal background + correct Small Seal glyph

Clerical

Use:

Clerical background + correct Clerical glyph

Regular

Use:

Regular background + correct Regular glyph

3. Glyph positioning

For Oracle → Regular, the historical glyph remains the visual hero.

Keep it:

large
centered
high contrast
approximately consistent in visual position between stages

Do not move the glyph to one side to accommodate the material artwork.

The approved backgrounds are intentionally subtle enough to sit behind it.

The visual hierarchy should be:

glyph first
historical writing environment second

The user should notice the material/tool context, but their eye should still go immediately to the evolving character.

4. Why these backgrounds are being added

A major educational idea in Script Roots is that historical forms did not change in a vacuum.

The surface and writing tool/process affected how characters could be produced.

The new backgrounds should help communicate this visually:

Oracle Bone
bone / shell + carving

Bronze
bronze objects + inscription/casting/engraving context

Small Seal
brush/manuscript writing context

Clerical
brush + writing surface such as paper

Regular
increasingly clean, controlled brush/paper writing environment

This should primarily be learned through the visual environment rather than through a large explanatory UI.

5. Small material/tool caption

Below the main Symbol artwork/glyph area, add a very restrained one-line museum-style material/process caption.

Examples:

Bone / shell · carved

Bronze vessel · cast / inscribed

Bamboo / manuscript · brush

Paper · brush

Keep this:

small
secondary
visually quiet
one line
underneath the exhibit rather than competing with the glyph

This is intended as a factual cue reinforcing what the background already communicates visually.

The exact wording should be data-driven per historical stage and historically accurate.

For Origin, this metadata is not necessary in the same way; the Origin page is driven by the concept illustration.

6. Remove dates/periods from Symbol

We have decided to remove the historical date/period line from the individual Symbol evolution pages.

Keep the stage names:

Origin
Oracle Bone
Bronze
Small Seal
Clerical
Regular

But remove the date/period information from these Symbol pages.

The reasoning is deliberate:

Symbol should answer:

How did this particular character change visually?

History should answer:

When and why did these writing systems develop?

This avoids duplication and keeps Symbol much more visual.

7. Transition between Symbol stages

Add a restrained transition when the learner moves between:

Origin → Oracle → Bronze → Seal → Clerical → Regular

The main goal is to make successive forms easy to compare naturally without introducing a separate comparison screen.

Preferred behavior:

outgoing content gently fades
incoming content fades into essentially the same visual position
background dissolves between the corresponding stage backgrounds
keep movement minimal
roughly 250–400 ms

The character should feel visually anchored as the user moves through history.

Do not perform a literal shape-morph between historical glyphs.

A controlled crossfade is sufficient and more appropriate.

For Origin → Oracle, crossfade the Origin illustration into the first historical glyph/background combination.

8. Symbol onboarding: reduce to one page

The current introductory experience should become one strong onboarding page rather than two similar pages.

Use the stronger existing concept:

SCRIPT ROOTS

One idea. One symbol. Thousands of years.

Then briefly explain that the learner is about to follow the symbol from its recognizable origin through historical writing and into modern languages.

Keep the existing visual idea of showing a small progression from:

illustration → historical character → modern character

One primary CTA:

Explore Fire

The objective of this screen is simply to teach the product concept once and then enter the exhibit.

Do not make the learner repeatedly pass through multiple introductory screens when exploring symbols.

9. Modern-language pages are a different part of the experience

After Regular Script, we reach the modern-language sections.

These need additional refinement.

The modern sections should not simply look like another set of historical-script pages because they are teaching a different idea.

Historical pages answer:

How did the glyph change?

Modern pages answer:

How does this character/meaning live in this language today?

The modern pages should therefore be highly visual and language-specific.

The four contexts currently being handled are:

Simplified Chinese
Traditional Chinese
Japanese
Korean

Do not force exactly the same content hierarchy onto all four.

10. Simplified Chinese page

Chinese still predominantly expresses these concepts through Chinese characters, so the modern character should remain the visual hero.

For 水, conceptually:

水

shuǐ

Then visually strong examples underneath.

For example:

水滴
shuǐdī
water drop

The hierarchy should be:

Chinese character
Chinese example
Pinyin
English support

Pinyin is secondary to the Chinese script.

For characters whose Simplified and Traditional forms differ, use the appropriate Simplified form on this page.

For characters such as 水 where the form is identical, do not imply that the glyph itself changed simply because the page is Simplified Chinese.

11. Traditional Chinese page

The modern character should also remain visually dominant here.

Use the appropriate Traditional form.

Show the relevant modern pronunciation/usage supported by our language data.

If we support multiple Chinese reading contexts such as Mandarin and Cantonese, make those relationships visually clear rather than burying them in one block of text.

For example:

水

Mandarin

shuǐ

Cantonese

seoi2

with examples underneath where appropriate.

Keep the Chinese script visually dominant over romanization.

12. Japanese needs its own visual logic

Japanese still uses Kanji extensively in normal modern writing.

Therefore the Kanji remains important and should remain visually prominent.

However, the page needs to make the Japanese reading system extremely clear.

For 水:

水

Then visually separate:

Kun / native Japanese reading

みず

mizu

and:

On / Sino-Japanese reading

すい

sui

Then reinforce the difference with real usage.

For example:

Native reading

水
みず
water

Sino-Japanese compound

水道
すいどう
water supply

The learner should be able to understand visually:

the same Kanji participates in Japanese in different ways depending on the word.

Japanese hierarchy

Japanese script should dominate:

Kanji
Kana
Romaji
English

Do not make romaji as visually strong as Japanese writing.

Also make this data-driven.

Not every Kanji has a useful Kun reading and On reading that should always be displayed. Do not create empty or artificial categories just to satisfy the layout.

13. Korean requires a significantly different hierarchy

This is especially important.

Modern Korean should not be presented as though the Chinese character is still the normal primary written word.

For 水 there are two different relationships we want to teach.

Hanja / Sino-Korean relationship

水

↓

수

su

This is the Sino-Korean reading associated with 水.

It appears in Korean vocabulary derived historically from Chinese.

For example:

수분

subun

moisture / water content

Ordinary modern Korean word

For everyday “water”:

물

mul

This should be visually prominent because 물 is how a modern Korean normally writes the everyday word “water”.

The Korean screen must therefore clearly communicate:

水 → 수 = Hanja / Sino-Korean relationship

while

물 = ordinary native Korean word for water

The Hanja matters greatly to Script Roots because we are explaining the historical influence of Chinese characters.

But the page must not accidentally imply:

Korean writes “water” primarily as 水.

That would give the learner the wrong impression.

14. Korean layout should be data-driven

The Water example above demonstrates the concept, but do not hard-code the assumption that every symbol has:

one neat native Korean equivalent
one Sino-Korean equivalent
one Hanja compound

Different entries will behave differently.

The data model/layout should support, where available:

Hanja
Sino-Korean reading in Hangul
modern Korean word/meaning in Hangul
example Sino-Korean vocabulary
example ordinary Korean usage

If there is no natural separate native Korean equivalent, do not fabricate one.

The visual hierarchy should reflect actual modern Korean usage.

15. Modern pages should be visual, not paragraph-heavy

This is a major design requirement.

Do not explain these linguistic relationships primarily through large paragraphs.

Use:

typography scale
grouping
whitespace
reading labels
examples
visual relationships

to make the distinction immediately understandable.

The learner should ideally understand the page before reading every explanatory sentence.

For example, Korean should visually communicate something resembling:

水
Hanja

↓

수
Sino-Korean

used in:

수분

while separately emphasizing:

물
modern everyday Korean

Japanese should visually communicate:

水

with clearly separated:

みず — Kun/native reading

すい — On/Sino-Japanese reading

These are conceptual hierarchy examples; preserve the established Script Roots design language rather than literally copying arrows if another existing layout treatment works better.

16. Audio

Add small pronunciation audio controls to modern-language readings.

Keep them visually restrained.

Examples include:

Mandarin
Cantonese
Japanese Kun/On readings
Korean modern word
Korean Sino-Korean reading where appropriate

Audio should reinforce the reading shown immediately beside it.

It should not become a large media-control component.

17. History becomes the home of chronology

Because we are removing the dates from Symbol, History should now carry the broader chronological explanation.

History should explain:

when each major writing stage developed
broader historical periods
important surfaces/materials
important writing tools/processes
why those conditions affected writing
how writing gradually became more standardized

The progression remains:

Oracle Bone → Bronze → Small Seal → Clerical → Regular

but History has the space to explain the wider historical context.

18. History should continue into the modern writing traditions

The History experience should not simply stop at Regular Script.

After Regular Script, explain how the shared historical character tradition continued differently in the modern language environments represented by the app:

Traditional Chinese
Simplified Chinese
Japanese
Korean

This should be presented as branching developments, not as though these are four additional consecutive script stages.

Conceptually:

Regular Script / shared historical tradition

then development into different modern contexts.

Chinese

Explain continuity of Traditional forms and the later development/standardization of Simplified forms.

Japanese

Explain how Chinese characters became Kanji within Japanese, alongside the development of Japanese kana and the modern combination of Kanji + kana.

Korean

Explain the historical use of Chinese characters as Hanja, the development of Hangul, and the much more limited role of Hanja in modern Korean writing.

The purpose is for the learner to understand why the four modern-language pages behave differently.

Use historically verified dates/content already in our source/data workflow rather than inventing historical details in UI code.

19. History artwork/layout fixes

The current History implementation still has visible layout issues in places.

Please fix these surgically.

Specifically check:

incorrect image cropping
artwork not fitting the intended frame
title/artwork overlap
body text collisions
truncated text
inconsistent vertical spacing
incorrect aspect-fit / aspect-fill behavior
content close to or underneath navigation/safe areas

Do not redesign History from scratch.

Correct the existing layout and then add the modern continuation described above within the same established design language.

20. Historical forms are representative

History should make it clear somewhere appropriate that individual historical character forms are representative examples.

A short methodological note is enough:

Historical forms shown in Script Roots are representative examples. Actual forms varied across periods, regions, objects, and individual writers.

This does not need to be repeated on every Symbol page.

21. Scope of this pass

Please keep this pass specifically limited to:

integrating all six approved Symbol_Background_v1 stage backgrounds
placing the existing Origin illustrations and historical glyphs correctly on top
adding the subtle material/process caption
removing dates/period information from Symbol
adding the gentle stage crossfade
consolidating Symbol onboarding to one page
improving the Simplified/Traditional/Japanese/Korean modern pages
adding small pronunciation audio controls where supported
expanding History into the modern-language branches
correcting the existing History artwork/layout issues

Do not use this task as an opportunity for unrelated redesign or refactoring.

If a supporting change is necessary to achieve one of the items above, make the smallest change needed.

Final design principle

The Symbol evolution should increasingly feel like one continuous exhibit:

Origin background + character illustration

→ Oracle background + Oracle glyph

→ Bronze background + Bronze glyph

→ Seal background + Seal glyph

→ Clerical background + Clerical glyph

→ Regular background + Regular glyph

→ modern language-specific usage

The new backgrounds should make the learner feel the changing material conditions, while the centered symbol remains the primary subject.

Then the modern pages should clearly answer:

What became of this character/meaning in Chinese, Japanese, and Korean today?

That distinction — historical evolution first, modern linguistic reality second — is the target for this polish pass.

## Reconciliation notes

- `Symbol_Background_v1.png` exists as a six-panel reference sheet under `Reference Pictures/Chatgpt/`; it is approved for exact panel extraction/integration and has not yet been integrated.
- The existing `History_V1.png` remains adequate artwork/reference material. The most definite current defect is the native History header composition: a right-side crop is being expanded across the full header, while the fixed header height also clips the copy. Timeline row text width and crop positioning still require simulator comparison.
- Removing Symbol-page period lines and consolidating onboarding to one direct Fire entry are approved.
- History language branches are approved for this implementation as branches after Regular Script, not additional sequential stages.
- Every historical script entry and modern-language branch is approved to become clickable, opening a deeper detail destination with a back button. Those destinations are intentionally unfinished in this pass and must use verified content or explicit unfinished states.
- Audio and speaker controls are approved for this implementation; the separate handoff defines the iOS-only service boundary and platform-independent linguistic data requirements.
- Material/process captions and speech text may require schema, validator, runtime model, migration, importer, and test alignment; they must not create parallel content databases.
- The broader History-page rework is explicitly deferred to the next implementation.
- The brief’s modern-language hierarchy remains subject to editorial/source verification during implementation; no unsupported readings or examples should be invented.

See the approved [implementation plan](symbol-history-modern-final-polish-implementation-plan.md) for the exact scope and fallback boundary.

## Subsequent approved teaching-order update — 2026-09-05

The exact 126-symbol teaching order was subsequently changed by direct user instruction. The authoritative order is now stored in `content/research/zdic-v1-complete-manifest.json` and mirrored by `Sources/App/Corpus/SeedCorpusManifest.swift` and `Resources/V1CorpusManifest.json`. It begins with 一 and then follows the eight supplied gallery groups through position 126.

Onboarding now opens the first-ranked runtime symbol dynamically, so the current onboarding symbol is 一. This does not change the complete-evolution corpus membership, Fire's separate pilot/reference status, draft language content, or the approved visual polish scope.
