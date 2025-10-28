import Foundation

@MainActor
final class SwipeViewModel: ObservableObject {
    @Published var cards: [SwipeCard] = []
    @Published var currentIndex: Int = 0
    @Published var match: MatchItem?
    @Published var swipeLimit: Int = 20
    @Published var remainingSwipes: Int = 20
    @Published var filter: SwipeFilter = .default

    private let apiClient: APIClient
    private let remoteConfig: RemoteConfigClient
    private let haptics: HapticsClient

    init(apiClient: APIClient, remoteConfig: RemoteConfigClient, haptics: HapticsClient) {
        self.apiClient = apiClient
        self.remoteConfig = remoteConfig
        self.haptics = haptics
    }

    func load() async {
        do {
            let config = try await remoteConfig.fetchConfig()
            swipeLimit = config.swipeLimit
            remainingSwipes = config.swipeLimit
            cards = try await apiClient.fetchSwipeCards(filter: filter)
        } catch {
            // handle silently for mocks
        }
    }

    func refreshCards() async {
        do {
            cards = try await apiClient.fetchSwipeCards(filter: filter)
            currentIndex = 0
        } catch {}
    }

    func performSwipe(isLike: Bool) async {
        guard remainingSwipes > 0, currentIndex < cards.count else { return }
        let card = cards[currentIndex]
        currentIndex += 1
        remainingSwipes -= 1
        if isLike {
            haptics.play(.like)
        } else {
            haptics.play(.pass)
        }
        do {
            if let match = try await apiClient.submitSwipe(cardID: card.id, isLike: isLike) {
                self.match = match
                haptics.play(.match)
            }
        } catch {}
    }

    func resetLimitIfNeeded() {
        if remainingSwipes <= 0 {
            remainingSwipes = swipeLimit
        }
    }
}
