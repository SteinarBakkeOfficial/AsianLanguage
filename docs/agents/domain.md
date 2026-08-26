# Domain Docs

How the engineering skills should consume this repo's domain documentation when exploring the codebase.

## Layout

This is a single-context repo.

## Before exploring, read these

- `CONTEXT.md` for glossary and domain language.
- `DECISIONS.md` for resolved product and architectural decisions.
- `ROADMAP.md` for phase-level direction and V1 carryover.
- `CURRENT_STEP.md` for the active scope and next concrete output.
- `docs/adr/` for architectural decision records when it exists.

## Normative hierarchy

When documents disagree, use this order:

1. `DECISIONS.md`
2. `ProjectBrief.md`
3. `CONTEXT.md`
4. `docs/architecture/v1-foundation.md`
5. `docs/design/PRODUCT_DESIGN_DIRECTION.md`
6. `docs/content/shared-character-schema.md`
7. approved screen-specific design specs and references
8. `ROADMAP.md`
9. `CURRENT_STEP.md`

Archived briefs and prototype feedback preserve history only and do not override normative documents.

If any optional file or folder does not exist, proceed silently. Do not suggest creating it upfront; producer workflows create docs lazily when terms or decisions are resolved.

## Use the glossary's vocabulary

When output names a domain concept, use the term as defined in `CONTEXT.md`. Do not drift to synonyms the glossary explicitly avoids.

If a needed concept is not in the glossary yet, note it as a candidate for `grill-with-docs` instead of inventing durable terminology.

## Flag decision conflicts

If output contradicts `DECISIONS.md` or an ADR, surface it explicitly rather than silently overriding it.
