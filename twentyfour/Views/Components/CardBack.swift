import SwiftUI

struct CardBack: View {
    @ObservedObject private var colorSchemeManager = ColorSchemeManager.shared
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Card background and border
                RoundedRectangle(cornerRadius: CardBackConstants.Layout.cornerRadius)
                    .fill(colorSchemeManager.currentScheme.primary)
                
                RoundedRectangle(cornerRadius: CardBackConstants.Layout.cornerRadius)
                    .strokeBorder(Color.black.opacity(CardBackConstants.Opacity.borderOpacity))
                
                // Simple block pattern
                VStack(spacing: 0) {
                    ForEach(0..<CardBackConstants.Layout.gridRows) { row in
                        HStack(spacing: 0) {
                            ForEach(0..<(CardBackConstants.Layout.gridColumns - 1)) { col in
                                Rectangle()
                                    .fill((row + col) % 2 == 0 ? 
                                        colorSchemeManager.currentScheme.secondary :
                                        colorSchemeManager.currentScheme.primary)
                                    .frame(
                                        width: geometry.size.width / CGFloat(CardBackConstants.Layout.gridColumns - 1),
                                        height: geometry.size.height / CGFloat(CardBackConstants.Layout.gridRows)
                                    )
                            }
                        }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: CardBackConstants.Layout.cornerRadius))
            }
            .animation(.easeInOut(duration: CardBackConstants.Animation.colorSchemeDuration), value: colorSchemeManager.currentScheme)
        }
    }
} 