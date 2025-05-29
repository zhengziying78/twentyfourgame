import SwiftUI

struct ColorSchemePicker: View {
    let onDismiss: () -> Void
    @ObservedObject private var colorSchemeManager = ColorSchemeManager.shared
    @ObservedObject private var preferences = SettingsPreferences.shared
    @AppStorage("autoChangeAppIcon") private var autoChangeAppIcon = false
    
    var body: some View {
        VStack(spacing: 0) {
            Text(LocalizationResource.string(for: .settingsColorScheme, language: preferences.language))
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
            
            Divider()
                .background(Color(UIColor.separator))
            
            VStack(spacing: 0) {
                ForEach(ColorScheme.allCases) { scheme in
                    Button(action: {
                        colorSchemeManager.setScheme(scheme)
                        if AppIconManager.supportsAlternateIcons && autoChangeAppIcon {
                            AppIconManager.changeAppIcon(to: scheme)
                        }
                    }) {
                        HStack(spacing: 12) {
                            // Color preview circles
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(scheme.primary)
                                    .frame(width: 20, height: 20)
                                Circle()
                                    .fill(scheme.secondary)
                                    .frame(width: 20, height: 20)
                            }
                            
                            Text(scheme.localizedName(language: preferences.language))
                                .font(.system(size: 18))
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            if colorSchemeManager.currentScheme == scheme {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                                    .font(.system(size: 20))
                            }
                        }
                        .frame(width: 200)
                        .contentShape(Rectangle())
                    }
                    .padding(.vertical, 12)
                }
            }
            .padding(.vertical, 16)
            .padding(.bottom, 8)
        }
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.systemBackground).ignoresSafeArea())
    }
} 