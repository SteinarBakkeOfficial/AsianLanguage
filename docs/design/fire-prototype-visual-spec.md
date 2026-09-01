# Fire Prototype Visual Specification

## Goal

Treat the approved Fire reference sheets as the first implementation specification for the Symbol Journey. This document records the measurements and relationships that can be carried into SwiftUI without turning the reference into a loose mood board.

## Reference frame

- Primary comparison frame: iPhone 15 Pro, 390 × 844 points.
- Content inset: 16 points from the usable screen edge.
- Bottom tab clearance: 34 points above the home indicator/tab-bar safe area.
- Stage page overflow: vertical scrolling is allowed inside a stage page only; horizontal paging advances the museum journey.
- Stage navigation is persistent at the bottom of the journey and is never a Continue gate.

## Visual tokens

- Gallery background: `#FAF7F2`.
- Subtle surface: `#F2EEE8`.
- Elevated card: `#FFFFFF`.
- Strong surface: `#F7F5F0`.
- Primary ink: `#111111`.
- Secondary ink: `#6A6A6A`.
- Separator: `#E6E1D9`.
- Cinnabar accent: `#C8382F`; pressed accent: `#A52022`.
- Learned jade: `#1F8F68`.
- Small radius: 4 points; control radius: 12 points; large card radius: 16 points.

## Typography

- The active AppShell reference is `AsianLanguage_AppShell_VisualReference_Alt`.
- Use bundled Playfair Display for editorial/display headings and concept moments.
- Use bundled Inter for navigation, labels, readings, translations, metadata, and body copy.
- Render Chinese, Japanese, and Korean characters with the platform's native fallback fonts; Playfair Display and Inter are Latin display/interface families and are not the source for CJK glyph forms.

## Symbol Journey composition

Each historical page follows the same relationship visible in the Fire sheet:

1. A compact stage header sits below the navigation bar: stage name, period metadata, and the character menu.
2. The artifact field is the dominant element, taking roughly 45–50% of the usable page height on a 390 × 844 frame.
3. The explanatory sentence sits below the artifact, centered and constrained to the readable content width.
4. The bottom rail shows `Origin` and `Today` endpoints, a dot for each available journey page, and a red current/visited segment. It exposes direct stage taps but does not require a button press to advance.
5. Today keeps the same room and rail, then presents one restrained card per selected modern track. With no tracks selected, the page remains a valid museum-only endpoint.

## Content boundaries

- The primary journey contains Origin → available historical stages → Today.
- Summary/Recall is excluded from this flow even though it appears in the older reference sheet; the current product decision keeps recognition, structure, and sources behind the character menu.
- Historical artwork must be source-backed/licensed and bundled. If it is unavailable, the artifact field states that explicitly; a modern glyph is never substituted for an ancient form.
- Modern cards teach the shared character, its reading(s), and word-level meaning. Sentence lessons are not part of this prototype journey.

## Validation target

The visual deliverable is not considered aligned until a macOS/Xcode simulator screenshot at the reference frame can be compared against the Fire sheet for: background color, content inset, artifact-field height, header hierarchy, rail placement, primary-action height, and Today-card density.
