import Foundation

@MainActor
final class MatchViewModel: ObservableObject {
    @Published var matches: [MatchItem] = []
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func load() async {
        do {
            matches = try await apiClient.fetchMatches()
        } catch {}
    }
}
