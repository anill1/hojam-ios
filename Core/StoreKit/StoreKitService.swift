import Foundation
import StoreKit

protocol StoreKitClient {
    func loadProducts() async throws -> [Product]
    func purchase(product: Product) async throws -> Transaction?
}

struct DefaultStoreKitClient: StoreKitClient {
    func loadProducts() async throws -> [Product] {
        try await Product.products(for: [
            "com.uniapp.plus.monthly",
            "com.uniapp.plus.quarterly",
            "com.uniapp.boost.single"
        ])
    }

    func purchase(product: Product) async throws -> Transaction? {
        let result = try await product.purchase()
        switch result {
        case .success(let verification):
            switch verification {
            case .unverified:
                return nil
            case .verified(let transaction):
                await transaction.finish()
                return transaction
            }
        case .userCancelled, .pending:
            return nil
        @unknown default:
            return nil
        }
    }
}

struct MockStoreKitClient: StoreKitClient {
    func loadProducts() async throws -> [Product] {
        []
    }

    func purchase(product: Product) async throws -> Transaction? {
        nil
    }
}
