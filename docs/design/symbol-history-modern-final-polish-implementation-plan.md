# Symbol / History / Modern Language Final Polish — Implementation Plan

**Status:** Approved scope; the Testing07_09 correction slice is implemented locally. Structural Symbol, History, modern-language, and audio slices are wired; macOS/device visual verification and remaining editorial data review are still outstanding.

**Approved:** 2026-09-04

## Goal

Make the Symbol Journey feel like one continuous historical exhibit, clarify modern language usage, add restrained pronunciation playback, and make History a navigable entry point to unfinished deeper detail pages without redesigning the app.

## Scope contract

### Included in this implementation

1. Integrate all six panels from `Symbol_Background_v1`, including Origin, as the coordinated environments behind the existing Origin illustrations and historical glyphs. Extract panels exactly if the runtime asset format requires individual files; do not redraw or replace the artwork.
2. Keep Oracle through Regular glyphs centered and visually primary. Add one quiet, data-driven material/process caption below the exhibit area where appropriate.
3. Remove date/period text from individual Symbol evolution pages. Keep the six stage names.
4. Add a restrained crossfade between successive Symbol stages, including Origin to Oracle. Do not morph glyph shapes or add a comparison screen.
5. Consolidate Symbol onboarding to one page with the approved concept, progression, and dynamic `Explore [first symbol]` CTA, entering the first-ranked Symbol exhibit directly.
6. Refine the existing Simplified Chinese, Traditional Chinese, Japanese, and Korean modern-language pages according to their distinct linguistic hierarchies. Preserve verified content and do not fabricate missing readings or examples.
7. Add one small iOS pronunciation service around `AVSpeechSynthesizer`, explicit draft speech text from the current content workflow, and restrained speaker controls on modern-language readings. Stop current speech before starting a new item; do not use cloud TTS, API keys, or bundled MP3 files. Keep linguistic data platform-independent, add Apple Speech Synthesis to Sources / Licenses as technical attribution, and document the future Android `TextToSpeech` replacement boundary.
8. Correct the existing History layout defects surgically: crop/aspect behavior, header overlap, text collisions/truncation, vertical spacing, and safe-area/navigation clearance. Keep `History_V1.png` as the artwork/reference source and preserve the existing History composition.
9. Extend History after Regular Script with branching modern-language contexts for Traditional Chinese, Simplified Chinese, Japanese, and Korean. These are branches, not four additional sequential script stages.
10. Make each existing historical script entry clickable: Oracle Bone, Bronze, Small Seal, Clerical, and Regular. Make each modern-language branch clickable as well. Each destination is a deeper detail page with source-backed detail where available, an explicit unfinished state where content is not yet complete, and a normal back button returning to History. Do not add a new root tab or separate comparison flow.

### Explicitly deferred to the next implementation

The next implementation will rework the History page itself. That later work may revisit the composition, layout, information architecture, and presentation of the History overview. It is not part of this polish implementation. This pass only makes the existing History page fit correctly, adds the agreed modern branches, and provides their minimal navigable detail destinations.

## Data and source boundaries

- Historical glyphs and artwork remain source-backed or explicitly marked missing; no modern glyph is used as a historical fallback.
- Material captions, modern-language relationships, readings, examples, and speech text must come from the existing verified content workflow.
- Speech text is explicit linguistic data. The renderer must never infer a Japanese, Korean, Mandarin, or Cantonese reading from the visible Han character.
- Simplified and Traditional Chinese pages may share Mandarin pronunciation data when the lexical item is the same; they do not require duplicate speech records.
- Japanese Kun/On and Korean Hanja/Sino-Korean/native relationships remain data-driven and may be absent when no natural verified value exists.
- Detail pages may be unfinished by design, but unfinished content must not be filled with invented historical facts, placeholder examples, or unsupported translations.

## Implementation boundaries

Likely touched areas are limited to the existing Symbol evolution/onboarding views, modern-language views and data, History view/navigation, the shared content model and validation path only if required for explicit speech/caption/detail data, the existing iOS shared/core service area for one pronunciation service, and the relevant focused tests. The approved reference asset may be converted into runtime assets during implementation.

Do not change Home beyond the narrowly defined Testing07_09 active-symbol and layout corrections recorded below. Do not change Browse, More, Collections, unrelated navigation, the typography/color/spacing/card systems, the existing illustration set, or unrelated architecture. Do not hand-edit generated review/runtime artifacts.

## Implementation order

1. Confirm the existing component/data seams and map the six supplied background panels without changing the reference artwork.
2. Implement Symbol stage presentation, captions, period removal, crossfade, and one-page onboarding.
3. Refine the four modern-language presentations and align explicit reading/speech data only where required.
4. Add the isolated iOS pronunciation service and wire the existing/small speaker controls.
5. Fix the current History layout, add the modern branches, and add clickable script/branch detail destinations with back navigation.
6. Run focused contract/content checks, then compare every changed SwiftUI screen against the last known-good visual baseline on macOS/Xcode. Any unrelated visual drift is out of scope and must be removed before handoff.

## Verification and fallback

- Review the complete changed-file list and diff against this scope contract before implementation handoff.
- Verify the four speech contexts on a physical supported iPhone where practical; unavailable voices must disable only the affected control and must never silently substitute another language.
- Verify History artwork remains fitted correctly, text remains clear, and detail pages return to History.
- If a requested change causes unrelated visual drift, restore that affected component to the last known-good baseline and reapply only the approved delta.
- This document, the two detailed handoffs, `CURRENT_STEP.md`, `ROADMAP.md`, `DECISIONS.md`, and the architecture note form the fallback record for the implementation.

## Implementation checkpoint — 2026-09-04

- The six exact stage backgrounds, Symbol period removal, one-page onboarding, stage crossfade, material captions, modern-language hierarchy, History branches/detail destinations, iOS pronunciation service, speaker controls, and Apple technical attribution are implemented in the agreed areas.
- Explicit draft speech data is now generated for all current V1 reading rows from the existing content workflow. It remains editorially unapproved by design; later native-speaker and multi-user review will correct readings where needed.
- Missing Hong Kong/Cantonese data remains missing; the importer and Traditional Chinese presentation do not substitute Mandarin readings or starter examples under a Cantonese label.
- The unfinished History detail pages are structural destinations by design. Their broader content and the planned History overview rework remain deferred to the next implementation.

## Related records

- [Final polish feedback](symbol-history-modern-final-polish-feedback.md)
- [Apple pronunciation audio handoff](../architecture/pronunciation-audio-apple-avspeechsynthesizer-feedback.md)
- [Architecture foundation](../architecture/v1-foundation.md)

## Post-implementation verification corrections — Testing07_09

**Status:** Implemented locally; macOS/Xcode and device visual verification remain outstanding.

The 2026-09-05 Testing07_09 review identified focused corrections to the current implementation. These are additions to the existing polish scope, not a redesign and not a change to corpus-selection logic.

### 1. Home active-symbol state and layout

- When onboarding starts Fire and the learner backs out of the Fire journey, Home must continue to show Fire rather than falling back to Person or another runtime-corpus record.
- Home must resolve the active journey record consistently even when that record is repository-backed but intentionally outside the 126-symbol Browse corpus.
- Keep the current Home concept title, using the actual meaning such as `Fire`, `Person`, or `Child`; do not replace it with generic copy such as `Symbol name`.
- Ensure the concept title is fully visible above the lineage artwork and is not clipped, overlapped, or partially hidden.
- Move the lineage exhibit slightly upward and give the modern symbol more breathing room above the primary action button.
- Preserve the existing Home illustration mix, card language, navigation, and primary-action behavior.

### 2. Symbol stage labels, captions, and Regular Script scale

- Keep the six stage names visible above the Symbol exhibit: `Origin`, `Oracle Bone Script`, `Bronze Script`, `Small Seal Script`, `Clerical Script`, and `Regular Script`.
- Continue to omit the age/period line from individual Symbol pages. This remains an intentional presentation decision; chronology belongs in History.
- Keep the existing one-line material/process captions and add only enough vertical separation to prevent the caption from touching or clipping against the exhibit square.
- Increase the Regular Script glyph so its visual weight is approximately comparable to the other historical glyphs and Origin illustrations.
- Do not move historical glyphs aside to make room for material context; the glyph remains the visual hero.

### 3. Exhibit-square crossfade

- Replace the current ineffective page-level fade/slide combination with a restrained overlap crossfade for the complete Symbol exhibit square.
- The outgoing background plus artwork/glyph should fade out while the incoming background plus artwork/glyph fades in at essentially the same position.
- Keep the transition minimal, approximately 250–400 ms, and do not morph glyph shapes.
- Keep the stage rail and surrounding explanatory layout stable; the requested transition concerns the exhibit square as a single visual unit.

### 4. One-page onboarding composition

- Preserve the approved single onboarding page, concept wording, four-item progression, and dynamic action for the first-ranked symbol (`Explore One` for the current order).
- Modestly enlarge the main first-symbol illustration and adjust vertical placement/spacing to reduce the unused lower area.
- Use the first-ranked symbol's existing origin illustration and historical stages; do not add fallback artwork.
- Do not restore a second onboarding page or alter the 126-symbol corpus eligibility rule as part of this correction slice.

### 5. History crop, typography, and whole-row navigation

- Correct the existing `History_V1.png` crop geometry and frame proportions surgically. Do not regenerate or replace the artwork unless corrected rendering demonstrates that the source itself is insufficient.
- Fix the header landscape crop, timeline artwork crops, and lower comparison crop so artwork is not unintentionally clipped and source text fragments do not appear in the exhibit.
- Increase the History overview explanatory text slightly while retaining smaller secondary treatment for dates and metadata.
- Make the full area of every historical script row tappable, not only its visible text or edge affordance.
- Make the full area of every modern-language branch row tappable, not only the chevron.
- Preserve the existing detail destinations, native back navigation, unfinished-state treatment, and current History composition.
- The broader History-page rework remains explicitly deferred to the implementation after this correction slice.

### Explicit non-changes for this correction slice

- Do not change the 126-symbol corpus or its complete-evolution selection rule.
- Fire remains a separate pilot/reference record; onboarding now follows the first ID in the ranked runtime manifest, currently 一.
- Do not rewrite or silently approve the current draft translations, readings, or examples; those remain editorial review work.
- Do not redesign unrelated screens, navigation, typography tokens, colors, spacing tokens, cards, or the modern-language information architecture.

### Next implementation order

1. Home Fire-state bug and Home layout.
2. Symbol stage labels, caption spacing, and Regular Script scale.
3. Exhibit-square crossfade.
4. Onboarding spacing and illustration scale.
5. History crop correction, larger overview text, and full-row navigation.
