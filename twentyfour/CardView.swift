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

struct DiamondPattern: Shape {
    let columns: Int
    let rows: Int
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let columnWidth = rect.width / CGFloat(columns)
        let rowHeight = rect.height / CGFloat(rows)
        
        for row in 0..<rows {
            for column in 0..<columns {
                let x = CGFloat(column) * columnWidth
                let y = CGFloat(row) * rowHeight
                
                let diamondWidth = columnWidth * 0.8
                let diamondHeight = rowHeight * 0.8
                
                let centerX = x + columnWidth / 2
                let centerY = y + rowHeight / 2
                
                path.move(to: CGPoint(x: centerX, y: centerY - diamondHeight / 2))
                path.addLine(to: CGPoint(x: centerX + diamondWidth / 2, y: centerY))
                path.addLine(to: CGPoint(x: centerX, y: centerY + diamondHeight / 2))
                path.addLine(to: CGPoint(x: centerX - diamondWidth / 2, y: centerY))
                path.closeSubpath()
            }
        }
        return path
    }
}

struct CirclePattern: Shape {
    let columns: Int
    let rows: Int
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let columnWidth = rect.width / CGFloat(columns)
        let rowHeight = rect.height / CGFloat(rows)
        
        for row in 0..<rows {
            for column in 0..<columns {
                let x = CGFloat(column) * columnWidth
                let y = CGFloat(row) * rowHeight
                
                let diameter = min(columnWidth, rowHeight) * 0.6
                let centerX = x + columnWidth / 2
                let centerY = y + rowHeight / 2
                
                path.addEllipse(in: CGRect(
                    x: centerX - diameter / 2,
                    y: centerY - diameter / 2,
                    width: diameter,
                    height: diameter
                ))
            }
        }
        return path
    }
}

#Preview {
    HStack {
        CardView(card: Card(value: 1, suit: .spades), isFaceUp: true)
        CardView(card: nil, isFaceUp: false)
    }
    .padding()
} 