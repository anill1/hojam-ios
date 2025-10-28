import SwiftUI

struct RootContentView: View {
    @Environment(\.appEnvironment) private var environment
    @StateObject private var viewModel: AppRootViewModel

    init() {
        let tokenStore = KeychainTokenStore()
        _viewModel = StateObject(wrappedValue: AppRootViewModel(tokenStore: tokenStore))
    }

    var body: some View {
        Group {
            switch viewModel.flow {
            case .onboarding:
                OnboardingContainer { token in
                    viewModel.completeOnboarding(with: token)
                }
            case .main:
                MainTabView(onLogout: viewModel.logout)
            }
        }
        .environment(\.$appEnvironment, environment)
    }
}
