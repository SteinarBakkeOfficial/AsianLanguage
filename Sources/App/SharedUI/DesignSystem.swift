import SwiftUI
import UIKit

/// Semantic colors for the contemporary gallery shell and historical artifact fields.
enum AppColors {
    // These values mirror the approved Fire handoff. Keep the light palette stable because
    // the reference screenshots are composed on this warm gallery field.
    static let appBackground = adaptive(light: (247, 243, 238), dark: (18, 18, 15))
    static let surfaceSubtle = adaptive(light: (239, 233, 225), dark: (28, 27, 24))
    static let surfaceElevated = adaptive(light: (255, 255, 255), dark: (31, 30, 26))
    static let surfaceStrong = adaptive(light: (247, 245, 240), dark: (38, 35, 32))
    static let textPrimary = adaptive(light: (28, 28, 28), dark: (245, 245, 242))
    static let textSecondary = adaptive(light: (104, 104, 104), dark: (134, 132, 140))
    static let textTertiary = adaptive(light: (183, 176, 166), dark: (143, 140, 132))
    static let separator = adaptive(light: (225, 218, 209), dark: (47, 45, 40))
    static let accentPrimary = adaptive(light: (194, 58, 43), dark: (226, 92, 74))
    static let accentPressed = adaptive(light: (165, 32, 34), dark: (191, 66, 47))
    static let accentSubtle = adaptive(light: (248, 233, 230), dark: (58, 29, 24))
    static let learned = adaptive(light: (46, 125, 110), dark: (51, 196, 157))
    static let warning = adaptive(light: (149, 104, 32), dark: (224, 174, 86))
    static let error = adaptive(light: (178, 55, 53), dark: (239, 113, 107))
    static let artifactField = adaptive(light: (239, 233, 225), dark: (42, 37, 28))
    static let artifactInk = adaptive(light: (53, 43, 36), dark: (228, 216, 200))

    /// A visibly separate museum-navigation surface keeps the Origin-to-Today rail
    /// legible without introducing a new accent color family.
    static let journeyRailBackground = adaptive(light: (229, 221, 211), dark: (42, 37, 32))
    static let journeyRailSelected = adaptive(light: (255, 252, 247), dark: (58, 51, 44))

    private static func adaptive(light: (CGFloat, CGFloat, CGFloat), dark: (CGFloat, CGFloat, CGFloat)) -> Color {
        Color(uiColor: UIColor { traits in
            let value = traits.userInterfaceStyle == .dark ? dark : light
            return UIColor(red: value.0 / 255, green: value.1 / 255, blue: value.2 / 255, alpha: 1)
        })
    }
}

/// Bundled typefaces match the approved AppShell reference and the locale-aware
/// CJK typography contract. Keep the CJK names aligned with the PostScript names
/// embedded in the selected official font files.
enum AppFont {
    static let playfairRegular = "PlayfairDisplay-Regular"
    static let playfairBold = "PlayfairDisplay-Bold"
    static let interRegular = "Inter-Regular"
    static let interMedium = "Inter-Medium"
    static let interSemiBold = "Inter-SemiBold"

    /// Canonical pedagogical endpoint for the museum timeline.
    static let museumRegular = "TW-Kai-98_1"

    /// Locale-specific Source Han Serif faces for the parallel Used Today forms.
    // Adobe's locale-specific OTFs use locale-qualified PostScript names;
    // keep these aligned with the official deployment filenames.
    static let sourceHanSerifJP = "SourceHanSerifJP-Regular"
    static let sourceHanSerifKR = "SourceHanSerifKR-Regular"
    static let sourceHanSerifSC = "SourceHanSerifSC-Regular"
    static let sourceHanSerifTC = "SourceHanSerifTC-Regular"
}

/// The role is semantic so a shared Unicode character never silently receives
/// the wrong regional glyph convention. Add a new role here if another living
/// writing system is approved for the product.
enum CJKFontRole {
    case museumRegular
    case simplifiedChinese
    case traditionalChinese
    case japanese
    case korean

    var postScriptName: String {
        switch self {
        case .museumRegular: return AppFont.museumRegular
        case .simplifiedChinese: return AppFont.sourceHanSerifSC
        case .traditionalChinese: return AppFont.sourceHanSerifTC
        case .japanese: return AppFont.sourceHanSerifJP
        case .korean: return AppFont.sourceHanSerifKR
        }
    }

    func font(size: CGFloat) -> Font {
        Font.custom(postScriptName, size: size)
    }
}

/// Shared typography keeps the Alt reference's editorial/display and utility roles distinct.
enum AppTypography {
    static let pageTitle = Font.custom(AppFont.interSemiBold, size: 17, relativeTo: .headline)
    static let exhibitHeading = Font.custom(AppFont.playfairBold, size: 24, relativeTo: .title2)
    static let heroConcept = Font.custom(AppFont.playfairBold, size: 18, relativeTo: .title3)
    static let conceptLabel = Font.custom(AppFont.interSemiBold, size: 11, relativeTo: .caption)
    static let stageTitle = Font.custom(AppFont.interSemiBold, size: 15, relativeTo: .headline)
    static let sectionHeading = Font.custom(AppFont.interSemiBold, size: 13, relativeTo: .subheadline)
    static let body = Font.custom(AppFont.interRegular, size: 16, relativeTo: .body)
    static let metadata = Font.custom(AppFont.interRegular, size: 13, relativeTo: .footnote)
    static let caption = Font.custom(AppFont.interRegular, size: 11, relativeTo: .caption)
    static let tabLabel = Font.custom(AppFont.interMedium, size: 11, relativeTo: .caption)
}

/// Small spacing vocabulary used by both shell and Symbol compositions.
enum AppSpacing {
    static let space2xs: CGFloat = 4
    static let spaceXs: CGFloat = 8
    static let spaceSm: CGFloat = 12
    static let spaceMd: CGFloat = 16
    static let spacePage: CGFloat = 16
    static let spaceLg: CGFloat = 24
    static let spaceXl: CGFloat = 32
    static let spaceExhibit: CGFloat = 40
    static let spaceSection: CGFloat = 48
    static let spaceHero: CGFloat = 64
}

enum AppRadius {
    static let small: CGFloat = 4
    static let control: CGFloat = 12
    static let surface: CGFloat = 12
    static let card: CGFloat = 16
}

enum AppMotion {
    static let press: Double = 0.12
    static let standard: Double = 0.22
    static let exhibit: Double = 0.64
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
            .frame(maxWidth: .infinity, minHeight: 44)
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
            .foregroundStyle(AppColors.accentPrimary)
            .frame(minHeight: 44)
            .padding(.horizontal, AppSpacing.spaceMd)
            .background(AppColors.surfaceElevated)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.control))
            .overlay {
                RoundedRectangle(cornerRadius: AppRadius.control)
                    .stroke(AppColors.accentPrimary, lineWidth: 1)
            }
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
            .background(AppColors.surfaceElevated)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.card))
            .overlay {
                RoundedRectangle(cornerRadius: AppRadius.card)
                    .stroke(AppColors.separator, lineWidth: 1)
            }
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
            .padding(AppSpacing.spaceSm)
            .frame(maxWidth: .infinity)
            .background(AppColors.artifactField)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.card))
            .overlay {
                RoundedRectangle(cornerRadius: AppRadius.card)
                    .stroke(AppColors.separator, lineWidth: 1)
            }
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
    enum Variant: Equatable {
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
            case .hero: return 3
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
            } else if variant == .hero {
                VStack(spacing: AppSpacing.space2xs) {
                    ForEach(Array(availableForms.enumerated()), id: \.offset) { index, item in
                        Text(item.form)
                            .font(.system(size: variant.glyphSize, design: .serif))
                            .foregroundStyle(item.historical ? AppColors.artifactInk : AppColors.textPrimary)
                            .frame(minWidth: 72, minHeight: 64)
                            .accessibilityLabel("\(item.label) form of \(record.coreSharedMeaning)")
                        if index < availableForms.count - 1 {
                            Image(systemName: "arrow.down")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(AppColors.textSecondary)
                                .accessibilityHidden(true)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
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
                    .font(.system(size: 34, design: .serif))
                    .foregroundStyle(AppColors.textPrimary)
                    .frame(width: 44)
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
            .frame(maxWidth: .infinity, minHeight: 72, alignment: .leading)
            .background(AppColors.surfaceElevated)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.card))
            .overlay {
                RoundedRectangle(cornerRadius: AppRadius.card)
                    .stroke(AppColors.separator, lineWidth: 1)
            }
            .shadow(color: AppColors.textPrimary.opacity(0.06), radius: 8, y: 3)
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
                .layoutPriority(1)
            if !text.isEmpty {
                IconActionButton(systemName: "xmark.circle.fill", accessibilityLabel: "Clear search") {
                    text = ""
                }
            }
            Button("Cancel", action: onCancel)
                .font(AppTypography.body)
                .foregroundStyle(AppColors.accentPrimary)
                .frame(minHeight: 44)
                .fixedSize()
        }
        .padding(.leading, AppSpacing.spaceMd)
        .padding(.trailing, AppSpacing.spaceXs)
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
