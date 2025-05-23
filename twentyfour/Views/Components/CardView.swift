import SwiftUI

struct CardView: View {
    let card: Card?
    var isFaceUp: Bool
    
    var body: some View {
        ZStack {
            if isFaceUp, let card = card {
                CardFront(card: card)
            } else {
                CardBack()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .aspectRatio(0.7, contentMode: .fit)
    }
}

#Preview {
    HStack {
        CardView(card: Card(value: 1, suit: .spades), isFaceUp: true)
        CardView(card: nil, isFaceUp: false)
    }
    .padding()
} 