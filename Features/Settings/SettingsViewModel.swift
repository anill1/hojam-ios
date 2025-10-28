import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
    enum Language: String, CaseIterable, Identifiable {
        case system
        case english = "en"
        case turkish = "tr"

        var id: String { rawValue }

        var title: String {
            switch self {
            case .system:
                NSLocalizedString("settings_language_system", comment: "")
            case .english:
                "English"
            case .turkish:
                "Türkçe"
            }
        }
    }

    @Published var selectedLanguage: Language
    @Published var notificationsEnabled: Bool
    @Published var anonymousMode: Bool

    private let preferences: PreferencesStore

    init(preferences: PreferencesStore) {
        self.preferences = preferences
        let rawLanguage: String = preferences.load(for: "language", default: Language.system.rawValue)
        self.selectedLanguage = Language(rawValue: rawLanguage) ?? .system
        self.notificationsEnabled = preferences.load(for: "notifications", default: true)
        self.anonymousMode = preferences.load(for: "anonymousMode", default: false)
    }

    func save() {
        preferences.save(value: selectedLanguage.rawValue, for: "language")
        preferences.save(value: notificationsEnabled, for: "notifications")
        preferences.save(value: anonymousMode, for: "anonymousMode")
    }
}
