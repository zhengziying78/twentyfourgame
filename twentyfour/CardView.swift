import SwiftUI

struct CardView: View {
    let card: Card?
    var isFaceUp: Bool
    
    // Theme colors matching the icon
    private let softRed = Color(red: 0.75, green: 0.2, blue: 0.2)
    private let softBlack = Color(white: 0.2)
    
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

struct CardBack: View {
    // Theme colors matching the icon
    private let softRed = Color(red: 0.75, green: 0.2, blue: 0.2)
    private let softBlack = Color(white: 0.2)
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Base color
                softBlack
                
                // Simple block pattern
                VStack(spacing: 0) {
                    ForEach(0..<3) { row in
                        HStack(spacing: 0) {
                            ForEach(0..<2) { col in
                                if (row + col) % 2 == 0 {
                                    Rectangle()
                                        .fill(softRed)
                                        .frame(
                                            width: geometry.size.width / 2,
                                            height: geometry.size.height / 3
                                        )
                                } else {
                                    Rectangle()
                                        .fill(softBlack)
                                        .frame(
                                            width: geometry.size.width / 2,
                                            height: geometry.size.height / 3
                                        )
                                }
                            }
                        }
                    }
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct DiamondShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        path.move(to: CGPoint(x: center.x, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: center.y))
        path.addLine(to: CGPoint(x: center.x, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: center.y))
        path.closeSubpath()
        
        return path
    }
}

struct CardFront: View {
    let card: Card
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
            
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(.black.opacity(0.2))
            
            Text(card.displayText)
                .font(.system(size: 50, weight: .medium))
                .foregroundColor(card.suit.color)
        }
    }
}

#Preview {
    HStack {
        CardView(card: Card(value: 1, suit: .spades), isFaceUp: true)
        CardView(card: nil, isFaceUp: false)
    }
    .padding()
} 