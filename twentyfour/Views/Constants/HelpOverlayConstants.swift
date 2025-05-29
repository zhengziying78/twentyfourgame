import SwiftUI

public enum HelpOverlayConstants {
    public enum Layout {
        public static let headerPaddingHorizontal: CGFloat = 20
        public static let headerPaddingVertical: CGFloat = 16
        public static let contentPaddingHorizontal: CGFloat = 20
        public static let contentPaddingBottom: CGFloat = 24
        public static let contentPaddingTop: CGFloat = 32
        public static let contentSpacing: CGFloat = 16
        public static let lineSpacing: CGFloat = 4
        public static let bottomSafeAreaInset: CGFloat = 90
    }
    
    public enum Font {
        public static let titleSize: CGFloat = SharedUIConstants.Font.titleSize
        public static let dismissButtonSize: CGFloat = 24
        public static let contentSize: CGFloat = 16
    }
    
    public enum Opacity {
        public static let contentTextOpacity: Double = 0.8
    }
} 