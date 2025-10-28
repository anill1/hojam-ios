import SwiftUI

extension View {
    func cardShadow() -> some View {
        shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 8)
    }

    func accessibleLabel(_ text: String) -> some View {
        accessibilityLabel(Text(text))
    }
}
