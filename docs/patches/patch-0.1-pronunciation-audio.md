# Patch 0.1 candidate — pronunciation and example audio

Status: planned post-release work; not implemented and not part of the V1.0 release candidate.

## Purpose

Use post-release feedback to improve how Script Roots speaks pronunciation. The goal is clearer, more useful listening support for the four target-language tracks without changing the approved V1.0 content or layout before marketplace submission.

## Candidate scope

1. Improve pronunciation playback for the displayed target-language readings. Review speaking quality, language/locale selection, speech text, pacing, and any cases where the synthesized voice is difficult for a learner to understand.
2. Evaluate adding a speaker action for every approved usage example, not only the main reading rows. Example playback should speak the actual written example and its verified language-specific reading, rather than asking the speech engine to infer a reading from an ambiguous character string.
3. Preserve the current written aids: native writing, furigana where applicable, Pinyin/Jyutping, romanization, Hangul/Hanja guidance, and English glosses remain available even when audio is unavailable.
4. Keep missing or uncertain speech data unavailable rather than generating a misleading pronunciation. Cantonese must continue to use explicit Jyutping/language intent and must not fall back silently to Mandarin.

## Boundaries

- Do not change the V1.0 release candidate while preparing the first marketplace submission.
- Do not rewrite approved translations, examples, equivalents, or historical copy as part of an audio improvement.
- Do not add cloud TTS, API keys, analytics, or bundled MP3 libraries without a separate product, privacy, licensing, and architecture decision.
- Keep pronunciation data platform-independent; only the playback renderer is iOS-specific in the current app.
- Keep the existing small, quiet speaker-control treatment unless feedback shows a specific usability problem.

## Review checklist for Patch 0.1

- Test each target language with the correct Apple voice/locale and explicit speech text.
- Test the main reading, each approved equivalent/variant, and each usage example that receives a speaker action.
- Check Japanese speech against furigana/kana, not only the visible Kanji.
- Check Korean native readings against Hangul, not only Hanja.
- Check Mandarin tones and Hong Kong Cantonese tone numbers through native-speaker/device review.
- Verify unavailable voices and missing speech text fail safely and leave the written pronunciation guidance intact.
- Test playback on supported Apple devices, including interruption, repeated taps, navigation away, silent mode expectations, accessibility labels, and offline behavior.
- Update the technical attribution and release notes if the implementation changes.

## Decision point

After V1.0 release feedback arrives, decide whether to implement the full candidate, a smaller language-by-language correction pass, or defer it. This document is a planning record only; it is not current implementation authorization.
