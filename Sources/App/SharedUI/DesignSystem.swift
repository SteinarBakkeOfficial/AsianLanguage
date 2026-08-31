import SwiftUI
import UIKit

/// Semantic colors for the contemporary gallery shell and historical artifact fields.
enum AppColors {
    static let appBackground = adaptive(light: (247, 242, 234), dark: (20, 18, 16))
    static let surfaceSubtle = adaptive(light: (241, 235, 227), dark: (27, 24, 21))
    static let surfaceStrong = adaptive(light: (233, 222, 208), dark: (36, 32, 28))
    static let textPrimary = adaptive(light: (30, 27, 24), dark: (243, 238, 231))
    static let textSecondary = adaptive(light: (111, 103, 94), dark: (197, 188, 178))
    static let textTertiary = adaptive(light: (138, 129, 120), dark: (147, 138, 129))
    static let separator = adaptive(light: (209, 198, 184), dark: (60, 53, 47))
    static let accentPrimary = adaptive(light: (179, 71, 50), dark: (212, 106, 82))
    static let accentPressed = adaptive(light: (150, 56, 37), dark: (182, 76, 56))
    static let accentSubtle = adaptive(light: (243, 228, 223), dark: (45, 27, 23))
    static let learned = adaptive(light: (46, 107, 88), dark: (116, 178, 157))
    static let warning = adaptive(light: (149, 104, 32), dark: (224, 174, 86))
    static let error = adaptive(light: (178, 55, 53), dark: (239, 113, 107))
    static let artifactField = adaptive(light: (238, 226, 211), dark: (42, 33, 25))
    static let artifactInk = adaptive(light: (53, 43, 36), dark: (228, 216, 200))

    private static func adaptive(light: (CGFloat, CGFloat, CGFloat), dark: (CGFloat, CGFloat, CGFloat)) -> Color {
        Color(uiColor: UIColor { traits in
            let value = traits.userInterfaceStyle == .dark ? dark : light
            return UIColor(red: value.0 / 255, green: value.1 / 255, blue: value.2 / 255, alpha: 1)
        })
    }
}

/// Shared typography keeps editorial serif moments distinct from utility UI.
enum AppTypography {
    static let pageTitle = Font.system(size: 34, weight: .bold, design: .default)
    static let exhibitHeading = Font.system(size: 30, weight: .semibold, design: .serif)
    static let conceptLabel = Font.system(size: 13, weight: .semibold, design: .default)
    static let stageTitle = Font.system(size: 22, weight: .semibold, design: .serif)
    static let sectionHeading = Font.system(size: 20, weight: .semibold, design: .default)
    static let body = Font.system(size: 17, weight: .regular, design: .default)
    static let metadata = Font.system(size: 13, weight: .medium, design: .default)
    static let caption = Font.system(size: 12, weight: .regular, design: .default)
    static let tabLabel = Font.system(size: 10, weight: .medium, design: .default)
}

/// Small spacing vocabulary used by both shell and Symbol compositions.
enum AppSpacing {
    static let space2xs: CGFloat = 4
    static let spaceXs: CGFloat = 8
    static let spaceSm: CGFloat = 12
    static let spaceMd: CGFloat = 16
    static let spacePage: CGFloat = 20
    static let spaceLg: CGFloat = 24
    static let spaceXl: CGFloat = 32
    static let spaceExhibit: CGFloat = 40
    static let spaceSection: CGFloat = 48
    static let spaceHero: CGFloat = 64
}

enum AppRadius {
    static let control: CGFloat = 10
    static let surface: CGFloat = 14
}

enum AppMotion {
    static let press: Double = 0.12
    static let standard: Double = 0.22
    static let exhibit: Double = 0.32
}

/// Full-width primary action with stable dimensions across loading and Dynamic Type.
struct PrimaryActionButton: View {
    let title: String
    let isLoading: Bool
    let action: () -> Void

    init(_ title: String, isLoading: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.isLoading = isLoading
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Group {
                if isLoading {
                    ProgressView().tint(Color.white)
                } else {
                    Text(title)
                }
            }
            .font(AppTypography.body.weight(.semibold))
            .frame(maxWidth: .infinity, minHeight: 52)
        }
        .buttonStyle(PrimaryButtonStyle())
        .disabled(isLoading)
        .accessibilityLabel(title)
    }
}

private struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(Color.white)
            .background(configuration.isPressed ? AppColors.accentPressed : AppColors.accentPrimary)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.surface))
            .scaleEffect(configuration.isPressed ? 0.985 : 1)
            .animation(.easeOut(duration: AppMotion.press), value: configuration.isPressed)
    }
}

/// Subordinate action for reversible or secondary journey choices.
struct SecondaryActionButton: View {
    let title: String
    let action: () -> Void

    init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    var body: some View {
        Button(title, action: action)
            .font(AppTypography.body.weight(.semibold))
            .foregroundStyle(AppColors.textPrimary)
            .frame(minHeight: 44)
            .padding(.horizontal, AppSpacing.spaceMd)
            .background(AppColors.surfaceSubtle)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.surface))
    }
}

/// Standard icon action with a platform-sized hit target and semantic VoiceOver label.
struct IconActionButton: View {
    let systemName: String
    let accessibilityLabel: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 19, weight: .medium))
                .foregroundStyle(AppColors.textSecondary)
                .frame(width: 44, height: 44)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(accessibilityLabel)
    }
}

/// Lightweight grouping surface; open editorial compositions should not use it by default.
struct GroupedSurface<Content: View>: View {
    private let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(AppSpacing.spaceMd)
            .background(AppColors.surfaceSubtle)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.surface))
    }
}

/// Material field reserved for historical evidence and deliberate missing-asset states.
struct ArtifactField<Content: View>: View {
    private let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(AppSpacing.spaceMd)
            .frame(maxWidth: .infinity)
            .background(AppColors.artifactField)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.surface))
    }
}

extension View {
    func groupedSurface() -> some View { GroupedSurface { self } }
    func artifactField() -> some View { ArtifactField { self } }
}

/// Intentional editorial state used when approved historical artwork is not bundled yet.
struct HistoricalMissingState: View {
    let title: String
    let detail: String

    init(title: String = "Historical form not yet included", detail: String = "This form is not currently available in the approved historical corpus.") {
        self.title = title
        self.detail = detail
    }

    var body: some View {
        VStack(spacing: AppSpacing.spaceSm) {
            Image(systemName: "rectangle.dashed")
                .font(.system(size: 28, weight: .light))
                .foregroundStyle(AppColors.artifactInk.opacity(0.7))
                .accessibilityHidden(true)
            Text(title)
                .font(AppTypography.body.weight(.semibold))
                .foregroundStyle(AppColors.artifactInk)
                .multilineTextAlignment(.center)
            Text(detail)
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, minHeight: 180)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title). \(detail)")
    }
}

/// Shared lineage preview for Home, compact discovery rows, and contextual history surfaces.
struct LineagePreview: View {
    enum Variant {
        case hero
        case compact
        case contextual

        var glyphSize: CGFloat {
            switch self {
            case .hero: return 64
            case .compact: return 38
            case .contextual: return 52
            }
        }

        var maximumStages: Int {
            switch self {
            case .hero: return 5
            case .compact: return 3
            case .contextual: return 4
            }
        }
    }

    let record: SharedCharacterRecord
    let variant: Variant

    private var availableForms: [(label: String, form: String, historical: Bool)] {
        var result = record.history.stages.compactMap { stage -> (label: String, form: String, historical: Bool)? in
            guard let form = stage.form, !form.isEmpty else { return nil }
            return (label: stage.label, form: form, historical: true)
        }
        if result.last?.form != record.coreCharacter {
            result.append((label: "Today", form: record.coreCharacter, historical: false))
        }
        return Array(result.prefix(variant.maximumStages))
    }

    var body: some View {
        VStack(spacing: AppSpacing.spaceXs) {
            if availableForms.isEmpty {
                HistoricalMissingState(
                    title: "Lineage artwork not yet included",
                    detail: "Approved historical forms will appear here when bundled."
                )
                .frame(minHeight: variant == .compact ? 100 : 160)
            } else {
                HStack(spacing: 0) {
                    ForEach(Array(availableForms.enumerated()), id: \.offset) { index, item in
                        VStack(spacing: AppSpacing.space2xs) {
                            Text(item.form)
                                .font(.system(size: variant.glyphSize, design: .serif))
                                .foregroundStyle(item.historical ? AppColors.artifactInk : AppColors.textPrimary)
                                .frame(minWidth: variant == .compact ? 48 : 72, minHeight: variant == .compact ? 48 : 80)
                                .accessibilityLabel("\(item.label) form of \(record.coreSharedMeaning)")
                            if variant != .compact {
                                Text(item.label)
                                    .font(AppTypography.caption)
                                    .foregroundStyle(AppColors.textSecondary)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        if index < availableForms.count - 1 {
                            Rectangle()
                                .fill(AppColors.separator)
                                .frame(width: variant == .compact ? 18 : 32, height: 1)
                                .accessibilityHidden(true)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Historical lineage preview for \(record.coreSharedMeaning), \(availableForms.count) available forms")
    }
}

/// Compact character tile with independent, quiet progress and library indicators.
struct CharacterTile: View {
    let record: SharedCharacterRecord
    let userState: LessonUserState?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.spaceSm) {
                Text(record.coreCharacter)
                    .font(.system(size: 48, design: .serif))
                    .foregroundStyle(AppColors.textPrimary)
                    .frame(width: 58)
                VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
                    Text(record.coreSharedMeaning.capitalized)
                        .font(AppTypography.body.weight(.semibold))
                        .foregroundStyle(AppColors.textPrimary)
                    HStack(spacing: AppSpacing.spaceSm) {
                        if let progressLabel {
                            Text(progressLabel)
                                .font(AppTypography.metadata)
                                .foregroundStyle(AppColors.learned)
                        }
                        if userState?.isStarred == true {
                            Image(systemName: "heart.fill")
                                .accessibilityLabel("Favorite")
                        }
                        if userState?.isReviewLater == true {
                            Image(systemName: "bookmark.fill")
                                .accessibilityLabel("Review later")
                        }
                    }
                    .foregroundStyle(AppColors.textSecondary)
                }
                Spacer(minLength: 0)
            }
            .padding(AppSpacing.spaceMd)
            .frame(maxWidth: .infinity, minHeight: 88, alignment: .leading)
            .background(AppColors.surfaceSubtle)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.surface))
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityDescription)
    }

    private var progressLabel: String? {
        switch userState?.progressStatus {
        case .learned: return "Learned"
        default: return nil
        }
    }

    private var accessibilityDescription: String {
        guard let progressLabel else {
            return "\(record.coreCharacter), \(record.coreSharedMeaning)"
        }
        return "\(record.coreCharacter), \(record.coreSharedMeaning), \(progressLabel)"
    }
}

/// Native-feeling search field for Browse-owned search screens.
struct AppSearchField: View {
    @Binding var text: String
    let prompt: String
    let onCancel: () -> Void

    var body: some View {
        HStack(spacing: AppSpacing.spaceXs) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(AppColors.textSecondary)
                .accessibilityHidden(true)
            TextField(prompt, text: $text)
                .font(AppTypography.body)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
            if !text.isEmpty {
                IconActionButton(systemName: "xmark.circle.fill", accessibilityLabel: "Clear search") {
                    text = ""
                }
            }
            Button("Cancel", action: onCancel)
                .font(AppTypography.body)
                .foregroundStyle(AppColors.accentPrimary)
                .frame(minHeight: 44)
        }
        .padding(.leading, AppSpacing.spaceMd)
        .background(AppColors.surfaceSubtle)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

/// Quiet settings row that keeps the primary label and secondary value legible.
struct SettingsRow<Destination: View>: View {
    let title: String
    let value: String?
    let destination: Destination?

    init(_ title: String, value: String? = nil, destination: Destination? = nil) {
        self.title = title
        self.value = value
        self.destination = destination
    }

    var body: some View {
        Group {
            if let destination {
                NavigationLink { destination } label: { rowContent }
            } else {
                rowContent
            }
        }
    }

    private var rowContent: some View {
        HStack {
            Text(title).font(AppTypography.body).foregroundStyle(AppColors.textPrimary)
            Spacer()
            if let value {
                Text(value).font(AppTypography.metadata).foregroundStyle(AppColors.textSecondary)
            }
        }
        .frame(minHeight: 52)
    }
}
