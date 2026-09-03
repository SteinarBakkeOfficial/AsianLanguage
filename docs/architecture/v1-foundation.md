# V1 Architecture

## Product architecture

The app is an offline-first SwiftUI iPhone application centered on one \`Shared Character\` and its \`Symbol Journey\`: origin, historical Evolution Stages, Today / Modern Endpoint, and supporting Content Phases.

The corpus is read-only bundled JSON. User state is separate, local, writable JSON. No cloud account or runtime content dependency exists in V1.

The runtime now loads the 126-character complete-evolution selection from `SeedCorpusManifest`. Each selected record has a local origin illustration, four normalized ZDIC historical assets, and a Regular Script endpoint rendered by the bundled CNS11643 Kai font. The locale-specific Adobe Source Han Serif faces are bundled and registered for Used Today. The old 11-record pilot remains as repository history; Fire is not in the complete 126-record runtime set.

## Root navigation

The root shell has five areas:

- Home
- Symbol
- History
- Browse
- More

Symbol is the canonical owner of the active Shared Character journey. Home, Search, Browse, and Collections request an \`open Shared Character\` action through shared navigation state rather than creating competing lesson owners.

Browse contains Search, collections, the separate All Symbols library, Learned, Review later, Favorites, Saved, and editorial collections. More contains Languages, Settings, About / Method, Account, reset, and offline information. History currently presents the approved overview artwork while the former generic period design remains preserved for a later release.

Use one NavigationStack per root area where practical. Child screens must not introduce duplicate root stacks.

## Symbol Journey position

The saved position is:

\`SymbolJourneyPosition(section, stageID?)\`

Sections are \`evolution\`, \`today\`, \`structure\`, \`usage\`, and \`summary\`. Historical stages save their exact canonical ID. Legacy \`LessonStep\` values decode through an explicit migration and are not the permanent primary navigation model.

The primary Evolution Stage sequence is data-driven:

\`origin\`, \`oracleBone\`, \`bronze\`, \`seal\`, \`clerical\`, followed by a separate Regular Script reference and \`modernForms\`

Relevant unavailable stages may remain as explicit Missing Historical Asset states. Uncertain or pedagogically unhelpful stages are omitted.

## Content and asset seams

The Shared Character content module owns origin content, stage metadata, modern focus-track variants, Character structure, Modern usage, sources, and publication status.

Presentation-facing models distinguish historical confidence from missing content. Readings may carry optional future audio references, but no audio playback system is part of V1.

Each historical stage owns its canonical asset reference and structured asset metadata. Global visual metadata may describe overall readiness but must not duplicate the stage map.

The asset-rendering module resolves bundled renderable assets. Source URLs are provenance only. SVG source files require an approved compiled iOS representation before they are treated as renderable. Missing or unsupported assets produce explicit content gaps; modern characters and fabricated glyph sketches are never fallbacks.

## User state

Lesson progression is centralized through explicit state transitions. Ordinary navigation cannot downgrade Learned. Restart is explicit and clears progress position while preserving Favorites and Review later. Learned, Favorite, and Review later are independent relationships. Home resumes the explicitly stored current character, with a deterministic recent in-progress fallback.

Local state also carries onboarding completion, appearance preference, and separate reset semantics. Reset Learning Progress does not delete corpus data or preferences; Reset All Preferences restores the local defaults.

Existing local state migrates from the former \`LessonStep\` and single-focus representations without deleting user data.

## Testing seams

Pure content, state, route, and selection rules remain Windows-testable. macOS/Xcode CI is required for actual SwiftUI compilation and XCTest execution. A physical iPhone remains the final check for touch, gesture, safe-area, asset rendering, and device behavior.
