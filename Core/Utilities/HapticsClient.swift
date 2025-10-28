import CoreHaptics
import UIKit

protocol HapticsClient {
    func play(_ event: HapticsEvent)
}

enum HapticsEvent {
    case like
    case pass
    case match
}

struct DefaultHapticsClient: HapticsClient {
    func play(_ event: HapticsEvent) {
        let generator: UINotificationFeedbackGenerator
        switch event {
        case .like:
            generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        case .pass:
            generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
        case .match:
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred(intensity: 0.8)
            return
        }
    }
}

struct NoOpHapticsClient: HapticsClient {
    func play(_ event: HapticsEvent) {}
}
