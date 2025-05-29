import SwiftUI

struct CardView: View {
    let card: Card?
    var isFaceUp: Bool
    
    var body: some View {
        ZStack {
            if isFaceUp, let card = card {
                CardFront(card: card)
                    .rotation3DEffect(
                        .degrees(isFaceUp ? CardViewConstants.Animation.frontRotationDegrees : CardViewConstants.Animation.backRotationDegrees),
                        axis: (x: 0, y: 1, z: 0)
                    )
            } else {
                CardBack()
                    .rotation3DEffect(
                        .degrees(isFaceUp ? -CardViewConstants.Animation.backRotationDegrees : CardViewConstants.Animation.frontRotationDegrees),
                        axis: (x: 0, y: 1, z: 0)
                    )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .aspectRatio(CardViewConstants.Layout.aspectRatio, contentMode: .fit)
    }
}

#Preview {
    HStack {
        CardView(card: Card(value: 1, suit: .spades), isFaceUp: true)
        CardView(card: nil, isFaceUp: false)
    }
    .padding()
} 