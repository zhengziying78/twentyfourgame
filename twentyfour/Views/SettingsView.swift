import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var preferences = SettingsPreferences.shared
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Picker(LocalizationResource.string(for: .settingsLanguage, language: preferences.language), selection: Binding(
                        get: { preferences.language },
                        set: { preferences.setLanguage($0) }
                    )) {
                        ForEach(Language.allCases) { language in
                            Text(language.displayName)
                                .tag(language)
                        }
                    }
                } header: {
                    Text(LocalizationResource.string(for: .settingsGeneral, language: preferences.language))
                }
            }
            .navigationTitle(LocalizationResource.string(for: .settingsTitle, language: preferences.language))
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text(LocalizationResource.string(for: .backButton, language: preferences.language))
                        }
                    }
                }
            }
        }
    }
} 