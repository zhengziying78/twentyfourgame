import SwiftUI

struct CardFront: View {
    let card: Card
    @ObservedObject private var colorSchemeManager = ColorSchemeManager.shared
    
    // Colors
    private let cardBackground = Color(white: 0.98) // Very light gray, almost white
    
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
    
    private var watermarkFontSize: CGFloat {
        // Use much smaller font size for double-digit numbers
        return card.value >= 10 ? 90 : 160
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Card background
                RoundedRectangle(cornerRadius: 10)
                    .fill(cardBackground)
                
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color.black.opacity(0.15))
                
                // Watermark
                Text(watermarkText)
                    .font(.system(size: watermarkFontSize, weight: .black))
                    .foregroundColor(.black.opacity(0.04)) // Slightly more visible
                    .offset(x: 20, y: 20)
                    .allowsHitTesting(false)
                
                // Corner number and suit
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: -4) {
                            Text(card.displayValue)
                                .font(.system(size: 56, weight: .medium))
                            Image(systemName: card.suit.symbol)
                                .font(.system(size: 48))
                        }
                        .foregroundColor(card.suit.color(scheme: colorSchemeManager.currentScheme))
                        .padding(.leading, 16)
                        .padding(.top, 12)
                        Spacer()
                    }
                    Spacer()
                }
            }
            .animation(.easeInOut(duration: 0.3), value: colorSchemeManager.currentScheme)
        }
    }
} 