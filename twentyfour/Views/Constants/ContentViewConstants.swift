import SwiftUI

public enum ContentViewConstants {
    public enum Layout {
        public static let navigationIconSpacing: CGFloat = DeviceScale.Layout.navigationIconSpacing
        public static let navigationPaddingHorizontal: CGFloat = DeviceScale.Layout.navigationPaddingHorizontal
        public static let navigationPaddingVertical: CGFloat = DeviceScale.Layout.navigationPaddingVertical
        
        public static let cardGridSpacing: CGFloat = DeviceScale.Layout.cardGridSpacing
        public static let cardGridPaddingHorizontal: CGFloat = DeviceScale.Layout.cardGridPaddingHorizontal
        public static let cardSectionTopSpacing: CGFloat = DeviceScale.Layout.cardSectionTopSpacing
        public static let cardSectionBottomSpacing: CGFloat = DeviceScale.Layout.cardSectionBottomSpacing
        public static let difficultyIndicatorHeight: CGFloat = DeviceScale.Layout.difficultyIndicatorHeight
        
        public static let actionButtonHeight: CGFloat = DeviceScale.Layout.actionButtonHeight
        public static let actionButtonSeparator: CGFloat = 1       // Width of separator between action buttons
        public static let actionButtonIconTextSpacing: CGFloat = DeviceScale.Layout.actionButtonIconTextSpacing
    }
    
    public enum Font {
        public static let navigationIcon: CGFloat = DeviceScale.Font.navigationIcon
        public static let actionButtonIcon: CGFloat = DeviceScale.Font.actionButtonIcon
        public static let actionButtonText: CGFloat = DeviceScale.Font.actionButtonText
    }
    
    public enum Animation {
        public static let cardFlipDuration: CGFloat = 0.3  // Duration of card flip animation
        public static let cardFlipDelay: CGFloat = 0.4     // Delay between card flips
    }
    
    public enum Opacity {
        public static let disabledButtonBackground: Double = 0.3  // Opacity for disabled button background
    }
} 