import SwiftUI

struct CardFront: View {
    let card: Card
    @ObservedObject private var colorSchemeManager = ColorSchemeManager.shared
    
    private var watermarkText: String {
        switch card.value {
        case 1: return "A"
        case 10: return "X"
        case 11: return "J"
        case 12: return "Q"
        case 13: return "K"
        default: return "\(card.value)"
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Card background
                RoundedRectangle(cornerRadius: SharedUIConstants.Card.cornerRadius)
                    .fill(CardFrontConstants.Colors.background)
                
                RoundedRectangle(cornerRadius: SharedUIConstants.Card.cornerRadius)
                    .strokeBorder(Color.black.opacity(CardFrontConstants.Opacity.borderOpacity))
                
                // Watermark
                Text(watermarkText)
                    .font(.system(size: CardFrontConstants.Font.watermarkSize, weight: .black))
                    .foregroundColor(.black.opacity(CardFrontConstants.Opacity.watermarkOpacity))
                    .offset(x: CardFrontConstants.Layout.watermarkOffset, y: CardFrontConstants.Layout.watermarkOffset)
                    .allowsHitTesting(false)
                
                // Corner number and suit
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: CardFrontConstants.Layout.cornerStackSpacing) {
                            Text(card.displayValue)
                                .font(.system(size: CardFrontConstants.Font.valueSize, weight: .medium))
                            Image(systemName: card.suit.symbol)
                                .font(.system(size: CardFrontConstants.Font.suitSize))
                        }
                        .foregroundColor(card.suit.color(scheme: colorSchemeManager.currentScheme))
                        .padding(.leading, CardFrontConstants.Layout.cornerPaddingLeading)
                        .padding(.top, CardFrontConstants.Layout.cornerPaddingTop)
                        Spacer()
                    }
                    Spacer()
                }
            }
            .animation(.easeInOut(duration: CardFrontConstants.Animation.colorSchemeDuration), value: colorSchemeManager.currentScheme)
        }
    }
} 