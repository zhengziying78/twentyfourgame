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
    let onDismiss: () -> Void
    @ObservedObject private var preferences = SettingsPreferences.shared
    @ObservedObject private var colorSchemeManager = ColorSchemeManager.shared
    @State private var showingExportAlert = false
    @State private var exportPath = ""
    @Environment(\.colorScheme) private var selectedScheme
    
    var body: some View {
        VStack(spacing: 0) {
            Text(LocalizationResource.string(for: .settingsTitle, language: preferences.language))
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
            
            Divider()
                .background(Color(UIColor.separator))
            
            VStack(spacing: 12) {
                // Language picker
                VStack(spacing: 4) {
                    Text(LocalizationResource.string(for: .settingsLanguage, language: preferences.language))
                        .font(.system(size: 14))
                        .foregroundColor(.primary)
                    
                    Picker("", selection: Binding(
                        get: { preferences.language },
                        set: { preferences.setLanguage($0) }
                    )) {
                        ForEach(Language.allCases) { language in
                            Text(language.displayName)
                                .tag(language)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                .frame(width: 200)
                .padding(.vertical, 4)
            }
            .padding(.vertical, 12)
        }
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.systemBackground).ignoresSafeArea())
    }
}

// MARK: - Preview
#Preview {
    SettingsView(onDismiss: {})
} 