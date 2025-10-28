import SwiftUI

struct IconButton: View {
    let systemName: String
    let background: Color
    let action: () -> Void

    init(systemName: String, background: Color = UniColor.surface, action: @escaping () -> Void) {
        self.systemName = systemName
        self.background = background
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(Circle().fill(background))
                .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text(systemName))
    }
}
