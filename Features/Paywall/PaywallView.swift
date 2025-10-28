import SwiftUI
import StoreKit

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: PaywallViewModel

    init(environment: AppEnvironment) {
        _viewModel = StateObject(wrappedValue: PaywallViewModel(storeKit: environment.storeKit, analytics: environment.analytics, remoteConfig: environment.remoteConfig))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                header
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(viewModel.featureList) { feature in
                            PaywallCTAView(feature: feature)
                        }
                    }
                    .padding(.horizontal)
                }
                content
            }
            .padding(.vertical)
            .task { await viewModel.load() }
            .navigationTitle(Text("paywall_title"))
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("close_button", role: .cancel) { dismiss() }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }

    private var header: some View {
        VStack(spacing: 8) {
            Text(viewModel.copy.headline)
                .font(UniTypography.titleMedium)
            Text(viewModel.copy.subtitle)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            ProgressView()
        case .failed:
            EmptyStateView(icon: "wifi.slash", title: "paywall_error_title", message: "paywall_error_message")
        case .loaded(let products):
            VStack(spacing: 12) {
                ForEach(products) { product in
                    Button {
                        Task { await viewModel.purchase(product: product) }
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(product.displayName)
                                    .font(UniTypography.bodyBold)
                                Text(product.displayPrice)
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 16).fill(UniColor.surface))
                    }
                    .disabled(viewModel.isProcessingPurchase)
                }
                Link(viewModel.copy.cta, destination: URL(string: "https://support.apple.com/en-us/HT202039")!)
                    .font(.footnote)
                    .padding(.top, 8)
            }
            .padding(.horizontal)
        }
    }
}
