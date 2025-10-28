import Combine
import Foundation

@MainActor
final class AppRootViewModel: ObservableObject {
    enum Flow {
        case onboarding
        case main
    }

    @Published private(set) var flow: Flow = .onboarding

    private let tokenStore: TokenStore

    init(tokenStore: TokenStore) {
        self.tokenStore = tokenStore
        if tokenStore.loadToken() != nil {
            flow = .main
        }
    }

    func completeOnboarding(with token: String) {
        tokenStore.save(token: token)
        flow = .main
    }

    func logout() {
        tokenStore.save(token: nil)
        flow = .onboarding
    }
}
