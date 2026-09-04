import SwiftUI

/// Five-area root shell for the Symbol Journey product model.
struct RootTabView: View {
    let dependencies: AppDependencies
    @ObservedObject private var navigationState: AppNavigationState

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _navigationState = ObservedObject(wrappedValue: dependencies.navigationState)
    }

    var body: some View {
        Group {
            if let corpusLoadError = dependencies.corpusLoadError {
                ContentUnavailableView("Corpus unavailable", systemImage: "exclamationmark.triangle", description: Text(corpusLoadError))
            } else {
                VStack(spacing: 0) {
                    rootContent
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    AppTabBar(selectedTab: $navigationState.selectedTab)
                }
            }
        }
        .background(AppColors.appBackground.ignoresSafeArea())
    }

    @ViewBuilder
    private var rootContent: some View {
        switch navigationState.selectedTab {
        case .home:
            HomeView(dependencies: dependencies)
        case .symbol:
            SymbolRootView(dependencies: dependencies)
        case .history:
            HistoryRootView(dependencies: dependencies)
        case .browse:
            BrowseView(dependencies: dependencies)
        case .more:
            MoreRootView(dependencies: dependencies)
        }
    }
}

/// First-launch introduction: explain the exhibit once, then enter the canonical first-symbol journey.
struct OnboardingView: View {
    let dependencies: AppDependencies
    @ObservedObject private var userStateStore: LocalUserStateStore

    /// The first ranked runtime symbol is the onboarding exhibit and remains data-backed.
    private var firstSymbolRecord: SharedCharacterRecord? {
        guard let firstSymbolID = SeedCorpusManifest.recordIDs.first else { return nil }
        return try? dependencies.corpusRepository.sharedCharacter(id: firstSymbolID)
    }

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _userStateStore = ObservedObject(wrappedValue: dependencies.userStateStore)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: AppSpacing.spaceSm) {
                Text("SCRIPT ROOTS")
                    .font(AppTypography.conceptLabel)
                    .tracking(1.4)
                    .foregroundStyle(AppColors.textSecondary)
                Text("One idea. One symbol. Thousands of years.")
                    .font(AppTypography.exhibitHeading)
                    .foregroundStyle(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                Text("Follow \(firstSymbolRecord?.coreSharedMeaning.capitalized ?? "One") from a recognizable origin through historical writing and into modern languages.")
                    .font(AppTypography.body)
                    .foregroundStyle(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                if let firstSymbolRecord {
                    SymbolOnboardingLineage(record: firstSymbolRecord)
                }
                PrimaryActionButton("Explore \(firstSymbolRecord?.coreSharedMeaning.capitalized ?? "One")") {
                    userStateStore.markFirstSymbolStarted()
                    if let firstSymbolID = SeedCorpusManifest.recordIDs.first {
                        dependencies.navigationState.openSymbol(firstSymbolID, intent: .start)
                    }
                }
            }
            .frame(maxWidth: 390)
            .padding(AppSpacing.spacePage)
            .padding(.bottom, AppSpacing.spaceSection)
        }
        .background(AppColors.appBackground.ignoresSafeArea())
        .tint(AppColors.accentPrimary)
    }

}

/// The first symbol's launch preview is intentionally separate from Home's compact lineage preview.
/// It shows the real concept first, then the available historical forms, without inventing a missing stage.
private struct SymbolOnboardingLineage: View {
    let record: SharedCharacterRecord

    init(record: SharedCharacterRecord) {
        self.record = record
        BundledFontRegistrar.registerMuseumFonts()
    }

    private var availableStages: [HistoricalStage] {
        record.history.stages.filter {
            ["oracleBone", "bronze", "seal"].contains($0.stage) && $0.assetRef != nil
        }
    }

    var body: some View {
        VStack(spacing: AppSpacing.spaceSm) {
            ArtifactField {
                if let origin = record.history.origin?.asset {
                    HistoricalAssetView(metadata: origin, displayHeight: 168)
                } else {
                    HistoricalMissingState(title: "Origin visual unavailable")
                }
            }
            .frame(height: 204)

            HStack(alignment: .top, spacing: AppSpacing.spaceXs) {
                ForEach(availableStages, id: \.stage) { stage in
                    SymbolOnboardingStageTile(
                        title: stage.stage == "oracleBone" ? "Oracle" : stage.stage.capitalized,
                        stage: stage
                    )
                }
                VStack(spacing: AppSpacing.space2xs) {
                    Text("Today")
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColors.textSecondary)
                    Text(record.coreCharacter)
                        .font(CJKFontRole.museumRegular.font(size: 42))
                        .foregroundStyle(AppColors.artifactInk)
                        .frame(height: 54)
                }
                .frame(maxWidth: .infinity)
                .accessibilityLabel("Today \(record.coreCharacter)")
            }
        }
        .frame(maxWidth: 390)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("\(record.coreSharedMeaning.capitalized) from origin through the available historical forms to today")
    }
}

private struct SymbolOnboardingStageTile: View {
    let title: String
    let stage: HistoricalStage

    var body: some View {
        VStack(spacing: AppSpacing.space2xs) {
            Text(title)
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.textSecondary)
                .lineLimit(1)
            HistoricalAssetView(assetRef: stage.assetRef ?? "", displayHeight: 54)
                .frame(height: 54)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppSpacing.space2xs)
        .background(AppColors.artifactField)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.small))
    }
}

/// Canonical owner of the active Shared Character journey.
private struct SymbolRootView: View {
    let dependencies: AppDependencies
    @ObservedObject private var navigationState: AppNavigationState
    @ObservedObject private var userStateStore: LocalUserStateStore

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _navigationState = ObservedObject(wrappedValue: dependencies.navigationState)
        _userStateStore = ObservedObject(wrappedValue: dependencies.userStateStore)
    }

    var body: some View {
        NavigationStack {
            // Rehydrate the canonical Symbol tab from local progress after a cold launch.
            if let route = navigationState.symbolRoute ?? userStateStore.state.resumeLessonRoute {
                LessonView(route: route, dependencies: dependencies)
                    .id(route.id)
            } else {
                ContentUnavailableView("No Symbol Selected", systemImage: "character")
            }
        }
    }
}

/// Retained period-by-period history design for a future deeper History release.
private struct LegacyHistoryRootView: View {
    let dependencies: AppDependencies

    private let periods = [
        HistoryPeriod(id: "oracleBone", displayName: "Oracle Bone Script"),
        HistoryPeriod(id: "bronze", displayName: "Bronze Inscriptions"),
        HistoryPeriod(id: "seal", displayName: "Seal Script"),
        HistoryPeriod(id: "clerical", displayName: "Clerical Script"),
        HistoryPeriod(id: "regular", displayName: "Regular Script")
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.spaceLg) {
                    Text("History")
                        .font(AppTypography.pageTitle)
                        .foregroundStyle(AppColors.textPrimary)
                    Text("How writing changed over thousands of years.")
                        .font(AppTypography.metadata)
                        .foregroundStyle(AppColors.textSecondary)

                    if let fire = dependencies.sharedCharacters.first(where: { $0.id == "fire" }),
                       let oracle = fire.history.stages.first(where: { $0.stage == "oracleBone" }),
                       let metadata = oracle.assetMetadata {
                        ArtifactField {
                            HistoricalAssetView(metadata: metadata)
                        }
                        .frame(height: 250)
                        Text(oracle.label)
                            .font(AppTypography.exhibitHeading)
                            .foregroundStyle(AppColors.textPrimary)
                        Text("A source-backed view into the earliest available Fire form.")
                            .font(AppTypography.body)
                            .foregroundStyle(AppColors.textSecondary)
                    }

                    VStack(alignment: .leading, spacing: AppSpacing.spaceSm) {
                        Text("Historical Stages")
                            .font(AppTypography.stageTitle)
                            .foregroundStyle(AppColors.textPrimary)
                        ForEach(periods) { period in
                            historyRow(period)
                        }
                    }
                }
                .padding(.horizontal, AppSpacing.spacePage)
                .padding(.top, AppSpacing.spaceSm)
                .padding(.bottom, AppSpacing.spaceSection)
            }
            .navigationBarTitleDisplayMode(.inline)
            .tint(AppColors.accentPrimary)
        }
        .background(AppColors.appBackground.ignoresSafeArea())
    }

    /// Period navigation uses the same elevated surface language as the app-shell reference.
    private func historyRow(_ period: HistoryPeriod) -> some View {
        NavigationLink {
            HistoryPeriodView(period: period, dependencies: dependencies)
        } label: {
            HStack(spacing: AppSpacing.spaceSm) {
                if let metadata = fireMetadata(for: period) {
                    HistoricalAssetView(metadata: metadata)
                        .frame(width: 56, height: 48)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: AppRadius.small))
                } else {
                    RoundedRectangle(cornerRadius: AppRadius.small)
                        .fill(AppColors.surfaceSubtle)
                        .frame(width: 56, height: 48)
                        .overlay {
                            Image(systemName: "character")
                                .foregroundStyle(AppColors.textSecondary)
                        }
                }
                Text(period.displayName)
                    .font(AppTypography.body.weight(.semibold))
                    .foregroundStyle(AppColors.textPrimary)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(AppColors.textTertiary)
            }
            .padding(AppSpacing.spaceMd)
            .background(AppColors.surfaceElevated)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.card))
            .overlay {
                RoundedRectangle(cornerRadius: AppRadius.card)
                    .stroke(AppColors.separator, lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
    }

    /// Reuses only bundled stage metadata for the overview thumbnails; no new historical claims are created here.
    private func fireMetadata(for period: HistoryPeriod) -> HistoricalAssetMetadata? {
        guard let fire = dependencies.sharedCharacters.first(where: { $0.id == "fire" }) else { return nil }
        return fire.history.stages.first(where: { $0.stage == period.id })?.assetMetadata
    }
}

/// Native V1 History overview based on the approved reference artwork; deeper destinations are intentionally unfinished.
private struct HistoryRootView: View {
    let dependencies: AppDependencies

    private let stages: [HistoryOverviewStage] = [
        HistoryOverviewStage(
            id: "oracleBone",
            title: "Oracle Bone",
            date: "c. 1200–1046 BCE",
            dynasty: "Shang Dynasty",
            material: "Carved on animal bones and turtle shells",
            explanation: "People used divination to ask about important matters. They carved questions on bone or shell, then heated them until cracks appeared. These early drawings were simple and symbolic.",
            artworkRect: CGRect(x: 0.287, y: 0.160, width: 0.318, height: 0.150),
            color: AppColors.accentPrimary
        ),
        HistoryOverviewStage(
            id: "bronze",
            title: "Bronze",
            date: "c. 1046–256 BCE",
            dynasty: "Zhou Dynasty",
            material: "Cast or engraved on bronze vessels",
            explanation: "With the rise of ritual and record-keeping, inscriptions moved to bronze vessels. Tools improved, strokes became more fluid and ornamental, and characters gained structure and balance.",
            artworkRect: CGRect(x: 0.287, y: 0.323, width: 0.318, height: 0.150),
            color: Color(red: 0.63, green: 0.43, blue: 0.25)
        ),
        HistoryOverviewStage(
            id: "seal",
            title: "Small Seal",
            date: "c. 221–206 BCE",
            dynasty: "Qin Dynasty",
            material: "Written with brush on bamboo slips and silk",
            explanation: "Qin unified China and standardized writing. Small Seal script was created for official use—characters became more uniform, symmetrical, and elegant.",
            artworkRect: CGRect(x: 0.287, y: 0.486, width: 0.318, height: 0.145),
            color: Color(red: 0.76, green: 0.56, blue: 0.28)
        ),
        HistoryOverviewStage(
            id: "clerical",
            title: "Clerical",
            date: "c. 206 BCE–220 CE",
            dynasty: "Han Dynasty",
            material: "Written with brush on paper",
            explanation: "Writing on paper and with brush encouraged faster strokes. Characters became flatter and wider, with distinct horizontal lines and turning strokes—the basis of many modern shapes.",
            artworkRect: CGRect(x: 0.287, y: 0.646, width: 0.318, height: 0.130),
            color: AppColors.learned
        ),
        HistoryOverviewStage(
            id: "regular",
            title: "Regular",
            date: "c. 220 CE–present",
            dynasty: "All Dynasties",
            material: "Written with brush on paper",
            explanation: "Over time, Clerical script evolved into Regular script. Strokes became more balanced and refined—the foundation of the characters we use today.",
            artworkRect: CGRect(x: 0.287, y: 0.784, width: 0.318, height: 0.105),
            color: AppColors.accentPrimary
        )
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.spaceLg) {
                    HistoryOverviewHeader()
                    HistoryTimelineCard(stages: stages)
                    HistoryLivingTraditionCard()
                }
                .padding(.horizontal, AppSpacing.spacePage)
                .padding(.top, AppSpacing.spaceSm)
                .padding(.bottom, AppSpacing.spaceSection)
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
        .background(AppColors.appBackground.ignoresSafeArea())
        .tint(AppColors.accentPrimary)
    }
}

private struct HistoryOverviewStage: Identifiable {
    let id: String
    let title: String
    let date: String
    let dynasty: String
    let material: String
    let explanation: String
    let artworkRect: CGRect
    let color: Color
}

private struct HistoryOverviewHeader: View {
    var body: some View {
        HStack(alignment: .top, spacing: AppSpacing.spaceSm) {
            VStack(alignment: .leading, spacing: AppSpacing.spaceSm) {
                Text("The History of Chinese Characters")
                    .font(AppTypography.exhibitHeading)
                    .foregroundStyle(AppColors.textPrimary)
                Text("Chinese characters have evolved over thousands of years. Each change reflects new materials, tools, and the needs of society.")
                    .font(AppTypography.body)
                    .foregroundStyle(AppColors.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // Keep the supplied landscape in its intended bounded frame so it cannot stretch under the copy.
            HistoryReferenceCropView(
                // The supplied reference is portrait; stop above the timeline card so the header never
                // picks up source copy or the first row's explanation panel.
                normalizedRect: CGRect(x: 0.60, y: 0.0, width: 0.40, height: 0.145),
                accessibilityLabel: "Ink-wash landscape with mountains and a pavilion"
            )
            .frame(width: 112, height: 96)
            .opacity(0.82)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, AppSpacing.spaceXs)
    }
}

private struct HistoryTimelineCard: View {
    let stages: [HistoryOverviewStage]

    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(AppColors.separator)
                .frame(width: 2)
                .padding(.leading, 16)
                .padding(.vertical, 34)
                .allowsHitTesting(false)

            VStack(spacing: 0) {
                ForEach(Array(stages.enumerated()), id: \.element.id) { index, stage in
                    NavigationLink {
                        HistoryScriptDetailView(stage: stage)
                    } label: {
                        HistoryOverviewRow(stage: stage)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    if index < stages.count - 1 {
                        Divider()
                            .padding(.leading, 48)
                    }
                }
            }
        }
        .background(AppColors.surfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.card))
        .overlay {
            RoundedRectangle(cornerRadius: AppRadius.card)
                .stroke(AppColors.separator, lineWidth: 1)
        }
    }
}

private struct HistoryOverviewRow: View {
    let stage: HistoryOverviewStage

    var body: some View {
        HStack(alignment: .top, spacing: AppSpacing.spaceSm) {
            Circle()
                .fill(stage.color)
                .frame(width: 22, height: 22)
                .overlay {
                    Circle()
                        .stroke(AppColors.surfaceElevated, lineWidth: 4)
                }
                .padding(.top, AppSpacing.spaceSm)

            VStack(alignment: .leading, spacing: AppSpacing.spaceXs) {
                HStack(alignment: .firstTextBaseline, spacing: AppSpacing.spaceXs) {
                    Text(stage.title)
                        .font(AppTypography.stageTitle)
                        .foregroundStyle(stage.color)
                    Spacer(minLength: AppSpacing.spaceXs)
                    Text(stage.date)
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColors.textSecondary)
                        .multilineTextAlignment(.trailing)
                }
                Text(stage.dynasty)
                    .font(AppTypography.metadata.weight(.semibold))
                    .foregroundStyle(AppColors.textPrimary)
                Text(stage.material)
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textSecondary)

                HStack(alignment: .top, spacing: AppSpacing.spaceSm) {
                    HistoryStageArtwork(stage: stage)
            .frame(width: 144, height: 112)
                    VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
                        Text("Why it changed")
                            .font(AppTypography.caption.weight(.semibold))
                            .foregroundStyle(stage.color)
                        Text(stage.explanation)
                            .font(AppTypography.metadata)
                            .foregroundStyle(AppColors.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .padding(.vertical, AppSpacing.spaceMd)
        }
        .padding(.horizontal, AppSpacing.spaceSm)
    }
}

private struct HistoryStageArtwork: View {
    let stage: HistoryOverviewStage

    var body: some View {
        HistoryReferenceCropView(
            normalizedRect: stage.artworkRect,
            accessibilityLabel: "\(stage.title) material and representative character artwork"
        )
        .background(AppColors.artifactField)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.small))
    }
}

private struct HistoryLivingTraditionCard: View {
    private let branches: [HistoryModernBranch] = [
        HistoryModernBranch(
            id: "traditionalChinese",
            title: "Traditional Chinese",
            scriptLabel: "繁體中文",
            explanation: "Traditional Chinese continues the shared character tradition in a modern Chinese writing environment."
        ),
        HistoryModernBranch(
            id: "simplifiedChinese",
            title: "Simplified Chinese",
            scriptLabel: "简体中文",
            explanation: "Simplified Chinese continues the character tradition with later standardized simplified forms for many characters."
        ),
        HistoryModernBranch(
            id: "japanese",
            title: "Japanese",
            scriptLabel: "漢字 + かな",
            explanation: "Japanese uses Kanji alongside kana, developing a modern writing environment with both systems."
        ),
        HistoryModernBranch(
            id: "korean",
            title: "Korean",
            scriptLabel: "한글 + 한자",
            explanation: "Korean historically used Hanja; Hangul is primary in modern Korean and Hanja has a more limited role."
        )
    ]

    var body: some View {
        GroupedSurface {
            HStack(alignment: .top, spacing: AppSpacing.spaceSm) {
                HistoryReferenceCropView(
                    normalizedRect: CGRect(x: 0.07, y: 0.909, width: 0.08, height: 0.065),
                    accessibilityLabel: "Traditional pavilion illustration"
                )
                .frame(width: 54, height: 64)

                VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
                    Text("A living tradition")
                        .font(AppTypography.stageTitle)
                        .foregroundStyle(AppColors.textPrimary)
                    Text("Chinese characters continue to evolve in calligraphy styles and modern life, connecting the past with the present.")
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColors.textSecondary)
                }
            }

            VStack(alignment: .leading, spacing: AppSpacing.spaceXs) {
                Text("Modern writing traditions")
                    .font(AppTypography.sectionHeading)
                    .foregroundStyle(AppColors.textPrimary)
                Text("The shared historical tradition continues differently in each language environment.")
                    .font(AppTypography.metadata)
                    .foregroundStyle(AppColors.textSecondary)

                ForEach(branches) { branch in
                    NavigationLink {
                        HistoryModernLanguageDetailView(branch: branch)
                    } label: {
                        HStack(alignment: .firstTextBaseline, spacing: AppSpacing.spaceSm) {
                            VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
                                Text(branch.title)
                                    .font(AppTypography.stageTitle)
                                    .foregroundStyle(AppColors.textPrimary)
                                Text(branch.scriptLabel)
                                    .font(AppTypography.metadata)
                                    .foregroundStyle(AppColors.textSecondary)
                            }
                            Spacer(minLength: 0)
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(AppColors.textTertiary)
                        }
                        .padding(.vertical, AppSpacing.spaceXs)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }

            HistoryReferenceCropView(
                // Crop the comparison glyphs, not the labels and card text beneath them.
                normalizedRect: CGRect(x: 0.45, y: 0.895, width: 0.50, height: 0.065),
                accessibilityLabel: "Oracle Bone, Bronze, Small Seal, Clerical, and Regular Script comparison"
            )
            .frame(maxWidth: .infinity, minHeight: 58, maxHeight: 70)
        }
    }
}

private struct HistoryModernBranch: Identifiable, Hashable {
    let id: String
    let title: String
    let scriptLabel: String
    let explanation: String
}

private struct HistoryScriptDetailView: View {
    let stage: HistoryOverviewStage

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.spaceLg) {
                Text(stage.title.uppercased())
                    .font(AppTypography.conceptLabel)
                    .tracking(1.4)
                    .foregroundStyle(AppColors.textSecondary)
                Text(stage.dynasty)
                    .font(AppTypography.exhibitHeading)
                    .foregroundStyle(AppColors.textPrimary)
                Text(stage.date)
                    .font(AppTypography.metadata)
                    .foregroundStyle(AppColors.textSecondary)

                HistoryReferenceCropView(
                    normalizedRect: stage.artworkRect,
                    accessibilityLabel: "Representative \(stage.title) material and character artwork"
                )
                .frame(maxWidth: .infinity, minHeight: 112, maxHeight: 160)
                .background(AppColors.artifactField)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.card))

                GroupedSurface {
                    VStack(alignment: .leading, spacing: AppSpacing.spaceSm) {
                        Text(stage.material)
                            .font(AppTypography.sectionHeading)
                            .foregroundStyle(AppColors.textPrimary)
                        Text(stage.explanation)
                            .font(AppTypography.body)
                            .foregroundStyle(AppColors.textSecondary)
                    }
                }

                Text("Historical forms shown here are representative examples. Actual forms varied across periods, regions, objects, and individual writers.")
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }
            .padding(AppSpacing.spacePage)
            .padding(.bottom, AppSpacing.spaceSection)
        }
        .navigationTitle(stage.title)
        .navigationBarTitleDisplayMode(.inline)
        .background(AppColors.appBackground.ignoresSafeArea())
    }
}

private struct HistoryModernLanguageDetailView: View {
    let branch: HistoryModernBranch

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.spaceLg) {
                Text("MODERN LANGUAGE")
                    .font(AppTypography.conceptLabel)
                    .tracking(1.4)
                    .foregroundStyle(AppColors.textSecondary)
                Text(branch.title)
                    .font(AppTypography.exhibitHeading)
                    .foregroundStyle(AppColors.textPrimary)
                Text(branch.scriptLabel)
                    .font(CJKFontRole.museumRegular.font(size: 42))
                    .foregroundStyle(AppColors.artifactInk)
                    .frame(maxWidth: .infinity, alignment: .leading)

                GroupedSurface {
                    VStack(alignment: .leading, spacing: AppSpacing.spaceSm) {
                        Text("The modern continuation")
                            .font(AppTypography.sectionHeading)
                            .foregroundStyle(AppColors.textPrimary)
                        Text(branch.explanation)
                            .font(AppTypography.body)
                            .foregroundStyle(AppColors.textSecondary)
                    }
                }

                HistoricalMissingState(
                    title: "Detailed language page in progress",
                    detail: "Further source-backed chronology, writing context, and examples will be added here."
                )
            }
            .padding(AppSpacing.spacePage)
            .padding(.bottom, AppSpacing.spaceSection)
        }
        .navigationTitle(branch.title)
        .navigationBarTitleDisplayMode(.inline)
        .background(AppColors.appBackground.ignoresSafeArea())
    }
}

/// Shows an exact crop of the supplied reference artwork without using the full infographic as the page.
private struct HistoryReferenceCropView: View {
    let normalizedRect: CGRect
    let accessibilityLabel: String

    var body: some View {
        GeometryReader { proxy in
            if let image = referenceImage {
                // Fit the complete reference crop so the material scene is never trimmed at the edges.
                let scale = min(
                    proxy.size.width / (image.size.width * normalizedRect.width),
                    proxy.size.height / (image.size.height * normalizedRect.height)
                )
                let cropWidth = image.size.width * normalizedRect.width * scale
                let cropHeight = image.size.height * normalizedRect.height * scale

                ZStack(alignment: .topLeading) {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: image.size.width * scale, height: image.size.height * scale)
                        .offset(
                            x: (proxy.size.width - cropWidth) / 2
                                - normalizedRect.minX * image.size.width * scale,
                            y: (proxy.size.height - cropHeight) / 2
                                - normalizedRect.minY * image.size.height * scale
                        )
                }
                .frame(width: proxy.size.width, height: proxy.size.height, alignment: .topLeading)
                .accessibilityLabel(accessibilityLabel)
            } else {
                AppColors.artifactField
                    .accessibilityLabel("Reference artwork unavailable")
            }
        }
        .clipped()
    }

    private var referenceImage: UIImage? {
        guard let url = Bundle.main.url(forResource: "History/History_V1", withExtension: "png")
            ?? Bundle.main.url(forResource: "History_V1", withExtension: "png") else {
            return nil
        }
        return UIImage(contentsOfFile: url.path)
    }
}

/// Stable structural model for generic history, intentionally without unsourced claims.
private struct HistoryPeriod: Identifiable, Hashable {
    let id: String
    let displayName: String
    let approximateDateLabel: String? = nil
    let shortDescription: String? = nil
    let materialContext: String? = nil
    let representativeCharacterIDs: [String] = []
    let sourceIDs: [String] = []
}

private struct HistoryPeriodView: View {
    let period: HistoryPeriod
    let dependencies: AppDependencies

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.spaceLg) {
                Text(period.displayName.uppercased())
                    .font(AppTypography.conceptLabel)
                    .tracking(1.4)
                    .foregroundStyle(AppColors.textSecondary)

                Text(period.shortDescription ?? "Historical editorial content is pending research.")
                    .font(AppTypography.exhibitHeading)
                    .foregroundStyle(AppColors.textPrimary)

                if let date = period.approximateDateLabel {
                    Text(date)
                        .font(AppTypography.metadata)
                        .foregroundStyle(AppColors.textSecondary)
                }

                GroupedSurface {
                    VStack(alignment: .leading, spacing: AppSpacing.spaceSm) {
                        Text("Historical context")
                            .font(AppTypography.sectionHeading)
                            .foregroundStyle(AppColors.textPrimary)
                        Text(period.materialContext ?? "Approved context and representative material are pending editorial review.")
                            .font(AppTypography.body)
                            .foregroundStyle(AppColors.textSecondary)
                    }
                }

                if period.representativeCharacterIDs.isEmpty {
                    HistoricalMissingState(
                        title: "Representative characters not yet assigned",
                        detail: "This period will link to approved Shared Character context when the corpus is ready."
                    )
                } else {
                    VStack(alignment: .leading, spacing: AppSpacing.spaceSm) {
                        Text("Explore characters")
                            .font(AppTypography.sectionHeading)
                            .foregroundStyle(AppColors.textPrimary)
                        ForEach(dependencies.sharedCharacters.filter { period.representativeCharacterIDs.contains($0.id) }) { record in
                            CharacterTile(record: record, userState: dependencies.userStateStore.state.lessonStates[record.id]) {
                                dependencies.navigationState.openSymbol(LessonRoute(sharedCharacterID: record.id, startingPosition: nil))
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, AppSpacing.spacePage)
            .padding(.vertical, AppSpacing.spaceLg)
        }
        .navigationTitle(period.displayName)
        .background(AppColors.appBackground.ignoresSafeArea())
        .tint(AppColors.accentPrimary)
    }
}

/// Utility area for focus tracks, settings, account, and method information.
private struct MoreRootView: View {
    let dependencies: AppDependencies

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.spaceLg) {
                    Text("More")
                        .font(AppTypography.pageTitle)
                        .foregroundStyle(AppColors.textPrimary)

                    utilitySection("Learning") {
                        utilityLink("Languages", detail: "Choose which modern tracks appear in Today", systemImage: "character.book.closed") {
                            LanguagesView(dependencies: dependencies)
                        }
                        utilityLink("Settings", detail: "Appearance and local app controls", systemImage: "gearshape") {
                            SettingsView(dependencies: dependencies)
                        }
                    }

                    utilitySection("About") {
                        utilityLink("Account", detail: "Local-only learner profile", systemImage: "person") {
                            AccountView(dependencies: dependencies)
                        }
                        utilityLink("About / Method", detail: "How Script Roots teaches characters", systemImage: "info.circle") {
                            AboutMethodView(corpusCount: dependencies.installedSharedCharacterCount)
                        }
                        utilityLink("Sources / Licenses", detail: "Evidence and attribution", systemImage: "doc.text.magnifyingglass") {
                            SourcesLicensesView(dependencies: dependencies)
                        }
                    }
                }
                .padding(.horizontal, AppSpacing.spacePage)
                .padding(.top, AppSpacing.spaceSm)
                .padding(.bottom, AppSpacing.spaceSection)
            }
            .navigationBarTitleDisplayMode(.inline)
            .tint(AppColors.accentPrimary)
        }
        .background(AppColors.appBackground.ignoresSafeArea())
    }

    /// Groups utility destinations into the same quiet editorial sections as the reference shell.
    @ViewBuilder
    private func utilitySection<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.spaceSm) {
            Text(title)
                .font(AppTypography.conceptLabel)
                .tracking(0.2)
                .foregroundStyle(AppColors.textSecondary)
            content()
        }
    }

    /// Utility rows expose their purpose in secondary copy without adding another navigation layer.
    private func utilityLink<Destination: View>(
        _ title: String,
        detail: String,
        systemImage: String,
        @ViewBuilder destination: () -> Destination
    ) -> some View {
        NavigationLink {
            destination()
        } label: {
            HStack(spacing: AppSpacing.spaceSm) {
                Image(systemName: systemImage)
                    .foregroundStyle(AppColors.accentPrimary)
                    .frame(width: 24)
                VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
                    Text(title)
                        .font(AppTypography.body.weight(.semibold))
                        .foregroundStyle(AppColors.textPrimary)
                    Text(detail)
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColors.textSecondary)
                }
                Spacer(minLength: 0)
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(AppColors.textTertiary)
            }
            .padding(.horizontal, AppSpacing.spaceSm)
            .frame(minHeight: 56)
            .background(AppColors.surfaceElevated)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.surface))
            .overlay {
                RoundedRectangle(cornerRadius: AppRadius.surface)
                    .stroke(AppColors.separator, lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
    }
}

/// Global attribution surface; record-level claims remain available from Symbol sources.
struct SourcesLicensesView: View {
    let dependencies: AppDependencies

    var body: some View {
        List {
            Section("Technical attribution") {
                VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
                    Text("Apple Speech Synthesis")
                        .font(AppTypography.body.weight(.semibold))
                        .foregroundStyle(AppColors.textPrimary)
                    Text("Pronunciation playback uses Apple's system speech-synthesis technology through AVSpeechSynthesizer. This describes how audio is produced; linguistic sources remain credited separately.")
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColors.textSecondary)
                }
                .padding(.vertical, AppSpacing.spaceXs)
                .listRowBackground(Color.clear)
            }
            if dependencies.sharedCharacters.flatMap(\.sources).isEmpty {
                Text("Source and license metadata is pending for the current draft corpus.")
                    .font(AppTypography.body)
                    .foregroundStyle(AppColors.textSecondary)
            } else {
                ForEach(dependencies.sharedCharacters.flatMap(\.sources), id: \.id) { source in
                    VStack(alignment: .leading) {
                        Text(source.label)
                            .font(AppTypography.body.weight(.semibold))
                            .foregroundStyle(AppColors.textPrimary)
                        Text(source.citation)
                            .font(AppTypography.caption)
                            .foregroundStyle(AppColors.textSecondary)
                    }
                    .padding(.vertical, AppSpacing.spaceXs)
                    .listRowBackground(Color.clear)
                }
            }
        }
        .navigationTitle("Sources / Licenses")
        .scrollContentBackground(.hidden)
        .background(AppColors.appBackground.ignoresSafeArea())
        .tint(AppColors.accentPrimary)
    }
}
