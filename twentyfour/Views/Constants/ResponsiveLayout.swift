import SwiftUI

/// Unified responsive layout system that eliminates device-specific conditionals
/// This prevents iPhone vs iPad layout conflicts by centralizing all device logic
public struct ResponsiveLayout {
    
    // MARK: - Device Detection
    private static var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    private static var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    private static var screenHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    
    
    // MARK: - Layout Dimensions
    
    /// Top navigation bar height - consistent across all devices
    public static var topBarHeight: CGFloat {
        DeviceScale.Layout.topBarHeight
    }
    
    /// Bottom action buttons height - consistent across all devices
    public static var bottomBarHeight: CGFloat {
        DeviceScale.Layout.actionButtonHeight
    }
    
    /// Card height - unified calculation for all devices
    public static var cardHeight: CGFloat {
        if isIPad {
            return 300
        } else {
            // For iPhone, calculate based on screen width and aspect ratio
            return screenWidth * SharedUIConstants.Card.aspectRatio
        }
    }
    
    /// Available middle section height after reserving space for top and bottom bars
    public static var middleSectionHeight: CGFloat {
        // Account for safe areas and bars
        let safeAreaTop = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?.safeAreaInsets.top ?? 0
        
        let safeAreaBottom = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?.safeAreaInsets.bottom ?? 0
        
        return screenHeight - safeAreaTop - safeAreaBottom - topBarHeight - bottomBarHeight
    }
    
    // MARK: - Button Layout
    
    /// Button layout style - unified for all devices
    public static var buttonLayout: ButtonLayoutStyle {
        // Always use horizontal layout for consistency
        return .horizontal
    }
    
    /// Button spacing within action buttons
    public static var actionButtonSpacing: CGFloat {
        DeviceScale.Layout.actionButtonIconTextSpacing
    }
    
    // MARK: - Grid Layout
    
    /// Card grid spacing - unified for all devices
    public static var cardGridSpacing: CGFloat {
        DeviceScale.Layout.cardGridSpacing
    }
    
    /// Card grid horizontal padding - unified for all devices
    public static var cardGridPadding: CGFloat {
        DeviceScale.Layout.cardGridPaddingHorizontal
    }
    
    // MARK: - Content Spacing
    
    /// Top spacing for card section
    public static var cardSectionTopSpacing: CGFloat {
        DeviceScale.Layout.cardSectionTopSpacing
    }
    
    /// Bottom spacing for card section
    public static var cardSectionBottomSpacing: CGFloat {
        DeviceScale.Layout.cardSectionBottomSpacing
    }
    
    /// Difficulty indicator height
    public static var difficultyIndicatorHeight: CGFloat {
        DeviceScale.Layout.difficultyIndicatorHeight
    }
    
    // MARK: - Navigation
    
    /// Navigation icon spacing
    public static var navigationIconSpacing: CGFloat {
        DeviceScale.Layout.navigationIconSpacing
    }
    
    /// Navigation horizontal padding
    public static var navigationPaddingHorizontal: CGFloat {
        DeviceScale.Layout.navigationPaddingHorizontal
    }
    
    /// Navigation vertical padding
    public static var navigationPaddingVertical: CGFloat {
        DeviceScale.Layout.navigationPaddingVertical
    }
    
    /// Action button separator spacing
    public static var actionButtonSeparator: CGFloat {
        DeviceScale.Layout.buttonSpacing
    }
}

// MARK: - Button Layout Styles

public enum ButtonLayoutStyle {
    case horizontal
    case vertical
}

