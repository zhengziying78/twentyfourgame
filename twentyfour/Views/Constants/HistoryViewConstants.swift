import SwiftUI

public enum HistoryViewConstants {
    public enum Layout {
        public static let headerPaddingHorizontal: CGFloat = 20
        public static let headerPaddingVertical: CGFloat = 16
        public static let contentPaddingHorizontal: CGFloat = 20
        public static let contentPaddingTop: CGFloat = 32
        public static let bottomSafeAreaInset: CGFloat = 90
        public static let emptyStatePaddingVertical: CGFloat = 24
        public static let limitNotePaddingVertical: CGFloat = 12
        public static let limitNotePaddingBottom: CGFloat = 16
        public static let entryRowPaddingHorizontal: CGFloat = 20
        public static let entryRowPaddingVertical: CGFloat = 12
        public static let entryRowContentSpacing: CGFloat = 4
        public static let cardValuesSpacing: CGFloat = 8
        public static let starsSpacing: CGFloat = 2
    }
    
    public enum Font {
        public static let titleSize: CGFloat = SharedUIConstants.Font.titleSize
        public static let dismissButtonSize: CGFloat = 24
        public static let emptyStateTextSize: CGFloat = 16
        public static let limitNoteTextSize: CGFloat = 14
        public static let cardValueSize: CGFloat = 22
        public static let solutionTextSize: CGFloat = 16
        public static let starSize: CGFloat = 12
    }
    
    public enum Opacity {
        public static let emptyStateTextOpacity: Double = 0.6
        public static let limitNoteTextOpacity: Double = 0.5
        public static let solutionTextOpacity: Double = 0.8
        public static let inactiveStarOpacity: Double = 0.5
    }
} 