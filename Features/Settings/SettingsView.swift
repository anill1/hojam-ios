import SwiftUI

struct SettingsView: View {
    private let environment: AppEnvironment
    @StateObject private var viewModel: SettingsViewModel

    init(environment: AppEnvironment) {
        self.environment = environment
        _viewModel = StateObject(wrappedValue: SettingsViewModel(preferences: environment.preferences))
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("settings_language")) {
                    Picker("settings_language", selection: $viewModel.selectedLanguage) {
                        ForEach(SettingsViewModel.Language.allCases) { language in
                            Text(language.title).tag(language)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section(header: Text("settings_notifications")) {
                    Toggle("settings_notifications_toggle", isOn: $viewModel.notificationsEnabled)
                    Toggle("profile_anonymous_mode", isOn: $viewModel.anonymousMode)
                }

                Section(header: Text("settings_legal")) {
                    NavigationLink("settings_terms") {
                        LegalTextView(titleKey: "settings_terms", contentKey: "legal_terms_content")
                    }
                    NavigationLink("settings_privacy") {
                        LegalTextView(titleKey: "settings_privacy", contentKey: "legal_privacy_content")
                    }
                }
            }
            .navigationTitle(Text("settings_title"))
            .onDisappear { viewModel.save() }
        }
    }
}

private struct LegalTextView: View {
    let titleKey: LocalizedStringKey
    let contentKey: LocalizedStringKey

    var body: some View {
        ScrollView {
            Text(contentKey)
                .padding()
                .font(.body)
        }
        .navigationTitle(titleKey)
    }
}
