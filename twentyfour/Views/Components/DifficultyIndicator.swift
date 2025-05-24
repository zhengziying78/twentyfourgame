import SwiftUI

struct DifficultyIndicator: View {
    let difficulty: Difficulty
    let handNumber: Int
    
    private var difficultyText: String {
        switch difficulty {
        case .easy: return "Difficulty: Easy"
        case .medium: return "Difficulty: Medium"
        case .hard: return "Difficulty: Hard"
        case .hardest: return "Difficulty: Hardest"
        }
    }
    
    private var filledStars: Int {
        switch difficulty {
        case .easy: return 1
        case .medium: return 2
        case .hard: return 3
        case .hardest: return 4
        }
    }
    
    var body: some View {
        VStack(spacing: 4) {
            Text("No. \(handNumber)")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.black.opacity(0.8))
            
            HStack(spacing: 8) {
                Text(difficultyText)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black.opacity(0.8))
                
                HStack(spacing: 2) {
                    ForEach(0..<4) { index in
                        Image(systemName: index < filledStars ? "star.fill" : "star")
                            .font(.system(size: 12))
                            .foregroundColor(index < filledStars ? .yellow : .gray.opacity(0.5))
                    }
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.white.opacity(0.9))
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
    }
} 