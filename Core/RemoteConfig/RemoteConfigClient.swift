import Foundation

protocol RemoteConfigClient {
    func fetchConfig() async throws -> RemoteConfigPayload
}

struct RemoteConfigService: RemoteConfigClient {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func fetchConfig() async throws -> RemoteConfigPayload {
        try await apiClient.loadRemoteConfig()
    }
}
