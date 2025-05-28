import SwiftUI

struct CardBack: View {
    @ObservedObject private var colorSchemeManager = ColorSchemeManager.shared
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Card background and border
                RoundedRectangle(cornerRadius: 10)
                    .fill(colorSchemeManager.currentScheme.primary)
                
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color.black.opacity(0.15))
                
                // Simple block pattern
                VStack(spacing: 0) {
                    ForEach(0..<3) { row in
                        HStack(spacing: 0) {
                            ForEach(0..<2) { col in
                                Rectangle()
                                    .fill((row + col) % 2 == 0 ? 
                                        colorSchemeManager.currentScheme.secondary :
                                        colorSchemeManager.currentScheme.primary)
                                    .frame(
                                        width: geometry.size.width / 2,
                                        height: geometry.size.height / 3
                                    )
                            }
                        }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .animation(.easeInOut(duration: 0.3), value: colorSchemeManager.currentScheme)
        }
    }
} 