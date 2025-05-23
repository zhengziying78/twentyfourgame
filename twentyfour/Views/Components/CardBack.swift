import SwiftUI

struct CardBack: View {
    // Theme colors matching the icon
    private let softRed = Color(red: 0.75, green: 0.2, blue: 0.2)
    private let softBlack = Color(white: 0.2)
    
    var body: some View {
        GeometryReader { geometry in
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
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
} 