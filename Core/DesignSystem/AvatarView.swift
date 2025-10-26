import SwiftUI

struct AvatarView: View {
    let url: URL?
    let size: CGFloat
    let anonymityMode: UserProfile.AnonymityMode

    @StateObject private var loader: ImageLoader

    init(url: URL?, size: CGFloat = 64, anonymityMode: UserProfile.AnonymityMode = .visible) {
        self.url = url
        self.size = size
        self.anonymityMode = anonymityMode
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
    }

    var body: some View {
        ZStack {
            if let image = loader.image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(Circle())
                    .overlay(overlayView)
            } else {
                Circle()
                    .fill(UniColor.secondary.opacity(0.2))
                    .frame(width: size, height: size)
                    .overlay(overlayView)
                    .overlay(
                        ProgressView()
                    )
            }
        }
        .onAppear { loader.load() }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text("avatar"))
    }

    @ViewBuilder
    private var overlayView: some View {
        switch anonymityMode {
        case .visible:
            EmptyView()
        case .blurred:
            Circle()
                .fill(Color.black.opacity(0.35))
        case .emoji:
            Text("😎")
                .font(.system(size: size / 2))
        }
    }
}
