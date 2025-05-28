import SwiftUI

struct CardBack: View {
    @ObservedObject private var colorSchemeManager = ColorSchemeManager.shared
    
    var body: some View {
        GeometryReader { geometry in
            // Base color
            colorSchemeManager.currentScheme.primary
            
            // Simple block pattern
            VStack(spacing: 0) {
                ForEach(0..<3) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<2) { col in
                            if (row + col) % 2 == 0 {
                                Rectangle()
                                    .fill(colorSchemeManager.currentScheme.secondary)
                                    .frame(
                                        width: geometry.size.width / 2,
                                        height: geometry.size.height / 3
                                    )
                            } else {
                                Rectangle()
                                    .fill(colorSchemeManager.currentScheme.primary)
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