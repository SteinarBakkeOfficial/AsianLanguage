# Asian Language Shared Character Lessons

This project is an English-first learning app about cross-language recognition across Mandarin, Traditional Chinese usage communities, Japanese, and Korean. It teaches how a shared underlying character survives across the required focus tracks through meaning, history, structure, and modern usage.

## Language

**Shared character lesson**:
The canonical V1 lesson unit centered on one underlying character record used meaningfully across Mandarin, Traditional Chinese usage communities, Japanese, and Korean.
_Avoid_: Grammar lesson, rule lesson, structure lesson, general language lesson

**Underlying character record**:
One canonical cross-language character identity that can have different modern display forms and readings in each language.
_Avoid_: Separate Chinese lesson, separate Japanese lesson, separate Korean lesson

**Core shared meaning**:
The teachable overlapping modern meaning that must still be recognizable across Mandarin, Traditional Chinese usage communities, Japanese, and Korean for a lesson to qualify.
_Avoid_: Loose resemblance, false friend, unrelated modern meaning

**Recognition value**:
The degree to which a lesson helps a learner notice and retain a meaningful cross-language connection early and clearly.
_Avoid_: Raw frequency only, chronology only

**Evolution framework**:
The canonical lesson framing that presents a shared character as a progression from historical origin anchor, through useful script stages, to modern focus-track forms.
_Avoid_: Static comparison only, isolated modern forms

**Historical painted form**:
The earliest lesson stage in which a character is presented as an older visual or pictorial root before stabilization into a later character form.
_Avoid_: Modern character, language-specific modern glyph

**Canonical history spine**:
The reference sequence Oracle Bone, Bronze, Seal, Clerical, Regular, then modern focus-track forms.
_Avoid_: Forcing every lesson to show every stage

**Historical stage metadata**:
The source-backed information attached to a shown script stage, including visual/text form, stage-to-stage change note, certainty, sources, and optional historical sound when accurate enough to include.
_Avoid_: Unsourced pronunciation claims, mandatory sound for every stage

**Stage-to-stage change note**:
A short explanation of how a displayed historical stage differs from the previous displayed stage.
_Avoid_: Full comparison panel for every stage, unsupported transformation story

**Characterized form**:
The middle lesson stage where an earlier historical image has become a stable meaning-bearing character before branching into modern language-specific forms.
_Avoid_: Raw painting only, fully modern language form

**Cross-language recognition**:
The primary V1 learning outcome in which a learner recognizes one shared character and understands how it appears across Mandarin, Traditional Chinese, Japanese, and Korean focus tracks.
_Avoid_: Fluency, test prep, single-language mastery

**Shared Chinese-character heritage**:
The public-facing description of the app's subject: the common character lineage and modern usage connections across Mandarin, Traditional Chinese usage communities, Japanese, and Korean.
_Avoid_: Generic Asian languages, Sino-Xenic as headline consumer term

**Modern usage**:
The present-day words, expressions, and short sentences that show how a shared character is still used in Mandarin, Traditional Chinese usage communities, Japanese, and Korean.
_Avoid_: Full grammar curriculum, broad language structure promise

**Shared Character**:
The primary user-facing content object representing one cross-language character lineage taught through a guided lesson.
_Avoid_: Generic lesson item, dictionary entry only

**Focus track**:
A selectable modern display and usage lane for Simplified Chinese, Traditional Chinese, Japanese, Korean, or all tracks.
_Avoid_: Treating every writing standard as a separate spoken language

**Traditional Chinese focus**:
The modern written-form track that shows Traditional Chinese forms and separate Taiwan/Hong Kong usage examples when selected or when all focus tracks are selected.
_Avoid_: Calling Traditional Chinese the ancestor of Kanji or Hanja

**Learned**:
The user-controlled state indicating that the learner considers a Shared Character understood well enough not to need immediate revisit.
_Avoid_: Automatically completed, system-scored mastery

**Review later**:
The user-controlled state indicating that a Shared Character should remain in a revisit queue for future study.
_Avoid_: Permanent failure state, automatic spaced repetition bucket

**Favorites**:
The user-controlled reference collection for Shared Characters the learner wants to keep handy regardless of retention state.
_Avoid_: Review queue, mastery queue

**Collections**:
The system-defined secondary navigation area that groups user-curated and system-defined Shared Character sets such as Review later and Favorites.
_Avoid_: Deep taxonomy, user-created folders in V1, account-backed archives

**Settings**:
The local utility area for focus language, display preferences, offline/app information, and reset app progress.
_Avoid_: Account, login, cloud profile

**Next featured Shared Character**:
The primary home-screen learning target chosen mainly by the editorial sequence, unless the learner is resuming an in-progress lesson.
_Avoid_: Heavily personalized recommendation feed

**New Symbol**:
The primary Home action that opens the next featured Shared Character when no lesson is in progress.
_Avoid_: Renaming the Home shell page

**Limited-certainty historical evolution**:
A required history section format that includes only high-confidence claims and explicitly marks uncertainty when the full pathway is disputed or incomplete.
_Avoid_: Fake certainty, full reconstruction claim

**Limited-certainty component breakdown**:
A required breakdown section format that separates high-confidence structural analysis from tentative interpretation and excludes unsupported mnemonic claims.
_Avoid_: Folk etymology, invented mnemonic story

**Character structure**:
The V1 `Structure` lesson section that explains character components, construction, and limited-certainty analysis when relevant.
_Avoid_: Grammar structure, sentence structure, rule lesson

**Modern stroke order**:
The view-only writing sequence for a modern focus-track form when authoritative data is available.
_Avoid_: User tracing, handwriting assessment, historical transformation path

**Reference pictures**:
External screenshots or examples used to guide design direction and lesson flow.
_Avoid_: Treating screenshots as production app assets

## Relationships

- A **Shared character lesson** is centered on exactly one **Underlying character record**
- An **Underlying character record** must have one **Core shared meaning** for V1 inclusion
- A **Shared character lesson** is prioritized by **Recognition value**
- A **Shared character lesson** exists to produce **Cross-language recognition**
- This project presents **Shared Chinese-character heritage** through **Shared character lessons**
- A **Shared Character** is taught through a guided lesson
- A **Shared Character** can be viewed through one **Focus track** or all focus tracks
- A **Traditional Chinese focus** includes separate Taiwan/Hong Kong usage examples
- A **Shared character lesson** follows an **Evolution framework**
- An **Evolution framework** uses the **Canonical history spine** without requiring every lesson to include every stage
- An **Evolution framework** progresses from a historical origin anchor to **Characterized form** or regular-script form to modern focus-track forms
- Shown stages in an **Evolution framework** use **Historical stage metadata**
- Every displayed historical stage after the first has a **Stage-to-stage change note**
- A **Shared character lesson** ends in **Modern usage** across Mandarin, Traditional Chinese usage communities, Japanese, and Korean
- A **Shared Character** can be marked **Learned** or **Review later**, but not both at once
- A **Shared Character** can belong to **Favorites** regardless of whether it is **Learned** or **Review later**
- **Collections** includes **Review later** and **Favorites**
- **Settings** contains **Focus track** selection
- The home screen centers on the **Next featured Shared Character**
- **New Symbol** is the primary Home action for the **Next featured Shared Character**
- A **Shared character lesson** may include **Limited-certainty historical evolution**
- A **Shared character lesson** may include **Limited-certainty component breakdown**
- **Character structure** is the only meaning of `Structure` in V1
- **Modern stroke order** is separate from historical evolution visuals
- **Reference pictures** guide design but are not production assets

## Example dialogue

> **Dev:** "Should this be a Japanese lesson about the Kanji, or a Korean lesson about the Hanja?"
> **Domain expert:** "Neither. It is one **Shared character lesson** built around one **Underlying character record**, with modern forms and usage shown across the required focus tracks."
>
> **Dev:** "The meanings overlap only a little. Is that enough?"
> **Domain expert:** "Only if there is one teachable **Core shared meaning**. If not, it does not belong in V1."
>
> **Dev:** "Are we teaching three separate language forms first and history second?"
> **Domain expert:** "No. The lesson uses an **Evolution framework**: start from the **Historical painted form**, move into the **Characterized form**, and then compare the modern descendants."
>
> **Dev:** "So is this a general language-learning app about Asian languages?"
> **Domain expert:** "No. It is about **Shared Chinese-character heritage**, taught through shared characters and their **Modern usage**."
>
> **Dev:** "If I finish reading a lesson, is it automatically done forever?"
> **Domain expert:** "No. The user decides whether the **Shared Character** is **Learned** or should be kept in **Review later**. **Favorites** is separate."

## Flagged ambiguities

- "symbol", "word", "grammar point", "rule", and "structure" were initially mixed together — resolved: V1 uses **Shared character lesson** as the canonical lesson unit
- "structure" could mean grammar or sentence structure — resolved: V1 uses **Character structure** only
- "history" could imply stronger certainty than the evidence supports — resolved: use **Limited-certainty historical evolution** when needed
- "dissect" could imply speculative explanations — resolved: use **Limited-certainty component breakdown** when certainty is incomplete
- "shared view" could have meant a side-by-side modern comparison only — resolved: lessons are anchored by an **Evolution framework**
- "writing system family tree" could imply every lesson must include every script stage — resolved: use the **Canonical history spine** but require only defensible stages
- "sound" for historical stages could imply false certainty — resolved: include it in **Historical stage metadata** only when accurate enough to source and label
- "comparison with previous family tree" could imply a full comparison panel for every stage — resolved: require a **Stage-to-stage change note** and make richer comparison optional
- "Asian languages" was too vague for the product promise — resolved: use **Shared Chinese-character heritage** in public-facing description
- "completed" was too weak and misleading for retention — resolved: use **Learned** and **Review later** as user-controlled states
- "Traditional Chinese" could imply a separate language or the ancestor of Kanji/Hanja — resolved: use **Traditional Chinese focus** as a modern written-form track with Taiwan/Hong Kong usage examples
- "Account" could imply login or sync — resolved: V1 has no account page; local preferences live in **Settings**
- "stroke patterns" could imply tracing or historical transformation — resolved: V1 uses view-only **Modern stroke order** for modern focus-track forms when authoritative data is available
- "Start Page - New Symbol" could imply replacing Home as the shell page — resolved: keep **Home** as the shell label and use **New Symbol** as the primary action
- "Reference Pictures" could imply production-ready assets — resolved: use **Reference pictures** as design inspiration only
