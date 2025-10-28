import Foundation

protocol APIClient {
    func fetchSwipeCards(filter: SwipeFilter) async throws -> [SwipeCard]
    func submitSwipe(cardID: UUID, isLike: Bool) async throws -> MatchItem?
    func fetchMatches() async throws -> [MatchItem]
    func fetchMessages(for matchID: UUID) async throws -> [ChatMessage]
    func send(message: ChatMessage, for matchID: UUID) async throws
    func update(profile: UserProfile) async throws -> UserProfile
    func fetchCurrentProfile() async throws -> UserProfile
    func loadRemoteConfig() async throws -> RemoteConfigPayload
}

struct RemoteConfigPayload: Codable {
    struct PaywallCopy: Codable {
        let headline: String
        let subtitle: String
        let cta: String
    }

    let paywallCopy: PaywallCopy
    let swipeLimit: Int
}

final class MockAPIClient: APIClient {
    private var swipeCards: [SwipeCard]
    private var matches: [MatchItem]
    private var messages: [UUID: [ChatMessage]]
    private var profile: UserProfile
    private var config: RemoteConfigPayload

    init() {
        let tags = ["Kampüs Kahvesi", "Hackathon", "Basketbol", "Girişimcilik"].map { InterestTag(title: $0) }
        let sampleProfiles = (0 ..< 12).map { index -> UserProfile in
            UserProfile(
                name: "Öğrenci \(index + 1)",
                age: 20 + (index % 4),
                faculty: index % 2 == 0 ? "Mühendislik" : "İktisat",
                department: index % 2 == 0 ? "Bilgisayar" : "İşletme",
                bio: "Kampüste yeni kahve dükkanı keşfetmeye var mısın?",
                interests: Array(tags.shuffled().prefix(3)),
                photos: [URL(string: "https://picsum.photos/id/\(index + 40)/400/600")!],
                anonymityMode: index % 3 == 0 ? .blurred : .visible
            )
        }

        swipeCards = sampleProfiles.map { profile in
            SwipeCard(
                profile: profile,
                distance: Int.random(in: 0 ... 5),
                isAnonymous: profile.anonymityMode != .visible
            )
        }

        matches = []
        messages = [:]
        profile = sampleProfiles.first ?? UserProfile(
            name: "Sen",
            age: 22,
            faculty: "Mühendislik",
            department: "Bilgisayar",
            bio: "SwiftUI ile geleceği tasarlıyorum",
            interests: tags,
            photos: [URL(string: "https://picsum.photos/id/1/400/600")!],
        )
        config = RemoteConfigPayload(
            paywallCopy: .init(
                headline: "Üniversitede fark yarat!",
                subtitle: "Plus ile seni beğenenleri gör, geri al ve Boost ile öne çık.",
                cta: "Plus’a Katıl",
            ),
            swipeLimit: 20,
        )
    }

    func fetchSwipeCards(filter: SwipeFilter) async throws -> [SwipeCard] {
        try await Task.sleep(for: .milliseconds(250))
        return swipeCards.filter { card in
            filter.faculties.isEmpty || filter.faculties.contains(card.profile.faculty)
        }
    }

    func submitSwipe(cardID: UUID, isLike: Bool) async throws -> MatchItem? {
        try await Task.sleep(for: .milliseconds(150))
        guard let index = swipeCards.firstIndex(where: { $0.id == cardID }) else { return nil }
        let card = swipeCards.remove(at: index)
        if isLike && Bool.random() {
            let match = MatchItem(
                id: UUID(),
                profile: card.profile,
                lastMessage: nil,
                matchedAt: Date()
            )
            matches.insert(match, at: 0)
            return match
        }
        return nil
    }

    func fetchMatches() async throws -> [MatchItem] {
        try await Task.sleep(for: .milliseconds(200))
        return matches
    }

    func fetchMessages(for matchID: UUID) async throws -> [ChatMessage] {
        try await Task.sleep(for: .milliseconds(120))
        if messages[matchID] == nil {
            messages[matchID] = [
                ChatMessage(
                    id: UUID(),
                    sender: .other,
                    content: "Selam! Kampüs festivaline gidecek misin?",
                    sentAt: Date().addingTimeInterval(-3600)
                ),
                ChatMessage(
                    id: UUID(),
                    sender: .me,
                    content: "Kesinlikle! Birlikte gidelim mi?",
                    sentAt: Date().addingTimeInterval(-1800)
                ),
            ]
        }
        return messages[matchID] ?? []
    }

    func send(message: ChatMessage, for matchID: UUID) async throws {
        try await Task.sleep(for: .milliseconds(80))
        messages[matchID, default: []].append(message)
    }

    func update(profile: UserProfile) async throws -> UserProfile {
        try await Task.sleep(for: .milliseconds(180))
        self.profile = profile
        return profile
    }

    func fetchCurrentProfile() async throws -> UserProfile {
        try await Task.sleep(for: .milliseconds(120))
        return profile
    }

    func loadRemoteConfig() async throws -> RemoteConfigPayload {
        try await Task.sleep(for: .milliseconds(100))
        return config
    }
}
