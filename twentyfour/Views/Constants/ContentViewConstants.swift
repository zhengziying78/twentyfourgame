import SwiftUI

public enum ContentViewConstants {
    public enum Layout {
        public static var navigationIconSpacing: CGFloat {
            UIDevice.current.userInterfaceIdiom == .pad ? 28 : 20
        }
        public static var navigationPaddingHorizontal: CGFloat {
            UIDevice.current.userInterfaceIdiom == .pad ? 32 : 20
        }
        public static var navigationPaddingVertical: CGFloat {
            UIDevice.current.userInterfaceIdiom == .pad ? 20 : 16
        }
        
        public static var cardGridSpacing: CGFloat {
            UIDevice.current.userInterfaceIdiom == .pad ? 24 : 16
        }
        public static var cardGridPaddingHorizontal: CGFloat {
            UIDevice.current.userInterfaceIdiom == .pad ? 40 : 28
        }
        public static var cardSectionTopSpacing: CGFloat {
            UIDevice.current.userInterfaceIdiom == .pad ? 32 : 20
        }
        public static var cardSectionBottomSpacing: CGFloat {
            UIDevice.current.userInterfaceIdiom == .pad ? 32 : 20
        }
        public static var difficultyIndicatorHeight: CGFloat {
            UIDevice.current.userInterfaceIdiom == .pad ? 50 : 40
        }
        
        public static var actionButtonHeight: CGFloat {
            UIDevice.current.userInterfaceIdiom == .pad ? 180 : 160
        }
        public static let actionButtonSeparator: CGFloat = 1       // Width of separator between action buttons
        public static var actionButtonIconTextSpacing: CGFloat {
            UIDevice.current.userInterfaceIdiom == .pad ? 16 : 12
        }
    }
    
    public enum Font {
        public static var navigationIcon: CGFloat {
            UIDevice.current.userInterfaceIdiom == .pad ? 26 : 22
        }
        public static var actionButtonIcon: CGFloat {
            UIDevice.current.userInterfaceIdiom == .pad ? 32 : 28
        }
        public static var actionButtonText: CGFloat {
            UIDevice.current.userInterfaceIdiom == .pad ? 28 : 24
        }
    }
    
    public enum Animation {
        public static let cardFlipDuration: CGFloat = 0.3  // Duration of card flip animation
        public static let cardFlipDelay: CGFloat = 0.4     // Delay between card flips
    }
    
    public enum Opacity {
        public static let disabledButtonBackground: Double = 0.3  // Opacity for disabled button background
    }
} 