import SwiftUI

struct DifficultyIndicator: View {
    let difficulty: Difficulty
    let handNumber: Int
    @ObservedObject private var settings = SettingsPreferences.shared
    
    private var difficultyText: String {
        let label = LocalizationResource.string(for: .difficultyLabel, language: settings.language)
        let level = difficultyLevelText(for: difficulty)
        return label + level
    }
    
    private func difficultyLevelText(for difficulty: Difficulty) -> String {
        let key: LocalizedKey
        switch difficulty {
        case .easy: key = .difficultyEasy
        case .medium: key = .difficultyMedium
        case .hard: key = .difficultyHard
        case .hardest: key = .difficultyHardest
        }
        return LocalizationResource.string(for: key, language: settings.language)
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
            Text(LocalizationResource.string(for: .handNumberPrefix, language: settings.language) + String(handNumber))
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