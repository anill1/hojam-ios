import Foundation

@MainActor
final class OnboardingViewModel: ObservableObject {
    enum Page: Int, CaseIterable, Identifiable {
        case community
        case privacy
        case premium

        var id: Int { rawValue }

        var icon: String {
            switch self {
            case .community:
                "person.3.fill"
            case .privacy:
                "lock.shield.fill"
            case .premium:
                "sparkles"
            }
        }

        var titleKey: String {
            switch self {
            case .community:
                "onboarding_community_title"
            case .privacy:
                "onboarding_privacy_title"
            case .premium:
                "onboarding_premium_title"
            }
        }

        var subtitleKey: String {
            switch self {
            case .community:
                "onboarding_community_subtitle"
            case .privacy:
                "onboarding_privacy_subtitle"
            case .premium:
                "onboarding_premium_subtitle"
            }
        }
    }

    @Published var currentPage: Page = .community
    @Published var showAuth = false

    var primaryButtonTitle: LocalizedStringKey {
        currentPage == .premium ? "onboarding_get_started" : "onboarding_next"
    }

    var secondaryButtonTitle: LocalizedStringKey {
        "onboarding_sign_in"
    }

    func advance() {
        if let index = Page.allCases.firstIndex(of: currentPage), index < Page.allCases.count - 1 {
            currentPage = Page.allCases[index + 1]
        } else {
            showAuth = true
        }
    }
}
