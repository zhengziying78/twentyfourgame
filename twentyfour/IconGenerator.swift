import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

// MARK: - Icon Theme
struct IconTheme {
    let softRed = Color(red: 0.75, green: 0.2, blue: 0.2)
    let softBlack = Color(white: 0.2)
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
    private let suitPadding: CGFloat = 80
    private let fontSize: CGFloat = 300
    
    var body: some View {
        ZStack {
            GridBackground(backgroundColor: theme.softBlack)
            SuitGrid(theme: theme)
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
            Rectangle()
                .fill(config.background)
            Image(systemName: config.suitImage)
                .resizable()
                .scaledToFit()
                .foregroundColor(config.suitColor)
                .padding(80)
        }
        .frame(width: 512, height: 512)
    }
}

// MARK: - Center Text
struct CenterText: View {
    let theme: IconTheme
    let fontSize: CGFloat
    
    var body: some View {
        Text("24")
            .font(.system(size: fontSize, weight: .semibold, design: .default))
            .foregroundColor(theme.textColor)
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
