# Symbol Evolution Design Handoff

## Goal

Record the next approach for the visual design phase before the first source-backed symbol pilot is implemented.

## Decision

Design preparation comes first.

The next implementation pass should not fill the full first-50 symbol set into the app before the symbol evolution screen is visually settled. The first implementation target after design is a 3-5 symbol pilot, then expansion to the first 50 after the schema and UI prove stable.

## Recommended Tool

Use Figma.

Figma is the better fit for this app because it supports precise mobile frames, reusable components, layout constraints, spacing tokens, inspectable measurements, and design-to-implementation handoff. It is also easier to compare screens against the app and keep states consistent.

Canva is acceptable for mood boards, quick visual references, or poster-style compositions, but it is weaker for app UI handoff. Use Canva only if it helps you explore visual mood before finalizing in Figma.

## Minimum Design Package

Design only the pieces needed to lock the symbol experience:

1. iPhone frame for one evolution stage page.
2. Stage variants for Origin plus Oracle Bone, Bronze, Seal, Clerical, Regular, and Modern Forms. If Origin and Oracle need separate pages, show that variant explicitly.
3. Fixed or floating bottom evolution navigation.
4. Overflow behavior when stage text is longer than one screen.
5. Typography scale for title, stage label, symbol image, origin explanation, component notes, and examples.
6. Image treatment for historical glyphs, artifact/reference images, and modern forms.
7. Component treatment: how a one-component symbol is explained, and how multi-component symbols show each component at the stage where it becomes visible or meaningful.
8. Light and dark mode direction if possible.

## Handoff Rules

- Use the reference `Evolution of the Horse Character` layout as the product target, adapted into swipeable iPhone pages.
- Include exact dimensions, spacing, colors, type sizes, and component states where possible.
- Do not rely on descriptive mood alone; the handoff needs concrete frames.
- Provide the first design around visually strong symbols such as `火`, `水`, `山`, `木`, `日`, `月`, `馬`, or `鳥` rather than abstract number symbols.
- Keep generic period history out of the symbol screen. Design a separate `History` or `Method / History` entry if you want to show what Oracle Bone, Bronze, Seal, Clerical, and Regular mean historically.
- The implementation should preserve the design unless a technical constraint is called out and approved.

## Pilot Recommendation

Use 3-5 pilot symbols before scaling to the first 50:

1. `火` fire
2. `水` water
3. `山` mountain
4. `木` tree / wood
5. `馬` horse

These are visually engaging, easy to understand, and useful for testing image-backed evolution pages.
