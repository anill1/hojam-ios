import SwiftUI

struct ChatListView: View {
    private let environment: AppEnvironment
    @State private var matches: [MatchItem] = []
    @State private var selectedMatch: MatchItem?

    init(environment: AppEnvironment) {
        self.environment = environment
    }

    var body: some View {
        NavigationStack {
            List(matches) { match in
                Button {
                    selectedMatch = match
                } label: {
                    HStack(spacing: 16) {
                        AvatarView(url: match.profile.photos.first, anonymityMode: match.profile.anonymityMode)
                        VStack(alignment: .leading) {
                            Text(match.profile.name)
                                .font(UniTypography.bodyBold)
                            Text(match.lastMessage?.content ?? "chat_placeholder")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Text(match.matchedAt, style: .time)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle(Text("chats_tab"))
            .task { await loadMatches() }
            .sheet(item: $selectedMatch) { match in
                ChatDetailView(match: match, environment: environment)
            }
        }
    }

    private func loadMatches() async {
        do {
            matches = try await environment.apiClient.fetchMatches()
        } catch {}
    }
}
