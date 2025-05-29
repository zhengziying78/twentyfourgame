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
        stride(from: 0, to: orderedSchemes.count, by: ColorSchemePickerConstants.Layout.schemesPerRow).map {
            Array(orderedSchemes[$0..<min($0 + ColorSchemePickerConstants.Layout.schemesPerRow, orderedSchemes.count)])
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text(LocalizationResource.string(for: .settingsColorScheme, language: preferences.language))
                .font(.system(size: ColorSchemePickerConstants.Font.titleSize, weight: .medium))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, ColorSchemePickerConstants.Layout.titlePaddingVertical)
            
            Divider()
                .background(Color(UIColor.separator))
            
            VStack(spacing: ColorSchemePickerConstants.Layout.schemesSpacingVertical) {
                ForEach(colorSchemeRows, id: \.self) { row in
                    HStack(spacing: ColorSchemePickerConstants.Layout.schemesSpacingHorizontal) {
                        ForEach(row) { scheme in
                            Button(action: {
                                colorSchemeManager.setScheme(scheme)
                                if AppIconManager.supportsAlternateIcons && autoChangeAppIcon {
                                    AppIconManager.changeAppIcon(to: scheme)
                                }
                            }) {
                                VStack(spacing: ColorSchemePickerConstants.Layout.schemeNameCheckmarkSpacing) {
                                    // Color preview circles
                                    HStack(spacing: ColorSchemePickerConstants.Layout.colorCirclesSpacing) {
                                        Circle()
                                            .fill(scheme.primary)
                                            .frame(width: ColorSchemePickerConstants.Layout.colorCircleSize, height: ColorSchemePickerConstants.Layout.colorCircleSize)
                                        Circle()
                                            .fill(scheme.secondary)
                                            .frame(width: ColorSchemePickerConstants.Layout.colorCircleSize, height: ColorSchemePickerConstants.Layout.colorCircleSize)
                                    }
                                    
                                    HStack(spacing: ColorSchemePickerConstants.Layout.schemeNameCheckmarkSpacing) {
                                        Text(scheme.localizedName(language: preferences.language))
                                            .font(.system(size: ColorSchemePickerConstants.Font.schemeNameSize))
                                            .foregroundColor(.primary)
                                            .lineLimit(1)
                                            .minimumScaleFactor(ColorSchemePickerConstants.Scale.schemeNameMinScale)
                                        
                                        if colorSchemeManager.currentScheme == scheme {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.blue)
                                                .font(.system(size: ColorSchemePickerConstants.Font.checkmarkSize))
                                        }
                                    }
                                }
                                .frame(width: ColorSchemePickerConstants.Layout.schemeButtonWidth)
                                .padding(.vertical, ColorSchemePickerConstants.Layout.schemeButtonPaddingVertical)
                                .contentShape(Rectangle())
                            }
                        }
                        
                        // Fill empty spaces in the last row if needed
                        if row.count < ColorSchemePickerConstants.Layout.schemesPerRow {
                            ForEach(0..<(ColorSchemePickerConstants.Layout.schemesPerRow - row.count), id: \.self) { _ in
                                Color.clear
                                    .frame(width: ColorSchemePickerConstants.Layout.schemeButtonWidth)
                            }
                        }
                    }
                }
            }
            .padding(.vertical, ColorSchemePickerConstants.Layout.schemesSpacingVertical)
            
            if AppIconManager.supportsAlternateIcons {
                Divider()
                    .background(Color(UIColor.separator))
                
                VStack(spacing: ColorSchemePickerConstants.Layout.schemesSpacingVertical) {
                    HStack {
                        Spacer()
                        Text(LocalizationResource.string(for: .settingsAppIconAutoChange, language: preferences.language))
                            .font(.system(size: ColorSchemePickerConstants.Font.settingsTextSize))
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
                            .font(.system(size: ColorSchemePickerConstants.Font.settingsTextSize))
                            .foregroundColor(.blue)
                    }
                    #endif*/
                }
                .padding(.horizontal, ColorSchemePickerConstants.Layout.settingsPaddingHorizontal)
                .padding(.vertical, ColorSchemePickerConstants.Layout.settingsPaddingVertical)
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