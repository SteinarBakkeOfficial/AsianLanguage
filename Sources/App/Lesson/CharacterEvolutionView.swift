import SwiftUI
import UIKit
import WebKit

/// One continuous, scrollable Symbol Journey from origin through history into Today.
struct CharacterEvolutionView: View {
    let record: SharedCharacterRecord
    let focusSelection: FocusTrackSelection
    @Binding var selectedStageID: String
    @State private var hasRestoredInitialPosition = false

    /// Keeps explicit editorial omissions out of the primary journey while preserving asset gaps as visible states.
    private var stages: [HistoricalStage] {
        record.history.stages.filter {
            $0.availabilityState != .unsupportedStage && $0.availabilityState != .intentionallyOmitted
        }
    }

    /// Origin plus only the stages supplied by the record; no stage slots are invented here.
    private var journeyIDs: [String] {
        var ids = ["origin"]
        ids.append(contentsOf: stages.map(\.stage).filter { $0 != "origin" && $0 != "modernForms" && $0 != "today" })
        ids.append("today")
        return ids.enumerated().reduce(into: [String]()) { result, item in
            if !result.contains(item.element) { result.append(item.element) }
        }
    }

    private var currentIndex: Int {
        journeyIDs.firstIndex(of: selectedStageID) ?? 0
    }

    private var currentLabel: String {
        if selectedStageID == "origin" { return "Origin" }
        if selectedStageID == "today" { return "Today" }
        return stages.first(where: { $0.stage == selectedStageID })?.label ?? selectedStageID
    }

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: AppSpacing.spaceXl) {
                    originPage
                        .id("origin")
                        .background(stageAnchor("origin"))
                    ForEach(stages, id: \.stage) { stage in
                        historicalPage(stage)
                            .id(stage.stage)
                            .background(stageAnchor(stage.stage))
                    }
                    todayPage
                        .id("today")
                        .background(stageAnchor("today"))
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, AppSpacing.spacePage)
                .padding(.vertical, AppSpacing.spaceLg)
            }
            .scrollIndicators(.hidden)
            .coordinateSpace(name: "journeyScroll")
            .safeAreaInset(edge: .bottom, spacing: 0) {
                stageNavigator(proxy: proxy)
            }
            .onAppear {
                let initialStageID = selectedStageID
                DispatchQueue.main.async {
                    proxy.scrollTo(initialStageID, anchor: .top)
                    hasRestoredInitialPosition = true
                }
            }
            .onPreferenceChange(StageOffsetPreferenceKey.self) { offsets in
                updateSelectedStage(from: offsets)
            }
        }
        .tint(AppColors.accentPrimary)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Historical journey for \(record.coreSharedMeaning)")
    }

    /// First page begins with the real-world concept and deliberately does not reveal a modern glyph.
    private var originPage: some View {
        journeyPage {
            stageHeader(overline: "ORIGIN", title: record.history.origin?.concept ?? record.coreSharedMeaning.capitalized, subtitle: nil)
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
            Text(record.history.origin?.explanation ?? record.history.originAnchor)
                .font(AppTypography.body)
                .foregroundStyle(AppColors.textPrimary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 320)
        }
    }

    /// One historical page shows only the evidence and explanation attached to that stage.
    private func historicalPage(_ stage: HistoricalStage) -> some View {
        journeyPage {
            stageHeader(
                overline: stage.label.uppercased(),
                title: stage.label,
                subtitle: stage.editorialConfidence.displayName
            )
            ArtifactField {
                if stage.availabilityState == .unavailableAsset {
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
            Text(stage.stageExplanation ?? stage.changeNoteFromPrevious ?? "Stage-specific explanation is pending editorial review.")
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

    /// Today is the final exhibit room in the same continuous journey, not a separate lesson concept.
    private var todayPage: some View {
        journeyPage {
            ModernFormsComparisonView(record: record, focusSelection: focusSelection)
            UsageExamplesView(record: record, focusSelection: focusSelection)
        }
    }

    private func journeyPage<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        VStack(spacing: AppSpacing.spaceLg) {
            content()
        }
        .frame(maxWidth: .infinity)
    }

    private func stageHeader(overline: String, title: String, subtitle: String?) -> some View {
        VStack(spacing: AppSpacing.spaceXs) {
            Text(overline)
                .font(AppTypography.conceptLabel)
                .tracking(1.4)
                .foregroundStyle(AppColors.textSecondary)
            Text(title)
                .font(AppTypography.exhibitHeading)
                .foregroundStyle(AppColors.textPrimary)
                .multilineTextAlignment(.center)
            if let subtitle {
                Text(subtitle)
                    .font(AppTypography.metadata)
                    .foregroundStyle(AppColors.textSecondary)
            }
        }
    }

    /// The rail exposes position and direct access while leaving the exhibit itself scrollable.
    private func stageNavigator(proxy: ScrollViewProxy) -> some View {
        VStack(spacing: AppSpacing.spaceXs) {
            HStack {
                Text(currentLabel)
                    .font(AppTypography.metadata)
                    .foregroundStyle(AppColors.textPrimary)
                Spacer()
                Text("\(currentIndex + 1) of \(journeyIDs.count)")
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(Array(journeyIDs.enumerated()), id: \.element) { index, id in
                        stageMarker(index: index, id: id, proxy: proxy)

                        if index < journeyIDs.count - 1 {
                            Rectangle()
                                .fill(AppColors.separator)
                                .frame(minWidth: 20, maxWidth: 52, minHeight: 1, maxHeight: 1)
                                .accessibilityHidden(true)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
            Text("Scroll through the exhibit")
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.textSecondary)
        }
        .padding(.horizontal, AppSpacing.spacePage)
        .padding(.bottom, AppSpacing.spaceXs)
        .background(AppColors.appBackground)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("\(currentLabel), stage \(currentIndex + 1) of \(journeyIDs.count)")
    }

    /// Tracks the exhibit room nearest the top edge so scrolling also updates exact resume state.
    private func updateSelectedStage(from offsets: [String: CGFloat]) {
        guard hasRestoredInitialPosition else { return }
        let visibleStages = offsets.filter { $0.value <= 120 }
        let currentID = visibleStages.max(by: { $0.value < $1.value })?.key
            ?? offsets.min(by: { $0.value < $1.value })?.key
        guard let currentID, currentID != selectedStageID else { return }
        selectedStageID = currentID
    }

    /// Zero-size geometry anchor used to identify the room currently being viewed.
    private func stageAnchor(_ id: String) -> some View {
        GeometryReader { geometry in
            Color.clear.preference(
                key: StageOffsetPreferenceKey.self,
                value: [id: geometry.frame(in: .named("journeyScroll")).minY]
            )
        }
    }

    /// Keeps each stage marker's conditional styling out of the larger navigation builder.
    private func stageMarker(index: Int, id: String, proxy: ScrollViewProxy) -> some View {
        let isCurrent = index == currentIndex
        return Button {
            selectedStageID = id
            withAnimation(.easeInOut(duration: AppMotion.standard)) {
                proxy.scrollTo(id, anchor: .top)
            }
        } label: {
            Circle()
                .fill(isCurrent ? AppColors.accentPrimary : AppColors.separator)
                .frame(width: isCurrent ? 10 : 8, height: isCurrent ? 10 : 8)
                .frame(width: 44, height: 44)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(label(for: id)), stage \(index + 1) of \(journeyIDs.count)")
        .accessibilityAddTraits(isCurrent ? .isSelected : [])
    }

    private func label(for id: String) -> String {
        if id == "origin" { return "Origin" }
        if id == "today" { return "Today" }
        return stages.first(where: { $0.stage == id })?.label ?? id
    }
}

private struct StageOffsetPreferenceKey: PreferenceKey {
    static let defaultValue: [String: CGFloat] = [:]

    static func reduce(value: inout [String: CGFloat], nextValue: () -> [String: CGFloat]) {
        value.merge(nextValue(), uniquingKeysWith: { _, new in new })
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

    init(metadata: HistoricalAssetMetadata) {
        self.resolution = BundledHistoricalAssetResolver(bundle: .main).resolve(metadata.assetRef)
        self.accessibilityDescription = metadata.accessibilityDescription ?? "Historical character artwork"
    }

    init(assetRef: String) {
        self.resolution = BundledHistoricalAssetResolver(bundle: .main).resolve(assetRef)
        self.accessibilityDescription = "Historical character artwork"
    }

    var body: some View {
        switch resolution {
        case .bundledImage(let url):
            if let image = UIImage(contentsOfFile: url.path) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, minHeight: 220)
                    .accessibilityLabel(accessibilityDescription)
            } else {
                HistoricalMissingState(title: "Historical visual unavailable")
            }
        case .bundledSVG(let url):
            BundledSVGView(url: url)
                .frame(maxWidth: .infinity, minHeight: 220)
                .accessibilityLabel(accessibilityDescription)
        case .unavailable:
            HistoricalMissingState(title: "Historical visual unavailable")
        }
    }
}

/// Displays a local SVG without allowing it to become a runtime network dependency.
private struct BundledSVGView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView(frame: .zero)
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = false
        webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        guard webView.url != url else { return }
        webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
    }
}
