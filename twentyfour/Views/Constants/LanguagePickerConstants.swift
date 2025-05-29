import SwiftUI

public enum LanguagePickerConstants {
    public enum Layout {
        public static let pickerWidth: CGFloat = 240        // Width of the language picker
        public static let pickerHeight: CGFloat = 44        // Height of the picker
        public static let pickerScale: CGFloat = 1.2        // Scale factor for the picker
        public static let verticalPadding: CGFloat = 16     // Vertical padding around picker
    }
    
    public enum Font {
        public static let titleSize: CGFloat = SharedUIConstants.Font.titleSize
        public static let optionSize: CGFloat = SharedUIConstants.Font.bodySize
    }
} 