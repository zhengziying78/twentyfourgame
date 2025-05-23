import SwiftUI

struct CardFront: View {
    let card: Card
    
    // Colors
    private let cardBackground = Color(white: 0.96) // Soft white
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Card background
                RoundedRectangle(cornerRadius: 10)
                    .fill(cardBackground)
                
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(.black.opacity(0.15))
                
                // Corner number and suit
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: -4) {
                            Text(card.displayValue)
                                .font(.system(size: 56, weight: .medium))
                            Text(card.suit.rawValue)
                                .font(.system(size: 48))
                        }
                        .foregroundColor(card.suit.color)
                        .padding(.leading, 16)
                        .padding(.top, 12)
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
    }
} 