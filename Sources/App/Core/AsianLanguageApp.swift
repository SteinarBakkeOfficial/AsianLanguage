import SwiftUI

/// App entry point for the V1 SwiftUI shell.
/// Uses live local dependencies for bundled corpus reading and writable user state.
@main
struct AsianLanguageApp: App {
    /// Shared app dependencies injected into the SwiftUI environment.
    private let dependencies = AppDependencies.live

    var body: some Scene {
        WindowGroup {
            Group {
                if dependencies.userStateStore.state.hasCompletedOnboarding {
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
        switch dependencies.userStateStore.state.appearancePreference {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}
