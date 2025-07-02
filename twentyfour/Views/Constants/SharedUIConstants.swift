import SwiftUI

public enum SharedUIConstants {
    public static let topBarHeight: CGFloat = DeviceScale.Layout.topBarHeight
    
    public enum Layout {
        public static let elementSpacing: CGFloat = DeviceScale.Layout.elementSpacing
        public static let buttonSpacing: CGFloat = DeviceScale.Layout.buttonSpacing
        public static let compactElementSpacing: CGFloat = DeviceScale.Layout.compactSpacing
    }
    
    public enum Font {
        public static let titleSize: CGFloat = DeviceScale.Font.title
        public static let bodySize: CGFloat = DeviceScale.Font.body
    }
    
    public enum Card {
        public static let aspectRatio: CGFloat = 0.52
        public static let cornerRadius: CGFloat = DeviceScale.Layout.cardCornerRadius
    }
    
    public enum Animation {
        public static let springResponse: CGFloat = 0.3
        public static let springDamping: CGFloat = 0.8
    }
} 