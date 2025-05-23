import SwiftUI
#if os(macOS)
import AppKit
#endif

#if DEBUG
struct IconExporter {
    @MainActor
    static func exportIcon() async {
        let icon = IconGenerator()
        let renderer = ImageRenderer(content: icon)
        
        // Configure renderer
        renderer.scale = 1.0
        
        // Get the document directory
        guard let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("❌ Could not access Documents directory")
            return
        }
        
        let assetPath = docURL.appendingPathComponent("AppIcon.png")
        print("📁 Attempting to save to: \(assetPath.path)")
        
        // Save the image
        guard let cgImage = renderer.cgImage else {
            print("❌ Failed to generate CGImage")
            return
        }
        
        guard let data = UIImage(cgImage: cgImage).pngData() else {
            print("❌ Failed to generate PNG data")
            return
        }
        
        do {
            try data.write(to: assetPath)
            print("✅ Successfully saved icon to:")
            print("📍 \(assetPath.path)")
            
            // Try to open the containing folder
            #if os(macOS)
            NSWorkspace.shared.selectFile(assetPath.path, inFileViewerRootedAtPath: docURL.path)
            #else
            // On iOS, we would show a share sheet here
            print("💡 On iOS device, use Files app to access the Documents folder")
            #endif
            
        } catch {
            print("❌ Failed to write file with error: \(error.localizedDescription)")
        }
    }
}

// Development preview that generates the icon
struct IconExporterPreview: View {
    @State private var exportResult: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            IconGenerator()
                .frame(width: 200, height: 200)
            Button("Export Icon") {
                Task {
                    await IconExporter.exportIcon()
                }
            }
            .buttonStyle(.borderedProminent)
            Text("The icon will be saved to your Documents folder")
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