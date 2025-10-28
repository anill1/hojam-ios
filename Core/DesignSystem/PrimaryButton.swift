import SwiftUI

struct PrimaryButton: View {
    let title: LocalizedStringKey
    let action: () -> Void

    init(_ title: LocalizedStringKey, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(UniTypography.bodyBold)
                .padding(.vertical, 14)
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 16).fill(UniColor.primary))
                .foregroundColor(.white)
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(.isButton)
    }
}
