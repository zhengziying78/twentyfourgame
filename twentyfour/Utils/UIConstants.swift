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
} 