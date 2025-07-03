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
    
    /// Detect newer iPad models that benefit from larger cards
    private static var isNewerIPad: Bool {
        guard isIPad else { return false }
        
        // Use screen size to detect newer iPad models
        // ACTUAL REPORTED DIMENSIONS (not native resolution):
        // iPad Pro 13" M4: 1032×1376 points (compatibility mode)
        // iPad Pro 11" M4: ~834×1194 points (estimated)
        // iPad Air 13" M2: 1032×1376 points (same as Pro 13")
        // iPad Air 11" M2: ~834×1194 points (estimated)
        
        let maxDimension = max(screenWidth, screenHeight)
        let minDimension = min(screenWidth, screenHeight)
        
        // Updated thresholds based on actual reported dimensions
        // iPad Pro/Air 13": 1376×1032 points
        // iPad Pro/Air 11": ~1194×834 points
        // Older iPads (iPad 10th gen, mini): typically < 1100 points max dimension
        let isNewer = maxDimension >= 1300 || minDimension >= 1000
        
        return isNewer
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
            if isNewerIPad {
                // Newer iPads get moderately bigger cards (25% increase)
                return 375  // 300 * 1.25
            } else {
                // Older iPads keep the standard size
                return 300
            }
        } else {
            // For iPhone, calculate based on screen width and aspect ratio (unchanged)
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
    
    /// Card grid horizontal padding - device-specific for newer iPads
    public static var cardGridPadding: CGFloat {
        if isNewerIPad {
            // Reduce horizontal padding significantly for newer iPads to allow bigger cards
            return DeviceScale.Layout.cardGridPaddingHorizontal * 0.4  // 35 → 14 points
        } else {
            return DeviceScale.Layout.cardGridPaddingHorizontal
        }
    }
    
    // MARK: - Content Spacing
    
    /// Top spacing for card section - device-specific for newer iPads
    public static var cardSectionTopSpacing: CGFloat {
        if isNewerIPad {
            // Reduce top spacing for newer iPads to allow bigger cards
            return DeviceScale.Layout.cardSectionTopSpacing * 0.6  // 25 → 15 points
        } else {
            return DeviceScale.Layout.cardSectionTopSpacing
        }
    }
    
    /// Bottom spacing for card section
    public static var cardSectionBottomSpacing: CGFloat {
        DeviceScale.Layout.cardSectionBottomSpacing
    }
    
    /// Difficulty indicator height - device-specific for newer iPads
    public static var difficultyIndicatorHeight: CGFloat {
        if isNewerIPad {
            // Reduce difficulty indicator height for newer iPads to allow bigger cards
            return DeviceScale.Layout.difficultyIndicatorHeight * 0.8  // 50 → 40 points
        } else {
            return DeviceScale.Layout.difficultyIndicatorHeight
        }
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