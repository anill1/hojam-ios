import Foundation
import SwiftUI
import UIKit

@MainActor
final class ImageLoader: ObservableObject {
    @Published var image: Image?
    private let url: URL?
    private let cache = URLCache(memoryCapacity: 20 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024)

    init(url: URL?) {
        self.url = url
    }

    func load() {
        guard let url else { return }
        if let cached = cache.cachedResponse(for: URLRequest(url: url)) {
            if let uiImage = UIImage(data: cached.data) {
                image = Image(uiImage: uiImage)
                return
            }
        }

        Task {
            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                if let httpResponse = response as? HTTPURLResponse,
                   (200 ..< 300).contains(httpResponse.statusCode) {
                    let cachedData = CachedURLResponse(response: response, data: data)
                    cache.storeCachedResponse(cachedData, for: URLRequest(url: url))
                }
                if let uiImage = UIImage(data: data) {
                    await MainActor.run {
                        self.image = Image(uiImage: uiImage)
                    }
                }
            } catch {
                // Silently ignore for mock images
            }
        }
    }
}
