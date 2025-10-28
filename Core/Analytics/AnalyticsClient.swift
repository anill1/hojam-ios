import Foundation

protocol AnalyticsClient {
    func track(event: AnalyticsEvent)
}

struct AnalyticsEvent {
    let name: String
    let parameters: [String: AnyHashable]
}

struct NoOpAnalyticsClient: AnalyticsClient {
    func track(event: AnalyticsEvent) {}
}
