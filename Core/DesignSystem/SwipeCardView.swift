import SwiftUI

struct SwipeCardView<Footer: View>: View {
    let card: SwipeCard
    let footer: Footer

    @StateObject private var imageLoader: ImageLoader

    init(card: SwipeCard, @ViewBuilder footer: () -> Footer) {
        self.card = card
        self.footer = footer()
        _imageLoader = StateObject(wrappedValue: ImageLoader(url: card.profile.photos.first))
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 24)
                .fill(UniColor.surface)
                .overlay(backgroundView)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .cardShadow()

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("\(card.profile.name), \(card.profile.age)")
                        .font(UniTypography.titleSmall)
                        .foregroundColor(.white)
                    Spacer()
                    TagChip("\(card.distance) km", isSelected: true)
                        .foregroundColor(.white)
                }
                Text(card.profile.bio)
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .lineLimit(2)
                footer
            }
            .padding(20)
        }
        .frame(maxWidth: .infinity, minHeight: 420, maxHeight: 520)
        .onAppear { imageLoader.load() }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text("profile_card_accessibility_label"))
    }

    @ViewBuilder
    private var backgroundView: some View {
        if let image = imageLoader.image {
            image
                .resizable()
                .scaledToFill()
                .overlay(overlayMask)
        } else {
            LinearGradient(
                colors: [UniColor.primary, UniColor.secondary],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .overlay(overlayMask)
        }
    }

    private var overlayMask: some View {
        LinearGradient(
            colors: [Color.black.opacity(0.1), Color.black.opacity(0.65)],
            startPoint: .center,
            endPoint: .bottom
        )
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}
