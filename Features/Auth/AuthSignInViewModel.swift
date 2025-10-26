import Foundation

@MainActor
final class AuthSignInViewModel: ObservableObject {
    enum Step {
        case providers
        case emailVerification
        case waiting
    }

    @Published var step: Step = .providers
    @Published var email: String = ""
    @Published var isLoading = false
    @Published var message: String?

    let allowedDomains = ["edu", "university.edu", "campus.edu.tr"]

    func selectProvider() {
        step = .emailVerification
    }

    func submitEmail() async {
        guard isValidEmail else {
            message = NSLocalizedString("auth_invalid_email", comment: "")
            return
        }
        isLoading = true
        message = nil
        try? await Task.sleep(for: .seconds(1))
        isLoading = false
        step = .waiting
        message = NSLocalizedString("auth_magic_link_sent", comment: "")
    }

    var isValidEmail: Bool {
        guard let domain = email.split(separator: "@").last else { return false }
        return allowedDomains.contains { domain.hasSuffix($0) }
    }
}
