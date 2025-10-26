import SwiftUI

struct SwipeFlowView: View {
    @StateObject private var viewModel: SwipeViewModel
    private let environment: AppEnvironment
    @State private var translation: CGSize = .zero
    @State private var showFilters = false

    init(environment: AppEnvironment) {
        self.environment = environment
        _viewModel = StateObject(wrappedValue: SwipeViewModel(
            apiClient: environment.apiClient,
            remoteConfig: environment.remoteConfig,
            haptics: environment.haptics
        ))
    }

    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                header
                cardStack
                controls
            }
            .padding()
            .task { await viewModel.load() }

            if let match = viewModel.match {
                MatchModalView(match: match) {
                    viewModel.match = nil
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
        .sheet(isPresented: $showFilters) {
            SwipeFilterView(filter: $viewModel.filter) {
                showFilters = false
                Task { await viewModel.refreshCards() }
            }
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("discover_title")
                    .font(UniTypography.titleMedium)
                Text(String(format: NSLocalizedString("swipe_remaining", comment: ""), viewModel.remainingSwipes, viewModel.swipeLimit))
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Button {
                showFilters.toggle()
            } label: {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .font(.system(size: 24))
            }
            .accessibilityLabel(Text("filters_button"))
        }
    }

    private var cardStack: some View {
        ZStack {
            ForEach(viewModel.cards.indices.reversed(), id: \.self) { index in
                cardView(for: index)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func cardView(for index: Int) -> some View {
        let card = viewModel.cards[index]
        let isTop = index == viewModel.currentIndex
        return SwipeCardView(card: card) {
            HStack {
                ForEach(card.profile.interests) { interest in
                    TagChip(interest.title)
                }
            }
        }
        .offset(x: isTop ? translation.width : 0, y: isTop ? translation.height : CGFloat(index - viewModel.currentIndex) * 8)
        .rotationEffect(.degrees(isTop ? Double(translation.width / 15) : 0))
        .scaleEffect(isTop ? 1 : 0.95)
        .animation(.spring(response: 0.45, dampingFraction: 0.86, blendDuration: 0.25), value: translation)
        .gesture(
            DragGesture()
                .onChanged { value in
                    guard isTop else { return }
                    translation = value.translation
                }
                .onEnded { value in
                    guard isTop else { return }
                    handleDragEnd(value: value)
                }
        )
    }

    private func handleDragEnd(value: DragGesture.Value) {
        let threshold: CGFloat = 120
        if value.translation.width > threshold {
            withAnimation(.spring()) {
                translation = .zero
            }
            Task { await viewModel.performSwipe(isLike: true) }
        } else if value.translation.width < -threshold {
            withAnimation(.spring()) {
                translation = .zero
            }
            Task { await viewModel.performSwipe(isLike: false) }
        } else {
            withAnimation(.interactiveSpring()) {
                translation = .zero
            }
        }
    }

    private var controls: some View {
        HStack(spacing: 48) {
            IconButton(systemName: "xmark") {
                withAnimation(.spring()) {
                    translation = CGSize(width: -200, height: 0)
                }
                Task {
                    await viewModel.performSwipe(isLike: false)
                    await MainActor.run {
                        translation = .zero
                    }
                }
            }
            IconButton(systemName: "arrow.uturn.backward.circle.fill", background: UniColor.accent) {
                viewModel.resetLimitIfNeeded()
            }
            IconButton(systemName: "heart.fill", background: UniColor.primary) {
                withAnimation(.spring()) {
                    translation = CGSize(width: 200, height: 0)
                }
                Task {
                    await viewModel.performSwipe(isLike: true)
                    await MainActor.run {
                        translation = .zero
                    }
                }
            }
        }
        .padding(.bottom, 16)
    }
}
