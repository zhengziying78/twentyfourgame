import SwiftUI

struct ColorSchemePicker: View {
    let onDismiss: () -> Void
    @ObservedObject private var colorSchemeManager = ColorSchemeManager.shared
    @ObservedObject private var preferences = SettingsPreferences.shared
    @AppStorage("autoChangeAppIcon") private var autoChangeAppIcon = false
    
    var body: some View {
        PopupContainer(content: {
            VStack(spacing: 0) {
                Text(LocalizationResource.string(for: .settingsColorScheme, language: preferences.language))
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color(UIColor.systemBackground).opacity(0.95))
                
                Divider()
                
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(ColorScheme.allCases) { scheme in
                            Button(action: {
                                colorSchemeManager.setScheme(scheme)
                                if AppIconManager.supportsAlternateIcons && autoChangeAppIcon {
                                    AppIconManager.changeAppIcon(to: scheme)
                                }
                                onDismiss()
                            }) {
                                HStack {
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
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                    
                                    if colorSchemeManager.currentScheme == scheme {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.blue)
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                            }
                            
                            if scheme != ColorScheme.allCases.last {
                                Divider()
                            }
                        }
                    }
                }
                .background(Color(UIColor.systemBackground).opacity(0.95))
            }
        }, onDismiss: onDismiss)
    }
} 