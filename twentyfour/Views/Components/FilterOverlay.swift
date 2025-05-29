import SwiftUI

struct FilterOverlay: View {
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
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 16) {
                ForEach(Difficulty.allCases, id: \.self) { difficulty in
                    Button(action: {
                        preferences.toggleDifficulty(difficulty)
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: preferences.selectedDifficulties.contains(difficulty) ? "checkmark.square.fill" : "square")
                                .foregroundColor(preferences.selectedDifficulties.contains(difficulty) ? .blue : .gray)
                                .font(.system(size: 20))
                                .frame(width: 24, height: 24)
                            
                            HStack(spacing: 8) {
                                Text(difficultyText(difficulty))
                                    .font(.system(size: 18))
                                    .foregroundColor(.primary)
                                
                                HStack(spacing: 2) {
                                    ForEach(0..<4) { index in
                                        Image(systemName: index < filledStars(for: difficulty) ? "star.fill" : "star")
                                            .font(.system(size: 12))
                                            .foregroundColor(index < filledStars(for: difficulty) ? .yellow : .gray.opacity(0.5))
                                    }
                                }
                            }
                            Spacer()
                        }
                        .frame(width: 200)
                        .contentShape(Rectangle())
                    }
                }
            }
            .padding(.vertical, 16)
            .padding(.bottom, 8)
        }
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.systemBackground).ignoresSafeArea())
    }
} 