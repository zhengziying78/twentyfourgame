import SwiftUI

public enum CardFrontConstants {
    public enum Layout {
        public static let cornerStackSpacing: CGFloat = -4
        public static let cornerPaddingLeading: CGFloat = 16
        public static let cornerPaddingTop: CGFloat = 12
        public static let watermarkOffset: CGFloat = 20
    }
    
    public enum Font {
        public static let watermarkSize: CGFloat = 140
        public static let valueSize: CGFloat = 56
        public static let suitSize: CGFloat = 48
    }
    
    public enum Colors {
        public static var background = Color(white: 0.98)
    }
    
    public enum Opacity {
        public static let borderOpacity: Double = 0.15
        public static let watermarkOpacity: Double = 0.025
    }
    
    public enum Animation {
        public static let colorSchemeDuration: Double = 0.3
    }
} 