import SwiftUI

public enum ColorSchemePickerConstants {
    public enum Layout {
        public static let titlePaddingVertical: CGFloat = 16
        public static let schemesSpacingVertical: CGFloat = 12
        public static let schemesSpacingHorizontal: CGFloat = 16
        public static let schemeButtonWidth: CGFloat = 110
        public static let schemeButtonPaddingVertical: CGFloat = 4
        public static let colorCircleSize: CGFloat = 16
        public static let colorCirclesSpacing: CGFloat = 8
        public static let schemeNameCheckmarkSpacing: CGFloat = 4
        public static let schemesPerRow: Int = 3
        public static let settingsPaddingHorizontal: CGFloat = 16
        public static let settingsPaddingVertical: CGFloat = 12
    }
    
    public enum Font {
        public static let titleSize: CGFloat = 20
        public static let schemeNameSize: CGFloat = 14
        public static let checkmarkSize: CGFloat = 12
        public static let settingsTextSize: CGFloat = 14
    }
    
    public enum Scale {
        public static let schemeNameMinScale: CGFloat = 0.8
    }
} 