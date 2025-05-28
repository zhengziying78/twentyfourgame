import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

// MARK: - Icon Theme
struct IconTheme {
    let softRed = Color(red: 0.87, green: 0.27, blue: 0.27)
    let softBlack = Color(red: 0.2, green: 0.2, blue: 0.2)
    let textColor = Color.white
    
    static let `default` = IconTheme()
}

// MARK: - Card Suit Configuration
struct SuitConfig {
    let background: Color
    let suitImage: String
    let suitColor: Color
}

// MARK: - Icon Generator
struct IconGenerator: View {
    private let theme = IconTheme.default
    private let fontSize: CGFloat = 800
    
    var body: some View {
        ZStack {
            // Just the colored grid background without suits
            SuitGrid(theme: theme)
            
            // The "24" text with color flipping
            Text("24")
                .font(.custom("Helvetica-Bold", size: fontSize * 0.7))
                .foregroundStyle(.clear)
                .overlay {
                    ZStack {
                        // Black text (appears over red areas)
                        Text("24")
                            .font(.custom("Helvetica-Bold", size: fontSize * 0.7))
                            .foregroundStyle(theme.softBlack)
                            .mask {
                                VStack(spacing: 0) {
                                    HStack(spacing: 0) {
                                        // Top-left: Red bg
                                        Rectangle().fill(theme.softRed)
                                        // Top-right: Empty (black bg)
                                        Rectangle().fill(.clear)
                                    }
                                    HStack(spacing: 0) {
                                        // Bottom-left: Empty (black bg)
                                        Rectangle().fill(.clear)
                                        // Bottom-right: Red bg
                                        Rectangle().fill(theme.softRed)
                                    }
                                }
                            }
                        
                        // Red text (appears over black areas)
                        Text("24")
                            .font(.custom("Helvetica-Bold", size: fontSize * 0.7))
                            .foregroundStyle(theme.softRed)
                            .mask {
                                VStack(spacing: 0) {
                                    HStack(spacing: 0) {
                                        // Top-left: Empty (red bg)
                                        Rectangle().fill(.clear)
                                        // Top-right: Black bg
                                        Rectangle().fill(theme.softBlack)
                                    }
                                    HStack(spacing: 0) {
                                        // Bottom-left: Black bg
                                        Rectangle().fill(theme.softBlack)
                                        // Bottom-right: Empty (red bg)
                                        Rectangle().fill(.clear)
                                    }
                                }
                            }
                    }
                }
        }
        .frame(width: 1024, height: 1024)
    }
    
    // Function to generate and save the icon
    static func exportIcon() async {
        // Need to run UI operations on the main thread
        await MainActor.run {
            let renderer = ImageRenderer(content: IconGenerator())
            // Configure the renderer
            renderer.scale = 1.0
            
            // Get the rendered image
            if let image = renderer.uiImage {
                if let pngData = image.pngData() {
                    do {
                        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                        let fileURL = documentsDirectory.appendingPathComponent("AppIcon.png")
                        try pngData.write(to: fileURL)
                        print("Icon exported to: \(fileURL.path)")
                    } catch {
                        print("Failed to save icon: \(error)")
                    }
                }
            }
        }
    }
}

// MARK: - Suit Grid
struct SuitGrid: View {
    let theme: IconTheme
    
    private let configs: [SuitConfig] = [
        SuitConfig(background: IconTheme.default.softRed, suitImage: "suit.spade.fill", suitColor: IconTheme.default.softBlack),
        SuitConfig(background: IconTheme.default.softBlack, suitImage: "suit.heart.fill", suitColor: IconTheme.default.softRed),
        SuitConfig(background: IconTheme.default.softBlack, suitImage: "suit.diamond.fill", suitColor: IconTheme.default.softRed),
        SuitConfig(background: IconTheme.default.softRed, suitImage: "suit.club.fill", suitColor: IconTheme.default.softBlack)
    ]
    
    var body: some View {
        GeometryReader { geometry in
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 0) {
                ForEach(0..<4) { index in
                    SuitCell(config: configs[index])
                }
            }
        }
    }
}

// MARK: - Suit Cell
struct SuitCell: View {
    let config: SuitConfig
    
    var body: some View {
        ZStack {
            // Background color
            Rectangle()
                .fill(config.background)
            
            // Suit symbol
            Image(systemName: config.suitImage)
                .resizable()
                .scaledToFit()
                .foregroundColor(config.suitColor)
                .frame(width: config.suitImage == "suit.diamond.fill" ? 160 : 200)
                .padding(80)
                .offset(x: symbolOffset.width, y: symbolOffset.height)
        }
        .frame(width: 512, height: 512)
    }
    
    // Calculate offset based on suit image
    private var symbolOffset: CGSize {
        switch config.suitImage {
        case "suit.spade.fill":    // Top-left
            return CGSize(width: -80, height: -80)
        case "suit.heart.fill":    // Top-right
            return CGSize(width: 80, height: -80)
        case "suit.diamond.fill":  // Bottom-left
            return CGSize(width: -80, height: 80)
        case "suit.club.fill":     // Bottom-right
            return CGSize(width: 80, height: 80)
        default:
            return CGSize.zero
        }
    }
}

// MARK: - Preview
#Preview {
    IconGenerator()
        .frame(width: 200, height: 200)
} 
