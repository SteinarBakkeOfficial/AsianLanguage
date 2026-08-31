import SwiftUI
import UIKit
import WebKit

/// Data-driven horizontal Evolution Stage navigation for one Symbol Journey.
struct CharacterEvolutionView: View {
    let record: SharedCharacterRecord
    let focusSelection: FocusTrackSelection
    let onAdvance: () -> Void
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

    private var nextLabel: String? {
        guard currentIndex + 1 < journeyIDs.count else { return nil }
        let nextID = journeyIDs[currentIndex + 1]
        if nextID == "today" { return "Today" }
        return stages.first(where: { $0.stage == nextID })?.label ?? nextID
    }

    var body: some View {
        VStack(spacing: AppSpacing.spaceMd) {
            TabView(selection: $selectedStageID) {
                originPage.tag("origin")
                ForEach(stages, id: \.stage) { stage in
                    historicalPage(stage).tag(stage.stage)
                }
                todayPlaceholder.tag("today")
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(maxHeight: .infinity)

            stageNavigator
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

    /// Today is owned by the same horizontal journey and is rendered by the canonical host.
    private var todayPlaceholder: some View {
        journeyPage {
            stageHeader(overline: "TODAY", title: record.coreCharacter, subtitle: "Modern forms")
            Text("Continue to Today to see how this Shared Character connects across your selected language tracks.")
                .font(AppTypography.body)
                .foregroundStyle(AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 320)
        }
    }

    private func journeyPage<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        ScrollView {
            VStack(spacing: AppSpacing.spaceLg) {
                content()
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, AppSpacing.spacePage)
            .padding(.vertical, AppSpacing.spaceLg)
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

    /// The rail exposes position, direct access, and the next stage without becoming a segmented control.
    private var stageNavigator: some View {
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
                        stageMarker(index: index, id: id)

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

            HStack {
                if let nextLabel {
                    Text("Next: \(nextLabel)")
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColors.textSecondary)
                    Spacer()
                    Button("Next") { onAdvance() }
                        .font(AppTypography.metadata.weight(.semibold))
                        .foregroundStyle(AppColors.accentPrimary)
                        .frame(minWidth: 44, minHeight: 44)
                } else {
                    Text("Journey endpoint")
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColors.textSecondary)
                    Spacer()
                    Button("Continue") { onAdvance() }
                        .font(AppTypography.metadata.weight(.semibold))
                        .foregroundStyle(AppColors.accentPrimary)
                        .frame(minWidth: 44, minHeight: 44)
                }
            }
        }
        .padding(.horizontal, AppSpacing.spacePage)
        .padding(.bottom, AppSpacing.spaceXs)
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
