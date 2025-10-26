import SwiftUI

struct MainTabView: View {
    @Environment(\.appEnvironment) private var environment
    @State private var selectedTab = 0
    let onLogout: () -> Void

    var body: some View {
        TabView(selection: $selectedTab) {
            SwipeFlowView(environment: environment)
                .tabItem {
                    Label("discover_tab", systemImage: "flame.fill")
                }
                .tag(0)

            MatchListView(environment: environment)
                .tabItem {
                    Label("matches_tab", systemImage: "heart.circle")
                }
                .tag(1)

            ChatListView(environment: environment)
                .tabItem {
                    Label("chats_tab", systemImage: "bubble.left.and.bubble.right.fill")
                }
                .tag(2)

            ProfileContainerView(environment: environment, onLogout: onLogout)
                .tabItem {
                    Label("profile_tab", systemImage: "person.circle")
                }
                .tag(3)
        }
        .accentColor(UniColor.primary)
    }
}
