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

// MARK: - Responsive Button View

public struct ResponsiveActionButton: View {
    let icon: String
    let text: String
    let action: () -> Void
    let isEnabled: Bool
    let backgroundColor: Color
    let foregroundColor: Color
    let trigger: Bool
    
    public init(
        icon: String,
        text: String,
        action: @escaping () -> Void,
        isEnabled: Bool = true,
        backgroundColor: Color,
        foregroundColor: Color,
        trigger: Bool = false
    ) {
        self.icon = icon
        self.text = text
        self.action = action
        self.isEnabled = isEnabled
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.trigger = trigger
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: ResponsiveLayout.actionButtonSpacing) {
                Image(systemName: icon)
                    .font(.system(size: DeviceScale.Font.actionButtonIcon, weight: .medium))
                    .scaleEffect(trigger ? 1.2 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: trigger)
                Text(text)
                    .font(.system(size: DeviceScale.Font.actionButtonText, weight: .medium))
            }
            .foregroundColor(foregroundColor)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(backgroundColor)
        }
        .disabled(!isEnabled)
    }
}