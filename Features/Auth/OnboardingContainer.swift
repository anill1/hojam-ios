import SwiftUI

struct OnboardingContainer: View {
    @StateObject private var viewModel: OnboardingViewModel
    let completion: (String) -> Void

    init(completion: @escaping (String) -> Void) {
        self.completion = completion
        _viewModel = StateObject(wrappedValue: OnboardingViewModel())
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                TabView(selection: $viewModel.currentPage) {
                    ForEach(OnboardingViewModel.Page.allCases) { page in
                        OnboardingPageView(page: page)
                            .tag(page)
                            .padding(.horizontal, 32)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .automatic))
                .frame(maxHeight: 360)

                PrimaryButton(viewModel.primaryButtonTitle) {
                    viewModel.advance()
                }
                .padding(.horizontal, 24)

                Button(viewModel.secondaryButtonTitle) {
                    viewModel.showAuth = true
                }
                .font(.footnote)
                .padding(.bottom)
            }
            .navigationDestination(isPresented: $viewModel.showAuth) {
                AuthSignInView { token in
                    completion(token)
                }
            }
            .navigationTitle(Text("onboarding_title"))
            .background(UniColor.background.ignoresSafeArea())
        }
    }
}

private struct OnboardingPageView: View {
    let page: OnboardingViewModel.Page

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: page.icon)
                .font(.system(size: 72))
                .foregroundColor(UniColor.primary)
            Text(LocalizedStringKey(page.titleKey))
                .font(UniTypography.titleMedium)
                .multilineTextAlignment(.center)
            Text(LocalizedStringKey(page.subtitleKey))
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
    }
}
