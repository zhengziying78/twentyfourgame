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
    @State private var showingExportAlert = false
    @State private var exportPath = ""
    @Environment(\.colorScheme) private var selectedScheme
    
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
                
                /* Hide export button for now
                #if DEBUG
                Button(action: {
                    Task {
                        await IconGenerator.exportAllIcons()
                        await MainActor.run {
                            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                            exportPath = documentsDirectory.path
                            showingExportAlert = true
                        }
                    }
                }) {
                    HStack {
                        Image(systemName: "square.and.arrow.down")
                        VStack(alignment: .leading) {
                            Text("Export All App Icons")
                            Text("Generates icons for all color schemes")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                #endif
                */
            }
            .navigationTitle(LocalizationResource.string(for: .settingsTitle, language: preferences.language))
            .navigationBarTitleDisplayMode(.large)
            .alert("Icons Exported", isPresented: $showingExportAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("All app icons have been exported to:\n\(exportPath)")
            }
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
        .formStyle(.grouped)
        .navigationTitle("Settings")
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        SettingsView()
    }
} 