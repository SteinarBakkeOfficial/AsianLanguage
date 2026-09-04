# Pronunciation Audio via Apple AVSpeechSynthesizer

## Status

This document preserves the complete user-provided pronunciation-audio handoff received on 2026-09-04.

It is approved for the current surgical polish implementation. The service and data seam are now implemented; native compilation, voice availability, and physical-device verification remain outstanding. The service remains iOS-specific, while the linguistic data remains platform-independent.

## User-provided handoff

# CODEX HANDOFF — PRONUNCIATION AUDIO VIA APPLE AVSpeechSynthesizer

We are adding pronunciation playback to the modern-language sections of Script Roots.

This is an iOS-specific implementation using Apple's native AVSpeechSynthesizer.

There should be:

no Amazon Polly
no paid TTS API
no external speech service
no API keys
no batch-downloaded MP3 library
no per-character/per-request speech cost

Apple's AVSpeechSynthesizer accepts an AVSpeechUtterance, allows a language-specific AVSpeechSynthesisVoice, and plays the resulting speech through the system speech synthesizer.

1. Scope

Make this a surgical addition.

The task is:

verify/structure the pronunciation text already used by our modern-language data
add a small reusable iOS pronunciation service based on AVSpeechSynthesizer
connect the small speaker buttons on the modern-language pages
document clearly that this implementation is iOS-only
add Apple Speech Synthesis to Sources / Licenses / technical attribution
document what must change if Script Roots is later ported to Android

Do not redesign unrelated screens or restructure unrelated app architecture.

2. iOS implementation

Use:

AVSpeechSynthesizer
AVSpeechUtterance
AVSpeechSynthesisVoice

from Apple's AVFAudio / AVFoundation speech-synthesis APIs.

Conceptually:

let utterance = AVSpeechUtterance(string: audioText)
utterance.voice = AVSpeechSynthesisVoice(language: locale)
synthesizer.speak(utterance)

The synthesizer should be retained by the pronunciation service rather than instantiated and immediately discarded; Apple's documentation notes that the system does not automatically retain the synthesizer for you.

3. Keep the Apple dependency isolated

Even though the current application is iOS-only, do not scatter direct AVSpeechSynthesizer calls throughout individual SwiftUI views.

Keep it behind one small pronunciation service, for example conceptually:

PronunciationService

or whatever naming best fits the existing project.

Views should essentially request:

speak(
    text: ...,
    locale: ...
)

rather than knowing how Apple TTS works internally.

Do not create an elaborate new architecture for this. One small centralized service is enough.

This isolation is important because the implementation must be replaced on Android later.

4. Required spoken-language contexts

Use these language/locale targets as the initial mapping:

Mandarin Chinese → zh-CN
Cantonese        → zh-HK
Japanese         → ja-JP
Korean           → ko-KR

Resolve the actual available AVSpeechSynthesisVoice through Apple's speech API.

Do not hard-code assumptions that every device contains every exact named voice.

Voice availability can differ with device/system configuration.

If the desired language voice genuinely cannot be obtained, do not silently substitute an incorrect language.

For example:

never fall back from Cantonese to Mandarin simply because Mandarin is available.

A missing pronunciation is preferable to an incorrect one.

5. The most important data rule: speak the explicit native-script reading, not blindly the Han character

The visible character and the string passed to the speech engine are not necessarily the same thing.

This is crucial for Japanese, Korean, and polyphonic Chinese characters.

For example, for 水:

Mandarin

Visible:

水

Reading:

shuǐ

Speech input may be the explicit Mandarin lexical form represented by 水.

Cantonese

Visible:

水

Reading:

seoi2

Speech must use the explicit Cantonese reading/context.

Japanese Kun

Visible relationship:

水 → みず

Speech input:

みず

not simply:

水
Japanese On

Visible relationship:

水 → すい

Speech input:

すい
Korean Sino-Korean

Visible relationship:

水 → 수

Speech input:

수
Korean everyday/native word

Visible:

물

Speech input:

물

The TTS engine should pronounce exactly the linguistic item the learner is looking at.

6. Do not let TTS determine our linguistic data

AVSpeechSynthesizer is a playback technology, not a dictionary.

Do not ask it to decide:

Pinyin
Jyutping
Japanese On readings
Japanese Kun readings
Korean Hanja readings
native Korean vocabulary
meanings
which reading is appropriate for a Symbol

Those values must come from the Script Roots content model. The current V1 values are draft and remain open to later user/native-speaker review.

The direction is:

Script Roots draft/editorial data → explicit native-script speech text → AVSpeechSynthesizer

Never:

character → ask TTS to guess reading → treat result as data

7. Pronunciation data

Where needed, extend the existing Symbol/language data with a dedicated speech value.

For example, conceptually:

struct Pronunciation {
    let displayReading: String
    let romanization: String?
    let speechText: String
    let locale: String
}

This is only an example.

Use the existing data architecture if it already supports this cleanly.

Do not create a second parallel content database merely for audio.

The important point is that `speechText` is explicit native-script input. It must not be a romanized label when Japanese kana, Korean Hangul, or another native-script form is required. Missing native-script speech text should leave playback unavailable until the content is supplied.

8. Mandarin and Traditional/Simplified Chinese

Do not create duplicate audio simply because the UI contains separate Simplified and Traditional pages.

Traditional and Simplified are writing-system distinctions.

If the same Mandarin lexical item has the same pronunciation, both can call the same pronunciation data.

Likewise, Cantonese should use the Cantonese reading attached to the relevant content.

The spoken-language contexts are therefore primarily:

Mandarin
Cantonese
Japanese
Korean

not “Simplified speech” versus “Traditional speech.”

9. Japanese

Japanese pronunciation controls should speak the actual Japanese reading being displayed.

Example:

Kun

みず

Speak:

みず
On

すい

Speak:

すい

If an example is:

水道
すいどう

and we later add audio for the example word, speak:

すいどう

Do not pass 水道 and assume the speech synthesizer will always choose the reading our lesson intends.

An explicit kana reading is safer and clearer.

10. Korean

Korean must keep the distinction established in the modern-language design.

For 水:

Hanja / Sino-Korean

水 → 수

Speaker beside 수:

수
Modern everyday Korean

물

Speaker beside 물:

물

Do not make the Hanja itself the input and ask TTS to infer how we want it pronounced.

This distinction must remain data-driven for all Symbols.

Some entries will not have a separate native Korean word, so do not fabricate content to satisfy the layout.

11. Speaker-button behavior

Keep the audio control very small and consistent with the existing modern-language UI.

Expected behavior:

tap speaker
immediately play the associated reading
if something else is currently speaking, stop it before playing the new item
tapping again can replay the item

Apple's synthesizer already supports speaking, pausing, stopping, and tracking current speech state.

No large media player is necessary.

12. Speech rate

Do not make pronunciation unnaturally fast.

Use a consistent learner-friendly rate across the app.

However, avoid heavily slowing the voice down to the point that tones, rhythm, or normal pronunciation become distorted.

Start reasonably close to the Apple voice's normal rate and adjust only if testing shows the default is too fast for learners.

Keep the setting centralized in the pronunciation service rather than assigning arbitrary rates on individual pages.

13. Test the four language contexts before rollout

Before wiring every Symbol, manually verify at minimum:

Mandarin
Cantonese
Japanese
Korean

using representative content such as:

Water
Fire
Tree
Person
Sun

Particularly verify the Mandarin/Cantonese distinction.

Do not assume that because AVSpeechSynthesisVoice(language:) returned something, the result is linguistically the voice we expect.

Test on a physical supported iPhone as well as Simulator where practical.

14. Missing voice behavior

If a required language/voice is unavailable:

do not crash
do not substitute another language
do not pronounce Cantonese as Mandarin
gracefully disable or hide the affected speaker control for that reading
log/debug the missing locale so we can investigate it

The written pronunciation information should still remain available.

15. No pre-generated audio assets required

For this implementation, do not generate hundreds of MP3 files.

The app should synthesize the verified pronunciation when the learner taps the speaker.

That means we do not need:

Audio/
    water/
    fire/
    tree/
    ...

and we do not need to add hundreds of audio files to the app bundle.

16. Sources / Licenses / About

Add a small technical attribution/reference for Apple's speech synthesis.

Suggested content:

Apple Speech Synthesis

Pronunciation playback uses Apple's system speech-synthesis technology through AVSpeechSynthesizer.

This attribution describes how audio is produced.

It does not replace the linguistic citations that establish the correct readings.

Keep our linguistic sources separately credited.

Apple's official documentation describes Speech Synthesis as configuring system voices to speak text strings through AVSpeechUtterance, AVSpeechSynthesisVoice, and AVSpeechSynthesizer.

Official reference to preserve in the project documentation:

Apple — AVSpeechSynthesizer documentation

Apple — Speech Synthesis documentation

17. IMPORTANT — document that this is iOS-specific

This needs to be written clearly into the appropriate technical/project documentation.

Add a section similar to:

Pronunciation Speech — Platform Dependency

Script Roots currently uses Apple's AVSpeechSynthesizer for pronunciation playback on iOS.

AVSpeechSynthesizer is an Apple-platform API and must not be treated as a cross-platform audio implementation.

The Script Roots linguistic pronunciation data (speechText, reading, locale/language intent, etc.) should remain platform-independent.

Only the speech-rendering implementation is platform-specific.

If an Android version of Script Roots is developed, the iOS AVSpeechSynthesizer implementation must be replaced with an Android-compatible text-to-speech implementation while preserving the same verified pronunciation data and UX behavior.

This warning should live somewhere a future Android developer will actually see it, such as:

architecture documentation
platform/services documentation
README/developer implementation notes

Use the project's existing documentation structure rather than creating unnecessary duplicate documentation files.

18. Android future implementation

For a future Android version, the intended equivalent is Android's native text-to-speech platform, typically:

android.speech.tts.TextToSpeech

The Android implementation must be evaluated independently for:

Mandarin support
Cantonese support
Japanese support
Korean support
installed/device voice availability
pronunciation quality
locale behavior

Do not assume Apple voice identifiers or behavior transfer to Android.

Android exposes its own TTS engine/voice system and language availability mechanisms.

Official future reference:

Android — Text-to-Speech API documentation

19. Keep linguistic data platform-independent

This distinction is important for the potential Android version.

Conceptually:

Symbol linguistic data
        ↓
draft native-script speechText + language intent
        ↓
Pronunciation service
        ↓
┌─────────────────────┬─────────────────────┐
│ iOS                 │ Android (future)    │
│ AVSpeechSynthesizer │ Android TextToSpeech│
└─────────────────────┴─────────────────────┘

Do not put Apple-specific voice objects, voice identifiers, or AVFoundation types inside the core Symbol content model.

For example, this is good platform-independent data:

speechText: "みず"
language: Japanese

The iOS service can translate that language intent into:

ja-JP

and an available AVSpeechSynthesisVoice.

A future Android implementation can translate the same data into the appropriate Android locale/voice.

This avoids having to rewrite the ~140-Symbol linguistic database for Android.

20. Documentation comments in code

At the iOS pronunciation-service implementation itself, add a concise comment such as:

// iOS-specific pronunciation renderer.
//
// Script Roots' pronunciation content is platform-independent, but playback
// currently uses AVSpeechSynthesizer. An Android port must provide its own
// implementation (for example Android TextToSpeech) rather than attempting
// to reuse this Apple-specific service.

This is worth stating directly in code so that the platform dependency cannot easily be missed later.

21. Final scope

Implement only what is required to support pronunciation playback:

Existing verified linguistic data

→ explicit speech text

→ small pronunciation service

→ Apple AVSpeechSynthesizer

→ existing speaker controls

And document:

Current implementation: iOS / Apple-specific

Future Android implementation: replace speech-rendering service; retain the same verified language data

No paid cloud TTS system is required for the current iPhone application.

## Reconciliation notes

- Audio playback and speaker controls are approved for the current implementation pass. The isolated service and small controls are now present; no speech service or audio asset gap remains in the agreed architecture.
- The proposal aligns with the offline-first and no-paid-service direction.
- The proposal correctly keeps speech text and language intent in content data while isolating Apple playback in a service.
- The proposal must preserve the rule that missing Cantonese or another required voice never silently falls back to a different language.
- Adding explicit `speechText` may require schema, validator, runtime model, importer, migration, and test alignment. It must not create a parallel pronunciation database.
- The Apple renderer must remain isolated from the platform-independent Symbol linguistic data. A future Android port replaces only the renderer with Android `TextToSpeech` after independent voice/locale testing.
- Apple and Android documentation links should be verified and added during implementation/documentation follow-through; no external documentation was fetched for this recording-only step.

## Implementation follow-through — 2026-09-04

- `PronunciationService` now retains one `AVSpeechSynthesizer`, maps the four approved language intents to exact iOS locales, stops current speech before replay, and refuses incorrect-language fallback.
- `PronunciationButton` is data-gated: it appears only when an explicit `speechText` and platform-independent `speechLanguage` are present and the exact iOS voice is available.
- All current V1 reading rows now receive explicit draft speech values through the existing importer. These values are intentionally not treated as user- or native-speaker-verified; later review is expected to correct draft readings. Missing Cantonese rows remain absent rather than falling back to Mandarin.
