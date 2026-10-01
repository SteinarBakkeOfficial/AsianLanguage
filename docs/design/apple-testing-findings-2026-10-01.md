# Apple Testing Findings — 2026-10-01

Status: screenshot review and local implementation complete; macOS/Xcode verification remains. The supplied screenshot blockers have been addressed in the Windows workspace, but the package is not finally release-ready until the Apple build is checked.

These were targeted post-release-candidate observations. They did not reopen the completed V1 corpus review or authorize broad redesign. The listed Symbol, History, onboarding, source-navigation, and action-surface issues are now implemented locally; this document remains the audit trail for Apple/Xcode verification and any later Patch 0.1 observations.

## AT-01 — Oracle Bone captions must explain non-obvious forms

Some Symbol stage text is still insufficient even though most captions are acceptable.

Example: `Well`.

- The Oracle Bone image does not make “well” immediately obvious.
- The current Oracle Bone caption is empty or insufficient.
- The learner therefore sees an unfamiliar historical form without the visual bridge needed to understand it.

Required follow-up:

- Inspect the supplied Oracle image and the completed Origin/Illustration text together.
- Keep the explanation of why the illustration means “well” in Origin, as already agreed.
- Add a concise Oracle Bone caption only for the difficult visible feature: what is hard to recognize, what lines or marks are present, and why the intended well is not immediately clear.
- Do not repeat the complete Origin explanation or invent a historical reason that cannot be seen in the glyph.

This is a targeted continuation of the approved Oracle rule, not a request to add text to every Oracle form.

## AT-02 — Standardize the four target-language example layouts

The four target-language pages are not visually centralized.

Current inconsistency:

- Japanese places the English translation below the example and the spoken romanized form beside the Japanese example.
- The other three language presentations place romanization and English translation to the right of the example.

Required follow-up:

- Establish one predictable example-row hierarchy for Simplified Chinese, Traditional Chinese, Japanese, and Korean.
- The learner should always be able to identify, in the same visual relationship:
  1. the written example;
  2. how it is pronounced or read;
  3. the English meaning.
- Japanese furigana may remain a language-specific feature, but it must fit into the same overall hierarchy rather than making Japanese the only differently arranged card.
- Verify the final arrangement against the supplied screenshot before changing layout.

The goal is not to erase linguistic differences; it is to make the information architecture consistent while preserving each language’s correct writing and reading conventions.

## AT-03 — History comparison box hierarchy

The History pages are substantially improved, but the box titled:

> One written tradition, different language environments

currently feels visually out of place.

Required follow-up:

- Inspect its position, surrounding spacing, surface treatment, and relationship to the article introduction.
- Decide whether it should become an integrated article introduction, a quieter explanatory note, or a table/card styled consistently with the surrounding History content.
- Preserve the useful explanation unless the screenshot shows that the content itself is wrong.

This is a visual-hierarchy issue first, not an instruction to remove the concept.

## AT-04 — Traditional Chinese pronunciation and tone explanation

The Traditional Chinese History page names tone systems, but does not yet teach the learner how to reproduce the tones.

The page must explain, in user-facing language:

- what the tone marks or tone numbers represent;
- whether a higher number means a higher pitch, a rising contour, or something else;
- how each tone moves or stays level;
- where the tone information is placed in the displayed word;
- whether the notation belongs to the whole syllable, a particular written character, or the word as a sequence of syllables;
- how the Taiwan/Mandarin presentation differs from the Hong Kong/Cantonese presentation when both are shown.

Important distinction for the follow-up:

- Mandarin Pinyin tone numbers/marks must not be explained using a Cantonese six-tone model.
- Cantonese Jyutping tone numbers require their own explanation if displayed.
- The screenshot must determine exactly which notation the current page is showing before copy is finalized.

At minimum, the page needs a clear text-and-visual explanation. Voice samples may strengthen it, but audio must supplement—not replace—the written explanation.

## AT-05 — Simplified Chinese pronunciation and Pinyin explanation

The Simplified Chinese page shows Pinyin and tone marks, which is useful, but it does not teach a beginner how to pronounce the different tones.

Required follow-up:

- Explain the Mandarin tone system in plain language.
- Show the relationship between the tone mark and the syllable.
- Explain the standard contour of the tones with a small visual guide or equivalent text.
- Clarify the neutral tone if it is supported by the examples.
- Show whether Pinyin is displayed inline after the word or above/beside each relevant character, and explain that choice.
- Use a real example from the page so the user can connect the guide directly to the displayed word.

For a beginner-facing explanation, a representative sequence such as `mā, má, mǎ, mà, ma` may be useful, but the final example and wording must match the approved content model and the page’s actual notation.

Japanese pitch accent and Korean pronunciation should not be forced into the Mandarin tone explanation. Each language needs the pronunciation system appropriate to it.

## AT-06 — Modern-language History cards need complete, balanced text

The four modern-language History pages are much improved. The screenshots may show missing text boxes or incomplete card content.

Required follow-up:

- Treat visibly missing text boxes as probable implementation/content errors until the screenshots establish otherwise.
- Compare Simplified Chinese, Traditional Chinese, Japanese, and Korean for equal editorial completeness.
- Bring Chinese and Korean up to the same level of clarity and polish as Japanese where their explanations are currently thinner.
- Include pronunciation guidance as part of the language explanation, not as an unexplained label.
- Preserve the distinctions between Chinese tones, Japanese readings/pitch information, and Korean Hanja/native Korean relationships.

The exact missing content must be identified from the screenshots before writing replacement copy.

## AT-07 — Regular Script conclusion is too shallow

The Regular Script summary currently does not give the learner enough sense of how the form changed and settled into the modern standard.

Required follow-up:

- Make the Regular Script conclusion a concise but substantive endpoint summary.
- It should identify the important visible features that remain, were added, were removed, merged, or settled into the final form.
- It must summarize the journey without repeating every previous stage.
- It must remain grounded in the actual selected stage forms.

Example direction for `Well`:

> The main lines remain recognizable through the later stages, while the interior dot is added and then removed; the form finally settles into the balanced shape used today.

That sentence is an example of the required level of explanation, not final approved wording. The actual wording must be checked against the Well assets.

## AT-08 — Symbol actions must not be hidden behind the three-dot menu

The current Symbol-page overflow/menu path exposes font licensing or informational content before allowing the user to perform common actions. This is poor interaction priority.

Required follow-up:

- Make these actions immediately and visibly accessible from the Symbol page:
  - Save/Favorite;
  - Review Later;
  - Share Symbol.
- Adding and removing Favorite or Review Later must be a simple, obvious toggle with immediate state feedback.
- Share should be a direct primary action, not buried behind a licensing screen.
- Keep `About this character` and `Character structure` easily available, since that organization is working well.
- Move font licenses, sources, and technical attribution behind a lower-priority information/source destination; they must never block ordinary learner actions.
- Preserve clear labels, selected states, accessibility labels, and one-tap removal behavior.

The screenshots should determine the best exact placement, but the priority rule is already clear: learner actions first, explanatory detail second, legal/source detail third.

## AT-09 — Positive Browse feedback to preserve

The star and note indicators in Browse are well understood:

- star = Favorite;
- note/review indicator = Review Later.

This visual language should be retained. The corresponding add/remove actions should be made equally easy inside the Symbol page.

## AT-10 — Remove duplicate About and Sources destinations

The current More page and Settings page both expose:

- `About Script Roots`;
- `Sources & Licenses`.

This creates two navigation paths to the same information and makes the app’s ownership of these pages unclear.

Required follow-up:

- Keep one canonical `About Script Roots` destination under More.
- Keep one canonical `Sources & Licenses` destination under More, either as its own More item or as one clearly owned child of About.
- Remove both duplicate entries from Settings; Settings should contain preferences and local app controls.
- Do not create a second replacement page while removing the duplicates.

Recommended release structure:

- More → About Script Roots;
- More → Sources & Licenses;
- Settings → preferences and local controls only.

This is a navigation/content-ownership correction, not a request to redesign the More page.

## AT-11 — Separate legal attribution from Symbol teaching content

The Symbol `…` sheet currently displays the complete `record.sources` array. For a record such as `Well`, that includes:

- research and etymology references;
- a ZDIC historical-asset reference;
- CNS11643 Kai and Adobe Source Han Serif font references;
- the internally authored Script Roots origin illustration, including an OpenAI generation URL.

This is the wrong user-facing grouping. It mixes editorial research provenance, asset rights, implementation notices, and the learner’s character explanation into one repeated list on every Symbol page.

Required follow-up:

- Remove the general `Sources` section from the per-Symbol information sheet.
- Keep `About this character` and `Character structure` available from that sheet.
- Keep the complete provenance and source IDs in the canonical content package/repository for editorial audit and release checks.
- Put only genuinely necessary rights and attribution notices in one global `Sources & Licenses` / legal surface.
- Deduplicate global notices by source identity rather than repeating them once per character.
- Include ZDIC or another historical-asset provider only to the extent required by the actual reuse/license terms for bundled assets.
- Include font notices only when their license or distribution terms require user-facing attribution, and show them once globally—not on every Symbol.
- Keep system implementation notices, such as Apple speech synthesis, in the global legal-notices layer when required; they are not Symbol sources.
- Do not present Script Roots’ own origin illustrations as external sources or licensing obligations. Their internal authorship/provenance may remain in repository metadata for audit, but should not appear as a repeated learner-facing source entry.
- Do not expose the OpenAI generation URL as an educational source or imply that the internal illustration is historical evidence.

Default rule for release: a Symbol page shows no source list. A symbol-specific attribution may appear only when a particular displayed asset has a legally required, user-facing attribution that cannot be satisfied by the global notice.

The current `SourcesLicensesView` already attempts to filter technical/generated provenance from the readable global list, but the Symbol sheet bypasses that filtering by rendering `record.sources` directly. Both surfaces must follow the same separation rule after approval.

## AT-12 — Add real pronunciation guides for Japanese kana and Korean Hangul

The Japanese and Korean History pages identify the scripts and show romanized readings, but they still assume that a beginner already knows how to turn the written symbols into those sounds. This is not sufficient for an English-first app.

The guide must explain that romanization is a learning aid and an approximation, not a promise that the sound is identical to an English sound.

### Japanese requirement

Japanese needs a compact kana reference that shows both scripts together:

- Hiragana and katakana side by side for the same basic sound;
- the five vowel sounds and the main consonant rows;
- the irregular-looking but common readings such as `し shi`, `ち chi`, `つ tsu`, `ふ fu`, and `を o`;
- voiced and semi-voiced marks, such as `か ka → が ga` and `は ha → ぱ pa`;
- combined sounds with small `ゃ`, `ゅ`, and `ょ`, such as `きゃ kya`;
- `ん n`, small `っ` and long vowels, because these change how a beginner reads a word.

The first visual should be a readable basic kana chart, not a wall of every rare loanword combination. A secondary note can explain that katakana has additional combinations for foreign words.

The Japan Foundation’s official Irodori kana material is a strong editorial reference: it places kana in a table with romanization, includes both basic and voiced rows, and separately explains long vowels and doubled consonants. It also treats the romanization below a kana as a reading/input aid rather than as a claim that English spelling reproduces Japanese pronunciation.

### Korean requirement

Korean needs two related visuals, because Hangul is not a syllabary like kana:

1. A letter chart showing the basic consonants and vowels with standard romanization and a careful pronunciation hint.
2. A syllable-block diagram showing how letters combine into a readable unit:
   - initial consonant + vowel: `가 = ㄱ + ㅏ = ga`;
   - initial + vowel + final consonant: `산 = ㅅ + ㅏ + ㄴ = san`;
   - a multi-block example such as `한글 = 한 + 글`.

The explanation must include the cases that make a basic “one symbol = one English sound” chart misleading:

- `ㅇ` is silent at the beginning of a block but `ng` at the end;
- `ㄱ`, `ㄷ`, and `ㅂ` are romanized differently depending on position (`g/k`, `d/t`, `b/p`);
- `ㄹ` is shown as `r/l` because its sound depends on position;
- `ㅓ` is written `eo` and `ㅡ` as `eu`, neither of which is an ordinary English spelling cue;
- doubled and aspirated consonants need their own explanation rather than being treated as ordinary English letters.

The National Institute of Korean Language is the primary reference for this. Its Hangeul overview explains the initial, medial, and final positions in a syllable block, and its Romanization of Korean page provides the vowel and consonant mappings and the positional rules.

### Chinese distinction

The Chinese tracks need a related but different guide, not the same letter chart:

- Mandarin uses a syllable structure of initial + final + tone. Pinyin letters are not pronounced like ordinary English spelling, and the tone mark belongs to the syllable’s vowel structure.
- Hong Kong Cantonese Jyutping writes the syllable with Latin letters and places an ASCII tone number at the end, such as `fu1` or `fu6`. The number is part of the pronunciation notation; it is not an index for a character.
- The Simplified and Traditional pages should therefore teach Pinyin and Jyutping in their own tone diagrams, while Japanese and Korean teach script decoding in their own charts.

The Linguistic Society of Hong Kong’s Jyutping reference explicitly shows the six tone numbers and states that the tone number appears at the end of the syllable. A Mandarin educational reference gives the initial/final/tone structure and the four basic Pinyin tone contours. These reinforce the existing AT-04 and AT-05 findings.

### Recommended in-app presentation

- Add a small `How to read this script` guide to each relevant modern-language History page.
- Use one custom, native app visual per script rather than embedding an external chart image.
- Make each chart cell show: native symbol, romanization, and a short pronunciation cue where an English reader is likely to misread it.
- Follow the chart immediately with one real example from the page, decomposed into its readable units.
- Keep audio playback as a useful supplement, not as the only explanation.
- Do not force Japanese kana, Korean Hangul, or Chinese tone notation into one identical chart. They need a shared visual hierarchy but language-specific rules.

These official references should guide the content and chart design:

- [Japan Foundation — Irodori kana reference](https://www.irodori.jpf.go.jp/assets/data/Kana_all.pdf)
- [National Institute of Korean Language — About Hangeul](https://www.korean.go.kr/eng_hangeul/principle/001.html)
- [National Institute of Korean Language — Romanization of Korean](https://www.korean.go.kr/front_eng/roman/roman_01.do)
- [Mandarin.ac.cn — Parts of a Chinese syllable and Pinyin tones](https://www.mandarin.ac.cn/resources/pinyin.html)
- [Linguistic Society of Hong Kong — Jyutping scheme](https://lshk.org/jyutping-scheme/)

The external charts are references only. Do not bundle copied chart images until their reuse rights are confirmed; the preferred implementation is our own chart built from the verified mappings.

## AT-13 — Expand onboarding into orientation plus language setup

The current onboarding is one full page, which is a good basic shape, but its orientation is incomplete.

Current behavior:

- It introduces the Mountain Symbol Journey.
- It briefly mentions opening History and choosing languages in More.
- It immediately starts the Symbol Journey with all four language tracks enabled.

The current wording does not clearly tell a new learner that the History pages explain how each selected language is written and pronounced. It also makes the learner discover language selection later in More, after the first Symbol has already started.

Recommended onboarding flow:

1. Keep the current first page as the concise product and Symbol Journey introduction.
2. Add a second onboarding page before entering Mountain: `Choose your language paths`.
3. Show Simplified Chinese, Traditional Chinese, Japanese, and Korean as selectable tracks, all enabled by default.
4. Explain that History contains the detailed explanations for each writing and pronunciation system.
5. Allow the learner to continue with all four selected, turn off any tracks, or use the existing museum-only state if all tracks are turned off.
6. Make the final action explicit, such as `Begin with Mountain`.

This should be setup and orientation, not a forced language test. The learner should be able to accept the default selection quickly and reach the Symbol without friction.

The current local state model already has persisted focus-track selection and onboarding milestones, so the implementation should reuse those existing concepts rather than add a second language-settings system.

## AT-14 — Re-review every Oracle Bone and Regular Script caption

The approved content boundary is now explicit:

- Origin / Illustration: approved;
- Bronze: approved;
- Small Seal: approved;
- Clerical: approved;
- Oracle Bone: not approved;
- Regular Script: not approved.

The current package contains 126 release records. A scan found 74 empty Oracle transition captions and 52 non-empty Oracle captions. Regular Script has a non-empty transition caption for all 126 records, but those captions have not received the final approval pass.

Oracle Bone should not be treated as empty by default. Even a strong pictograph carved on bone or shell may be difficult for a modern learner to recognize. The Oracle caption should therefore normally use the same restrained, visible-form style as Bronze through Clerical:

- describe what is visibly difficult to recognize;
- identify the lines, framing, dots, limbs, openings, or other relevant marks;
- explain how those marks relate to the approved Origin illustration;
- say when the resemblance is indirect because the form is simplified, stylized, damaged, or difficult to read;
- avoid repeating the full Origin explanation when the Origin already establishes the intended meaning;
- leave the caption empty only when the Oracle image is genuinely self-explanatory after the Origin stage.

Regular Script also needs a full final-stage pass. Its caption should explain how the visible form settles into the modern standardized endpoint, including important additions, removals, merges, preserved lines, or changed arrangement. It should give the learner a meaningful conclusion rather than merely naming the final form.

The next review must therefore inspect every Oracle image and every Regular endpoint individually. It must not alter the already approved Origin, Bronze, Small Seal, or Clerical wording except where a screenshot or factual inconsistency proves a separate issue.

## AT-15 — History article tables render headers without their rows

The `Testing1_10` screenshots show several History comparison tables with their column headers and footer notes visible, but no body rows. This is a release blocker because the page presents an apparently empty comparison while implying that the information is present.

Confirmed affected screenshots include:

- Korean: `A Hanja reading is not the same as a native Korean word`;
- Japanese: `Japanese writing uses several systems together` and `Kana preserves a visible history of abbreviation`;
- Traditional Chinese: `One written tradition, different language environments`;
- Modern bridge: `The modern paths are related, but not interchangeable`.

The source data in `Sources/App/Navigation/RootTabView.swift` contains populated rows for these tables. The likely rendering defect is in `HistoryArticleTableView`: the nested column `ForEach` uses the same column-offset IDs for every row inside one `LazyVGrid`, so row cells can collide with one another and with the header IDs. The implementation must use a unique row-and-column identity (or an equivalent grid structure) and be verified on every History article, not only the screenshots listed above.

Acceptance requirement: every displayed table must show its complete header, every configured row, readable wrapping, and its note without horizontal clipping or duplicate/missing cells.

## AT-16 — Screenshot review record and first-use verdict

The folder contains 52 PNG files. Eight exact duplicate pairs were detected, leaving 44 unique screenshots; all 44 unique images were inspected.

Positive findings to preserve:

- the overall clay-and-paper visual language, navigation shell, Home, Browse, About, and More surfaces are coherent;
- Origin, Bronze, Small Seal, and Clerical Symbol stages generally communicate clearly;
- the History prose is substantially improved and the four modern-language sections have a strong editorial direction;
- Browse's star and note indicators are understandable;
- the per-language Usage pages contain useful examples and readable written/read/English relationships, even though the overall row hierarchy still needs normalization.

Release blockers confirmed by the screenshots:

1. Empty History table bodies (AT-15).
2. Oracle Bone pages such as Mountain and Well show the glyph and material caption but no visible explanatory transition caption (AT-01 and AT-14).
3. The Well Regular Script caption is too shallow to serve as the final journey summary (AT-07 and AT-14).
4. The Symbol information sheet still shows a long per-character source list, including research sources, font notices, ZDIC, and the internal origin illustration, before the common actions (AT-08 and AT-11).
5. `About Script Roots` and `Sources & Licenses` remain duplicated between Settings and More (AT-10).
6. Onboarding explains the general journey but does not provide the requested second language-selection/orientation step or clearly explain that History contains writing and pronunciation guides (AT-13).
7. Japanese and Korean History pages explain the concepts of kana and Hangul but do not yet provide the requested beginner decoding charts; Chinese pages show Pinyin/Jyutping examples but still need the requested tone-contour teaching (AT-04, AT-05, and AT-12).
8. Japanese Usage is linguistically justified in using furigana and a different reading arrangement, but its overall information hierarchy is not yet aligned with the three other language tracks (AT-02).

First-time-user verdict: a new learner can understand the app's overall promise and navigate the main areas, but will encounter apparently broken comparison tables, unexplained historical glyphs, and incomplete pronunciation instruction. Those are release-blocking comprehension failures, not post-release polish items. The app should not be described as release-ready until the blockers above are corrected and rechecked on-device.

## Final implementation contract — 2026-10-01

The next implementation is one focused release pass. It must:

- repair the shared History table renderer and verify every populated table;
- write the final visible-form Oracle caption and Regular Script endpoint summary for all 126 records, preserving approved Origin, Bronze, Small Seal, and Clerical copy;
- use the Japanese vertical reading order as the common mobile Usage hierarchy: native form, reading aid, then English meaning;
- add native History guidance for Mandarin tones, Jyutping tone numbers, kana decoding, and Hangul letter/block decoding;
- add the second onboarding setup page with all four tracks enabled by default and an explicit History/pronunciation explanation;
- expose Favorite, Review Later, and Share directly from the Symbol toolbar;
- remove the per-Symbol source list and duplicate Settings destinations while preserving repository provenance and the canonical More source/legal page;
- run the content/runtime import and all local checks, then perform Apple/Xcode screenshot verification.

No new feature family, corpus expansion, historical asset replacement, or unrelated redesign is authorized by this contract.

## Screenshot review checklist

When the screenshots arrive, inspect:

- the Well Oracle Bone image and caption;
- at least one example card from each target language;
- Japanese, Chinese, and Korean row alignment;
- the Traditional Chinese tone explanation and notation placement;
- the Simplified Chinese Pinyin tone explanation and notation placement;
- all four modern-language History cards for missing text boxes;
- the `One written tradition, different language environments` box in context;
- the Regular Script summary for Well and representative other symbols;
- the three-dot menu, font-license route, and primary Symbol actions;
- Favorite/Review Later selected and unselected states;
- Share Symbol discoverability;
- Browse star/note behavior, which should remain unchanged unless the screenshots reveal a concrete problem.

No implementation should begin from this record alone where the screenshot is needed to distinguish a missing asset, missing text, layout problem, or intentional language-specific treatment.

## Latest testing findings — post-implementation review

These findings supersede the corresponding action and Usage-layout requirements in the earlier final implementation contract above. They are recorded for the next focused correction pass; they do not reopen the completed corpus review or the approved historical-stage wording.

### AT-17 — Keep only Favorite visible in the Symbol toolbar

The Symbol page should show only:

- the Favorite star;
- the three-dot More action.

Review Later and Share should not be quick toolbar marks. They should be grouped with Mark as Learned inside the character action area opened from More. The Favorite star remains the one direct quick action. Browse's existing star and Review Later indicators are not changed by this finding.

### AT-18 — Restore the intended target-language example hierarchy

The current vertical stack is incorrect for Simplified Chinese, Traditional Chinese, and Korean, and the resulting spacing also weakens all four target-language pages. The intended mobile example relationship is:

1. the native word or phrase is prominent and visually separated from the surrounding Symbol content, with the example form normalized and centered within its card;
2. the reading or romanization sits to the right of that native form on the same example line;
3. the English meaning sits below that line.

This is a visual hierarchy correction, not a request to remove language-specific details. Japanese furigana and other language-specific reading aids remain valid, but the native form must not collapse into an entirely left-aligned vertical stack beneath the main Symbol.

### AT-19 — Japanese History must explain how kana combine into sounds

The current Japanese guide identifies individual Hiragana, Katakana, and Romaji equivalents, but it does not yet teach a new learner how to combine kana into a spoken unit. The guide must add explicit composition examples, such as:

- `か` / `カ` → `ka`;
- `きゃ` = `き` + small `ゃ` / `キャ` → `kya`;
- voiced changes such as `か` → `が` and `し` → `じ`;
- small `っ` for a doubled consonant and `ー` for a long vowel in Katakana.

The learner needs to see that kana are combined into mora-sized sound units; a one-symbol lookup table alone is insufficient. This explanation belongs in History, alongside the existing Chinese tone and Korean Hangul guidance.

### Confirmed complete areas

- Onboarding is complete for the current design.
- Most Symbol text is complete.
- Most History pages are complete.
- Chinese History guidance is complete for Simplified and Traditional Chinese.
- Korean History guidance is complete and sufficiently explains Hangul reading for the current scope.
- Japanese History needs the kana-combination explanation above before it is considered complete.

### AT-20 — Quick Review needs meaningful prompts and transient exit behavior

Quick Review is a useful feature and its lightweight, no-score/no-timer format should be preserved. The current implementation does not yet serve that purpose well:

- `What character connects to this form?` is vague and can show the same modern form that the answer repeats;
- `What idea does this character carry?` is a generic flashcard prompt rather than a recognition question grounded in the Symbol Journey;
- the reading questions expose isolated readings without enough context about which language or writing system the learner is recognizing;
- the answer is often only a word or reading, without the short visual or historical reason that makes the review useful;
- leaving Quick Review through Symbol, Journey, Usage, Browse, Home, or another page can leave the lesson in review mode and return the user to Quick Review instead of completing the transient session.

Recommended Quick Review direction:

1. Keep the session short, optional, and playful: three or four meaningful cards, no score, timer, streak, or penalty.
2. Use prompts tied to visible content: show a historical glyph or Origin image and ask for the shared meaning; show the modern character and ask for its meaning; show a language reading and ask which language/system it belongs to; or show a before/after pair and ask what visible feature changed.
3. Make every answer explanatory. Pair the answer with one concise reason, such as the visible frame, preserved body outline, added dot, removed stroke, or language-specific reading label.
4. Show the language name and the native form beside the romanized reading. Do not ask a learner to interpret an unlabeled reading string.
5. Keep `Open Symbol Journey` as an escape hatch, but make it a deliberate transition into the Journey rather than a continuation of the review session.

Quick Review must be transient. The moment the user leaves it, opens the Symbol Journey, changes to Usage, returns to Browse/Home, or selects another page, the review session is finished and must not be restored automatically. The next-symbol action after finishing should also enter the next Symbol's intended destination, never the previous review state.

### Confirmed current status after Testing1_11

- Settings and the previously completed Settings/About/source changes are accepted and should remain unchanged.
- The Quick Review shell and the idea of a lightweight recognition activity are accepted.
- Quick Review copy/question design and exit-state handling are new focused corrections.

### AT-21 — Testing1_11 visual confirmation

The newly available `Reference Pictures/Testing1_11` set contains 16 screenshots. It confirms the following details:

- Quick Review visibly shows five questions, but Questions 1 and 2 are nearly duplicates: both show the same modern `水` form and ask for its meaning in different words. The first question, `What character connects to this form?`, is especially unclear because the displayed form is already the modern character rather than a historical form or origin image.
- The Mandarin, Japanese, and Korean questions are simple reveal cards, but the answers are isolated strings (`shuǐ`, `スイ — sui`, and `수 — su`) without enough explanation of the reading type or why that reading is useful for recognition.
- The Quick Review toolbar still visibly exposes Favorite, Review Later, Share, and More. This confirms AT-17: only Favorite and More should remain in that toolbar.
- The repeated `Open Water Journey` link is useful as an escape hatch, but the visual flow does not communicate that leaving the review ends the temporary session. The reported return-to-Quick-Review behavior therefore remains a functional correction, not merely a wording issue.
- Traditional Chinese and Simplified Chinese examples are visibly stacked as native form, reading, and English below one another. They do not use the intended prominent native form with the reading to its right and English beneath the line.
- Japanese is visually closer to the intended relationship in several examples because the kana/romaji relationship is shown beside the Kanji, but the overall card still needs a consistent example hierarchy. Korean is also currently stacked vertically and should be corrected with the other target-language cards.
- The Japanese History page now says that small kana combine with the preceding sound, but the screenshot does not show a concrete composition example such as `き` + `ゃ` → `きゃ` → `kya`. The learner is told the rule without being shown how to apply it.

Refined Quick Review recommendation:

1. Replace the first two overlapping meaning cards with one modern-meaning card and one genuinely visual historical/origin card.
2. Keep at most one or two language-reading cards per short session, each labeled with the language and reading type, and include a brief recognition explanation after reveal.
3. Treat the review as a temporary layer: leaving it, opening the Journey, changing tabs, or navigating Home/Browse must end it and clear the review entry state.
4. Preserve the current calm card, reveal, and no-score interaction model; the problem is the prompt/content design and lifecycle, not the basic presentation pattern.

### User refinement — Quick Review guessing design

The review must not reveal the answer through the prompt, the Symbol name, a character title, or an always-visible `Open Water Journey` identity link. That would defeat the recognition exercise.

The preferred direction is a small three-option guessing card:

- show a meaningful visual or contextual prompt without naming the Symbol;
- present three possible meanings, identities, or readings;
- let the learner choose one;
- reveal the correct answer with a short explanation and optional Journey link only after the choice.

Target-language content can be used for some cards, but Quick Review should not ask for the same character in Simplified Chinese, Traditional Chinese, Japanese, and Korean one after another. The session should test Shared Character recognition first, then use at most one selected target-language example as context. The language card should show a real word or sentence and ask a useful question about it, rather than simply asking for four isolated readings.

Implementation status: AT-17 (toolbar action hierarchy), AT-18 (target-language Usage hierarchy), AT-19 (Japanese kana composition and decoding guidance), and AT-20 (Quick Review behavior) are implemented locally. AT-22 is also complete. Apple/Xcode visual verification remains.

### AT-22 — Japanese History needs a compact kana sound guide

The previous guide showed representative rows plus composition examples, then expanded into a long wall of every basic, voiced, and contracted kana. That was more than this History page needs and made the explanation harder to scan.

The finished guide should include:

- a compact row-based table showing the shared Hiragana/Katakana sound pattern with Romaji;
- a small set of clear construction examples for dakuten, contracted sounds, small `っ`, and long-vowel `ー`;
- the important reading exceptions/particle readings;
- a clear statement that Hiragana and Katakana represent the same basic sounds in different writing systems.

Implementation status: complete locally. The History guide now uses a conventional five-column vowel chart, with Hiragana, Katakana, and Romaji stacked inside each cell, followed by a separate combinations chart for small ゃ・ゅ・ょ. Quick Review is resolved separately below under AT-20.

### Final target-language alignment correction — 2026-10-02

The target-language Usage pages now use the approved two-column hierarchy: the native form is left-aligned, the English meaning is right-aligned on the same line, and romanization sits beneath the native form. Japanese furigana remains attached above the written form. Traditional Chinese now separates the neutral form from clearly labeled Taiwan Mandarin/Pinyin and Hong Kong Cantonese/Jyutping sections.

Implementation status: complete locally. This correction supersedes the over-centered intermediate layout identified during testing.

### Hotfix corrections — 2026-10-02

- Quick Review meaning-to-symbol cards use clear English and reserve the large artifact field for a displayed symbol. Meaning prompts use a compact prompt surface, while Regular Script answer choices are the large selectable cards.
- Japanese sentence examples use a wrapping written-text layout instead of a non-wrapping furigana segment row, so the final example remains readable on narrow screens.
- Learner-facing titles and controls use the primary meaning before any semicolon-separated editorial qualifier. Historical nuance remains available in the editorial takeaway and source-backed content.

### Final Quick Review resolution — 2026-10-02

The final product decision separates Quick Review from Review Later:

- Home shows Quick Review as soon as at least one Symbol is fully learned.
- A Quick Review session randomizes all learned Symbols and presents one three-choice recognition card per Symbol, with progress shown as `n of x`.
- The cards rotate among showing a Symbol and asking for its meaning, showing a meaning and asking for the Symbol, and asking how the meaning is written in one active target language. The session does not repeat the same four-language recognition question for one Symbol.
- A correct choice advances directly to the next Symbol. An incorrect choice reveals the correct answer and offers `Check this Symbol`, which opens the full Journey and ends the temporary session.
- Quick Review changes no Learned, Favorite, or Review Later state. Leaving Home, Symbol, or the session ends it and it must not be restored automatically.
- Browse → Review Later remains a plain saved list. Selecting an item opens the full Symbol Journey; it does not start Quick Review or any other game.
- Browse → Learned also opens the full Symbol Journey. Quick Review has one clear Home entry point.

Implementation status: complete locally. The remaining release verification is Apple/Xcode visual and interaction testing.
