import SwiftUI

struct LanguagePicker: View {
    let onDismiss: () -> Void
    @ObservedObject private var preferences = SettingsPreferences.shared
    
    var body: some View {
        VStack(spacing: 0) {
            Text(LocalizationResource.string(for: .settingsLanguage, language: preferences.language))
                .font(.system(size: UIConstants.Font.titleSize, weight: .medium))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, UIConstants.Layout.elementSpacing)
            
            Divider()
                .background(Color(UIColor.separator))
            
            VStack(spacing: UIConstants.Layout.buttonSpacing) {
                // Language picker
                VStack(spacing: UIConstants.Layout.compactElementSpacing) {
                    Picker("", selection: Binding(
                        get: { preferences.language },
                        set: { preferences.setLanguage($0) }
                    )) {
                        ForEach(Language.allCases) { language in
                            Text(language.displayName)
                                .font(.system(size: UIConstants.Font.bodySize))
                                .tag(language)
                        }
                    }
                    .pickerStyle(.segmented)
                    .scaleEffect(1.2)
                    .frame(height: 44)
                }
                .frame(width: 240)
                .padding(.vertical, UIConstants.Layout.elementSpacing)
            }
            .padding(.vertical, UIConstants.Layout.buttonSpacing)
        }
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.systemBackground).ignoresSafeArea())
    }
}

#Preview {
    LanguagePicker(onDismiss: {})
} 