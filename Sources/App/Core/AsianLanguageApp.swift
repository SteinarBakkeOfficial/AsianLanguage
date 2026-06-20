import SwiftUI

/// App entry point for the V1 SwiftUI shell.
/// Uses live local dependencies for bundled corpus reading and writable user state.
@main
struct AsianLanguageApp: App {
    /// Shared app dependencies injected into the SwiftUI environment.
    private let dependencies = AppDependencies.live

    var body: some Scene {
        WindowGroup {
            RootTabView(dependencies: dependencies)
        }
    }
}
