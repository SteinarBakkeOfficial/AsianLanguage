import SwiftUI

/// App entry point for the V1 SwiftUI shell.
/// Replace the placeholder dependencies here when local corpus and user-state services are implemented.
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
