import SwiftUI

struct AuthSignInView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AuthSignInViewModel()
    let completion: (String) -> Void

    var body: some View {
        VStack(spacing: 24) {
            Text("auth_title")
                .font(UniTypography.titleMedium)
                .padding(.top, 32)

            switch viewModel.step {
            case .providers:
                providerButtons
            case .emailVerification:
                emailVerification
            case .waiting:
                waitingView
            }

            Spacer()
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("close_button", role: .cancel) { dismiss() }
            }
        }
        .animation(.easeInOut, value: viewModel.step)
        .background(UniColor.background.ignoresSafeArea())
    }

    private var providerButtons: some View {
        VStack(spacing: 16) {
            PrimaryButton("auth_continue_apple") {
                viewModel.selectProvider()
            }
            PrimaryButton("auth_continue_google") {
                viewModel.selectProvider()
            }
            Button("auth_use_email") {
                viewModel.step = .emailVerification
            }
            .font(.footnote)
        }
    }

    private var emailVerification: some View {
        VStack(spacing: 16) {
            TextField("auth_email_placeholder", text: $viewModel.email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .padding()
                .background(RoundedRectangle(cornerRadius: 16).fill(UniColor.surface))
            if let message = viewModel.message {
                Text(message)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            PrimaryButton(viewModel.isLoading ? "loading" : "auth_send_magic_link") {
                Task { await viewModel.submitEmail() }
            }
            .disabled(viewModel.isLoading)
        }
    }

    private var waitingView: some View {
        VStack(spacing: 16) {
            ProgressView()
            Text(viewModel.message ?? "")
                .font(.footnote)
                .foregroundColor(.secondary)
            PrimaryButton("auth_continue_app") {
                completion(UUID().uuidString)
            }
        }
    }
}
