import SwiftUI

struct PaywallCTAView: View {
    let feature: PaywallFeature

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: feature.icon)
                .font(.system(size: 20, weight: .bold))
                .frame(width: 44, height: 44)
                .background(Circle().fill(UniColor.primary.opacity(0.1)))
                .foregroundColor(UniColor.primary)
            VStack(alignment: .leading, spacing: 4) {
                Text(feature.title)
                    .font(UniTypography.bodyBold)
                Text(feature.description)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(UniColor.surface))
        .cardShadow()
    }
}
