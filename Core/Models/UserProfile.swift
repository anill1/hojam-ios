import Foundation

struct UserProfile: Identifiable, Codable, Equatable {
    enum AnonymityMode: String, Codable {
        case visible
        case blurred
        case emoji
    }

    let id: UUID
    var name: String
    var age: Int
    var faculty: String
    var department: String
    var bio: String
    var interests: [InterestTag]
    var photos: [URL]
    var anonymityMode: AnonymityMode
    var isPremium: Bool

    init(
        id: UUID = UUID(),
        name: String,
        age: Int,
        faculty: String,
        department: String,
        bio: String,
        interests: [InterestTag],
        photos: [URL],
        anonymityMode: AnonymityMode = .visible,
        isPremium: Bool = false
    ) {
        self.id = id
        self.name = name
        self.age = age
        self.faculty = faculty
        self.department = department
        self.bio = bio
        self.interests = interests
        self.photos = photos
        self.anonymityMode = anonymityMode
        self.isPremium = isPremium
    }
}

struct InterestTag: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String

    init(id: UUID = UUID(), title: String) {
        self.id = id
        self.title = title
    }
}

struct SwipeCard: Identifiable, Codable, Equatable {
    let id: UUID
    var profile: UserProfile
    var distance: Int
    var isAnonymous: Bool

    init(id: UUID = UUID(), profile: UserProfile, distance: Int, isAnonymous: Bool) {
        self.id = id
        self.profile = profile
        self.distance = distance
        self.isAnonymous = isAnonymous
    }
}

struct MatchItem: Identifiable, Codable, Equatable {
    let id: UUID
    var profile: UserProfile
    var lastMessage: ChatMessage?
    var matchedAt: Date
}

struct ChatMessage: Identifiable, Codable, Equatable {
    enum Sender: Codable {
        case me
        case other
    }

    let id: UUID
    let sender: Sender
    var content: String
    var sentAt: Date
}

struct PaywallFeature: Identifiable, Equatable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
}

struct SwipeFilter: Equatable {
    var minAge: Int
    var maxAge: Int
    var faculties: [String]
    var interests: [InterestTag]
    var includeAnonymous: Bool

    static let `default` = SwipeFilter(minAge: 18, maxAge: 28, faculties: [], interests: [], includeAnonymous: true)
}
