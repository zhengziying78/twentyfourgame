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
    private let cornerRadius: CGFloat = 220
    private let suitPadding: CGFloat = 140
    private let fontSize: CGFloat = 800
    
    var body: some View {
        ZStack {
            // Just the colored grid background without suits
            SuitGrid(theme: theme)
            
            // The "24" text with color flipping
            CenterText(theme: theme, fontSize: fontSize)
        }
        .frame(width: 1024, height: 1024)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
    
    #if DEBUG
    // Function to generate and save the icon
    func saveIcon() {
        let renderer = ImageRenderer(content: self)
        renderer.scale = 1.0
        
        // Ensure we can get the CGImage
        guard let cgImage = renderer.cgImage else {
            print("Failed to generate icon image")
            return
        }
        
        // Convert to UIImage
        let uiImage = UIImage(cgImage: cgImage)
        
        // Get the asset catalog path
        if let projectURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let assetPath = projectURL
                .appendingPathComponent("twentyfour")
                .appendingPathComponent("Assets.xcassets")
                .appendingPathComponent("AppIcon.appiconset")
            
            // Create directories if they don't exist
            try? FileManager.default.createDirectory(at: assetPath, withIntermediateDirectories: true)
            
            // Save the image
            let imageURL = assetPath.appendingPathComponent("AppIcon.png")
            if let imageData = uiImage.pngData() {
                try? imageData.write(to: imageURL)
                print("Icon saved to: \(imageURL.path)")
            }
        }
    }
    #endif
}

// MARK: - Grid Background
struct GridBackground: View {
    let backgroundColor: Color
    
    var body: some View {
        Rectangle()
            .fill(backgroundColor)
    }
}

// MARK: - Suit Grid
struct SuitGrid: View {
    let theme: IconTheme
    
    private var suitConfigs: [[SuitConfig]] {
        [
            [
                // Top left - Red bg, Black spade
                SuitConfig(background: theme.softRed, suitImage: "suit.spade.fill", suitColor: theme.softBlack),
                // Top right - Black bg, Red heart
                SuitConfig(background: theme.softBlack, suitImage: "suit.heart.fill", suitColor: theme.softRed)
            ],
            [
                // Bottom left - Black bg, Red diamond
                SuitConfig(background: theme.softBlack, suitImage: "suit.diamond.fill", suitColor: theme.softRed),
                // Bottom right - Red bg, Black club
                SuitConfig(background: theme.softRed, suitImage: "suit.club.fill", suitColor: theme.softBlack)
            ]
        ]
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<2) { row in
                HStack(spacing: 0) {
                    ForEach(0..<2) { col in
                        SuitCell(config: suitConfigs[row][col])
                    }
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

// MARK: - Center Text
struct CenterText: View {
    let theme: IconTheme
    let fontSize: CGFloat
    
    var body: some View {
        Text("24")
            .font(.custom("Helvetica-Bold", size: fontSize * 0.7))
            .foregroundStyle(.clear)
            .overlay {
                GeometryReader { geometry in
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
    }
}

// MARK: - Preview
#Preview {
    IconGenerator()
        .frame(width: 200, height: 200)
        .onAppear {
            #if DEBUG
            IconGenerator().saveIcon()
            #endif
        }
} 
