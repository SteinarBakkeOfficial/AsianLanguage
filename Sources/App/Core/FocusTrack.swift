import Foundation

/// Modern display and usage lane that can be enabled by the learner.
enum FocusTrack: String, CaseIterable, Identifiable, Codable {
    case simplifiedChinese
    case traditionalChinese
    case japanese
    case korean

    /// Stable identifier for SwiftUI pickers and local preference storage.
    var id: String { rawValue }

    /// User-facing label for focus-track controls.
    var title: String {
        switch self {
        case .simplifiedChinese:
            return "Simplified Chinese"
        case .traditionalChinese:
            return "Traditional Chinese"
        case .japanese:
            return "Japanese"
        case .korean:
            return "Korean"
        }
    }
}

/// Persisted multi-select focus preference for lesson forms and examples.
struct FocusTrackSelection: Codable, Equatable {
    /// Ordered selected tracks; all tracks are enabled by default for first launch.
    var selectedTracks: [FocusTrack]

    /// Default selection matching the agreed V1 behavior: every focus track is on.
    static let all = FocusTrackSelection(selectedTracks: FocusTrack.allCases)

    /// Returns true when a focus track should be displayed in lessons.
    func contains(_ track: FocusTrack) -> Bool {
        selectedTracks.contains(track)
    }

    /// Stable membership toggle that keeps at least one focus track selected.
    mutating func set(_ track: FocusTrack, isSelected: Bool) {
        if isSelected {
            if !selectedTracks.contains(track) {
                selectedTracks.append(track)
            }
            selectedTracks = FocusTrack.allCases.filter { selectedTracks.contains($0) }
            return
        }

        let remainingTracks = selectedTracks.filter { $0 != track }
        if !remainingTracks.isEmpty {
            selectedTracks = remainingTracks
        }
    }
}
