import SwiftUI

struct CardView: View {
    let card: Card?
    let isFaceUp: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(isFaceUp ? Color.white : Color.gray.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(Color.black, lineWidth: 1)
                )
            
            if isFaceUp, let card = card {
                Text(card.displayText)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(card.suit.color)
            } else {
                Text("?")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.gray)
            }
        }
        .aspectRatio(3/4, contentMode: .fit)
    }
} 