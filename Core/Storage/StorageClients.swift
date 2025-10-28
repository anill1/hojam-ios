import Foundation

protocol TokenStore {
    func save(token: String?)
    func loadToken() -> String?
}

final class KeychainTokenStore: TokenStore {
    private let key = "uniapp.token"

    func save(token: String?) {
        if let token {
            UserDefaults.standard.set(token, forKey: key)
        } else {
            UserDefaults.standard.removeObject(forKey: key)
        }
    }

    func loadToken() -> String? {
        UserDefaults.standard.string(forKey: key)
    }
}

protocol PreferencesStore {
    func save<Value: Codable>(_ value: Value, for key: String)
    func load<Value: Codable>(for key: String, default defaultValue: Value) -> Value
}

final class InMemoryPreferencesStore: PreferencesStore {
    private var store: [String: Data] = [:]
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    func save<Value: Codable>(_ value: Value, for key: String) {
        if let data = try? encoder.encode(value) {
            store[key] = data
        }
    }

    func load<Value: Codable>(for key: String, default defaultValue: Value) -> Value {
        guard let data = store[key], let decoded = try? decoder.decode(Value.self, from: data) else {
            return defaultValue
        }
        return decoded
    }
}
