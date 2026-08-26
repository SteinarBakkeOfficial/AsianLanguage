# Product Design Direction

## Status

This is a product-wide direction document, not an approved final screen design. Exact colors, typefaces, spacing tokens, and component geometry come from the approved Fire handoff.

## Personality

AsianLanguage should feel like a modern gallery containing ancient artifacts: warm, restrained, editorial, and confident. Historical material receives attention and care without turning the whole app into an antique parchment interface.

## Hierarchy

The character and its transformation through history are the hero.

- Home is approximately 70% current/resumable/next Symbol Journey and 30% supporting progress or context.
- Symbol owns the active Shared Character journey.
- History explains script periods and methodology.
- Browse owns discovery and collections.
- More owns utilities and deferred concepts.

Streaks, XP, and gamification must remain subordinate to recognition and understanding.

## Interaction

The Symbol Journey moves horizontally through Evolution Stages. Stage content may scroll vertically. A fixed or floating stage navigator remains reachable. Today presents selected focus-track content vertically and avoids nested swipe conflicts.

Simple pictographs should not receive redundant panels. Character structure appears when it becomes historically meaningful and may be recapped later.

## Material and accessibility

Use strong whitespace, short text, clear hierarchy, and subtle material treatment for historical imagery. Language identity must never rely on color alone. Support Dynamic Type, VoiceOver labels for every Historical Asset or Missing Historical Asset, sufficient contrast, and touch targets suitable for iPhone use.

Light and dark mode are both first-class. Light mode is the first Fire design target.

## Asset rules

Reference pictures are design targets, not production assets. Historical Assets must be source-backed or licensed. Missing Historical Assets are explicit content gaps. Fabricated glyphs and modern-form fallbacks are prohibited.

## Source of truth

Approved Figma frames, exported references, design specs, and behavioral requirements are the design source of truth. The implementation workflow is approved design → SwiftUI → simulator screenshot → visual comparison/correction.
