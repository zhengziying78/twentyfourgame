import SwiftUI

struct ColorSchemeRow: View {
    let scheme: ColorScheme
    let isSelected: Bool
    @ObservedObject private var preferences = SettingsPreferences.shared
    
    var body: some View {
        HStack {
            Text(scheme.localizedName(language: preferences.language))
            Spacer()
            // Color preview circles
            HStack(spacing: 8) {
                Circle()
                    .fill(scheme.primary)
                    .frame(width: 20, height: 20)
                Circle()
                    .fill(scheme.secondary)
                    .frame(width: 20, height: 20)
            }
            if isSelected {
                Image(systemName: "checkmark")
                    .foregroundColor(.blue)
            }
        }
    }
}

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var preferences = SettingsPreferences.shared
    @ObservedObject private var colorSchemeManager = ColorSchemeManager.shared
    
    var body: some View {
        NavigationView {
            List {
                // General section
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
                
                // Appearance section
                Section {
                    ForEach(ColorScheme.allCases) { scheme in
                        Button(action: {
                            colorSchemeManager.setScheme(scheme)
                        }) {
                            ColorSchemeRow(
                                scheme: scheme,
                                isSelected: colorSchemeManager.currentScheme == scheme
                            )
                        }
                        .foregroundColor(.primary)
                    }
                } header: {
                    Text(LocalizationResource.string(for: .settingsColorScheme, language: preferences.language))
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