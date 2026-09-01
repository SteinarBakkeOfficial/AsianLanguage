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
        BundledFontRegistrar.register()
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

    /// Maps the persisted neutral preference to the native SwiftUI appearance API.
    private var colorScheme: ColorScheme? {
        switch userStateStore.state.appearancePreference {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}

/// Registers the local font files before SwiftUI resolves the shared typography tokens.
/// Keep this list in sync with Resources/Fonts when adding or removing app typefaces.
private enum BundledFontRegistrar {
    private static let fontNames = [
        "PlayfairDisplay-Regular",
        "PlayfairDisplay-Bold",
        "Inter-Regular",
        "Inter-Medium",
        "Inter-SemiBold"
    ]

    static func register() {
        for fontName in fontNames {
            guard let fontURL = Bundle.main.url(forResource: fontName, withExtension: "ttf", subdirectory: "Fonts") else {
                continue
            }
            CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, nil)
        }
    }
}
