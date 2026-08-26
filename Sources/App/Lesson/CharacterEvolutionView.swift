import SwiftUI
import UIKit

/// Data-driven horizontal Evolution Stage navigation for one Symbol Journey.
struct CharacterEvolutionView: View {
    let record: SharedCharacterRecord
    let focusSelection: FocusTrackSelection
    @Binding var selectedStageID: String

    private var stages: [HistoricalStage] { record.history.stages }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            TabView(selection: $selectedStageID) {
                originPage.tag("origin")
                ForEach(stages, id: \.stage) { stage in
                    historicalPage(stage).tag(stage.stage)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(minHeight: 360)

            stageNavigator
        }
        .onChange(of: selectedStageID) { _, newValue in
            guard !newValue.isEmpty else { return }
        }
    }

    /// First page for the real-world idea and earliest defensible origin content.
    private var originPage: some View {
        stagePage(title: "Origin", subtitle: record.history.origin?.concept ?? record.coreSharedMeaning.capitalized) {
            if let originAsset = record.history.origin?.asset {
                HistoricalAssetView(metadata: originAsset)
            } else {
                missingAssetView("Origin visual not yet sourced")
            }
            Text(record.history.origin?.explanation ?? record.history.originAnchor)
                .font(.subheadline)
            Text("The origin visual and explanation are draft content until source-backed editorial material is approved.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    /// One historical stage page with only the content attached to that exact stage.
    private func historicalPage(_ stage: HistoricalStage) -> some View {
        stagePage(title: stage.label, subtitle: stage.stage) {
            if let metadata = stage.assetMetadata {
                HistoricalAssetView(metadata: metadata)
            } else if let assetRef = stage.assetRef {
                HistoricalAssetView(assetRef: assetRef)
            } else {
                missingAssetView("Historical visual not yet sourced")
            }
            Text(stage.stageExplanation ?? stage.changeNoteFromPrevious ?? "No stage-specific explanation is available yet.")
                .font(.subheadline)
            Text("Certainty: \(stage.certainty.capitalized)")
                .font(.caption)
                .foregroundStyle(.secondary)
            if let sound = stage.historicalSound {
                Text(sound).font(.caption).foregroundStyle(.secondary)
            }
        }
    }

    private func stagePage<Content: View>(title: String, subtitle: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title).font(.title3.weight(.semibold))
            Text(subtitle).font(.caption).foregroundStyle(.secondary)
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    /// Fixed/floating stage controls; final visual treatment comes from the Fire design.
    private var stageNavigator: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                stageButton(id: "origin", title: "Origin")
                ForEach(stages, id: \.stage) { stage in
                    stageButton(id: stage.stage, title: stage.label)
                }
            }
        }
    }

    private func stageButton(id: String, title: String) -> some View {
        Button(title) { selectedStageID = id }
            .buttonStyle(.bordered)
            .tint(selectedStageID == id ? .accentColor : .secondary)
    }

    private func missingAssetView(_ message: String) -> some View {
        ContentUnavailableView(message, systemImage: "photo")
            .frame(maxWidth: .infinity, minHeight: 150)
    }
}

/// Resolution result for a bundled asset reference.
enum HistoricalAssetResolution: Equatable {
    case bundledImage(URL)
    case unavailable(String)
}

/// Resolves only actually renderable bundled images; source SVGs need compiled display assets.
struct BundledHistoricalAssetResolver {
    let bundle: Bundle

    func resolve(_ assetRef: String?) -> HistoricalAssetResolution {
        guard let assetRef, !assetRef.isEmpty else { return .unavailable("No bundled asset reference") }
        let relativePath = assetRef.replacingOccurrences(of: "Assets/", with: "")
        let pathExtension = URL(fileURLWithPath: relativePath).pathExtension.lowercased()
        guard ["png", "jpg", "jpeg", "heic"].contains(pathExtension) else {
            return .unavailable("Asset requires a compiled iOS image representation")
        }
        let path = relativePath.dropLast(pathExtension.count + 1)
        guard let url = bundle.url(forResource: String(path), withExtension: pathExtension) else {
            return .unavailable("Bundled asset not found")
        }
        return .bundledImage(url)
    }
}

/// Renders a source-backed compiled image or an explicit missing-asset state.
struct HistoricalAssetView: View {
    let resolution: HistoricalAssetResolution

    init(metadata: HistoricalAssetMetadata) {
        self.resolution = BundledHistoricalAssetResolver(bundle: .main).resolve(metadata.assetRef)
    }

    init(assetRef: String) {
        self.resolution = BundledHistoricalAssetResolver(bundle: .main).resolve(assetRef)
    }

    var body: some View {
        switch resolution {
        case .bundledImage(let url):
            if let image = UIImage(contentsOfFile: url.path) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, minHeight: 150)
            } else {
                ContentUnavailableView("Historical visual unavailable", systemImage: "photo.badge.exclamationmark")
                    .frame(maxWidth: .infinity, minHeight: 150)
            }
        case .unavailable(let reason):
            ContentUnavailableView("Historical visual unavailable", systemImage: "photo.badge.exclamationmark", description: Text(reason))
                .frame(maxWidth: .infinity, minHeight: 150)
        }
    }
}
