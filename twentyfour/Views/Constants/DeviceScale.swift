import SwiftUI

/// Centralized device scaling system for adaptive layouts
public enum DeviceScale {
    /// Scale factor for different device types
    private static var scaleFactor: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 1.25 : 1.0
    }
    
    /// Scale a value based on device type
    public static func value(_ baseValue: CGFloat) -> CGFloat {
        baseValue * scaleFactor
    }
    
    /// Scale an integer value and return as CGFloat
    public static func value(_ baseValue: Int) -> CGFloat {
        CGFloat(baseValue) * scaleFactor
    }
    
    /// Common preset values for frequently used sizes
    public enum Font {
        public static let navigationIcon: CGFloat = DeviceScale.value(22)
        public static let actionButtonIcon: CGFloat = DeviceScale.value(28)
        public static let actionButtonText: CGFloat = DeviceScale.value(24)
        public static let title: CGFloat = DeviceScale.value(20)
        public static let body: CGFloat = DeviceScale.value(16)
        public static let closeButton: CGFloat = DeviceScale.value(16)
        public static let solutionMinSize: CGFloat = DeviceScale.value(20)
        
        // Component-specific fonts
        public static let difficultyText: CGFloat = DeviceScale.value(20)
        public static let star: CGFloat = DeviceScale.value(16)
        public static let cardValue: CGFloat = DeviceScale.value(56)
        public static let cardSuit: CGFloat = DeviceScale.value(48)
        public static let cardWatermark: CGFloat = DeviceScale.value(140)
    }
    
    public enum Layout {
        public static let topBarHeight: CGFloat = DeviceScale.value(92)
        public static let actionButtonHeight: CGFloat = DeviceScale.value(160)
        public static let elementSpacing: CGFloat = DeviceScale.value(16)
        public static let buttonSpacing: CGFloat = DeviceScale.value(24)
        public static let compactSpacing: CGFloat = DeviceScale.value(12)
        public static let cardCornerRadius: CGFloat = DeviceScale.value(10)
        
        // Navigation
        public static let navigationIconSpacing: CGFloat = DeviceScale.value(20)
        public static let navigationPaddingHorizontal: CGFloat = DeviceScale.value(20)
        public static let navigationPaddingVertical: CGFloat = DeviceScale.value(16)
        
        // Card Grid
        public static let cardGridSpacing: CGFloat = DeviceScale.value(16)
        public static let cardGridPaddingHorizontal: CGFloat = DeviceScale.value(28)
        public static let cardSectionTopSpacing: CGFloat = DeviceScale.value(20)
        public static let cardSectionBottomSpacing: CGFloat = DeviceScale.value(20)
        public static let difficultyIndicatorHeight: CGFloat = DeviceScale.value(40)
        
        // Action Buttons
        public static let actionButtonIconTextSpacing: CGFloat = DeviceScale.value(12)
    }
}