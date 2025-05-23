import SwiftUI

struct CardView: View {
    let card: Card?
    let isFaceUp: Bool
    
    private let cardAspectRatio: CGFloat = 0.7
    private let cornerRadius: CGFloat = 12
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if isFaceUp {
                    // Face-up card design
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(.white)
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                    
                    // Wavy divider and colored background
                    if let card = card {
                        let isRed = card.suit == .hearts || card.suit == .diamonds
                        
                        Wave()
                            .fill(isRed ? Color.red.opacity(0.9) : Color.black.opacity(0.9))
                            .frame(height: geometry.size.height * 0.7)
                            .offset(y: geometry.size.height * 0.3)
                        
                        // Card value and suit
                        VStack(spacing: 0) {
                            HStack {
                                Text(card.displayValue)
                                    .font(.system(size: geometry.size.width * 0.4, weight: .medium))
                                    .foregroundColor(isRed ? .red : .black)
                                Spacer()
                                Text(card.suit.rawValue)
                                    .font(.system(size: geometry.size.width * 0.4))
                            }
                            .padding([.top, .horizontal], 12)
                            Spacer()
                        }
                    }
                } else {
                    // Face-down card design
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(.white)
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                    
                    // Diagonal split background
                    DiagonalSplit()
                        .fill(LinearGradient(
                            colors: [.black, .red],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                }
            }
        }
        .aspectRatio(cardAspectRatio, contentMode: .fit)
    }
}

// Custom wave shape for face-up cards
struct Wave: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: 0, y: rect.maxY))
        
        let controlPoint1 = CGPoint(x: rect.width * 0.5, y: rect.height * 0.7)
        let controlPoint2 = CGPoint(x: rect.width * 0.5, y: rect.height * 0.7)
        
        path.addCurve(
            to: CGPoint(x: rect.width, y: rect.maxY),
            control1: controlPoint1,
            control2: controlPoint2
        )
        
        path.addLine(to: CGPoint(x: rect.width, y: rect.maxY))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY))
        
        return path
    }
}

// Custom diagonal split shape for face-down cards
struct DiagonalSplit: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height * 0.4))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        
        return path
    }
} 