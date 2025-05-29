import UIKit

enum UIConstants {
    static let topBarHeight: CGFloat = 92
    
    enum Layout {
        static let elementSpacing: CGFloat = 16
        static let buttonSpacing: CGFloat = 24
        static let compactElementSpacing: CGFloat = 12
    }
    
    enum Font {
        static let titleSize: CGFloat = 20
        static let bodySize: CGFloat = 16
    }
    
    enum Card {
        static let aspectRatio: CGFloat = 0.52 // height = screen width * aspectRatio
    }
    
    enum Animation {
        static let springResponse: CGFloat = 0.3
        static let springDamping: CGFloat = 0.8
    }
    
    // Constants specific to ContentView
    enum ContentView {
        enum Layout {
            static let navigationIconSpacing: CGFloat = 20      // Spacing between navigation icons
            static let navigationPaddingHorizontal: CGFloat = 20 // Horizontal padding in navigation bar
            static let navigationPaddingVertical: CGFloat = 16   // Vertical padding in navigation bar
            
            static let cardGridSpacing: CGFloat = 16            // Spacing between cards in the grid
            static let cardGridPaddingHorizontal: CGFloat = 28  // Horizontal padding around card grid
            static let cardSectionTopSpacing: CGFloat = 20      // Space above card grid
            static let cardSectionBottomSpacing: CGFloat = 20   // Space below difficulty indicator
            static let difficultyIndicatorHeight: CGFloat = 40  // Height of difficulty indicator container
            
            static let actionButtonHeight: CGFloat = 160        // Height of action buttons section
            static let actionButtonSeparator: CGFloat = 1       // Width of separator between action buttons
            static let actionButtonIconTextSpacing: CGFloat = 12 // Space between icon and text in buttons
        }
        
        enum Font {
            static let navigationIcon: CGFloat = 22    // Size of navigation bar icons
            static let actionButtonIcon: CGFloat = 28  // Size of icons in action buttons
            static let actionButtonText: CGFloat = 24  // Size of text in action buttons
        }
        
        enum Animation {
            static let cardFlipDuration: CGFloat = 0.3  // Duration of card flip animation
            static let cardFlipDelay: CGFloat = 0.4     // Delay between card flips
        }
        
        enum Opacity {
            static let disabledButtonBackground: Double = 0.3  // Opacity for disabled button background
        }
    }
} 