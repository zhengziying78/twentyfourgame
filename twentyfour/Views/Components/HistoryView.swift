import SwiftUI

struct HistoryView: View {
    let onDismiss: () -> Void
    @ObservedObject private var historyManager = HistoryManager.shared
    @ObservedObject private var settings = SettingsPreferences.shared
    
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
                
                // History container
                ZStack {
                    // White background
                    Color.white.opacity(0.95)
                    
                    VStack(spacing: 20) {
                        Text(LocalizationResource.string(for: .historyTitle, language: settings.language))
                            .font(.system(size: 22, weight: .medium))
                            .foregroundColor(.black)
                            .padding(.top, 24)
                        
                        if historyManager.entries.isEmpty {
                            VStack {
                                Spacer()
                                Text(LocalizationResource.string(for: .historyEmpty, language: settings.language))
                                    .font(.system(size: 16))
                                    .foregroundColor(.black.opacity(0.6))
                                Spacer()
                            }
                        } else {
                            ScrollView {
                                VStack(spacing: 16) {
                                    ForEach(historyManager.entries) { entry in
                                        HistoryEntryRow(entry: entry)
                                    }
                                    
                                    if historyManager.totalHandsCount > historyManager.entries.count {
                                        Text(LocalizationResource.string(for: .historyLimitNote, language: settings.language))
                                            .font(.system(size: 14))
                                            .foregroundColor(.black.opacity(0.5))
                                            .padding(.top, 8)
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.bottom, 24)
                            }
                        }
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
                .frame(height: 480)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
    }
}

struct HistoryEntryRow: View {
    let entry: HistoryEntry
    @ObservedObject private var settings = SettingsPreferences.shared
    
    var body: some View {
        HStack(spacing: 0) {
            // Left part - Cards only
            CardValuesColumn(cards: entry.cards)
                .frame(maxWidth: .infinity)
            
            // Right part - Difficulty and Solution
            VStack(spacing: 0) {
                // Upper part - Difficulty stars
                DifficultyStars(difficulty: entry.difficulty)
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: .infinity)
                    .background(Color.black.opacity(0.03))
                
                // Lower part - Solution
                Text(entry.solution)
                    .font(.system(size: 16))
                    .foregroundColor(.black.opacity(0.8))
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: .infinity)
                    .background(Color.black.opacity(0.06))
            }
            .frame(maxWidth: .infinity)
        }
        .frame(height: 80)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        )
    }
}

// New helper view for displaying just card values in large format
struct CardValuesColumn: View {
    let cards: [Card]
    
    private func displayValue(for card: Card) -> String {
        switch card.value {
        case 1: return "A"
        case 11: return "J"
        case 12: return "Q"
        case 13: return "K"
        default: return "\(card.value)"
        }
    }
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(Array(cards.enumerated()), id: \.offset) { _, card in
                Text(displayValue(for: card))
                    .font(.system(size: 22, weight: .bold, design: .default))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 12)
    }
}

// Helper view for displaying difficulty stars
struct DifficultyStars: View {
    let difficulty: Difficulty
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<4, id: \.self) { index in
                Image(systemName: index < difficulty.starCount ? "star.fill" : "star")
                    .font(.system(size: 12))
                    .foregroundColor(index < difficulty.starCount ? .yellow : .gray.opacity(0.5))
            }
        }
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

#Preview {
    HistoryView(onDismiss: {})
} 