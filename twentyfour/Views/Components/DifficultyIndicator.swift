import SwiftUI

struct DifficultyIndicator: View {
    let difficulty: Difficulty
    @ObservedObject private var settings = SettingsPreferences.shared
    @ObservedObject private var colorSchemeManager = ColorSchemeManager.shared
    
    private var difficultyText: String {
        switch difficulty {
        case .easy:
            return LocalizationResource.string(for: .difficultyEasy, language: settings.language)
        case .medium:
            return LocalizationResource.string(for: .difficultyMedium, language: settings.language)
        case .hard:
            return LocalizationResource.string(for: .difficultyHard, language: settings.language)
        case .hardest:
            return LocalizationResource.string(for: .difficultyHardest, language: settings.language)
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Text(difficultyText)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(colorSchemeManager.currentScheme.primary.opacity(0.8))
            
            HStack(spacing: 4) {
                ForEach(0..<4) { index in
                    Image(systemName: index < difficulty.starCount ? "star.fill" : "star")
                        .font(.system(size: 16))
                        .foregroundColor(index < difficulty.starCount ? .yellow : colorSchemeManager.currentScheme.primary.opacity(0.3))
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.9))
        )
    }
}

private extension Difficulty {
    var starCount: Int {
        switch self {
        case .easy: return 1
        case .medium: return 2
        case .hard: return 3
        case .hardest: return 4
        }
    }
} 