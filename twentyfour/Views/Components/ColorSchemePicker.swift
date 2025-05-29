import SwiftUI

struct ColorSchemePicker: View {
    let onDismiss: () -> Void
    @ObservedObject private var colorSchemeManager = ColorSchemeManager.shared
    @ObservedObject private var preferences = SettingsPreferences.shared
    @AppStorage("autoChangeAppIcon") private var autoChangeAppIcon = false
    @State private var showingExportAlert = false
    @State private var exportPath = ""
    
    private var orderedSchemes: [ColorScheme] {
        [
            // First row (unchanged)
            .classic,
            .hermes,
            .barbie,
            // Second row
            .seahawks,
            .lakers,
            .barcelona,
            // Third row
            .psg,
            .interMilan,
            .bocaJuniors
        ]
    }
    
    private var colorSchemeRows: [[ColorScheme]] {
        stride(from: 0, to: orderedSchemes.count, by: 3).map {
            Array(orderedSchemes[$0..<min($0 + 3, orderedSchemes.count)])
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
                                .frame(width: 110)
                                .padding(.vertical, 4)
                                .contentShape(Rectangle())
                            }
                        }
                        
                        // Fill empty spaces in the last row if needed
                        if row.count < 3 {
                            ForEach(0..<(3 - row.count), id: \.self) { _ in
                                Color.clear
                                    .frame(width: 110)
                            }
                        }
                    }
                }
            }
            .padding(.vertical, 12)
            
            if AppIconManager.supportsAlternateIcons {
                Divider()
                    .background(Color(UIColor.separator))
                
                VStack(spacing: 12) {
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
                    
                    // Temporarily hidden export button
                    /*#if DEBUG
                    Button(action: {
                        Task {
                            await IconGenerator.exportAllIcons()
                            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                            exportPath = documentsDirectory.path
                            showingExportAlert = true
                        }
                    }) {
                        Text("Export All Icons")
                            .font(.system(size: 14))
                            .foregroundColor(.blue)
                    }
                    #endif*/
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.systemBackground).ignoresSafeArea())
        .alert("Icon Exported", isPresented: $showingExportAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("All app icons have been exported to:\n\(exportPath)")
        }
    }
} 