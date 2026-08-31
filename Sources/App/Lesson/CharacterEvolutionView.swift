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
        if focusSelection.selectedTracks.isEmpty {
            ids.append("today")
        } else {
            ids.append(contentsOf: focusSelection.selectedTracks.map { "today-\($0.rawValue)" })
        }
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
        if selectedStageID.hasPrefix("today-"),
           let track = FocusTrack(rawValue: String(selectedStageID.dropFirst("today-".count))) {
            return "Today · \(track.title)"
        }
        return stages.first(where: { $0.stage == selectedStageID })?.label ?? selectedStageID
    }

    /// The reference shows a quiet next-stage cue at the foot of every exhibit; paging remains gesture-led.
    private var nextStageCue: String? {
        guard currentIndex + 1 < journeyIDs.count else { return nil }
        return "Next: \(label(for: journeyIDs[currentIndex + 1])) →"
    }

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $selectedStageID) {
                originPage
                    .tag("origin")
                ForEach(stages, id: \.stage) { stage in
                    historicalPage(stage)
                        .tag(stage.stage)
                }
                if focusSelection.selectedTracks.isEmpty {
                    todayPage(track: nil, isFinal: true)
                        .tag("today")
                } else {
                    ForEach(Array(focusSelection.selectedTracks.enumerated()), id: \.element) { index, track in
                        todayPage(track: track, isFinal: index == focusSelection.selectedTracks.count - 1)
                            .tag("today-\(track.rawValue)")
                    }
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
            .frame(minHeight: 360)
            Text(record.history.origin?.concept ?? record.coreSharedMeaning.capitalized)
                .font(AppTypography.stageTitle)
                .foregroundStyle(AppColors.textPrimary)
            Text(record.history.origin?.explanation ?? record.history.originAnchor)
                .font(AppTypography.body)
                .foregroundStyle(AppColors.textPrimary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 320)
            if let nextStageCue {
                Text(nextStageCue)
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textPrimary)
            }
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
            .frame(minHeight: 360)
            Text(stage.stageExplanation ?? stage.changeNoteFromPrevious ?? "Stage-specific explanation is pending editorial review.")
                .font(AppTypography.body)
                .foregroundStyle(AppColors.textPrimary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 320)
            if let nextStageCue {
                Text(nextStageCue)
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textPrimary)
            }
            if let sound = stage.historicalSound {
                Text(sound)
                    .font(AppTypography.metadata)
                    .foregroundStyle(AppColors.textSecondary)
            }
        }
    }

    /// Each selected language gets a horizontal Today exhibit page with its own word context.
    private func todayPage(track: FocusTrack?, isFinal: Bool) -> some View {
        journeyPage {
            ModernFormsComparisonView(record: record, focusSelection: focusSelection, track: track)
            UsageExamplesView(record: record, focusSelection: focusSelection, track: track)
            if isFinal {
                PrimaryActionButton(completionTitle, action: onComplete)
            }
        }
    }

    private func journeyPage<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        ScrollView(.vertical) {
            VStack(spacing: AppSpacing.spaceXl) {
                content()
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, AppSpacing.spacePage)
            .padding(.top, AppSpacing.spaceMd)
            .padding(.bottom, AppSpacing.spaceLg)
        }
        .scrollIndicators(.hidden)
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

    /// The rail exposes position and direct access while the exhibit remains horizontally swipeable.
    private var stageNavigator: some View {
        VStack(spacing: AppSpacing.spaceXs) {
            HStack {
                Text("Origin")
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textPrimary)
                Spacer()
                Text("Today")
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textPrimary)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(Array(journeyIDs.enumerated()), id: \.element) { index, id in
                        stageMarker(index: index, id: id)

                        if index < journeyIDs.count - 1 {
                            Rectangle()
                                .fill(index < currentIndex ? AppColors.accentPrimary : AppColors.separator)
                                .frame(minWidth: 16, maxWidth: 52, minHeight: 1, maxHeight: 1)
                                .accessibilityHidden(true)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
            Text(currentLabel)
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.textSecondary)
        }
        .padding(.horizontal, AppSpacing.spacePage)
        .padding(.bottom, AppSpacing.spaceSm)
        .padding(.top, AppSpacing.space2xs)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(AppColors.separator)
                .frame(height: 1)
        }
        .background(AppColors.appBackground)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("\(currentLabel), stage \(currentIndex + 1) of \(journeyIDs.count)")
    }

    /// Keeps each stage marker's conditional styling out of the larger navigation builder.
    private func stageMarker(index: Int, id: String) -> some View {
        let isCurrent = index == currentIndex
        return Button {
            selectedStageID = id
        } label: {
            Circle()
                .fill(index <= currentIndex ? AppColors.accentPrimary : AppColors.separator)
                .frame(width: isCurrent ? 9 : 7, height: isCurrent ? 9 : 7)
                .frame(width: 44, height: 44)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(label(for: id)), stage \(index + 1) of \(journeyIDs.count)")
        .accessibilityAddTraits(isCurrent ? .isSelected : [])
    }

    private func label(for id: String) -> String {
        if id == "origin" { return "Origin" }
        if id == "today" { return "Today" }
        if id.hasPrefix("today-"),
           let track = FocusTrack(rawValue: String(id.dropFirst("today-".count))) {
            return track.title
        }
        return stages.first(where: { $0.stage == id })?.label ?? id
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
                    .frame(maxWidth: .infinity, minHeight: 320)
                    .accessibilityLabel(accessibilityDescription)
            } else {
                HistoricalMissingState(title: "Historical visual unavailable")
            }
        case .bundledSVG(let url):
            BundledSVGView(url: url)
                .frame(maxWidth: .infinity, minHeight: 320)
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
