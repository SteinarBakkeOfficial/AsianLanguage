# Target-language pages — Codex handoff

This bundle replaces the generated/starter `focusCoverage` content for the 126-symbol V1 museum sequence. Historical evolution data, sources, artwork references, and teaching order are preserved. `fire.json` is intentionally not part of the runtime 126-symbol corpus.

## Rendering contract

Keep the current four-tab/page design. `Traditional Chinese` contains two regional sections: Taiwan Mandarin and Hong Kong Cantonese. Every reading has a learner-facing **native-script + romanization display** in `value` (for example `ダイ (dai)` or `대 / dae`), while audio must speak **`speechText`**, using `speechLanguage`. Do not send `value` to TTS.

For examples, show `text`, then `reading`, then `translation`. Example audio should speak the example `speechText` (identical to native-script `text`).

Japanese readings are deliberately selective rather than exhaustive: common On readings plus a useful Kun/native Japanese reading where one exists. Korean likewise distinguishes the Hanja reading from a native/everyday Korean equivalent when this genuinely helps the learner.

Do not infer that a Korean native equivalent is a reading of the Hanja. It is a semantic bridge shown separately. Likewise, do not imply that every Japanese Kun reading is available in every compound.

## Important semantic divergences

`走`: Mandarin = walk/go, Cantonese commonly = leave/run, Japanese 走る = run, Korean 走 survives mainly in Sino-Korean compounds such as 주행/질주.

`行`: highly polyphonic and language-dependent. Use the curated examples rather than one universal reading.

`申`: modern pages focus on useful descendants (申请/申請, 申し込む, 신청), not the historical gloss “stretch”.

`後`: Simplified Chinese page must render **后** for “after/behind”; the historical/root character remains 後.

`采`: Traditional/Japanese/Korean modern “pick/gather” pages use **採**.

`云`: Japanese/Korean/Traditional cloud pages use **雲**.

`黑`: Japanese uses **黒**.

## Files

- `Corpus/*.json` — exactly 126 corrected runtime records.
- `target-language-manifest.json` — order and modern forms by track.
- `QA-REPORT.md` — automated checks.
- `Excluded/fire.json` — retained reference only; do not import into V1 runtime sequence.
