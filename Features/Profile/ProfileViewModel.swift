import Foundation
import PhotosUI
import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var profile: UserProfile
    @Published var isLoading = false
    @Published var photoItems: [PhotosPickerItem] = []
    @Published var showPaywall = false

    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
        self.profile = UserProfile(
            name: "",
            age: 20,
            faculty: "",
            department: "",
            bio: "",
            interests: [],
            photos: []
        )
    }

    func load() async {
        do {
            profile = try await apiClient.fetchCurrentProfile()
        } catch {}
    }

    func save() async {
        isLoading = true
        defer { isLoading = false }
        do {
            profile = try await apiClient.update(profile: profile)
        } catch {}
    }

    func handlePhotoSelection() {
        Task {
            guard let item = photoItems.first else { return }
            guard let data = try? await item.loadTransferable(type: Data.self) else { return }
            guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
                return
            }
            let tempURL = cachesDirectory.appendingPathComponent(UUID().uuidString + ".jpg")
            try? data.write(to: tempURL)
            profile.photos = [tempURL]
        }
    }
}
