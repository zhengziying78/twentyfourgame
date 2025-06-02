import SwiftUI

struct DifficultyIndicator: View {
    let difficulty: Difficulty
    @ObservedObject private var languageSettings = LanguagePreferences.shared
    @ObservedObject private var colorSchemeManager = ColorSchemeManager.shared
    
    private var difficultyText: String {
        switch difficulty {
        case .easy:
            return LocalizationResource.string(for: .difficultyEasy, language: languageSettings.language)
        case .medium:
            return LocalizationResource.string(for: .difficultyMedium, language: languageSettings.language)
        case .hard:
            return LocalizationResource.string(for: .difficultyHard, language: languageSettings.language)
        case .hardest:
            return LocalizationResource.string(for: .difficultyHardest, language: languageSettings.language)
        }
    }
    
    var body: some View {
        HStack(spacing: DifficultyIndicatorConstants.Layout.textStarsSpacing) {
            Text(difficultyText)
                .font(.system(size: DifficultyIndicatorConstants.Font.difficultyTextSize, weight: .medium))
                .foregroundColor(colorSchemeManager.currentScheme.primary.opacity(DifficultyIndicatorConstants.Opacity.difficultyTextOpacity))
            
            HStack(spacing: DifficultyIndicatorConstants.Layout.starsSpacing) {
                ForEach(0..<DifficultyIndicatorConstants.Layout.totalStars) { index in
                    Image(systemName: index < difficulty.starCount ? "star.fill" : "star")
                        .font(.system(size: DifficultyIndicatorConstants.Font.starSize))
                        .foregroundColor(index < difficulty.starCount ? .yellow : colorSchemeManager.currentScheme.primary.opacity(DifficultyIndicatorConstants.Opacity.inactiveStarOpacity))
                }
            }
        }
        .padding(.horizontal, DifficultyIndicatorConstants.Layout.containerPaddingHorizontal)
        .padding(.vertical, DifficultyIndicatorConstants.Layout.containerPaddingVertical)
        .background(
            RoundedRectangle(cornerRadius: DifficultyIndicatorConstants.Layout.containerCornerRadius)
                .fill(Color.white.opacity(DifficultyIndicatorConstants.Opacity.containerBackgroundOpacity))
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