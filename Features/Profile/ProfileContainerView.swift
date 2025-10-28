import PhotosUI
import SwiftUI
import UIKit

struct ProfileContainerView: View {
    @StateObject private var viewModel: ProfileViewModel
    private let environment: AppEnvironment
    let onLogout: () -> Void

    init(environment: AppEnvironment, onLogout: @escaping () -> Void) {
        self.environment = environment
        self.onLogout = onLogout
        _viewModel = StateObject(wrappedValue: ProfileViewModel(apiClient: environment.apiClient))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    header
                    photoSection
                    formSection
                    anonymitySection
                    NavigationLink("settings_title") {
                        SettingsView(environment: environment)
                    }
                    PrimaryButton(viewModel.isLoading ? "loading" : "profile_save") {
                        Task { await viewModel.save() }
                    }
                    .disabled(viewModel.isLoading)

                    Button("logout_button", role: .destructive) {
                        onLogout()
                    }
                    .padding(.top, 8)
                }
                .padding()
            }
            .background(UniColor.background.ignoresSafeArea())
            .navigationTitle(Text("profile_tab"))
            .task { await viewModel.load() }
            .sheet(isPresented: $viewModel.showPaywall) {
                PaywallView(environment: environment)
            }
            .onChange(of: viewModel.photoItems) { _ in
                viewModel.handlePhotoSelection()
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("profile_headline")
                .font(UniTypography.titleMedium)
            Text("profile_subheadline")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }

    private var photoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("profile_photos")
                .font(UniTypography.bodyBold)
            PhotosPicker(selection: $viewModel.photoItems, maxSelectionCount: 1, matching: .images) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(UniColor.surface)
                        .frame(height: 220)
                        .overlay(
                            Group {
                                if let url = viewModel.profile.photos.first {
                                    if url.isFileURL, let data = try? Data(contentsOf: url), let uiImage = UIImage(data: data) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFill()
                                            .clipShape(RoundedRectangle(cornerRadius: 16))
                                    } else {
                                        AsyncImage(url: url) { phase in
                                            switch phase {
                                            case .empty:
                                                ProgressView()
                                            case let .success(image):
                                                image.resizable().scaledToFill()
                                            case .failure:
                                                Image(systemName: "photo")
                                            @unknown default:
                                                EmptyView()
                                            }
                                        }
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                    }
                                } else {
                                    VStack(spacing: 12) {
                                        Image(systemName: "camera.fill")
                                        Text("profile_add_photo")
                                    }
                                    .foregroundColor(.secondary)
                                }
                            }
                        )
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [6]))
                        .foregroundColor(UniColor.primary.opacity(0.4))
                }
            }
        }
    }

    private var formSection: some View {
        Group {
            TextField("profile_name_placeholder", text: $viewModel.profile.name)
                .textContentType(.name)
                .padding()
                .background(RoundedRectangle(cornerRadius: 16).fill(UniColor.surface))
            Stepper(value: $viewModel.profile.age, in: 18 ... 40) {
                Text(String(format: NSLocalizedString("profile_age %d", comment: ""), viewModel.profile.age))
            }
            TextField("profile_faculty_placeholder", text: $viewModel.profile.faculty)
                .padding()
                .background(RoundedRectangle(cornerRadius: 16).fill(UniColor.surface))
            TextField("profile_department_placeholder", text: $viewModel.profile.department)
                .padding()
                .background(RoundedRectangle(cornerRadius: 16).fill(UniColor.surface))
            TextField("profile_bio_placeholder", text: $viewModel.profile.bio, axis: .vertical)
                .lineLimit(3 ... 5)
                .padding()
                .background(RoundedRectangle(cornerRadius: 16).fill(UniColor.surface))
        }
    }

    private var anonymitySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Toggle("profile_anonymous_mode", isOn: Binding(
                get: { viewModel.profile.anonymityMode != .visible },
                set: { viewModel.profile.anonymityMode = $0 ? .blurred : .visible }
            ))

            if viewModel.profile.anonymityMode != .visible {
                Text("profile_anonymous_description")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }

            if !viewModel.profile.isPremium {
                Button("profile_upgrade") {
                    viewModel.showPaywall = true
                }
                .font(.footnote)
            }
        }
    }
}
