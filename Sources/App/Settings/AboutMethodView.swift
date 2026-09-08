import SwiftUI

/// Explains the teaching method without mixing in the global source inventory.
struct AboutMethodView: View {
    /// Number of Shared Character records installed in the bundled corpus.
    let corpusCount: Int

    var body: some View {
        List {
            Section("Learn the story, not an isolated shape") {
                Text("Script Roots follows characters from the ideas and structures behind their earliest surviving forms, through major historical writing traditions, and into the forms used today.")
            }

            Section("Characters changed over time") {
                Text("Ancient characters were never one perfectly standardized set of shapes. Different writers, regions, materials, and historical periods produced variation. Script Roots uses representative forms to make major stages of development understandable.")
            }

            Section("Materials shaped writing") {
                Text("Bone, bronze, bamboo, wood, silk, paper, brush writing, carving, printing, and digital typography all influenced how characters could be written and reproduced.")
            }

            Section("One history, several modern traditions") {
                Text("Shared historical characters developed differently in Chinese, Japanese, and Korean writing traditions. Script Roots shows both their common ancestry and the differences in modern form, pronunciation, and use.")
            }

            Section("Educational reconstruction") {
                Text("Illustrations are designed to clarify historical relationships rather than imitate a single surviving artifact exactly. Historical character forms are based on verified references wherever available.")
            }

            Section("Offline library") {
                LabeledContent("Characters available", value: "\(corpusCount)")
                Text("The core experience works offline with its bundled corpus and local assets.")
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }
        }
        .navigationTitle("About Script Roots")
        .scrollContentBackground(.hidden)
        .background(AppColors.appBackground.ignoresSafeArea())
        .tint(AppColors.accentPrimary)
    }
}
