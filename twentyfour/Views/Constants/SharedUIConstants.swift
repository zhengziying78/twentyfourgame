import SwiftUI

public enum SharedUIConstants {
    public static var topBarHeight: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 120 : 92
    }
    
    public enum Layout {
        public static var elementSpacing: CGFloat {
            UIDevice.current.userInterfaceIdiom == .pad ? 20 : 16
        }
        public static var buttonSpacing: CGFloat {
            UIDevice.current.userInterfaceIdiom == .pad ? 30 : 24
        }
        public static var compactElementSpacing: CGFloat {
            UIDevice.current.userInterfaceIdiom == .pad ? 16 : 12
        }
    }
    
    public enum Font {
        public static var titleSize: CGFloat {
            UIDevice.current.userInterfaceIdiom == .pad ? 24 : 20
        }
        public static var bodySize: CGFloat {
            UIDevice.current.userInterfaceIdiom == .pad ? 18 : 16
        }
    }
    
    public enum Card {
        public static let aspectRatio: CGFloat = 0.52
        public static var cornerRadius: CGFloat {
            UIDevice.current.userInterfaceIdiom == .pad ? 12 : 10
        }
    }
    
    public enum Animation {
        public static let springResponse: CGFloat = 0.3
        public static let springDamping: CGFloat = 0.8
    }
} 