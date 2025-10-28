import SwiftUI

struct MatchListView: View {
    @StateObject private var viewModel: MatchViewModel

    init(environment: AppEnvironment) {
        _viewModel = StateObject(wrappedValue: MatchViewModel(apiClient: environment.apiClient))
    }

    var body: some View {
        NavigationStack {
            List {
                if viewModel.matches.isEmpty {
                    EmptyStateView(icon: "heart.slash", title: "matches_empty_title", message: "matches_empty_message")
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                } else {
                    ForEach(viewModel.matches) { match in
                        NavigationLink(destination: MatchDetailView(match: match)) {
                            HStack(spacing: 16) {
                                AvatarView(url: match.profile.photos.first, anonymityMode: match.profile.anonymityMode)
                                VStack(alignment: .leading) {
                                    Text(match.profile.name)
                                        .font(UniTypography.bodyBold)
                                    Text(match.lastMessage?.content ?? "matches_start_chat")
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Text(match.matchedAt, style: .time)
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 8)
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle(Text("matches_tab"))
            .task {
                await viewModel.load()
            }
        }
    }
}
