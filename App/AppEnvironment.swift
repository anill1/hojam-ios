import Foundation

struct AppEnvironment {
    var apiClient: APIClient
    var tokenStore: TokenStore
    var preferences: PreferencesStore
    var analytics: AnalyticsClient
    var remoteConfig: RemoteConfigClient
    var haptics: HapticsClient
    var storeKit: StoreKitClient
}

extension AppEnvironment {
    static let mock: AppEnvironment = {
        let api = MockAPIClient()
        return AppEnvironment(
            apiClient: api,
            tokenStore: InMemoryTokenStore(),
            preferences: InMemoryPreferencesStore(),
            analytics: NoOpAnalyticsClient(),
            remoteConfig: RemoteConfigService(apiClient: api),
            haptics: NoOpHapticsClient(),
            storeKit: MockStoreKitClient()
        )
    }()
}

private final class InMemoryTokenStore: TokenStore {
    private var token: String?

    func save(token: String?) {
        self.token = token
    }

    func loadToken() -> String? {
        token
    }
}
