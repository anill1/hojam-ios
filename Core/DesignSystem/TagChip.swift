import SwiftUI

struct TagChip: View {
    let text: String
    let isSelected: Bool

    init(_ text: String, isSelected: Bool = false) {
        self.text = text
        self.isSelected = isSelected
    }

    var body: some View {
        Text(text)
            .font(.footnote)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(isSelected ? UniColor.accent.opacity(0.2) : UniColor.surface)
            )
            .overlay(
                Capsule()
                    .stroke(isSelected ? UniColor.accent : UniColor.surface, lineWidth: 1)
            )
            .foregroundColor(isSelected ? UniColor.accent : .primary)
    }
}
