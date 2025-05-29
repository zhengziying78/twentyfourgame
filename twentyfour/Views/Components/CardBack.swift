import SwiftUI

struct CardBack: View {
    @ObservedObject private var colorSchemeManager = ColorSchemeManager.shared
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Card background and border
                RoundedRectangle(cornerRadius: SharedUIConstants.Card.cornerRadius)
                    .fill(colorSchemeManager.currentScheme.primary)
                
                RoundedRectangle(cornerRadius: SharedUIConstants.Card.cornerRadius)
                    .strokeBorder(Color.black.opacity(CardBackConstants.Opacity.borderOpacity))
                
                // Simple block pattern
                VStack(spacing: 0) {
                    ForEach(0..<CardBackConstants.Layout.gridRows) { row in
                        HStack(spacing: 0) {
                            ForEach(0..<CardBackConstants.Layout.gridColumns) { col in
                                Rectangle()
                                    .fill((row + col) % 2 == 0 ? 
                                        colorSchemeManager.currentScheme.secondary :
                                        colorSchemeManager.currentScheme.primary)
                                    .frame(
                                        width: geometry.size.width / CGFloat(CardBackConstants.Layout.gridColumns),
                                        height: geometry.size.height / CGFloat(CardBackConstants.Layout.gridRows)
                                    )
                            }
                        }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: SharedUIConstants.Card.cornerRadius))
            }
            .animation(.easeInOut(duration: CardBackConstants.Animation.colorSchemeDuration), value: colorSchemeManager.currentScheme)
        }
    }
} 