import SwiftUI

public enum CardFrontConstants {
    public enum Layout {
        public static let cornerStackSpacing: CGFloat = -4
        public static let cornerPaddingLeading: CGFloat = 16
        public static let cornerPaddingTop: CGFloat = 12
        public static let watermarkOffset: CGFloat = 20
    }
    
    public enum Font {
        public static var watermarkSize: CGFloat {
            UIDevice.current.userInterfaceIdiom == .pad ? 180 : 140
        }
        public static var valueSize: CGFloat {
            UIDevice.current.userInterfaceIdiom == .pad ? 68 : 56
        }
        public static var suitSize: CGFloat {
            UIDevice.current.userInterfaceIdiom == .pad ? 58 : 48
        }
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