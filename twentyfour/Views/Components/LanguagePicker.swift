import SwiftUI

struct LanguagePicker: View {
    let onDismiss: () -> Void
    @ObservedObject private var preferences = SettingsPreferences.shared
    
    var body: some View {
        VStack(spacing: 0) {
            Text(LocalizationResource.string(for: .settingsLanguage, language: preferences.language))
                .font(.system(size: LanguagePickerConstants.Font.titleSize, weight: .medium))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, SharedUIConstants.Layout.elementSpacing)
            
            Divider()
                .background(Color(UIColor.separator))
            
            VStack(spacing: SharedUIConstants.Layout.buttonSpacing) {
                // Language picker
                VStack(spacing: SharedUIConstants.Layout.compactElementSpacing) {
                    Picker("", selection: Binding(
                        get: { preferences.language },
                        set: { preferences.setLanguage($0) }
                    )) {
                        ForEach(Language.allCases) { language in
                            Text(language.displayName)
                                .font(.system(size: LanguagePickerConstants.Font.optionSize))
                                .tag(language)
                        }
                    }
                    .pickerStyle(.segmented)
                    .scaleEffect(LanguagePickerConstants.Layout.pickerScale)
                    .frame(height: LanguagePickerConstants.Layout.pickerHeight)
                }
                .frame(width: LanguagePickerConstants.Layout.pickerWidth)
                .padding(.vertical, LanguagePickerConstants.Layout.verticalPadding)
            }
            .padding(.vertical, SharedUIConstants.Layout.buttonSpacing)
        }
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.systemBackground).ignoresSafeArea())
    }
}

#Preview {
    LanguagePicker(onDismiss: {})
} 