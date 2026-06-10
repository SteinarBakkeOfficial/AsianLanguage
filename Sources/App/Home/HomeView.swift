import SwiftUI

/// Home screen for resume state and the next featured Shared Character.
struct HomeView: View {
    /// Shared app dependencies used by the shell until real stores exist.
    let dependencies: AppDependencies

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("New Symbol")
                            .font(.headline)
                        Text("木")
                            .font(.system(size: 56, weight: .regular, design: .serif))
                        Text("Tree / wood")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }

                Section("Corpus") {
                    LabeledContent("Installed", value: dependencies.installedCorpusName)
                    LabeledContent("Shared Characters", value: "\(dependencies.installedSharedCharacterCount)")
                }
            }
            .navigationTitle("Home")
        }
    }
}
