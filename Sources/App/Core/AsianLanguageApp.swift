import SwiftUI
import CoreText

/// App entry point for the V1 SwiftUI shell.
/// Uses live local dependencies for bundled corpus reading and writable user state.
@main
struct AsianLanguageApp: App {
    /// Shared app dependencies injected into the SwiftUI environment.
    private let dependencies: AppDependencies

    /// Observes the same shared store that Settings mutates so scene-level appearance updates immediately.
    @StateObject private var userStateStore: LocalUserStateStore

    init() {
        // Register only the small shell fonts before the first frame; large CJK faces load
        // when the Symbol journey needs them so launch remains responsive on-device.
        BundledFontRegistrar.registerCoreFonts()
        let liveDependencies = AppDependencies.live
        dependencies = liveDependencies
        _userStateStore = StateObject(wrappedValue: liveDependencies.userStateStore)
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if userStateStore.state.hasCompletedOnboarding {
                    RootTabView(dependencies: dependencies)
                } else {
                    OnboardingView(dependencies: dependencies)
                }
            }
            .preferredColorScheme(colorScheme)
        }
    }

    /// Maps the persisted appearance preference to the native SwiftUI API.
    private var colorScheme: ColorScheme? {
        switch userStateStore.state.appearancePreference {
        case .light: return .light
        case .dark: return .dark
        }
    }
}

/// Registers the local font files before SwiftUI resolves the shared typography tokens.
/// Keep this list in sync with Resources/Fonts when adding or removing app typefaces.
enum BundledFontRegistrar {
    private static let coreFontFiles = [
        ("PlayfairDisplay-Regular", "ttf"),
        ("PlayfairDisplay-Bold", "ttf"),
        ("Inter-Regular", "ttf"),
        ("Inter-Medium", "ttf"),
        ("Inter-SemiBold", "ttf")
    ]

    private static let museumFontFiles = [
        ("TW-Kai-98_1", "ttf"),
    ]

    private static let modernFontFiles = [
        ("SourceHanSerifJP-Regular", "otf"),
        ("SourceHanSerifKR-Regular", "otf"),
        ("SourceHanSerifSC-Regular", "otf"),
        ("SourceHanSerifTC-Regular", "otf")
    ]

    /// Registers the lightweight fonts used by the shell and onboarding screens.
    static func registerCoreFonts() {
        register(coreFontFiles)
    }

    /// Registers the Kai endpoint when a learner enters the Symbol journey.
    static func registerMuseumFonts() {
        register(museumFontFiles)
    }

    /// Registers locale-specific modern forms when the Today content is constructed.
    static func registerModernFonts() {
        register(modernFontFiles)
    }

    private static func register(_ fontFiles: [(String, String)]) {
        for (fontName, fileExtension) in fontFiles {
            guard let fontURL = Bundle.main.url(forResource: fontName, withExtension: fileExtension, subdirectory: "Fonts") else {
                continue
            }
            CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, nil)
        }
    }
}
