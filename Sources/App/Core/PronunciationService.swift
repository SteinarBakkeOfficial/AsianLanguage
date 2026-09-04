import AVFoundation
import SwiftUI

/// iOS-specific pronunciation renderer.
//
/// Script Roots' pronunciation content is platform-independent, but playback
/// currently uses AVSpeechSynthesizer. An Android port must provide its own
/// implementation (for example Android TextToSpeech) rather than attempting
/// to reuse this Apple-specific service.
final class PronunciationService {
    static let shared = PronunciationService()

    /// The synthesizer is retained because AVFoundation does not retain it for the caller.
    private let synthesizer = AVSpeechSynthesizer()

    /// Keep playback close to the system voice while leaving room for learner-friendly clarity.
    private let speechRate = AVSpeechUtteranceDefaultSpeechRate * 0.9

    private init() {}

    /// Returns the Apple locale for platform-independent Script Roots language intent.
    private func locale(for language: PronunciationLanguage) -> String {
        switch language {
        case .mandarin: return "zh-CN"
        case .cantonese: return "zh-HK"
        case .japanese: return "ja-JP"
        case .korean: return "ko-KR"
        }
    }

    /// A missing exact voice is unavailable rather than a reason to substitute another language.
    func canSpeak(_ reading: CharacterReading) -> Bool {
        guard let text = reading.speechText,
              !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              let language = reading.speechLanguage else {
            return false
        }
        return AVSpeechSynthesisVoice(language: locale(for: language)) != nil
    }

    /// Speaks only explicit native-script speech text and stops an existing item first.
    @discardableResult
    func speak(_ reading: CharacterReading) -> Bool {
        guard let text = reading.speechText,
              !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              let language = reading.speechLanguage,
              let voice = AVSpeechSynthesisVoice(language: locale(for: language)) else {
            return false
        }

        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = voice
        utterance.rate = speechRate
        synthesizer.speak(utterance)
        return true
    }
}

/// Small, quiet speaker control used beside an explicit modern-language reading.
struct PronunciationButton: View {
    let reading: CharacterReading

    var body: some View {
        if PronunciationService.shared.canSpeak(reading) {
            Button {
                _ = PronunciationService.shared.speak(reading)
            } label: {
                Image(systemName: "speaker.wave.2")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(AppColors.textSecondary)
                    .frame(width: 28, height: 28)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Play pronunciation \(reading.value)")
        }
    }
}
