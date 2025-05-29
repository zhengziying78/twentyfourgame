import SwiftUI

public enum SharedUIConstants {
    public static let topBarHeight: CGFloat = 92
    
    public enum Layout {
        public static let elementSpacing: CGFloat = 16
        public static let buttonSpacing: CGFloat = 24
        public static let compactElementSpacing: CGFloat = 12
    }
    
    public enum Font {
        public static let titleSize: CGFloat = 20
        public static let bodySize: CGFloat = 16
    }
    
    public enum Card {
        public static let aspectRatio: CGFloat = 0.52
        public static let cornerRadius: CGFloat = 10  // Shared corner radius for all cards
    }
    
    public enum Animation {
        public static let springResponse: CGFloat = 0.3
        public static let springDamping: CGFloat = 0.8
    }
} 