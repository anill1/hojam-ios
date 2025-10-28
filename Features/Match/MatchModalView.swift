import SwiftUI

struct MatchModalView: View {
    let match: MatchItem
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("match_title")
                .font(UniTypography.titleMedium)
            AvatarView(url: match.profile.photos.first, size: 120, anonymityMode: match.profile.anonymityMode)
            Text(String(format: NSLocalizedString("match_subtitle %1$@", comment: ""), match.profile.name))
                .font(.subheadline)
            PrimaryButton("match_start_chat") {
                onDismiss()
            }
            Button("close_button", role: .cancel) { onDismiss() }
                .font(.footnote)
        }
        .padding(32)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24))
        .shadow(radius: 32)
        .padding()
        .transition(.scale.combined(with: .opacity))
    }
}
