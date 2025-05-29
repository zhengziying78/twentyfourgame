import SwiftUI

struct ColorSchemePicker: View {
    let onDismiss: () -> Void
    @ObservedObject private var colorSchemeManager = ColorSchemeManager.shared
    @ObservedObject private var preferences = SettingsPreferences.shared
    @AppStorage("autoChangeAppIcon") private var autoChangeAppIcon = false
    
    private var colorSchemeRows: [[ColorScheme]] {
        let schemes = ColorScheme.allCases
        return stride(from: 0, to: schemes.count, by: 2).map {
            Array(schemes[$0..<min($0 + 2, schemes.count)])
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text(LocalizationResource.string(for: .settingsColorScheme, language: preferences.language))
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
            
            Divider()
                .background(Color(UIColor.separator))
            
            VStack(spacing: 12) {
                ForEach(colorSchemeRows, id: \.self) { row in
                    HStack(spacing: 16) {
                        ForEach(row) { scheme in
                            Button(action: {
                                colorSchemeManager.setScheme(scheme)
                                if AppIconManager.supportsAlternateIcons && autoChangeAppIcon {
                                    AppIconManager.changeAppIcon(to: scheme)
                                }
                            }) {
                                VStack(spacing: 4) {
                                    // Color preview circles
                                    HStack(spacing: 8) {
                                        Circle()
                                            .fill(scheme.primary)
                                            .frame(width: 16, height: 16)
                                        Circle()
                                            .fill(scheme.secondary)
                                            .frame(width: 16, height: 16)
                                    }
                                    
                                    HStack(spacing: 4) {
                                        Text(scheme.localizedName(language: preferences.language))
                                            .font(.system(size: 14))
                                            .foregroundColor(.primary)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.8)
                                        
                                        if colorSchemeManager.currentScheme == scheme {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.blue)
                                                .font(.system(size: 12))
                                        }
                                    }
                                }
                                .frame(width: 100)
                                .padding(.vertical, 4)
                                .contentShape(Rectangle())
                            }
                        }
                        
                        if row.count == 1 {
                            Color.clear
                                .frame(width: 100)
                        }
                    }
                }
            }
            .padding(.vertical, 12)
            
            if AppIconManager.supportsAlternateIcons {
                Divider()
                    .background(Color(UIColor.separator))
                
                HStack {
                    Spacer()
                    Text(LocalizationResource.string(for: .settingsAppIconAutoChange, language: preferences.language))
                        .font(.system(size: 14))
                        .foregroundColor(.primary)
                    Toggle("", isOn: $autoChangeAppIcon)
                        .labelsHidden()
                    Spacer()
                }
                .onChange(of: autoChangeAppIcon) { newValue in
                    if newValue {
                        // If enabled, immediately update icon to match current scheme
                        AppIconManager.forceChangeAppIcon(to: colorSchemeManager.currentScheme)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.systemBackground).ignoresSafeArea())
    }
} 