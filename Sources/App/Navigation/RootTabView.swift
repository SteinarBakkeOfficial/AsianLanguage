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

/// History overview and article entry points. The existing reference artwork remains the bounded visual source.
private struct HistoryRootView: View {
    let dependencies: AppDependencies

    private let stages: [HistoryOverviewStage] = [
        HistoryOverviewStage(
            id: "oracleBone",
            title: "Oracle Bone",
            date: "c. 1200–1046 BCE",
            dynasty: "Shang Dynasty",
            material: "Carved on animal bones and turtle shells",
            explanation: "At the Shang court, writing recorded divination, names, dates, offerings, and events. Compact marks had to remain legible on hard surfaces, yet the system was already capable of expressing language through sound and compound principles.",
            artworkRect: CGRect(x: 0.282, y: 0.165, width: 0.323, height: 0.150),
            color: AppColors.accentPrimary
        ),
        HistoryOverviewStage(
            id: "bronze",
            title: "Bronze",
            date: "c. 1046–256 BCE",
            dynasty: "Zhou Dynasty",
            material: "Cast or engraved on bronze vessels",
            explanation: "Bronze inscriptions recorded ancestors, gifts, appointments, victories, and ritual events. Longer texts and ceremonial display encouraged broad, balanced forms, while regional variants continued alongside one another.",
            artworkRect: CGRect(x: 0.282, y: 0.331, width: 0.323, height: 0.135),
            color: Color(red: 0.63, green: 0.43, blue: 0.25)
        ),
        HistoryOverviewStage(
            id: "seal",
            title: "Small Seal",
            date: "c. 221–206 BCE",
            dynasty: "Qin Dynasty",
            material: "Written with brush on bamboo slips and silk",
            explanation: "The Qin state standardized inherited writing across a newly unified empire. Small Seal forms became taller, more balanced, and more consistent without replacing an undeveloped system with a new invention.",
            artworkRect: CGRect(x: 0.282, y: 0.492, width: 0.323, height: 0.136),
            color: Color(red: 0.76, green: 0.56, blue: 0.28)
        ),
        HistoryOverviewStage(
            id: "clerical",
            title: "Clerical",
            date: "c. 206 BCE–220 CE",
            dynasty: "Han Dynasty",
            material: "Written quickly with brush on bamboo, wood, and paper",
            explanation: "As administration expanded, a practical hand developed for writing large quantities of information. Curves were reorganized into straighter, broader strokes, making the modern structural skeleton easier to recognize.",
            artworkRect: CGRect(x: 0.282, y: 0.645, width: 0.323, height: 0.126),
            color: AppColors.learned
        ),
        HistoryOverviewStage(
            id: "regular",
            title: "Regular",
            date: "Emerges c. 3rd century CE · mature by Tang",
            dynasty: "Wei–Jin through Tang; continuing today",
            material: "Brush-written, carved, printed, and digitized",
            explanation: "Regular Script emerged over centuries from Clerical Script. By the Tang dynasty, balanced stroke conventions formed an influential model for education, inscriptions, copying, printing, and modern type.",
            artworkRect: CGRect(x: 0.282, y: 0.781, width: 0.323, height: 0.115),
            color: AppColors.accentPrimary
        )
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.spaceLg) {
                    HistoryOverviewHeader()
                    HistoryTimelineCard(stages: stages, dependencies: dependencies)
                    HistoryLivingTraditionCard(dependencies: dependencies)
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

    /// Recreates a navigable stage destination without coupling article layout to the landing view.
    static func destination(for id: String) -> HistoryOverviewStage? {
        switch id {
        case "oracleBone": return HistoryOverviewStage(id: id, title: "Oracle Bone", date: "c. 1200–1046 BCE", dynasty: "Shang Dynasty", material: "Carved on animal bones and turtle shells", explanation: "At the Shang court, writing recorded divination, names, dates, offerings, and events.", artworkRect: CGRect(x: 0.282, y: 0.165, width: 0.323, height: 0.150), color: AppColors.accentPrimary)
        case "bronze": return HistoryOverviewStage(id: id, title: "Bronze", date: "c. 1046–256 BCE", dynasty: "Zhou Dynasty", material: "Cast or engraved on bronze vessels", explanation: "Bronze inscriptions recorded ancestors, gifts, appointments, victories, and ritual events.", artworkRect: CGRect(x: 0.282, y: 0.331, width: 0.323, height: 0.135), color: Color(red: 0.63, green: 0.43, blue: 0.25))
        case "seal": return HistoryOverviewStage(id: id, title: "Small Seal", date: "c. 221–206 BCE", dynasty: "Qin Dynasty", material: "Written with brush on bamboo slips and silk", explanation: "The Qin state standardized inherited writing across a newly unified empire.", artworkRect: CGRect(x: 0.282, y: 0.492, width: 0.323, height: 0.136), color: Color(red: 0.76, green: 0.56, blue: 0.28))
        case "clerical": return HistoryOverviewStage(id: id, title: "Clerical", date: "c. 206 BCE–220 CE", dynasty: "Han Dynasty", material: "Written quickly with brush on bamboo, wood, and paper", explanation: "A practical hand developed for writing large quantities of information.", artworkRect: CGRect(x: 0.282, y: 0.645, width: 0.323, height: 0.126), color: AppColors.learned)
        case "regular": return HistoryOverviewStage(id: id, title: "Regular", date: "Emerges c. 3rd century CE · mature by Tang", dynasty: "Wei–Jin through Tang; continuing today", material: "Brush-written, carved, printed, and digitized", explanation: "Regular Script emerged over centuries from Clerical Script and remains foundational.", artworkRect: CGRect(x: 0.282, y: 0.781, width: 0.323, height: 0.115), color: AppColors.accentPrimary)
        default: return nil
        }
    }
}

/// Keeps the supplied artwork board scoped to individual History pages, never the overview timeline.
private enum HistoryArtworkSet {
    /// Crops each historical panel inside the visible white dividers of the supplied artwork board.
    static func stageRect(for id: String) -> CGRect? {
        switch id {
        case "oracleBone": return CGRect(x: 0.004, y: 0.068, width: 0.158, height: 0.294)
        case "bronze": return CGRect(x: 0.166, y: 0.068, width: 0.165, height: 0.294)
        case "seal": return CGRect(x: 0.335, y: 0.068, width: 0.163, height: 0.294)
        case "clerical": return CGRect(x: 0.501, y: 0.068, width: 0.160, height: 0.294)
        case "regular": return CGRect(x: 0.665, y: 0.068, width: 0.166, height: 0.294)
        default: return nil
        }
    }
}

/// Short native-text article data shared by all History destinations.
private struct HistoryArticle {
    let title: String
    let eyebrow: String
    let era: String
    let date: String
    let intro: [String]
    let sections: [HistoryArticleSection]
    let examples: [HistoryArticleExample]
    let nextID: String?
    let showsCalligraphyHero: Bool
    let footerNote: String?

    init(
        title: String,
        eyebrow: String,
        era: String,
        date: String,
        intro: [String],
        sections: [HistoryArticleSection],
        examples: [HistoryArticleExample],
        nextID: String?,
        showsCalligraphyHero: Bool = false,
        footerNote: String? = "Historical forms are representative examples. Styles overlap, and forms varied across periods, regions, materials, objects, and writers."
    ) {
        self.title = title
        self.eyebrow = eyebrow
        self.era = era
        self.date = date
        self.intro = intro
        self.sections = sections
        self.examples = examples
        self.nextID = nextID
        self.showsCalligraphyHero = showsCalligraphyHero
        self.footerNote = footerNote
    }
}

private struct HistoryArticleSection: Identifiable {
    let id: String
    let title: String
    let paragraphs: [String]
    let calligraphyStyles: [HistoryCalligraphyStyle]
    let showsCalligraphyComparison: Bool
    let showsCalligraphyTools: Bool

    init(
        id: String,
        title: String,
        paragraphs: [String],
        calligraphyStyles: [HistoryCalligraphyStyle] = [],
        showsCalligraphyComparison: Bool = false,
        showsCalligraphyTools: Bool = false
    ) {
        self.id = id
        self.title = title
        self.paragraphs = paragraphs
        self.calligraphyStyles = calligraphyStyles
        self.showsCalligraphyComparison = showsCalligraphyComparison
        self.showsCalligraphyTools = showsCalligraphyTools
    }
}

private struct HistoryCalligraphyStyle: Identifiable {
    let id: String
    let title: String
    let descriptor: String
    let detail: String

    static let catalog = [
        HistoryCalligraphyStyle(id: "seal", title: "Seal", descriptor: "Measured and symmetrical", detail: "Long, controlled lines preserve an ancient visual character."),
        HistoryCalligraphyStyle(id: "clerical", title: "Clerical", descriptor: "Broad and grounded", detail: "Strong horizontals and wide proportions give the character a distinctive rhythm."),
        HistoryCalligraphyStyle(id: "regular", title: "Regular", descriptor: "Clear and balanced", detail: "Individual strokes remain clearly defined within a stable structure."),
        HistoryCalligraphyStyle(id: "running", title: "Running", descriptor: "Fluid and connected", detail: "The brush moves more continuously and some strokes begin to join."),
        HistoryCalligraphyStyle(id: "cursive", title: "Cursive", descriptor: "Rapid and expressive", detail: "The structure is abbreviated into flowing movements that demand greater familiarity to read.")
    ]

    /// Coordinates the five calligraphy examples within the supplied artwork board.
    static func artworkRect(for id: String) -> CGRect {
        switch id {
        case "seal": return CGRect(x: 0.020, y: 0.750, width: 0.065, height: 0.105)
        case "clerical": return CGRect(x: 0.090, y: 0.750, width: 0.087, height: 0.105)
        case "regular": return CGRect(x: 0.177, y: 0.750, width: 0.077, height: 0.105)
        case "running": return CGRect(x: 0.254, y: 0.750, width: 0.076, height: 0.105)
        default: return CGRect(x: 0.329, y: 0.750, width: 0.086, height: 0.105)
        }
    }
}

private struct HistoryArticleExample: Identifiable {
    let id: String
    let recordID: String
    let label: String
    let detail: String
    let position: SymbolJourneyPosition
}

private extension HistoryArticle {
    /// Supplies the approved editorial arc without inventing an additional artwork system.
    static func article(for id: String) -> HistoryArticle {
        switch id {
        case "oracleBone":
            return HistoryArticle(
                title: "Writing becomes a record",
                eyebrow: "ORACLE BONE",
                era: "Late Shang",
                date: "c. 1200–1046 BCE",
                intro: [
                    "Oracle Bone inscriptions are the earliest large surviving body of mature Chinese writing. At the Shang court, diviners recorded questions about ritual, weather, harvests, warfare, and royal affairs on animal bone and turtle shell.",
                    "These marks were not merely simple pictures. They used flexible sound and compound principles to record language, while their shapes still preserve visible relationships to the things and ideas they named."
                ],
                sections: [
                    HistoryArticleSection(id: "surface", title: "Why this writing looked different", paragraphs: [
                        "Bone and shell are hard, narrow surfaces. Marks had to be carved with care and remain legible after the surface was heated to produce divination cracks.",
                        "The result is angular and economical, but the writing system was already capable of more than drawing objects. It recorded names, dates, actions, and relationships."
                    ]),
                    HistoryArticleSection(id: "records", title: "What people wrote", paragraphs: [
                        "Many inscriptions ask whether an event will happen, report what the court offered, or record what happened after a prediction. Writing was part of a ritual and administrative practice, not an isolated decoration."
                    ]),
                    HistoryArticleSection(id: "closely", title: "Look closely", paragraphs: [
                        "Compare the representative forms below with the modern characters. The connection is sometimes pictorial, sometimes structural, and sometimes preserved through sound."
                    ])
                ],
                examples: historicalExamples(stage: "oracleBone"),
                nextID: "bronze"
            )
        case "bronze":
            return HistoryArticle(
                title: "Writing made to last",
                eyebrow: "BRONZE",
                era: "Shang and Zhou",
                date: "c. 11th–3rd centuries BCE",
                intro: [
                    "Bronze inscriptions were cast or engraved on ritual vessels, weapons, bells, and other objects. The tradition began in the Shang period and became especially important in the Western Zhou.",
                    "Bronze writing preserved political and ritual memory: ancestors, gifts, appointments, victories, and ceremonies could be recorded on objects meant to endure."
                ],
                sections: [
                    HistoryArticleSection(id: "forms", title: "Why the forms changed", paragraphs: [
                        "A vessel offered a broader surface than a bone or shell, and a cast inscription could be designed for ceremonial display. Characters often became fuller, more balanced, and more fluid.",
                        "Bronze was not one perfectly uniform script. Different regions, workshops, and periods produced related but distinct conventions."
                    ]),
                    HistoryArticleSection(id: "voices", title: "A script with many voices", paragraphs: [
                        "The same inherited writing tradition could serve royal ritual, political memory, and practical identification. Material and purpose shaped the visual result without creating a single clean break from earlier writing."
                    ]),
                    HistoryArticleSection(id: "closely", title: "Look closely", paragraphs: [
                        "Compare the broad Bronze forms with the earlier carved forms and the later standardized stages. Similar structures endure even when the proportions and stroke treatment change."
                    ])
                ],
                examples: historicalExamples(stage: "bronze"),
                nextID: "seal"
            )
        case "seal":
            return HistoryArticle(
                title: "One empire, one official standard",
                eyebrow: "SMALL SEAL",
                era: "Qin Dynasty",
                date: "221–206 BCE",
                intro: [
                    "Before imperial unification, states of the Warring States period used related but increasingly different writing conventions. When Qin conquered its rivals in 221 BCE, governing the new empire required officials in distant regions to recognize the same written forms.",
                    "The Qin state promoted a standardized official script now known as Small Seal. It regularized a tradition that had already evolved for more than a thousand years; Qin did not invent Chinese writing."
                ],
                sections: [
                    HistoryArticleSection(id: "regular", title: "What became more regular", paragraphs: [
                        "Small Seal characters tend to be tall, balanced, and carefully proportioned. Curves are controlled, line thickness is visually even, and components are arranged in more consistent ways."
                    ]),
                    HistoryArticleSection(id: "standard", title: "Why standardization mattered", paragraphs: [
                        "A shared script supported administration across a larger state. Laws, records, measurements, inscriptions, and communication could circulate with fewer regional differences in character form."
                    ]),
                    HistoryArticleSection(id: "closely", title: "Look closely", paragraphs: [
                        "Small Seal can make a character’s ancestry easier to see because its structure is regular while older relationships remain visible."
                    ])
                ],
                examples: historicalExamples(stage: "seal"),
                nextID: "clerical"
            )
        case "clerical":
            return HistoryArticle(
                title: "The decisive turn toward modern structure",
                eyebrow: "CLERICAL",
                era: "Late Qin and Han Dynasty",
                date: "c. 3rd century BCE–2nd century CE",
                intro: [
                    "As government expanded, scribes needed to write large quantities of information quickly and clearly. A practical style developed alongside and beyond the formal seal tradition, becoming a major form of administrative writing and monumental inscription by the Han dynasty.",
                    "This was more than a new calligraphic look. Older rounded structures were reorganized into straighter strokes and new component shapes, so many characters began to look recognizably related to forms used today."
                ],
                sections: [
                    HistoryArticleSection(id: "visual", title: "What changed visually", paragraphs: [
                        "Characters became broader and more rectangular. Curved lines were frequently replaced by straighter brush strokes. Components were compressed, rotated, or rewritten, and strong horizontal movement became characteristic of mature Han clerical writing."
                    ]),
                    HistoryArticleSection(id: "matters", title: "Why it matters", paragraphs: [
                        "The clerical transformation weakened some obvious picture-like connections, but it made writing faster and helped establish the stroke-based structures inherited by later Regular Script."
                    ]),
                    HistoryArticleSection(id: "closely", title: "Look closely", paragraphs: [
                        "Compare Small Seal and Clerical side by side. The meaning may be unchanged even when the internal geometry has been reorganized."
                    ])
                ],
                examples: historicalExamples(stage: "clerical"),
                nextID: "regular"
            )
        case "regular":
            return HistoryArticle(
                title: "The form that became the foundation",
                eyebrow: "REGULAR",
                era: "Wei–Jin through Tang; continuing today",
                date: "Emerges c. 3rd century CE · mature by the Tang dynasty",
                intro: [
                    "Regular Script developed from the structural changes of Clerical Script while absorbing the more fluid possibilities of brush writing. Each stroke became clearly articulated, and characters settled into balanced, self-contained forms.",
                    "Regular Script emerged over several centuries rather than appearing on one date. By the Tang dynasty, masters of standard calligraphy established models that had enormous influence on education, official documents, stone inscriptions, copying, and eventually the design of printed characters."
                ],
                sections: [
                    HistoryArticleSection(id: "stable", title: "What became stable", paragraphs: [
                        "Dots, horizontal strokes, verticals, hooks, turns, and diagonals were organized into repeatable conventions. Components occupied more predictable positions inside a square character space. The result was a form that could be learned, copied, taught, carved, and printed with great consistency."
                    ]),
                    HistoryArticleSection(id: "frozen", title: "Regular does not mean frozen", paragraphs: [
                        "Running and cursive styles continued alongside Regular Script, and individual calligraphers developed highly personal hands. Printing later introduced its own visual conventions. Regular Script is therefore a structural foundation, not one immutable font."
                    ]),
                    HistoryArticleSection(id: "matters", title: "Why it still matters", paragraphs: [
                        "The basic architecture of modern Chinese characters, Japanese kanji, and Korean Hanja remains closely connected to Regular Script. Even digital typefaces that look very different from brush calligraphy still organize characters around this inherited structure."
                    ]),
                    HistoryArticleSection(id: "closely", title: "Look closely", paragraphs: [
                        "At this point in the timeline, many characters become immediately familiar. Compare Clerical, Regular, and the modern forms used in the app."
                    ])
                ],
                examples: historicalExamples(stage: "regular"),
                nextID: "livingTradition"
            )
        default:
            return modernBridgeArticle
        }
    }

    /// Supplies the calligraphy page without treating Running or Cursive as later evolution stages.
    static var livingTraditionArticle: HistoryArticle {
        HistoryArticle(
            title: "Writing becomes an art",
            eyebrow: "A LIVING TRADITION",
            era: "",
            date: "From antiquity to the present",
            intro: [
                "The history of Chinese writing did not end when Regular Script became established. Older styles survived, and writers continued to explore very different ways of forming the same characters.",
                "With brush and ink, writing also became a major visual art. A character could be careful and balanced, broad and ancient-looking, or written in a rapid sequence of flowing movements. The words remained important, but so did the movement of the hand that created them."
            ],
            sections: [
                HistoryArticleSection(id: "survived", title: "The old styles survived", paragraphs: [
                    "New scripts did not simply erase the ones that came before them. Seal Script continued in seals and inscriptions. Clerical Script remained an admired historical style. Regular Script became a foundation for clear formal writing.",
                    "Calligraphers could return to any of these traditions centuries later, studying older forms and giving them new personality through proportion, rhythm, pressure, and brush movement."
                ]),
                HistoryArticleSection(id: "movement", title: "When the brush begins to move", paragraphs: [
                    "Running Script allows strokes to flow more naturally into one another. Some movements are shortened or connected, making writing faster while usually remaining recognizable.",
                    "Cursive Script takes this freedom much further. Strokes can be abbreviated, joined, or transformed into continuous gestures. The result can look almost abstract, but the forms still follow learned conventions rather than being random handwriting.",
                    "Running and Cursive are not additional stages after Regular Script in the Symbol evolution timeline. They are different traditions of handwriting and calligraphy."
                ]),
                HistoryArticleSection(id: "styles", title: "One character, different expression", paragraphs: [
                    "The same character can look measured, broad, clear, fluid, or rapid depending on the writing tradition. These styles are compared as calligraphic practices, not presented as a simple five-step evolution."
                ], calligraphyStyles: HistoryCalligraphyStyle.catalog),
                HistoryArticleSection(id: "expression", title: "More than beautiful handwriting", paragraphs: [
                    "In calligraphy, the character records the movement that created it. A heavy stroke can show pressure. A thin line can reveal the brush lifting from the page. Changes in speed, direction, spacing, and ink can give the same character a completely different feeling.",
                    "This made writing a form of artistic expression as well as a way of recording language."
                ]),
                HistoryArticleSection(id: "tools", title: "Brush, ink, paper, and inkstone", paragraphs: [
                    "Traditional calligraphy developed around four essential tools: the brush, ink, paper, and inkstone. Together they are often known as the Four Treasures of the Scholar’s Studio."
                ], showsCalligraphyTools: true),
                HistoryArticleSection(id: "look-closely", title: "Look closely", paragraphs: [
                    "The character is the same. What changes is the movement used to write it."
                ], showsCalligraphyComparison: true),
                HistoryArticleSection(id: "alive", title: "Still alive today", paragraphs: [
                    "These historical styles are still practiced today. Regular, Running, Cursive, Clerical, and Seal Script continue to appear in calligraphy, inscriptions, seals, art, and design.",
                    "The ancient history of Chinese characters is therefore not something that simply ended. Many of its writing traditions remain visible whenever a brush touches paper."
                ])
            ],
            examples: [],
            nextID: "modern",
            showsCalligraphyHero: true,
            footerNote: nil
        )
    }

    /// Keeps the bridge article in the same reusable native-text layout as ancient stages.
    static var modernBridgeArticle: HistoryArticle {
        HistoryArticle(
            title: "One tradition, several paths",
            eyebrow: "MODERN",
            era: "From mature Regular Script to the present",
            date: "A shared foundation shaped by different languages and standards",
            intro: [
                "Regular Script did not suddenly split into four equal descendants. Chinese characters entered different societies at different times, served different languages, and were later standardized in different ways.",
                "To understand modern forms, ask four different questions: Which forms were preserved? Which were simplified? How were characters read in another language? And in Korea, why was an entirely new alphabet created alongside them?"
            ],
            sections: [
                HistoryArticleSection(id: "relationships", title: "Four different relationships", paragraphs: [
                    "Traditional Chinese represents continuity within inherited character forms and later regional standards. Simplified Chinese represents modern character reform with many older roots. Japanese combines kanji with Japanese readings and kana, followed by later form standardization. Korean preserves Hanja as a historical and lexical tradition alongside a purpose-built Hangul writing system."
                ]),
                HistoryArticleSection(id: "note", title: "These are writing traditions, not four identical languages", paragraphs: [
                    "Traditional and Simplified describe character standards used to write Chinese. Japanese kanji and Korean Hanja are Chinese characters adapted within different languages. The same historical character can therefore preserve a related shape while carrying different readings and patterns of use."
                ])
            ],
            examples: modernExamples(),
            nextID: nil
        )
    }

    static func modernArticle(for id: String) -> HistoryArticle {
        switch id {
        case "traditionalChinese":
            return HistoryArticle(title: "Continuity, not a single split", eyebrow: "TRADITIONAL CHINESE", era: "Inherited forms with modern regional standards", date: "繁體中文 / 正體字", intro: [
                "Traditional Chinese is the modern name for character forms that largely continue the inherited pre-simplification tradition. It was not created in a single reform, and there is no one moment when it diverged from Regular Script.",
                "Regular Script forms continued through handwriting, dictionaries, woodblock printing, movable type, education, and modern typography. Over time, institutions in different regions established preferred reference standards."
            ], sections: [
                HistoryArticleSection(id: "label", title: "Why “traditional” is a modern label", paragraphs: ["For most of history, writers did not need this label; these were simply the forms in ordinary literary and printed use. It became useful when simplified standards spread in the 20th century and a contrast was needed."]),
                HistoryArticleSection(id: "regional", title: "One tradition, regional standards", paragraphs: ["Taiwan and Hong Kong both use Traditional Chinese, but they do not always select exactly the same variant or display every component in exactly the same glyph form. These are regional standards within a broader tradition."]),
                HistoryArticleSection(id: "sound", title: "The same character can sound very different", paragraphs: ["A Traditional Chinese character does not belong to only one spoken variety. The same written form may be read in Mandarin, Cantonese, or another Chinese language with different pronunciation."])
            ], examples: modernExamples(), nextID: "simplifiedChinese")
        case "simplifiedChinese":
            return HistoryArticle(title: "A modern standard with older roots", eyebrow: "SIMPLIFIED CHINESE", era: "Mainland China", date: "National simplification adopted from 1956 · 简体中文", intro: [
                "Simplified Chinese is a modern character standard associated especially with mainland China. A national simplification scheme was approved in 1956 as part of a broader effort to make reading and writing easier to teach and use.",
                "The reform did not invent every form from nothing. Many simplified forms drew on abbreviations, cursive shapes, popular variants, or simplification patterns that had existed for centuries."
            ], sections: [
                HistoryArticleSection(id: "methods", title: "Several methods, not one rule", paragraphs: ["Some characters lost strokes. Some complex components were replaced by shorter forms. Some handwritten shapes were regularized into print, and some older characters were consolidated under one modern form."]),
                HistoryArticleSection(id: "different", title: "Similar does not mean identical", paragraphs: ["China and Japan simplified characters independently. Some results happen to match, while others differ. Modern standards therefore differ while remaining part of the same long character tradition."]),
                HistoryArticleSection(id: "shared", title: "Most of the writing system remained shared", paragraphs: ["Many characters were never simplified, and many components remain recognizable across Traditional Chinese, Simplified Chinese, and Japanese kanji."])
            ], examples: modernExamples(), nextID: "japanese")
        case "japanese":
            return HistoryArticle(title: "Chinese characters adapted to Japanese", eyebrow: "JAPANESE", era: "Adopted by the 5th–6th centuries", date: "漢字 + かな", intro: [
                "Japan adopted Chinese writing through sustained contact with the Asian continent, especially China and the Korean peninsula. Chinese characters became central to government, Buddhism, scholarship, and record-keeping.",
                "Japanese and Chinese are structurally different languages. Japanese writers therefore developed new ways to read, combine, and supplement characters rather than simply borrowing shapes."
            ], sections: [
                HistoryArticleSection(id: "readings", title: "One character, more than one reading", paragraphs: ["Kanji can preserve readings derived historically from Chinese pronunciation, called on’yomi, while also representing native Japanese words with kun’yomi. A single kanji can therefore have several established readings."]),
                HistoryArticleSection(id: "kana", title: "Japanese needed a way to write grammar and sound", paragraphs: ["Early writers sometimes used characters for their sound rather than their meaning. These practices developed into kana: hiragana emerged from flowing cursive forms, while katakana developed from abbreviated parts. Modern Japanese combines kanji, hiragana, and katakana."]),
                HistoryArticleSection(id: "reform", title: "A separate 20th-century reform", paragraphs: ["Japan later standardized many commonly used kanji forms. The 1946 Tōyō Kanji list and 1949 character-form table established many shinjitai forms independently of mainland Chinese reform."]),
                HistoryArticleSection(id: "divergence", title: "The divergence happened in layers", paragraphs: ["Japanese writing began diverging through pronunciation, grammar, local vocabulary, and kana many centuries ago. Visible divergence of some kanji shapes became more systematic much later."])
            ], examples: modernExamples(), nextID: "korean")
        default:
            return HistoryArticle(title: "Hanja remained. Hangul changed the system.", eyebrow: "KOREAN", era: "Chinese characters used for centuries", date: "한글 + 漢字 · Hangul created 1443, promulgated 1446", intro: [
                "Chinese characters reached the Korean peninsula long before Hangul and became a major written medium for government, scholarship, literature, religion, and historical record.",
                "Korean and Chinese are very different languages. Characters could carry meaning and learned vocabulary, but they were not designed to represent Korean speech and grammar directly."
            ], sections: [
                HistoryArticleSection(id: "hangul", title: "A writing system designed for Korean", paragraphs: ["In 1443, King Sejong created Hunminjeongeum, the ancestor of modern Hangul. In 1446, the system was publicly explained and promulgated. Its letters were designed to represent Korean sounds systematically."]),
                HistoryArticleSection(id: "coexist", title: "Centuries of coexistence", paragraphs: ["Hangul did not immediately replace Chinese characters. Hanja remained important in official, scholarly, and elite writing while Hangul expanded through literature, correspondence, education, and everyday communication. Modern Korean is primarily written in Hangul, while Hanja remains part of its historical and lexical background."]),
                HistoryArticleSection(id: "different", title: "A different relationship", paragraphs: ["A Korean reading is not the next graphical stage of a Hanja character. It is the Korean pronunciation written in a different script. The major change was functional: Hanja tradition alongside a newly designed Korean alphabet."])
            ], examples: koreanExamples(), nextID: nil)
        }
    }

    private static func historicalExamples(stage: String) -> [HistoryArticleExample] {
        [
            HistoryArticleExample(id: "day-\(stage)", recordID: "day", label: "Day", detail: stageDisplay(stage), position: SymbolJourneyPosition(section: .evolution, stageID: stage)),
            HistoryArticleExample(id: "moon-\(stage)", recordID: "moon", label: "Moon", detail: stageDisplay(stage), position: SymbolJourneyPosition(section: .evolution, stageID: stage)),
            HistoryArticleExample(id: "mountain-\(stage)", recordID: "mountain", label: "Mountain", detail: stageDisplay(stage), position: SymbolJourneyPosition(section: .evolution, stageID: stage))
        ]
    }

    private static func modernExamples() -> [HistoryArticleExample] {
        [
            HistoryArticleExample(id: "day-modern", recordID: "day", label: "日", detail: "Open this Shared Character", position: SymbolJourneyPosition(section: .today, stageID: "modern")),
            HistoryArticleExample(id: "water-modern", recordID: "water", label: "水", detail: "Open this Shared Character", position: SymbolJourneyPosition(section: .today, stageID: "modern")),
            HistoryArticleExample(id: "person-modern", recordID: "person", label: "人", detail: "Open this Shared Character", position: SymbolJourneyPosition(section: .today, stageID: "modern"))
        ]
    }

    private static func koreanExamples() -> [HistoryArticleExample] {
        [
            HistoryArticleExample(id: "mountain-korean", recordID: "mountain", label: "山 · 산 · san", detail: "Read in Korean as", position: SymbolJourneyPosition(section: .today, stageID: "usage-korean")),
            HistoryArticleExample(id: "water-korean", recordID: "water", label: "水 · 수 · su", detail: "Read in Korean as", position: SymbolJourneyPosition(section: .today, stageID: "usage-korean")),
            HistoryArticleExample(id: "person-korean", recordID: "person", label: "人 · 인 · in", detail: "Read in Korean as", position: SymbolJourneyPosition(section: .today, stageID: "usage-korean"))
        ]
    }

    private static func stageDisplay(_ stage: String) -> String { "Representative \(stage) form" }
}

private struct HistoryOverviewHeader: View {
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Use the landscape crop as the complete header backdrop; the editorial copy sits over it.
            HistoryReferenceCropView(
                normalizedRect: CGRect(x: 0.60, y: 0.0, width: 0.40, height: 0.145),
                accessibilityLabel: "Ink-wash landscape with mountains and a pavilion"
            )
            .frame(maxWidth: .infinity)
            .frame(height: 214)
            .allowsHitTesting(false)

            LinearGradient(
                colors: [Color.white.opacity(0.92), Color.white.opacity(0.48), Color.clear],
                startPoint: .leading,
                endPoint: .trailing
            )
            .allowsHitTesting(false)

            VStack(alignment: .leading, spacing: AppSpacing.spaceSm) {
                Text("The History of Chinese Characters")
                    .font(AppTypography.exhibitHeading)
                    .foregroundStyle(AppColors.textPrimary)
                Text("Chinese characters have changed for more than three thousand years. New tools, institutions, and communities reshaped how they were written—while many underlying structures endured.")
                    .font(AppTypography.body)
                    .foregroundStyle(AppColors.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(AppSpacing.spaceMd)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 214)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.card))
        .overlay {
            RoundedRectangle(cornerRadius: AppRadius.card)
                .stroke(AppColors.separator, lineWidth: 1)
        }
        .padding(.top, AppSpacing.spaceXs)
    }
}

private struct HistoryTimelineCard: View {
    let stages: [HistoryOverviewStage]
    let dependencies: AppDependencies

    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(stages.enumerated()), id: \.element.id) { index, stage in
                NavigationLink {
                    HistoryScriptDetailView(stage: stage, dependencies: dependencies)
                } label: {
                    HistoryOverviewRow(stage: stage)
                        .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                .contentShape(Rectangle())
                if index < stages.count - 1 {
                    Divider()
                        .padding(.leading, 48)
                }
            }
        }
        .overlay(alignment: .leading) {
            Rectangle()
                .fill(AppColors.separator)
                .frame(width: 2)
                .padding(.leading, 16)
                .padding(.vertical, 34)
                .allowsHitTesting(false)
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
        .allowsHitTesting(false)
    }
}

private struct HistoryLivingTraditionCard: View {
    let dependencies: AppDependencies

    private let branches = HistoryModernBranch.catalog

    var body: some View {
        GroupedSurface {
            NavigationLink {
                HistoryLivingTraditionView(dependencies: dependencies)
            } label: {
                HStack(alignment: .top, spacing: AppSpacing.spaceSm) {
                    HistoryReferenceCropView(
                        normalizedRect: CGRect(x: 0.055, y: 0.909, width: 0.085, height: 0.065),
                        accessibilityLabel: "Traditional pavilion illustration"
                    )
                    .frame(width: 54, height: 64)
                    .allowsHitTesting(false)
                    VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
                        Text("A Living Tradition")
                            .font(AppTypography.stageTitle)
                            .foregroundStyle(AppColors.textPrimary)
                        Text("Ancient styles · still practiced today")
                            .font(AppTypography.metadata.weight(.semibold))
                            .foregroundStyle(AppColors.textSecondary)
                        Text("New scripts did not erase the old ones. Seal, Clerical, Regular, Running, and Cursive became lasting traditions of writing and calligraphy.")
                            .font(AppTypography.caption)
                            .foregroundStyle(AppColors.textSecondary)
                        Text("Explore calligraphy →")
                            .font(AppTypography.caption.weight(.semibold))
                            .foregroundStyle(AppColors.accentPrimary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .contentShape(Rectangle())
                .frame(maxWidth: .infinity, minHeight: 64, alignment: .leading)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: AppSpacing.spaceXs) {
                Text("Modern writing traditions")
                    .font(AppTypography.sectionHeading)
                    .foregroundStyle(AppColors.textPrimary)
                Text("The shared historical tradition continues differently in each language environment.")
                    .font(AppTypography.metadata)
                    .foregroundStyle(AppColors.textSecondary)

                ForEach(branches) { branch in
                    NavigationLink {
                        HistoryModernLanguageDetailView(branch: branch, dependencies: dependencies)
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
                        .frame(maxWidth: .infinity, minHeight: 56, alignment: .leading)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .frame(maxWidth: .infinity, minHeight: 56, alignment: .leading)
                    .contentShape(Rectangle())
                }
            }

            HistoryReferenceCropView(
                // Crop only the comparison glyphs; the source labels below them stay out of the overview.
                normalizedRect: CGRect(x: 0.475, y: 0.914, width: 0.485, height: 0.050),
                accessibilityLabel: "Oracle Bone, Bronze, Small Seal, Clerical, and Regular Script comparison"
            )
            .frame(maxWidth: .infinity, minHeight: 58, maxHeight: 70)
            .allowsHitTesting(false)
        }
    }
}

private struct HistoryModernBranch: Identifiable, Hashable {
    let id: String
    let title: String
    let scriptLabel: String
    let explanation: String
    let artworkRect: CGRect

    /// Stable branch order is shared by the landing card and the bridge article.
    static let catalog: [HistoryModernBranch] = [
        HistoryModernBranch(id: "traditionalChinese", title: "Traditional Chinese", scriptLabel: "繁體中文 / 正體字", explanation: "Inherited forms with modern regional standards.", artworkRect: CGRect(x: 0.004, y: 0.486, width: 0.243, height: 0.147)),
        HistoryModernBranch(id: "simplifiedChinese", title: "Simplified Chinese", scriptLabel: "简体中文", explanation: "A modern standard with older roots.", artworkRect: CGRect(x: 0.255, y: 0.486, width: 0.240, height: 0.147)),
        HistoryModernBranch(id: "japanese", title: "Japanese", scriptLabel: "漢字 + かな", explanation: "Chinese characters adapted to Japanese.", artworkRect: CGRect(x: 0.504, y: 0.486, width: 0.243, height: 0.147)),
        HistoryModernBranch(id: "korean", title: "Korean", scriptLabel: "한글 + 漢字", explanation: "Hanja alongside a purpose-built Korean alphabet.", artworkRect: CGRect(x: 0.756, y: 0.486, width: 0.239, height: 0.147))
    ]
}

private struct HistoryScriptDetailView: View {
    let stage: HistoryOverviewStage
    let dependencies: AppDependencies

    var body: some View {
        HistoryArticlePage(
            article: .article(for: stage.id),
            dependencies: dependencies,
            artworkRect: HistoryArtworkSet.stageRect(for: stage.id),
            artworkImageName: "History/History_Artwork_Set"
        ) {
            nextStageDestination
        }
        .navigationTitle(stage.title)
        .navigationBarTitleDisplayMode(.inline)
        .background(AppColors.appBackground.ignoresSafeArea())
    }

    @ViewBuilder
    private var nextStageDestination: some View {
        if HistoryArticle.article(for: stage.id).nextID == "livingTradition" {
            NavigationLink {
                HistoryLivingTraditionView(dependencies: dependencies)
            } label: {
                HistoryNextLink(title: "Next: A Living Tradition", detail: "Writing becomes an art through calligraphy")
            }
            .buttonStyle(.plain)
        } else if let nextID = HistoryArticle.article(for: stage.id).nextID,
                  let nextStage = HistoryOverviewStage.destination(for: nextID) {
            NavigationLink {
                HistoryScriptDetailView(stage: nextStage, dependencies: dependencies)
            } label: {
                HistoryNextLink(title: "Next: \(nextStage.title)", detail: nextStage.explanation)
            }
            .buttonStyle(.plain)
        }
    }
}

private struct HistoryLivingTraditionView: View {
    let dependencies: AppDependencies

    var body: some View {
        HistoryArticlePage(
            article: .livingTraditionArticle,
            dependencies: dependencies,
            presentation: .calligraphy
        ) {
            NavigationLink {
                HistoryModernBridgeView(dependencies: dependencies)
            } label: {
                HistoryNextLink(
                    title: "Explore modern writing traditions",
                    detail: "Traditional Chinese · Simplified Chinese · Japanese · Korean"
                )
            }
            .buttonStyle(.plain)
        }
        .navigationTitle("A Living Tradition")
        .navigationBarTitleDisplayMode(.inline)
        .background(AppColors.appBackground.ignoresSafeArea())
    }
}

/// Shared modern-language card treatment; artwork is cropped from the supplied placement board.
private struct HistoryModernBranchCard: View {
    let branch: HistoryModernBranch

    var body: some View {
        HStack(alignment: .top, spacing: AppSpacing.spaceSm) {
            HistoryReferenceCropView(
                normalizedRect: branch.artworkRect,
                imageName: "History/History_Artwork_Set",
                accessibilityLabel: "Artwork for \(branch.title) writing tradition"
            )
            .frame(width: 124, height: 82)
            .background(AppColors.artifactField)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.small))
            .allowsHitTesting(false)

            VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
                Text(branch.title)
                    .font(AppTypography.body.weight(.semibold))
                    .foregroundStyle(AppColors.textPrimary)
                Text(branch.scriptLabel)
                    .font(AppTypography.metadata)
                    .foregroundStyle(AppColors.textSecondary)
                Text(branch.explanation)
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textSecondary)
                Text("Explore →")
                    .font(AppTypography.caption.weight(.semibold))
                    .foregroundStyle(AppColors.accentPrimary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(AppSpacing.spaceSm)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppColors.surfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.card))
        .overlay {
            RoundedRectangle(cornerRadius: AppRadius.card)
                .stroke(AppColors.separator, lineWidth: 1)
        }
        .contentShape(Rectangle())
    }
}

private struct HistoryModernLanguageIdentityView: View {
    let branch: HistoryModernBranch

    var body: some View {
        ArtifactField {
            VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
                Text("MODERN WRITING TRADITION")
                    .font(AppTypography.conceptLabel)
                    .tracking(1.2)
                    .foregroundStyle(AppColors.textSecondary)
                Text(branch.title)
                    .font(AppTypography.sectionHeading)
                    .foregroundStyle(AppColors.textPrimary)
                Text(branch.scriptLabel)
                    .font(AppTypography.metadata.weight(.semibold))
                    .foregroundStyle(AppColors.accentPrimary)
                Text(branch.explanation)
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }
        }
    }
}

private struct HistoryModernBridgeView: View {
    let dependencies: AppDependencies

    var body: some View {
        HistoryArticlePage(
            article: .modernBridgeArticle,
            dependencies: dependencies,
            presentation: .modernBridge
        ) {
            VStack(alignment: .leading, spacing: AppSpacing.spaceSm) {
                Text("Explore the four modern contexts")
                    .font(AppTypography.sectionHeading)
                    .foregroundStyle(AppColors.textPrimary)
                ForEach(HistoryModernBranch.catalog) { branch in
                    NavigationLink {
                        HistoryModernLanguageDetailView(branch: branch, dependencies: dependencies)
                    } label: {
                        HistoryModernBranchCard(branch: branch)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .navigationTitle("Modern")
        .navigationBarTitleDisplayMode(.inline)
        .background(AppColors.appBackground.ignoresSafeArea())
    }
}

private struct HistoryModernLanguageDetailView: View {
    let branch: HistoryModernBranch
    let dependencies: AppDependencies

    var body: some View {
        HistoryArticlePage(
            article: .modernArticle(for: branch.id),
            dependencies: dependencies,
            artworkRect: branch.artworkRect,
            artworkImageName: "History/History_Artwork_Set",
            modernBranch: branch,
            presentation: .modernLanguage
        ) {
            if let nextBranch = HistoryModernBranch.catalog.first(where: { $0.id == nextBranchID }) {
                NavigationLink {
                    HistoryModernLanguageDetailView(branch: nextBranch, dependencies: dependencies)
                } label: {
                    HistoryNextLink(title: "Compare: \(nextBranch.title)", detail: nextBranch.scriptLabel)
                }
                .buttonStyle(.plain)
            } else {
                NavigationLink {
                    HistoryModernBridgeView(dependencies: dependencies)
                } label: {
                    HistoryNextLink(title: "Back to modern traditions", detail: "Explore another modern context")
                }
                .buttonStyle(.plain)
            }
        }
        .navigationTitle(branch.title)
        .navigationBarTitleDisplayMode(.inline)
        .background(AppColors.appBackground.ignoresSafeArea())
    }

    private var nextBranchID: String? {
        switch branch.id {
        case "traditionalChinese": return "simplifiedChinese"
        case "simplifiedChinese": return "japanese"
        case "japanese": return "korean"
        default: return nil
        }
    }
}

/// Shared native-text article layout for historical and modern History pages.
private enum HistoryArticlePresentation {
    case historical
    case calligraphy
    case modernBridge
    case modernLanguage
}

private struct HistoryArticlePage<NextDestination: View>: View {
    let article: HistoryArticle
    let dependencies: AppDependencies
    let artworkRect: CGRect?
    let artworkImageName: String
    let modernBranch: HistoryModernBranch?
    let presentation: HistoryArticlePresentation
    let nextDestination: () -> NextDestination

    init(
        article: HistoryArticle,
        dependencies: AppDependencies,
        artworkRect: CGRect? = nil,
        artworkImageName: String = "History/History_V1",
        modernBranch: HistoryModernBranch? = nil,
        presentation: HistoryArticlePresentation = .historical,
        @ViewBuilder nextDestination: @escaping () -> NextDestination
    ) {
        self.article = article
        self.dependencies = dependencies
        self.artworkRect = artworkRect
        self.artworkImageName = artworkImageName
        self.modernBranch = modernBranch
        self.presentation = presentation
        self.nextDestination = nextDestination
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.spaceLg) {
                Text(article.eyebrow)
                    .font(AppTypography.conceptLabel)
                    .tracking(1.4)
                    .foregroundStyle(presentation == .modernLanguage ? AppColors.accentPrimary : AppColors.textSecondary)
                Text(article.title)
                    .font(AppTypography.exhibitHeading)
                    .foregroundStyle(AppColors.textPrimary)
                if !article.era.isEmpty {
                    Text(article.era)
                        .font(AppTypography.sectionHeading)
                        .foregroundStyle(AppColors.textPrimary)
                }
                Text(article.date)
                    .font(AppTypography.metadata)
                    .foregroundStyle(AppColors.textSecondary)

                if article.showsCalligraphyHero {
                    HistoryCalligraphyHeroView()
                }

                if let artworkRect {
                    if presentation == .historical {
                        HistoryReferenceCropView(
                            normalizedRect: artworkRect,
                            imageName: artworkImageName,
                            accessibilityLabel: "Representative artwork for \(article.title)"
                        )
                        .frame(width: 220, height: 340)
                        .frame(maxWidth: .infinity)
                        .background(AppColors.artifactField)
                        .clipShape(RoundedRectangle(cornerRadius: AppRadius.card))
                        .allowsHitTesting(false)
                    } else {
                        HistoryReferenceCropView(
                            normalizedRect: artworkRect,
                            imageName: artworkImageName,
                            accessibilityLabel: "Representative artwork for \(article.title)"
                        )
                        .frame(maxWidth: .infinity, minHeight: 132, maxHeight: 190)
                        .background(AppColors.artifactField)
                        .clipShape(RoundedRectangle(cornerRadius: AppRadius.card))
                        .allowsHitTesting(false)
                    }
                }

                if let modernBranch {
                    HistoryModernLanguageIdentityView(branch: modernBranch)
                }

                ForEach(Array(article.intro.enumerated()), id: \.offset) { _, paragraph in
                    Text(paragraph)
                        .font(AppTypography.body)
                        .foregroundStyle(AppColors.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                ForEach(Array(article.sections.enumerated()), id: \.element.id) { index, section in
                    VStack(alignment: .leading, spacing: AppSpacing.spaceSm) {
                        Text(section.title)
                            .font(AppTypography.sectionHeading)
                            .foregroundStyle(AppColors.textPrimary)
                        ForEach(Array(section.paragraphs.enumerated()), id: \.offset) { _, paragraph in
                            Text(paragraph)
                                .font(AppTypography.body)
                                .foregroundStyle(AppColors.textSecondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        if !section.calligraphyStyles.isEmpty {
                            HistoryCalligraphyStyleList(styles: section.calligraphyStyles)
                        }
                        if section.showsCalligraphyTools {
                            HistoryCalligraphyToolsView()
                        }
                        if section.showsCalligraphyComparison {
                            HistoryCalligraphyComparisonView()
                        }
                    }
                    if index < article.sections.count - 1 {
                        Divider()
                            .overlay(presentation == .modernLanguage ? AppColors.accentPrimary.opacity(0.28) : AppColors.separator)
                    }
                }

                if !article.examples.isEmpty {
                    GroupedSurface {
                        VStack(alignment: .leading, spacing: AppSpacing.spaceSm) {
                            Text("Look closely")
                                .font(AppTypography.sectionHeading)
                                .foregroundStyle(AppColors.textPrimary)
                            Text("These representative forms are drawn from the app’s available Shared Character corpus.")
                                .font(AppTypography.caption)
                                .foregroundStyle(AppColors.textSecondary)
                            ForEach(article.examples) { example in
                                HistoryArticleExampleRow(example: example, dependencies: dependencies)
                            }
                        }
                    }
                }

                if let footerNote = article.footerNote {
                    Text(footerNote)
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColors.textSecondary)
                }

                NavigationLink {
                    SourcesLicensesView(dependencies: dependencies)
                } label: {
                    Text("Sources & historical notes")
                        .font(AppTypography.caption.weight(.semibold))
                        .foregroundStyle(AppColors.accentPrimary)
                        .frame(minHeight: 44, alignment: .leading)
                }

                nextDestination()
            }
            .padding(AppSpacing.spacePage)
            .padding(.bottom, AppSpacing.spaceSection)
        }
        .scrollIndicators(.hidden)
    }
}

/// Shows the supplied five-style calligraphy artwork with native labels beneath it.
private struct HistoryCalligraphyHeroView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.spaceXs) {
            HistoryReferenceCropView(
                normalizedRect: CGRect(x: 0.008, y: 0.750, width: 0.410, height: 0.105),
                imageName: "History/History_Artwork_Set",
                accessibilityLabel: "One character written in Seal, Clerical, Regular, Running, and Cursive styles"
            )
            .frame(maxWidth: .infinity, minHeight: 150, maxHeight: 190)
            .background(AppColors.artifactField)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.card))
            HStack(alignment: .top, spacing: AppSpacing.spaceXs) {
                ForEach(HistoryCalligraphyStyle.catalog) { style in
                    Text(style.title)
                        .font(AppTypography.caption.weight(.semibold))
                        .foregroundStyle(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }
}

/// Presents the supplied style vocabulary without implying a historical sequence.
private struct HistoryCalligraphyStyleList: View {
    let styles: [HistoryCalligraphyStyle]

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.spaceSm) {
            ForEach(styles) { style in
                VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
                    Text(style.title)
                        .font(AppTypography.body.weight(.semibold))
                        .foregroundStyle(AppColors.textPrimary)
                    Text(style.descriptor)
                        .font(AppTypography.metadata.weight(.semibold))
                        .foregroundStyle(AppColors.accentPrimary)
                    Text(style.detail)
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColors.textSecondary)
                }
                if style.id != styles.last?.id {
                    Divider()
                        .overlay(AppColors.separator)
                }
            }
        }
        .padding(.top, AppSpacing.spaceXs)
    }
}

/// Keeps the Four Treasures section compact while the dedicated illustrations are unavailable.
private struct HistoryCalligraphyToolsView: View {
    private let tools: [HistoryCalligraphyTool] = [
        HistoryCalligraphyTool(id: "brush", title: "Brush", detail: "Controls movement, pressure, and stroke width."),
        HistoryCalligraphyTool(id: "ink", title: "Ink", detail: "Changes in density as it moves through the brush."),
        HistoryCalligraphyTool(id: "paper", title: "Paper", detail: "Responds differently to speed, moisture, and pressure."),
        HistoryCalligraphyTool(id: "inkstone", title: "Inkstone", detail: "Used to prepare and control the ink.")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.spaceSm) {
            HistoryReferenceCropView(
                normalizedRect: CGRect(x: 0.679, y: 0.750, width: 0.318, height: 0.129),
                imageName: "History/History_Artwork_Set",
                accessibilityLabel: "Brush, ink stick, inkstone, and paper"
            )
            .frame(maxWidth: .infinity, minHeight: 94, maxHeight: 124)
            .background(AppColors.artifactField)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.small))

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .leading, spacing: AppSpacing.spaceSm) {
                ForEach(tools) { tool in
                    VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
                        Text(tool.title)
                            .font(AppTypography.body.weight(.semibold))
                            .foregroundStyle(AppColors.textPrimary)
                        Text(tool.detail)
                            .font(AppTypography.caption)
                            .foregroundStyle(AppColors.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .padding(.top, AppSpacing.spaceXs)
    }
}

private struct HistoryCalligraphyTool: Identifiable {
    let id: String
    let title: String
    let detail: String
}

/// Lets the learner inspect each calligraphic style without presenting an evolution arrow.
private struct HistoryCalligraphyComparisonView: View {
    @State private var selectedStyle: HistoryCalligraphyStyle?

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.spaceSm) {
            Text("The character is the same. Tap a style to enlarge it.")
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.textSecondary)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: AppSpacing.spaceSm) {
                    ForEach(HistoryCalligraphyStyle.catalog) { style in
                        Button {
                            selectedStyle = style
                        } label: {
                            VStack(spacing: AppSpacing.space2xs) {
                                HistoryReferenceCropView(
                                    normalizedRect: HistoryCalligraphyStyle.artworkRect(for: style.id),
                                    imageName: "History/History_Artwork_Set",
                                    accessibilityLabel: "(style.title) calligraphy example"
                                )
                                .frame(width: 72, height: 104)
                                .background(AppColors.artifactField)
                                .clipShape(RoundedRectangle(cornerRadius: AppRadius.small))
                                Text(style.title)
                                    .font(AppTypography.caption.weight(.semibold))
                                    .foregroundStyle(AppColors.textPrimary)
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .padding(.top, AppSpacing.spaceXs)
        .sheet(item: $selectedStyle) { style in
            HistoryCalligraphyDetailView(style: style)
        }
    }
}

private struct HistoryCalligraphyDetailView: View {
    let style: HistoryCalligraphyStyle

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.spaceMd) {
                HistoryReferenceCropView(
                    normalizedRect: HistoryCalligraphyStyle.artworkRect(for: style.id),
                    imageName: "History/History_Artwork_Set",
                    accessibilityLabel: "Enlarged (style.title) calligraphy example"
                )
                .frame(maxWidth: .infinity, minHeight: 260, maxHeight: 360)
                .background(AppColors.artifactField)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.card))

                Text(style.title)
                    .font(AppTypography.exhibitHeading)
                    .foregroundStyle(AppColors.textPrimary)
                Text(style.descriptor)
                    .font(AppTypography.sectionHeading)
                    .foregroundStyle(AppColors.accentPrimary)
                Text(style.detail)
                    .font(AppTypography.body)
                    .foregroundStyle(AppColors.textSecondary)
            }
            .padding(AppSpacing.spacePage)
        }
        .background(AppColors.appBackground.ignoresSafeArea())
    }
}

private struct HistoryArticleExampleRow: View {
    let example: HistoryArticleExample
    let dependencies: AppDependencies

    var body: some View {
        if let record = dependencies.sharedCharacters.first(where: { $0.id == example.recordID }),
           let form = displayForm(for: record) {
            NavigationLink {
                LessonView(route: LessonRoute(sharedCharacterID: record.id, startingPosition: example.position), dependencies: dependencies)
            } label: {
                HStack(spacing: AppSpacing.spaceSm) {
                    Text(form)
                        .font(CJKFontRole.museumRegular.font(size: 34))
                        .foregroundStyle(AppColors.artifactInk)
                        .frame(width: 54, height: 48)
                    VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
                        Text(displayLabel(for: record))
                            .font(AppTypography.body.weight(.semibold))
                            .foregroundStyle(AppColors.textPrimary)
                        Text(example.detail)
                            .font(AppTypography.caption)
                            .foregroundStyle(AppColors.textSecondary)
                    }
                    Spacer(minLength: 0)
                    Image(systemName: "chevron.right")
                        .foregroundStyle(AppColors.textTertiary)
                        .accessibilityHidden(true)
                }
                .frame(minHeight: 52)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("\(displayLabel(for: record)), open \(record.coreSharedMeaning) Symbol")
        }
    }

    private func displayForm(for record: SharedCharacterRecord) -> String? {
        if example.position.section == .evolution, let stageID = example.position.stageID,
           let stage = record.history.stages.first(where: { $0.stage == stageID }), let form = stage.form, !form.isEmpty {
            return form
        }
        guard example.position.section == .today else { return nil }
        if example.position.stageID == "usage-korean" { return record.focusCoverage.korean.form }
        return record.coreCharacter
    }

    /// Uses the bundled Korean reading data when a History row presents Hanja in Korean.
    private func displayLabel(for record: SharedCharacterRecord) -> String {
        guard example.position.stageID == "usage-korean",
              let reading = record.focusCoverage.korean.readings.first?.value else {
            return example.label
        }
        return "\(record.focusCoverage.korean.form) · \(reading)"
    }
}

private struct HistoryNextLink: View {
    let title: String
    let detail: String

    var body: some View {
        HStack(alignment: .top, spacing: AppSpacing.spaceSm) {
            VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
                Text(title)
                    .font(AppTypography.body.weight(.semibold))
                    .foregroundStyle(AppColors.accentPrimary)
                Text(detail)
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }
            Spacer(minLength: 0)
            Image(systemName: "arrow.right")
                .foregroundStyle(AppColors.accentPrimary)
                .accessibilityHidden(true)
        }
        .padding(AppSpacing.spaceMd)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppColors.surfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.surface))
        .overlay {
            RoundedRectangle(cornerRadius: AppRadius.surface)
                .stroke(AppColors.separator, lineWidth: 1)
        }
        .contentShape(Rectangle())
    }
}

/// Shows an exact crop of the supplied reference artwork without using the full infographic as the page.
private struct HistoryReferenceCropView: View {
    let normalizedRect: CGRect
    let imageName: String
    let accessibilityLabel: String

    init(normalizedRect: CGRect, imageName: String = "History/History_V1", accessibilityLabel: String) {
        self.normalizedRect = normalizedRect
        self.imageName = imageName
        self.accessibilityLabel = accessibilityLabel
    }

    var body: some View {
        GeometryReader { proxy in
            if let image = referenceImage, let croppedImage = croppedImage(from: image) {
                // Crop the source pixels first so a narrow panel can never reveal neighboring artwork
                // when it is fitted into a wider page frame.
                Image(uiImage: croppedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .accessibilityLabel(accessibilityLabel)
            } else {
                AppColors.artifactField
                    .accessibilityLabel("Reference artwork unavailable")
            }
        }
        .clipped()
    }

    private var referenceImage: UIImage? {
        guard let url = Bundle.main.url(forResource: imageName, withExtension: "png")
            ?? Bundle.main.url(forResource: URL(fileURLWithPath: imageName).lastPathComponent, withExtension: "png") else {
            return nil
        }
        return UIImage(contentsOfFile: url.path)
    }

    /// Extracts only the requested normalized panel from the bundled reference image.
    private func croppedImage(from image: UIImage) -> UIImage? {
        guard let source = image.cgImage else { return nil }
        let sourceSize = CGSize(width: source.width, height: source.height)
        let requestedRect = CGRect(
            x: normalizedRect.minX * sourceSize.width,
            y: normalizedRect.minY * sourceSize.height,
            width: normalizedRect.width * sourceSize.width,
            height: normalizedRect.height * sourceSize.height
        ).integral.intersection(CGRect(origin: .zero, size: sourceSize))
        guard requestedRect.width > 0, requestedRect.height > 0,
              let croppedSource = source.cropping(to: requestedRect) else { return nil }
        return UIImage(cgImage: croppedSource, scale: image.scale, orientation: image.imageOrientation)
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

                    utilitySection("Your Library") {
                        utilityLink("Your Progress", detail: "Learning and saved items on this device", systemImage: "person") {
                            AccountView(dependencies: dependencies)
                        }
                    }

                    utilitySection("About") {
                        utilityLink("About Script Roots", detail: "App information and developer details", systemImage: "info.circle") {
                            AboutMethodView(corpusCount: dependencies.installedSharedCharacterCount)
                        }
                        utilityLink("Sources & Licenses", detail: "Evidence, attribution, and licenses", systemImage: "doc.text.magnifyingglass") {
                            SourcesLicensesView(dependencies: dependencies)
                        }
                    }

                    utilitySection("Support") {
                        utilityLink("Send Feedback", detail: "Share thoughts about the museum experience", systemImage: "bubble.left.and.bubble.right") {
                            FeedbackView()
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

/// Shows the small set of external references that matter to the museum experience.
struct SourcesLicensesView: View {
    let dependencies: AppDependencies

    /// Filters technical and generated provenance out of the readable source list.
    /// Record-level IDs remain untouched in the corpus and Symbol detail sheets.
    private var visibleSources: [VisibleSource] {
        var unique: [String: CorpusSource] = [:]
        for source in dependencies.sharedCharacters.flatMap(\.sources) {
            let type = source.type.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            guard type == "research" || type == "historical-asset" else { continue }
            let key = canonicalSourceKey(for: source)
            if unique[key] == nil {
                unique[key] = source
            }
        }
        return unique
            .map { key, source in
                if key == "zdic" {
                    return VisibleSource(
                        id: key,
                        title: "漢典 / ZDIC",
                        citation: "Historical reference images used for the museum timeline and representative forms.",
                        url: "https://zdic.net/"
                    )
                }
                return VisibleSource(
                    id: key,
                    title: source.label,
                    citation: source.citation,
                    url: source.url
                )
            }
            .sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
    }

    var body: some View {
        List {
            Section {
                Text("These are the historical and research references used for the museum timeline and representative forms.")
                    .font(AppTypography.body)
                    .foregroundStyle(AppColors.textSecondary)
            }

            Section("Historical and research references") {
                ForEach(visibleSources) { source in
                    sourceRow(source)
                }
            }
            if visibleSources.isEmpty {
                Text("Source information is not available for this content yet.")
                    .font(AppTypography.body)
                    .foregroundStyle(AppColors.textSecondary)
            }

            Section("Licensing") {
                Text("Rights and technical notices are kept separately from the museum's readable source list.")
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textSecondary)
                NavigationLink("Legal notices & licenses") {
                    LegalNoticesView()
                }
            }
        }
        .navigationTitle("Sources & Licenses")
        .scrollContentBackground(.hidden)
        .background(AppColors.appBackground.ignoresSafeArea())
        .tint(AppColors.accentPrimary)
    }

    /// Keeps source rows concise while preserving a direct reference link when one exists.
    @ViewBuilder
    private func sourceRow(_ source: VisibleSource) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.space2xs) {
            Text(source.title)
                .font(AppTypography.body.weight(.semibold))
                .foregroundStyle(AppColors.textPrimary)
            Text(source.citation)
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.textSecondary)
            if let urlString = source.url, let url = URL(string: urlString) {
                Link("Open reference", destination: url)
                    .font(AppTypography.caption)
            }
        }
        .padding(.vertical, AppSpacing.spaceXs)
        .listRowBackground(Color.clear)
    }

    private struct VisibleSource: Identifiable {
        let id: String
        let title: String
        let citation: String
        let url: String?
    }

    /// Treats per-character ZDIC identifiers as one visible historical-image source.
    private func canonicalSourceKey(for source: CorpusSource) -> String {
        let identity = "\(source.id) \(source.label)".lowercased()
        if identity.contains("zdic") || identity.contains("漢典") || identity.contains("汉典") {
            return "zdic"
        }
        if identity.contains("apple") && identity.contains("speech") {
            return "apple-speech"
        }
        return source.id.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }
}

/// Keeps exhaustive rights language separate from the readable source overview.
private struct LegalNoticesView: View {
    var body: some View {
        List {
            Section("Historical references") {
                Text("Historical image selections are retained with their source and asset provenance. Copied ZDIC reference images require reuse permission or cleared replacements before commercial distribution.")
            }
            Section("Fonts") {
                Text("Regular Script uses CNS11643 Kai. Modern Chinese, Japanese, and Korean forms use the bundled Adobe Source Han Serif locale faces. Refer to the bundled font notices for the applicable license terms.")
            }
            Section("Speech") {
                Text("Pronunciation playback uses Apple's system speech-synthesis technology. No audio files are bundled by the app.")
            }
            Section("Third-party notices") {
                Text("The full source URLs, attribution details, and license terms used by the current content package are maintained with the app's bundled provenance records.")
            }
        }
        .navigationTitle("Legal Notices")
        .scrollContentBackground(.hidden)
        .background(AppColors.appBackground.ignoresSafeArea())
        .tint(AppColors.accentPrimary)
    }
}
