import Foundation

@MainActor
final class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var inputText: String = ""
    private let apiClient: APIClient
    let match: MatchItem

    init(match: MatchItem, apiClient: APIClient) {
        self.match = match
        self.apiClient = apiClient
    }

    func load() async {
        do {
            messages = try await apiClient.fetchMessages(for: match.id)
        } catch {}
    }

    func send() async {
        guard !inputText.isEmpty else { return }
        let message = ChatMessage(id: UUID(), sender: .me, content: inputText, sentAt: Date())
        messages.append(message)
        inputText = ""
        try? await apiClient.send(message: message, for: match.id)
    }
}
