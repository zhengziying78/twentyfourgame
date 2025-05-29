import SwiftUI

struct ColorSchemePicker: View {
    @ObservedObject private var colorSchemeManager = ColorSchemeManager.shared
    @ObservedObject private var preferences = SettingsPreferences.shared
    @Environment(\.dismiss) private var dismiss
    @AppStorage("autoChangeAppIcon") private var autoChangeAppIcon = false
    
    var body: some View {
        List {
            ForEach(ColorScheme.allCases) { scheme in
                Button(action: {
                    colorSchemeManager.setScheme(scheme)
                    if AppIconManager.supportsAlternateIcons && autoChangeAppIcon {
                        AppIconManager.changeAppIcon(to: scheme)
                    }
                    dismiss()
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
                }
            }
        }
        .listStyle(.plain)
        .frame(width: 240)
        .background(Color(UIColor.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
    }
} 