import SwiftUI

struct HistoryView: View {
    let onDismiss: () -> Void
    @ObservedObject private var historyManager = HistoryManager.shared
    @ObservedObject private var settings = SettingsPreferences.shared
    
    var body: some View {
        VStack(spacing: 0) {
            Text(LocalizationResource.string(for: .historyTitle, language: settings.language))
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color(UIColor.systemBackground).opacity(0.95))
            
            Divider()
            
            if historyManager.entries.isEmpty {
                Text(LocalizationResource.string(for: .historyEmpty, language: settings.language))
                    .font(.system(size: 16))
                    .foregroundColor(.primary.opacity(0.6))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                    .background(Color(UIColor.systemBackground).opacity(0.95))
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(historyManager.entries) { entry in
                            HistoryEntryRow(entry: entry)
                                .background(Color(UIColor.systemBackground).opacity(0.95))
                            
                            if entry != historyManager.entries.last {
                                Divider()
                            }
                        }
                        
                        if historyManager.totalHandsCount > historyManager.entries.count {
                            Divider()
                            Text(LocalizationResource.string(for: .historyLimitNote, language: settings.language))
                                .font(.system(size: 14))
                                .foregroundColor(.primary.opacity(0.5))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color(UIColor.systemBackground).opacity(0.95))
                        }
                    }
                }
            }
        }
    }
}

struct HistoryEntryRow: View {
    let entry: HistoryEntry
    @ObservedObject private var settings = SettingsPreferences.shared
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            // Left part - Cards
            CardValuesColumn(cards: entry.cards)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
            
            // Right part
            VStack(alignment: .leading, spacing: 4) {
                // Difficulty stars
                DifficultyStars(difficulty: entry.difficulty)
                
                // Solution
                Text(entry.solution)
                    .font(.system(size: 16))
                    .foregroundColor(.primary.opacity(0.8))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
        }
        .padding(.horizontal, 20)
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

// Helper view for displaying just card values
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
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
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