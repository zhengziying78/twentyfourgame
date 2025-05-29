import SwiftUI

public enum DifficultyIndicatorConstants {
    public enum Layout {
        public static let containerCornerRadius: CGFloat = 10
        public static let containerPaddingHorizontal: CGFloat = 16
        public static let containerPaddingVertical: CGFloat = 8
        public static let textStarsSpacing: CGFloat = 12
        public static let starsSpacing: CGFloat = 4
        public static let totalStars: Int = 4
    }
    
    public enum Font {
        public static let difficultyTextSize: CGFloat = 20
        public static let starSize: CGFloat = 16
    }
    
    public enum Opacity {
        public static let containerBackgroundOpacity: Double = 0.9
        public static let difficultyTextOpacity: Double = 0.8
        public static let inactiveStarOpacity: Double = 0.3
    }
} 