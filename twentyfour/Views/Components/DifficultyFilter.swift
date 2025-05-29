import SwiftUI

struct DifficultyFilter: View {
    let onDismiss: () -> Void
    @ObservedObject private var preferences = FilterPreferences.shared
    @ObservedObject private var settings = SettingsPreferences.shared
    
    private func difficultyText(_ difficulty: Difficulty) -> String {
        let key: LocalizedKey
        switch difficulty {
        case .easy: key = .difficultyEasy
        case .medium: key = .difficultyMedium
        case .hard: key = .difficultyHard
        case .hardest: key = .difficultyHardest
        }
        return LocalizationResource.string(for: key, language: settings.language)
    }
    
    private func filledStars(for difficulty: Difficulty) -> Int {
        switch difficulty {
        case .easy: return 1
        case .medium: return 2
        case .hard: return 3
        case .hardest: return 4
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text(LocalizationResource.string(for: .selectDifficulties, language: settings.language))
                .font(.system(size: DifficultyFilterConstants.Font.titleSize, weight: .medium))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, DifficultyFilterConstants.Layout.titlePaddingVertical)
            
            Divider()
            
            VStack(alignment: .leading, spacing: DifficultyFilterConstants.Layout.optionsSpacing) {
                ForEach(Difficulty.allCases, id: \.self) { difficulty in
                    Button(action: {
                        preferences.toggleDifficulty(difficulty)
                    }) {
                        HStack(spacing: DifficultyFilterConstants.Layout.checkboxTextSpacing) {
                            Image(systemName: preferences.selectedDifficulties.contains(difficulty) ? "checkmark.square.fill" : "square")
                                .foregroundColor(preferences.selectedDifficulties.contains(difficulty) ? .blue : .gray)
                                .font(.system(size: DifficultyFilterConstants.Font.checkboxSize))
                                .frame(width: DifficultyFilterConstants.Layout.checkboxSize, height: DifficultyFilterConstants.Layout.checkboxSize)
                            
                            HStack(spacing: DifficultyFilterConstants.Layout.textStarsSpacing) {
                                Text(difficultyText(difficulty))
                                    .font(.system(size: DifficultyFilterConstants.Font.optionTextSize))
                                    .foregroundColor(.primary)
                                
                                HStack(spacing: DifficultyFilterConstants.Layout.starsSpacing) {
                                    ForEach(0..<4) { index in
                                        Image(systemName: index < filledStars(for: difficulty) ? "star.fill" : "star")
                                            .font(.system(size: DifficultyFilterConstants.Font.starSize))
                                            .foregroundColor(index < filledStars(for: difficulty) ? .yellow : .gray.opacity(DifficultyFilterConstants.Opacity.inactiveStarOpacity))
                                    }
                                }
                            }
                            Spacer()
                        }
                        .frame(width: DifficultyFilterConstants.Layout.optionWidth)
                        .contentShape(Rectangle())
                    }
                }
            }
            .padding(.vertical, DifficultyFilterConstants.Layout.titlePaddingVertical)
            .padding(.bottom, DifficultyFilterConstants.Layout.bottomPadding)
        }
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.systemBackground).ignoresSafeArea())
    }
} 