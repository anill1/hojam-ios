import SwiftUI

@main
struct UniApp: App {
    @State private var environment: AppEnvironment

    init() {
        let apiClient = MockAPIClient()
        _environment = State(initialValue: AppEnvironment(
            apiClient: apiClient,
            tokenStore: KeychainTokenStore(),
            preferences: InMemoryPreferencesStore(),
            analytics: NoOpAnalyticsClient(),
            remoteConfig: RemoteConfigService(apiClient: apiClient),
            haptics: DefaultHapticsClient(),
            storeKit: DefaultStoreKitClient()
        ))
    }

    var body: some Scene {
        WindowGroup {
            RootContentView()
                .environment(\.$appEnvironment, environment)
        }
    }
}
