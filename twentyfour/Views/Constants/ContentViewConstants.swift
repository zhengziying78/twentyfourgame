import SwiftUI

public enum ContentViewConstants {
    public enum Layout {
        public static let navigationIconSpacing: CGFloat = 20      // Spacing between navigation icons
        public static let navigationPaddingHorizontal: CGFloat = 20 // Horizontal padding in navigation bar
        public static let navigationPaddingVertical: CGFloat = 16   // Vertical padding in navigation bar
        
        public static let cardGridSpacing: CGFloat = 16            // Spacing between cards in the grid
        public static let cardGridPaddingHorizontal: CGFloat = 28  // Horizontal padding around card grid
        public static let cardSectionTopSpacing: CGFloat = 20      // Space above card grid
        public static let cardSectionBottomSpacing: CGFloat = 20   // Space below difficulty indicator
        public static let difficultyIndicatorHeight: CGFloat = 40  // Height of difficulty indicator container
        
        public static let actionButtonHeight: CGFloat = 160        // Height of action buttons section
        public static let actionButtonSeparator: CGFloat = 1       // Width of separator between action buttons
        public static let actionButtonIconTextSpacing: CGFloat = 12 // Space between icon and text in buttons
    }
    
    public enum Font {
        public static let navigationIcon: CGFloat = 22    // Size of navigation bar icons
        public static let actionButtonIcon: CGFloat = 28  // Size of icons in action buttons
        public static let actionButtonText: CGFloat = 24  // Size of text in action buttons
    }
    
    public enum Animation {
        public static let cardFlipDuration: CGFloat = 0.3  // Duration of card flip animation
        public static let cardFlipDelay: CGFloat = 0.4     // Delay between card flips
    }
    
    public enum Opacity {
        public static let disabledButtonBackground: Double = 0.3  // Opacity for disabled button background
    }
} 