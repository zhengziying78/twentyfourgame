import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

// MARK: - Icon Theme
struct IconTheme {
    let primary: Color
    let secondary: Color
    let textColor: Color
    
    init(scheme: ColorScheme) {
        self.primary = scheme.primary
        self.secondary = scheme.secondary
        self.textColor = scheme.textAndIcon
    }
}

// MARK: - Card Suit Configuration
struct SuitConfig {
    let background: Color
    let suitImage: String
    let suitColor: Color
}

// MARK: - App Icon Manager
enum AppIconManager {
    private static let autoChangeKey = "autoChangeAppIcon"
    
    static var shouldAutoChange: Bool {
        get {
            UserDefaults.standard.bool(forKey: autoChangeKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: autoChangeKey)
        }
    }
    
    static func changeAppIcon(to scheme: ColorScheme) {
        // For classic, use nil to revert to primary icon
        // For others, use the raw value as the icon name with "AppIcon-" prefix
        let iconName = scheme == .classic ? nil : "AppIcon-\(scheme.rawValue)"
        
        // Only proceed if auto-change is enabled or if this is a manual change
        guard shouldAutoChange else {
            print("🔄 App icon auto-change is disabled")
            return
        }
        
        print("🔄 Attempting to change app icon to: \(iconName ?? "classic")")
        print("📱 Device supports alternate icons: \(UIApplication.shared.supportsAlternateIcons)")
        print("🎯 Current alternate icon name: \(UIApplication.shared.alternateIconName ?? "None")")
        
        // Print out bundle information for debugging
        print("📦 Bundle URL: \(Bundle.main.bundleURL)")
        if let infoPlist = Bundle.main.infoDictionary {
            print("📝 Info.plist contents:")
            if let iconsDict = infoPlist["CFBundleIcons"] as? [String: Any] {
                print("   Icons configuration found:")
                print("   Primary icon: \(iconsDict["CFBundlePrimaryIcon"] ?? "Not found")")
                if let alternateIcons = iconsDict["CFBundleAlternateIcons"] as? [String: Any] {
                    print("   Available alternate icons: \(alternateIcons.keys.joined(separator: ", "))")
                    if let iconName = iconName {
                        print("   Attempting to set icon: \(iconName)")
                    }
                } else {
                    print("   No alternate icons found in Info.plist")
                }
            } else {
                print("   No CFBundleIcons found in Info.plist")
            }
        }
        
        Task { @MainActor in
            do {
                if UIApplication.shared.supportsAlternateIcons {
                    try await UIApplication.shared.setAlternateIconName(iconName)
                    print("✅ Successfully changed app icon to: \(iconName ?? "classic")")
                    
                    // Verify the change
                    if let currentIcon = UIApplication.shared.alternateIconName {
                        print("🎨 New icon name verified: \(currentIcon)")
                    } else {
                        print("🎨 Using primary icon (verified)")
                    }
                } else {
                    print("❌ Device does not support alternate icons")
                }
            } catch {
                print("❌ Failed to change app icon: \(error.localizedDescription)")
                print("❌ Error details: \(error)")
                
                // Additional error information
                if let nsError = error as NSError? {
                    print("❌ Error domain: \(nsError.domain)")
                    print("❌ Error code: \(nsError.code)")
                    print("❌ Error user info: \(nsError.userInfo)")
                }
            }
        }
    }
    
    static func forceChangeAppIcon(to scheme: ColorScheme) {
        // This method will change the icon regardless of the auto-change setting
        let iconName = scheme == .classic ? nil : "AppIcon-\(scheme.rawValue)"
        
        print("🔄 Forcing app icon change to: \(iconName ?? "classic")")
        print("📱 Device supports alternate icons: \(UIApplication.shared.supportsAlternateIcons)")
        print("🎯 Current alternate icon name: \(UIApplication.shared.alternateIconName ?? "None")")
        
        // Print out bundle information for debugging
        print("📦 Bundle URL: \(Bundle.main.bundleURL)")
        if let infoPlist = Bundle.main.infoDictionary {
            print("📝 Info.plist contents:")
            if let iconsDict = infoPlist["CFBundleIcons"] as? [String: Any] {
                print("   Icons configuration found:")
                print("   Primary icon: \(iconsDict["CFBundlePrimaryIcon"] ?? "Not found")")
                if let alternateIcons = iconsDict["CFBundleAlternateIcons"] as? [String: Any] {
                    print("   Available alternate icons: \(alternateIcons.keys.joined(separator: ", "))")
                    if let iconName = iconName {
                        print("   Attempting to set icon: \(iconName)")
                    }
                } else {
                    print("   No alternate icons found in Info.plist")
                }
            } else {
                print("   No CFBundleIcons found in Info.plist")
            }
        }
        
        Task { @MainActor in
            do {
                if UIApplication.shared.supportsAlternateIcons {
                    try await UIApplication.shared.setAlternateIconName(iconName)
                    print("✅ Successfully changed app icon to: \(iconName ?? "classic")")
                    
                    // Verify the change
                    if let currentIcon = UIApplication.shared.alternateIconName {
                        print("🎨 New icon name verified: \(currentIcon)")
                    } else {
                        print("🎨 Using primary icon (verified)")
                    }
                } else {
                    print("❌ Device does not support alternate icons")
                }
            } catch {
                print("❌ Failed to change app icon: \(error.localizedDescription)")
                print("❌ Error details: \(error)")
                
                // Additional error information
                if let nsError = error as NSError? {
                    print("❌ Error domain: \(nsError.domain)")
                    print("❌ Error code: \(nsError.code)")
                    print("❌ Error user info: \(nsError.userInfo)")
                }
            }
        }
    }
    
    static var supportsAlternateIcons: Bool {
        UIApplication.shared.supportsAlternateIcons
    }
}

// MARK: - Icon Generator
struct IconGenerator: View {
    let scheme: ColorScheme
    private let fontSize: CGFloat = 800
    
    private var theme: IconTheme {
        IconTheme(scheme: scheme)
    }
    
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
                        // Primary text (appears over secondary areas)
                        Text("24")
                            .font(.custom("Helvetica-Bold", size: fontSize * 0.7))
                            .foregroundStyle(theme.primary)
                            .mask {
                                VStack(spacing: 0) {
                                    HStack(spacing: 0) {
                                        // Top-left: Secondary bg
                                        Rectangle().fill(theme.secondary)
                                        // Top-right: Empty (primary bg)
                                        Rectangle().fill(.clear)
                                    }
                                    HStack(spacing: 0) {
                                        // Bottom-left: Empty (primary bg)
                                        Rectangle().fill(.clear)
                                        // Bottom-right: Secondary bg
                                        Rectangle().fill(theme.secondary)
                                    }
                                }
                            }
                        
                        // Secondary text (appears over primary areas)
                        Text("24")
                            .font(.custom("Helvetica-Bold", size: fontSize * 0.7))
                            .foregroundStyle(theme.secondary)
                            .mask {
                                VStack(spacing: 0) {
                                    HStack(spacing: 0) {
                                        // Top-left: Empty (secondary bg)
                                        Rectangle().fill(.clear)
                                        // Top-right: Primary bg
                                        Rectangle().fill(theme.primary)
                                    }
                                    HStack(spacing: 0) {
                                        // Bottom-left: Primary bg
                                        Rectangle().fill(theme.primary)
                                        // Bottom-right: Empty (secondary bg)
                                        Rectangle().fill(.clear)
                                    }
                                }
                            }
                    }
                }
        }
        .frame(width: 1024, height: 1024)
    }
    
    // Function to generate and save all icons
    static func exportAllIcons() async {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        // Create icons for all color schemes
        for scheme in ColorScheme.allCases {
            await MainActor.run {
                let iconName = scheme == .classic ? "AppIcon" : "AppIcon-\(scheme.rawValue)"
                let renderer = ImageRenderer(content: IconGenerator(scheme: scheme))
                renderer.scale = 1.0
                
                if let image = renderer.uiImage {
                    if let pngData = image.pngData() {
                        do {
                            let fileURL = documentsDirectory.appendingPathComponent("\(iconName).png")
                            try pngData.write(to: fileURL)
                            print("✅ Exported \(iconName).png to: \(fileURL.path)")
                        } catch {
                            print("❌ Failed to save \(iconName).png: \(error)")
                        }
                    }
                }
            }
        }
        
        print("\n📁 All icons exported to: \(documentsDirectory.path)")
    }
    
    // Keep the old export function for backward compatibility
    static func exportIcon() async {
        await exportAllIcons()
    }
}

// MARK: - Suit Grid
struct SuitGrid: View {
    let theme: IconTheme
    
    private var configs: [SuitConfig] {
        [
            SuitConfig(background: theme.secondary, suitImage: "suit.spade.fill", suitColor: theme.primary),
            SuitConfig(background: theme.primary, suitImage: "suit.heart.fill", suitColor: theme.secondary),
            SuitConfig(background: theme.primary, suitImage: "suit.diamond.fill", suitColor: theme.secondary),
            SuitConfig(background: theme.secondary, suitImage: "suit.club.fill", suitColor: theme.primary)
        ]
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    SuitCell(config: configs[0])
                    SuitCell(config: configs[1])
                }
                HStack(spacing: 0) {
                    SuitCell(config: configs[2])
                    SuitCell(config: configs[3])
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
    IconGenerator(scheme: .classic)
        .frame(width: 200, height: 200)
} 
