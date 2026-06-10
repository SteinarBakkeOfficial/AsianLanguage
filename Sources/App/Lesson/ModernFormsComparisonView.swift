import SwiftUI

/// Reusable comparison of the modern focus-track forms for one Shared Character.
struct ModernFormsComparisonView: View {
    /// Bundled Shared Character record being studied.
    let record: SharedCharacterRecord

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            formRow(title: "Simplified Chinese", form: record.focusCoverage.simplifiedChinese.form)
            formRow(title: "Traditional Chinese", form: record.focusCoverage.traditionalChinese.form)
            formRow(title: "Japanese", form: record.focusCoverage.japanese.form)
            formRow(title: "Korean", form: record.focusCoverage.korean.form)
        }
    }

    /// One modern focus-track form row.
    private func formRow(title: String, form: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(form)
                .font(.system(size: 28, weight: .regular, design: .serif))
        }
    }
}
