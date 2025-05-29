import SwiftUI

public enum PopupContainerConstants {
    public enum Layout {
        // Removed topOffset since we're using SharedUIConstants.topBarHeight directly
    }
    
    public enum Animation {
        public static let springResponse: CGFloat = SharedUIConstants.Animation.springResponse
        public static let springDamping: CGFloat = SharedUIConstants.Animation.springDamping
    }
    
    public enum Opacity {
        public static let backgroundOverlay: Double = 0.2   // Opacity of the background overlay
        public static let contentBackground: Double = 0.95  // Opacity of the content background
    }
} 