import SwiftUI
#if os(macOS)
import AppKit
#endif

#if DEBUG
struct IconExporter {
    @MainActor
    static func exportIcon() async {
        await IconGenerator.exportAllIcons()
    }
}

// Development preview that generates the icon
struct IconExporterPreview: View {
    @State private var exportResult: String = ""
    @ObservedObject private var colorSchemeManager = ColorSchemeManager.shared
    
    var body: some View {
        VStack(spacing: 20) {
            IconGenerator(scheme: colorSchemeManager.currentScheme)
                .frame(width: 200, height: 200)
            Button("Export All Icons") {
                Task {
                    await IconExporter.exportIcon()
                }
            }
            .buttonStyle(.borderedProminent)
            Text("Icons will be saved to your Documents folder")
                .font(.caption)
            if !exportResult.isEmpty {
                Text(exportResult)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }
}

#Preview {
    IconExporterPreview()
}
#endif 