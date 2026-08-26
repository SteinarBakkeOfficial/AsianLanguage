# macOS / iPhone Testing

## Purpose

Windows checks validate content, local state rules, project wiring, and static contracts. macOS/Xcode is required for actual SwiftUI compilation, XCTest execution, simulator testing, signing, and physical iPhone testing.

## Preferred development loop

1. Commit or push Windows changes.
2. Run \`Tools/Run-Checks.ps1\`.
3. Use macOS CI or a remote Mac to build the app and run XCTest/simulator checks.
4. Reserve a physical iPhone for touch targets, swipe gestures, safe areas, rendering, and final device behavior.

The repository should eventually use a macOS build command that runs the actual app and tests. Do not claim iOS compilation from Windows-only checks.

## First Mac setup

1. Install Xcode and accept first-run setup.
2. Add the Apple ID/team in Xcode settings.
3. Clone or copy the complete repository.
4. Open \`AsianLanguage.xcodeproj\`.
5. Select the \`AsianLanguage\` scheme and a simulator or connected iPhone.
6. Build and run.

## What to report

When a build or device run fails, report the first real compiler, signing, runtime, or interaction error with its file/line or screenshot. Avoid pasting the full Xcode log unless the first error is unclear.

## Boundaries

An iOS executable cannot be copied directly to an iPhone. A signed app package still requires Apple build/signing infrastructure. The design source of truth is the approved Figma/exported reference and behavioral specification.
