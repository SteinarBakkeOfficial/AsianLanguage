# Symbol Journey Design Handoff

## Purpose

This document defines how approved visual design becomes native SwiftUI implementation. It is a handoff standard, not an approved final design.

## First target

Design the complete Light-mode Symbol Journey for \`火\` (Fire) first:

Origin, Oracle Bone, Bronze, Seal, Clerical, Regular, Today / Modern Endpoint, stage navigator, component behavior, text density, scrolling, completion, and relevant supporting Content Phases.

Then test the system against Water, Mountain, Tree, and Horse. Horse must not enter the corpus until its content and assets are sourced.

## Required handoff

Provide approved Figma frames or exported images plus a concise behavioral specification containing:

- exact iPhone frame dimensions
- spacing, type hierarchy, and provisional tokens
- horizontal swipe and tap behavior
- fixed/floating stage navigator behavior
- vertical overflow behavior
- light/dark direction
- selected focus-track states
- Missing Historical Asset state
- source/readiness labels
- component appearance at the stage where it is introduced
- completion, restart, resume, and Review later states

## Interaction rules

The Symbol Journey is horizontal across Evolution Stages. Stage content may scroll vertically. Today should present one page per selected focus track inside the main horizontal journey; each page may use vertical overflow for its own word-level context, but there is no nested horizontal carousel.

The historical glyph or origin visual is the hero. Surrounding app chrome remains contemporary. Do not make every screen a parchment-themed surface.

## Implementation workflow

Approved design → exported reference image/spec → SwiftUI implementation → simulator screenshot → visual comparison and correction.

Repository design references may use:

\`design/references/\` for approved images and \`design/specs/\` for behavioral notes.

HTML/CSS may be used for disposable interaction experiments only. It is not the design source of truth for this native SwiftUI app.

## Content safety

Reference pictures guide hierarchy and storytelling; they are not production assets. Historical visuals must be source-backed or licensed, explicitly unavailable, or editorially omitted. Never use a fabricated glyph or modern character as an older historical stage.
