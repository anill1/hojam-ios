import SwiftUI

struct ChatDetailView: View {
    @StateObject private var viewModel: ChatViewModel

    init(match: MatchItem, environment: AppEnvironment) {
        _viewModel = StateObject(wrappedValue: ChatViewModel(match: match, apiClient: environment.apiClient))
    }

    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(viewModel.messages) { message in
                            bubble(for: message)
                                .id(message.id)
                        }
                    }
                    .padding()
                }
                .onChange(of: viewModel.messages.count) { _ in
                    if let last = viewModel.messages.last {
                        withAnimation {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
            }

            HStack {
                TextField("chat_input_placeholder", text: $viewModel.inputText)
                    .textFieldStyle(.roundedBorder)
                Button {
                    Task { await viewModel.send() }
                } label: {
                    Image(systemName: "paperplane.fill")
                }
                .disabled(viewModel.inputText.isEmpty)
            }
            .padding()
        }
        .navigationTitle(Text(String(format: NSLocalizedString("chat_with %1$@", comment: ""), viewModel.match.profile.name)))
        .task { await viewModel.load() }
    }

    private func bubble(for message: ChatMessage) -> some View {
        HStack {
            if message.sender == .me { Spacer() }
            Text(message.content)
                .padding(12)
                .background(message.sender == .me ? UniColor.primary : UniColor.surface)
                .foregroundColor(message.sender == .me ? .white : .primary)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            if message.sender == .other { Spacer() }
        }
    }
}
