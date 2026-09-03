import SwiftUI
import UIKit
import WebKit

/// One continuous, swipeable Symbol Journey from origin through history into Today.
struct CharacterEvolutionView: View {
    let record: SharedCharacterRecord
    let focusSelection: FocusTrackSelection
    let completionTitle: String
    let onComplete: () -> Void
    @Binding var selectedStageID: String

    init(
        record: SharedCharacterRecord,
        focusSelection: FocusTrackSelection,
        completionTitle: String,
        onComplete: @escaping () -> Void,
        selectedStageID: Binding<String>
    ) {
        self.record = record
        self.focusSelection = focusSelection
        self.completionTitle = completionTitle
        self.onComplete = onComplete
        self._selectedStageID = selectedStageID
        // Keep the expensive CJK registration out of app launch while ensuring the
        // Regular Script endpoint is available before the museum pages are shown.
        BundledFontRegistrar.registerMuseumFonts()
    }

    /// Keeps explicit editorial omissions out of the primary journey while preserving asset gaps as visible states.
    private var stages: [HistoricalStage] {
        record.history.stages.filter {
            $0.availabilityState != .unsupportedStage && $0.availabilityState != .intentionallyOmitted
        }
    }

    /// The museum portion ends at Modern; Regular Script is represented by that Modern endpoint.
    private var museumStages: [HistoricalStage] {
        stages.filter { $0.stage != "regular" && $0.stage != "modernForms" && $0.stage != "today" }
    }

    private var currentLabel: String {
        if selectedStageID == "origin" { return "Origin" }
        if selectedStageID == "modern" { return "Modern" }
        if selectedStageID.hasPrefix("usage-"),
           let track = FocusTrack(rawValue: String(selectedStageID.dropFirst("usage-".count))) {
            return "Usage · \(track.title)"
        }
        return stages.first(where: { $0.stage == selectedStageID })?.label ?? selectedStageID
    }

    /// The requested language order is stable even when the persisted selection was made in another order.
    private var orderedTracks: [FocusTrack] {
        [.traditionalChinese, .simplifiedChinese, .japanese, .korean]
            .filter { focusSelection.selectedTracks.contains($0) }
    }

    /// One visible rail changes its destinations with the learner's current room: museum stages through Modern, then selected languages.
    private var museumNavigatorIDs: [String] {
        ["origin"] + museumStages.map(\.stage) + ["modern"]
    }

    /// Language rail: Modern remains visible as the return point, followed by selected target languages.
    private var languageNavigatorIDs: [String] {
        ["modern"] + orderedTracks.map { "usage-\($0.rawValue)" }
    }

    private var navigatorIDs: [String] {
        !orderedTracks.isEmpty && (selectedStageID == "modern" || selectedStageID.hasPrefix("usage-"))
            ? languageNavigatorIDs
            : museumNavigatorIDs
    }

    private var selectedNavigatorID: String {
        if selectedStageID.hasPrefix("usage-") { return selectedStageID }
        return selectedStageID
    }

    private var navigatorIndex: Int {
        navigatorIDs.firstIndex(of: selectedNavigatorID) ?? 0
    }

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $selectedStageID) {
                originPage
                    .tag("origin")
                ForEach(museumStages, id: \.stage) { stage in
                    historicalPage(stage)
                        .tag(stage.stage)
                }
                modernPage
                    .tag("modern")
                if !orderedTracks.isEmpty {
                    ForEach(Array(orderedTracks.enumerated()), id: \.element) { index, track in
                        usagePage(track: track, isFinal: index == orderedTracks.count - 1)
                            .tag("usage-\(track.rawValue)")
                    }
                } else {
                    EmptyView()
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            stageNavigator
        }
        .background(AppColors.appBackground)
        .tint(AppColors.accentPrimary)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Historical journey for \(record.coreSharedMeaning)")
    }

    /// First page begins with the real-world concept and deliberately does not reveal a modern glyph.
    private var originPage: some View {
        journeyPage(allowsVerticalScroll: true) {
            stageHeader(overline: "Origin", title: nil, subtitle: nil)
            ArtifactField {
                if let originAsset = record.history.origin?.asset {
                    HistoricalAssetView(metadata: originAsset)
                } else {
                    HistoricalMissingState(
                        title: "Origin visual not yet included",
                        detail: "This concept visual is not currently available in the approved historical corpus."
                    )
                }
            }
            .frame(height: 304)
            Text(record.history.origin?.concept ?? record.coreSharedMeaning.capitalized)
                .font(AppTypography.exhibitHeading)
                .foregroundStyle(AppColors.textPrimary)
                .padding(.top, AppSpacing.spaceMd)
            // The anchor is the concise learner-facing bridge; the longer asset explanation
            // is provenance/editorial copy and should not interrupt the first visual comparison.
            Text(record.history.originAnchor)
                .font(AppTypography.body)
                .foregroundStyle(AppColors.textPrimary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 320)
        }
    }

    /// One historical page shows only the evidence and explanation attached to that stage.
    private func historicalPage(_ stage: HistoricalStage) -> some View {
        journeyPage(allowsVerticalScroll: true) {
            stageHeader(
                overline: learnerStageLabel(for: stage),
                title: stageDateLabel(for: stage),
                subtitle: nil
            )
            ArtifactField {
                if stage.stage == "regular" {
                    // Regular Script is the approved modern standardized Kai endpoint,
                    // not a copied historical inscription or a prototype SVG fallback.
                    Text(record.coreCharacter)
                        .font(CJKFontRole.museumRegular.font(size: 148))
                        .foregroundStyle(AppColors.artifactInk)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .accessibilityLabel("Regular Script \(record.coreCharacter)")
                } else if stage.availabilityState == .unavailableAsset {
                    HistoricalMissingState()
                } else if let metadata = stage.assetMetadata {
                    HistoricalAssetView(metadata: metadata)
                } else if let assetRef = stage.assetRef {
                    HistoricalAssetView(assetRef: assetRef)
                } else {
                    // Historical visual unavailable is an intentional editorial state, never a modern fallback.
                    HistoricalMissingState()
                }
            }
            .frame(height: 304)
            // Transition notes are destination-stage captions: they explain what visibly changed
            // from the previous available exhibit into this exact form.
            Text(stage.transitionNote ?? stage.changeNoteFromPrevious ?? stage.stageExplanation ?? "Stage-specific explanation is pending editorial review.")
                .font(AppTypography.body)
                .foregroundStyle(AppColors.textPrimary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 320)
            if let sound = stage.historicalSound {
                Text(sound)
                    .font(AppTypography.metadata)
                    .foregroundStyle(AppColors.textSecondary)
            }
        }
    }

    /// Modern is the last museum page; with no target languages it owns the Next Symbol action.
    private var modernPage: some View {
        journeyPage(allowsVerticalScroll: true) {
            ModernFormsComparisonView(record: record, focusSelection: focusSelection)
            if orderedTracks.isEmpty {
                PrimaryActionButton(completionTitle, action: onComplete)
            }
        }
    }

    /// Each selected target language owns a separate Usage page after the Modern bridge.
    private func usagePage(track: FocusTrack, isFinal: Bool) -> some View {
        journeyPage(allowsVerticalScroll: true) {
            UsageExamplesView(record: record, focusSelection: focusSelection, track: track)
            if isFinal {
                PrimaryActionButton(completionTitle, action: onComplete)
            }
        }
    }

    /// Normal exhibits fit the reference frame; overflow is opt-in for future long-form editorial copy.
    @ViewBuilder
    private func journeyPage<Content: View>(allowsVerticalScroll: Bool = false, @ViewBuilder content: () -> Content) -> some View {
        if allowsVerticalScroll {
            ScrollView(.vertical) {
                journeyContent(content: content)
            }
            .scrollIndicators(.hidden)
        } else {
            journeyContent(content: content)
                .frame(maxHeight: .infinity, alignment: .top)
        }
    }

    /// Shared fixed-frame wrapper keeps the artifact, text, and rail in the same vertical composition.
    private func journeyContent<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        VStack(spacing: AppSpacing.spaceMd) {
            content()
        }
        .frame(maxWidth: .infinity, alignment: .top)
        .padding(.horizontal, AppSpacing.spacePage)
        .padding(.top, AppSpacing.spaceSm)
        .padding(.bottom, AppSpacing.spaceMd)
    }

    private func stageHeader(overline: String, title: String?, subtitle: String?) -> some View {
        VStack(spacing: AppSpacing.space2xs) {
            Text(overline)
                .font(AppTypography.conceptLabel)
                .tracking(1.6)
                .foregroundStyle(AppColors.textSecondary)
            if let title {
                Text(title)
                    .font(AppTypography.stageTitle)
                    .foregroundStyle(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
            }
            if let subtitle {
                Text(subtitle)
                    .font(AppTypography.metadata)
                    .foregroundStyle(AppColors.textSecondary)
            }
        }
    }

    /// The rail exposes position and direct access while the exhibit remains horizontally swipeable.
    private var stageNavigator: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppSpacing.spaceXs) {
                    ForEach(Array(navigatorIDs.enumerated()), id: \.element) { index, id in
                        stageMarker(index: index, id: id)

                        if index < navigatorIDs.count - 1 {
                            Rectangle()
                                .fill(index < navigatorIndex ? AppColors.accentPrimary : AppColors.separator)
                                .frame(minWidth: 10, maxWidth: 28, minHeight: 1, maxHeight: 1)
                                .accessibilityHidden(true)
                        }
                    }
                }
                .padding(.vertical, AppSpacing.space2xs)
            }
        }
        .padding(.horizontal, AppSpacing.spacePage)
        .padding(.bottom, AppSpacing.space2xs)
        .padding(.top, AppSpacing.spaceXs)
        .overlay {
            RoundedRectangle(cornerRadius: AppRadius.surface)
                .stroke(AppColors.separator, lineWidth: 1)
        }
        .background(AppColors.journeyRailBackground)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("\(currentLabel), stage \(navigatorIndex + 1) of \(navigatorIDs.count)")
    }

    /// Keeps each stage marker's conditional styling out of the larger navigation builder.
    private func stageMarker(index: Int, id: String) -> some View {
        let isCurrent = index == navigatorIndex
        return Button {
            selectedStageID = destinationID(for: id)
        } label: {
            VStack(spacing: AppSpacing.space2xs) {
                Circle()
                    .fill(index <= navigatorIndex ? AppColors.accentPrimary : AppColors.textTertiary)
                    .frame(width: isCurrent ? 10 : 8, height: isCurrent ? 10 : 8)
                Text(shortLabel(for: id))
                    .font(AppTypography.caption.weight(isCurrent ? .semibold : .regular))
                    .foregroundStyle(isCurrent ? AppColors.textPrimary : AppColors.textSecondary)
                    .lineLimit(1)
            }
            .padding(.horizontal, AppSpacing.spaceXs)
            .padding(.vertical, AppSpacing.space2xs)
            .frame(minWidth: 48)
            .background(isCurrent ? AppColors.journeyRailSelected : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.small))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(label(for: id)), stage \(index + 1) of \(navigatorIDs.count)")
        .accessibilityAddTraits(isCurrent ? .isSelected : [])
    }

    private func destinationID(for navigatorID: String) -> String { navigatorID }

    private func label(for id: String) -> String {
        if id == "origin" { return "Origin" }
        if id == "modern" { return "Modern" }
        if id == "usage" { return "Usage" }
        if id.hasPrefix("usage-"),
           let track = FocusTrack(rawValue: String(id.dropFirst("usage-".count))) {
            return "Usage · \(track.title)"
        }
        return stages.first(where: { $0.stage == id })?.label ?? id
    }

    private func learnerStageLabel(for stage: HistoricalStage) -> String {
        switch stage.stage {
        case "oracleBone": return "Oracle Bone Script"
        case "bronze": return "Bronze Script"
        case "seal": return "Small Seal Script"
        case "clerical": return "Clerical Script"
        case "regular": return "Regular Script"
        default: return stage.label.components(separatedBy: " /").first ?? stage.label
        }
    }

    private func stageDateLabel(for stage: HistoricalStage) -> String? {
        if let period = stage.assetMetadata?.approximatePeriod, !period.isEmpty { return period }
        switch stage.stage {
        case "oracleBone": return "c. 1200–1046 BCE"
        case "bronze": return "c. 1046–256 BCE"
        case "seal": return "c. 221–206 BCE"
        case "clerical": return "c. 206 BCE–220 CE"
        default: return nil
        }
    }

    /// Short rail labels preserve the full stage name in the page header and accessibility label.
    private func shortLabel(for id: String) -> String {
        if id == "origin" { return "Origin" }
        if id == "modern" { return "Modern" }
        if id == "usage" || id.hasPrefix("usage-") { return id == "usage" ? "Usage" : shortTrackLabel(for: id) }
        switch id {
        case "oracleBone": return "Oracle"
        case "bronze": return "Bronze"
        case "seal": return "Seal"
        case "clerical": return "Clerical"
        case "regular": return "Regular"
        default: return label(for: id)
        }
    }

    private func shortTrackLabel(for id: String) -> String {
        guard let track = FocusTrack(rawValue: String(id.dropFirst("usage-".count))) else { return "Usage" }
        switch track {
        case .traditionalChinese: return "Traditional"
        case .simplifiedChinese: return "Simplified"
        case .japanese: return "Japanese"
        case .korean: return "Korean"
        }
    }
}

/// Resolution result for a bundled asset reference.
enum HistoricalAssetResolution: Equatable {
    case bundledImage(URL)
    case bundledSVG(URL)
    case unavailable(String)
}

/// Resolves local raster and SVG assets; remote URLs are never accepted for lesson rendering.
struct BundledHistoricalAssetResolver {
    let bundle: Bundle

    func resolve(_ assetRef: String?) -> HistoricalAssetResolution {
        guard let assetRef, !assetRef.isEmpty else { return .unavailable("No bundled asset reference") }
        let relativePath = assetRef.replacingOccurrences(of: "Assets/", with: "")
        let pathExtension = URL(fileURLWithPath: relativePath).pathExtension.lowercased()
        guard ["png", "jpg", "jpeg", "heic", "svg"].contains(pathExtension) else {
            return .unavailable("Asset requires a compiled iOS image representation")
        }
        let path = relativePath.dropLast(pathExtension.count + 1)
        guard let url = bundle.url(forResource: String(path), withExtension: pathExtension) else {
            return .unavailable("Bundled asset not found")
        }
        if pathExtension == "svg" {
            return .bundledSVG(url)
        }
        return .bundledImage(url)
    }
}

/// Renders a source-backed compiled image or an explicit missing-asset state.
struct HistoricalAssetView: View {
    let resolution: HistoricalAssetResolution
    let accessibilityDescription: String
    /// The compact height is used by lineage previews; the default preserves full exhibit presentation.
    let displayHeight: CGFloat

    init(metadata: HistoricalAssetMetadata, displayHeight: CGFloat = 276) {
        self.resolution = BundledHistoricalAssetResolver(bundle: .main).resolve(metadata.assetRef)
        self.accessibilityDescription = metadata.accessibilityDescription ?? "Historical character artwork"
        self.displayHeight = displayHeight
    }

    init(assetRef: String, displayHeight: CGFloat = 276) {
        self.resolution = BundledHistoricalAssetResolver(bundle: .main).resolve(assetRef)
        self.accessibilityDescription = "Historical character artwork"
        self.displayHeight = displayHeight
    }

    var body: some View {
        switch resolution {
        case .bundledImage(let url):
            if let image = UIImage(contentsOfFile: url.path) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .frame(height: displayHeight)
                    .clipped()
                    .accessibilityLabel(accessibilityDescription)
            } else {
                HistoricalMissingState(title: "Historical visual unavailable")
            }
        case .bundledSVG(let url):
            BundledSVGView(url: url)
                .frame(maxWidth: .infinity)
                .frame(height: displayHeight)
                .clipped()
                .accessibilityLabel(accessibilityDescription)
        case .unavailable:
            HistoricalMissingState(title: "Historical visual unavailable")
        }
    }
}

/// Displays a local SVG without allowing it to become a runtime network dependency.
private struct BundledSVGView: UIViewRepresentable {
    let url: URL

    final class Coordinator {
        var loadedURL: URL?
    }

    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView(frame: .zero)
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.isUserInteractionEnabled = false
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        loadFittedSVG(into: webView)
        context.coordinator.loadedURL = url
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        guard context.coordinator.loadedURL != url else { return }
        loadFittedSVG(into: webView)
        context.coordinator.loadedURL = url
    }

    /// Wraps the local SVG in a fixed viewport so its intrinsic dimensions cannot escape the SwiftUI frame.
    private func loadFittedSVG(into webView: WKWebView) {
        guard let svg = try? String(contentsOf: url, encoding: .utf8) else { return }
        let body = svg.replacingOccurrences(of: #"(?s)<\?xml.*?\?>"#, with: "", options: .regularExpression)
        let html = """
        <!doctype html>
        <html><head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
        <style>
        html, body { margin: 0; padding: 0; width: 100%; height: 100%; overflow: hidden; background: transparent; }
        #canvas { width: 100%; height: 100%; display: flex; align-items: center; justify-content: center; }
        #canvas svg { width: 100% !important; height: 100% !important; max-width: 100%; max-height: 100%; display: block; }
        </style></head><body><div id="canvas">
        \(body)
        </div></body></html>
        """
        webView.loadHTMLString(html, baseURL: url.deletingLastPathComponent())
    }
}
