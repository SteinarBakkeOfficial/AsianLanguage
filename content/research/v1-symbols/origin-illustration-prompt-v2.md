# Origin Illustration Generation — Approved v2 Style

Use this prompt recipe for the origin illustration immediately before each symbol's Oracle Bone stage:

```text
Depicting: [short plain-language description of the verified subject or action].

Use case: illustration-story. Asset type: origin illustration for a contemporary symbol museum app.

Create a simple, friendly, clearly recognizable illustration of the verified real-world subject, object, person, action, or natural phenomenon represented by [CHARACTER]. The real subject is the priority: depict it naturally and understandably, with a warm, lightly cartoony museum-editorial feeling.

Use the selected Oracle Bone reference for [CHARACTER] only as a loose guide to broad orientation, facing direction, posture, placement, or overall composition. Do not copy its outline literally. Do not force the subject's anatomy, proportions, silhouette, or details to match the glyph. The Oracle Bone form should create a subtle visual relationship, never a strange or distorted subject.

If the verified origin is a compound made from two or three meaningful pictographic components, show those components as two or three separate, clearly readable mini-illustrations within the same horizontal artwork. Use generous space between them and a calm left-to-right or top-to-bottom arrangement. Each component must remain a natural real-world subject; do not fuse them into one distorted object. A subtle visual relationship may connect the group only when it is part of the verified meaning. Do not illustrate a component that is only phonetic.

Style: Soft Ink & Wash — Museum Editorial Illustration: hand-painted dark brown or charcoal ink outline, restrained muted watercolor, subtle handmade imperfections, simplified forms, elegant contemporary museum and illustrated natural-history-book feeling, clearly illustrative and lightly cartoony, not realistic.

Composition: horizontal 11:9, one isolated dominant subject, optically centered, generous negative space, pale warm ivory or clean background, subtle grounding wash only, no scenery unless genuinely necessary to communicate the verified meaning.

No text, no Chinese/Japanese/Korean characters, no labels, no borders, no UI, no watermark.

Avoid literal glyph tracing, distorted or alien anatomy, hyperrealism, 3D rendering, vector-icon appearance, emoji, children's clip art, cinematic lighting, fantasy elements, excessive detail, or bright saturation.
```

## Per-symbol requirements

- Replace `[CHARACTER]` with the symbol's verified character and use its existing research meaning/origin metadata.
- Begin each generation request with a short `Depicting:` line. Keep it plain and concrete so reviewers can quickly identify the intended subject.
- Study the selected Oracle Bone image before generation, but use it only for a restrained compositional cue.
- For simple pictographs, use one dominant subject. For meaningful compounds, use two or three separate component illustrations in the shared 11:9 area.
- Never invent a visual etymology. If the verified meaning is too abstract or unclear to depict reliably, mark `originIllustrationNeedsReview: true` and do not guess.
- Keep the subject simple enough to read at small iPhone size.
- Preserve the approved v2 style across the collection while allowing the subject to determine its natural pose and form.

## Approved direction examples

- `女`: a natural side-facing adult woman; do not force her body into the Oracle glyph.
- `口`: a friendly front-facing human mouth; do not make it a square glyph, animal mouth, or diagram.
- `舌`: a front-facing open human mouth with a naturally placed, proportionate tongue inside; do not make the tongue detached, alien-like, or snake-like.

## Output contract

- Master format: horizontal 11:9, preferably 1100 × 900 px or larger.
- One dominant subject, no baked-in text or labels.
- Store the generated asset as a versioned file so prior drafts are not overwritten.
- This illustration is an educational reconstruction, not historical evidence.
