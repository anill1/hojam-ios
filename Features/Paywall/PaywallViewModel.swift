import Foundation
import StoreKit

@MainActor
final class PaywallViewModel: ObservableObject {
    enum State {
        case loading
        case loaded([Product])
        case failed
    }

    @Published var state: State = .loading
    @Published var isProcessingPurchase = false
    @Published var copy: RemoteConfigPayload.PaywallCopy = .init(
        headline: NSLocalizedString("paywall_headline", comment: ""),
        subtitle: NSLocalizedString("paywall_subheadline", comment: ""),
        cta: NSLocalizedString("paywall_manage_subscription", comment: "")
    )

    private let storeKit: StoreKitClient
    private let analytics: AnalyticsClient
    private let remoteConfig: RemoteConfigClient
    private let features: [PaywallFeature] = [
        PaywallFeature(
            icon: "goforward",
            title: NSLocalizedString("paywall_rewind_title", comment: ""),
            description: NSLocalizedString("paywall_rewind_desc", comment: "")
        ),
        PaywallFeature(
            icon: "eye",
            title: NSLocalizedString("paywall_who_likes_title", comment: ""),
            description: NSLocalizedString("paywall_who_likes_desc", comment: "")
        ),
        PaywallFeature(
            icon: "bolt.fill",
            title: NSLocalizedString("paywall_boost_title", comment: ""),
            description: NSLocalizedString("paywall_boost_desc", comment: "")
        ),
    ]

    var featureList: [PaywallFeature] { features }

    init(storeKit: StoreKitClient, analytics: AnalyticsClient, remoteConfig: RemoteConfigClient) {
        self.storeKit = storeKit
        self.analytics = analytics
        self.remoteConfig = remoteConfig
    }

    func load() async {
        do {
            if let config = try? await remoteConfig.fetchConfig() {
                copy = config.paywallCopy
            }
            let products = try await storeKit.loadProducts()
            state = .loaded(products.sorted(by: { $0.displayPrice < $1.displayPrice }))
            analytics.track(event: AnalyticsEvent(name: "paywall_view", parameters: [:]))
        } catch {
            state = .failed
        }
    }

    func purchase(product: Product) async {
        isProcessingPurchase = true
        defer { isProcessingPurchase = false }
        do {
            _ = try await storeKit.purchase(product: product)
            analytics.track(event: AnalyticsEvent(name: "purchase", parameters: ["productID": product.id]))
        } catch {
            analytics.track(event: AnalyticsEvent(name: "purchase_failed", parameters: ["productID": product.id]))
        }
    }
}
