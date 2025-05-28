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
        ZStack {
            // Semi-transparent background
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    onDismiss()
                }
            
            VStack(spacing: 0) {
                Spacer()
                
                // Filter container
                ZStack {
                    // White background
                    Color.white.opacity(0.95)
                    
                    VStack(spacing: 20) {
                        Text(LocalizationResource.string(for: .selectDifficulties, language: settings.language))
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.black)
                            .padding(.top, 24)
                        
                        // Center the list with a fixed width
                        HStack {
                            Spacer()
                            VStack(alignment: .leading, spacing: 16) {
                                ForEach(Difficulty.allCases, id: \.self) { difficulty in
                                    Button(action: {
                                        preferences.toggleDifficulty(difficulty)
                                    }) {
                                        HStack(spacing: 12) {
                                            Image(systemName: preferences.selectedDifficulties.contains(difficulty) ? "checkmark.square.fill" : "square")
                                                .foregroundColor(preferences.selectedDifficulties.contains(difficulty) ? .blue : .gray)
                                                .font(.system(size: 20))
                                            
                                            HStack(spacing: 8) {
                                                Text(difficultyText(difficulty))
                                                    .font(.system(size: 18))
                                                    .foregroundColor(.black)
                                                
                                                HStack(spacing: 2) {
                                                    ForEach(0..<4) { index in
                                                        Image(systemName: index < filledStars(for: difficulty) ? "star.fill" : "star")
                                                            .font(.system(size: 12))
                                                            .foregroundColor(index < filledStars(for: difficulty) ? .yellow : .gray.opacity(0.5))
                                                    }
                                                }
                                            }
                                        }
                                        .frame(width: 220, alignment: .leading)
                                    }
                                }
                            }
                            Spacer()
                        }
                        
                        Spacer()
                    }
                    
                    // Dismiss button overlay
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: onDismiss) {
                                ZStack {
                                    Circle()
                                        .fill(Color.black.opacity(0.6))
                                        .frame(width: 36, height: 36)
                                    Image(systemName: "xmark")
                                        .foregroundColor(.white)
                                        .font(.system(size: 16, weight: .bold))
                                }
                            }
                            .padding(.top, 16)
                            .padding(.trailing, 16)
                        }
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 280)
                
                Spacer()
            }
        }
    }
} 