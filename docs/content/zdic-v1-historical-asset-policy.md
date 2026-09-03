# ZDIC V1 Historical Glyph Asset Policy

Status: active V1 runtime/content policy; copied assets are bundled for the current implementation but remain blocked from commercial distribution until reuse rights are confirmed.

Date: 2026-09-03

## Current V1 reference set

The current V1 design/content reference is the **126-character complete-evolution selection** in [`content/research/zdic-v1-complete-manifest.json`](../../content/research/zdic-v1-complete-manifest.json). Each has a selected ZDIC image for Oracle Bone, Bronze, Small Seal, and Clerical. The 22 incomplete records from the 148-character intake remain available in the audit manifest but are not V1. The broader 306-character six-stage pool remains a research and replacement pool.

The full intake audit is [`content/research/zdic-v1-selection-manifest.json`](../../content/research/zdic-v1-selection-manifest.json); the V1-only manifest is [`content/research/zdic-v1-complete-manifest.json`](../../content/research/zdic-v1-complete-manifest.json). Each prepared symbol folder contains the selected source SVG and a normalized museum-canvas SVG under `historical/zdic-selected/`.

## Museum stages

The primary historical journey uses these four stages:

1. Oracle Bone / 甲骨文
2. Bronze / 金文
3. Small Seal / 小篆
4. Clerical / 隶书

Regular Script is not copied from ZDIC. The modern/regular overview uses the bundled approved Kai font, while present-day language forms use the bundled locale-specific Source Han Serif faces. Package sources and notices are recorded in `Resources/Fonts/SOURCE-CJK.md`. The imported runtime records use `Resources/Assets/Symbols/<record>/historical/<stage>/glyph.svg` for normalized historical presentation and retain `source-original.svg` beside each selected glyph for inspection.

## Selection workflow

- Look up each character on [漢典 / ZDIC](https://zdic.net).
- For each required stage, use the first available SVG in the ZDIC page order.
- Move to the next candidate only when the first candidate cannot be retrieved or is empty. The current intake does not claim a manual visual review of every ZDIC variant.
- Preserve the original downloaded SVG and create a transparent 1024×1024 museum-canvas wrapper that retains the source viewBox and glyph geometry.
- Record the character, stage, ZDIC page URL, selected image URL, selected variant number, candidate count, and local paths in the manifest.
- Do not invent a stage when ZDIC has no available example. The app must show an explicit missing historical asset instead.

## Intake result

- Intake characters processed: **148**
- Possible intake stage selections: **592**
- Selected ZDIC stage images: **568**
- Current V1 characters with all four selected stages: **126**
- Excluded incomplete characters: **22**
- Current V1 stage selections: **504**

The missing stage slots are recorded per character in the manifest. They are not silently filled from EVOBC, a generated image, or a modern font.

## Rights and publication boundary

ZDIC is the primary visual reference for this pass, but attribution alone is not assumed to grant commercial redistribution rights. The copied files remain under `content/research/` and must not be bundled into a commercial release until reuse permission is confirmed. If permission cannot be confirmed, replace each selected file with a cleared or public-domain equivalent while retaining the ZDIC page as a research reference where appropriate.

[EVOBC](https://huggingface.co/datasets/HaisuGuan/EVOBC) is a fallback/research source for now because its published CC BY-NC-SA 4.0 license does not permit commercial use. It is not used to override a missing ZDIC stage in this intake.

## Reproducibility

The intake can be rerun with [`Tools/Download-ZDIC-V1Research.ps1`](../../Tools/Download-ZDIC-V1Research.ps1). It reads the locked 148-character sequence from the assessment document and does not modify bundled runtime corpus records.
