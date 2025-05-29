import SwiftUI

struct HistoryView: View {
    let onDismiss: () -> Void
    @ObservedObject private var historyManager = HistoryManager.shared
    @ObservedObject private var settings = SettingsPreferences.shared
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with dismiss button
            HStack {
                Spacer()
                
                Text(LocalizationResource.string(for: .historyTitle, language: settings.language))
                    .font(.system(size: HistoryViewConstants.Font.titleSize, weight: .medium))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button(action: onDismiss) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: HistoryViewConstants.Font.dismissButtonSize))
                        .foregroundColor(.gray)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, HistoryViewConstants.Layout.headerPaddingHorizontal)
            .padding(.vertical, HistoryViewConstants.Layout.headerPaddingVertical)
            
            Divider()
                .background(Color(UIColor.separator))
            
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 0) {
                        if historyManager.entries.isEmpty {
                            Text(LocalizationResource.string(for: .historyEmpty, language: settings.language))
                                .font(.system(size: HistoryViewConstants.Font.emptyStateTextSize))
                                .foregroundColor(.primary.opacity(HistoryViewConstants.Opacity.emptyStateTextOpacity))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, HistoryViewConstants.Layout.emptyStatePaddingVertical)
                        } else {
                            VStack(spacing: 0) {
                                ForEach(historyManager.entries) { entry in
                                    HistoryEntryRow(entry: entry)
                                }
                            }
                            
                            if historyManager.totalHandsCount > historyManager.entries.count {
                                Text(LocalizationResource.string(for: .historyLimitNote, language: settings.language))
                                    .font(.system(size: HistoryViewConstants.Font.limitNoteTextSize))
                                    .foregroundColor(.primary.opacity(HistoryViewConstants.Opacity.limitNoteTextOpacity))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, HistoryViewConstants.Layout.limitNotePaddingVertical)
                                    .padding(.bottom, HistoryViewConstants.Layout.limitNotePaddingBottom)
                            }
                        }
                    }
                    .padding(.horizontal, HistoryViewConstants.Layout.contentPaddingHorizontal)
                }
                .padding(.top, HistoryViewConstants.Layout.contentPaddingTop)
                .safeAreaInset(edge: .bottom) {
                    Color.clear.frame(height: HistoryViewConstants.Layout.bottomSafeAreaInset)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.systemBackground).ignoresSafeArea())
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
                .padding(.vertical, HistoryViewConstants.Layout.entryRowPaddingVertical)
            
            // Right part
            VStack(alignment: .center, spacing: HistoryViewConstants.Layout.entryRowContentSpacing) {
                // Difficulty stars
                DifficultyStars(difficulty: entry.difficulty)
                
                // Solution
                Text(entry.solution)
                    .font(.system(size: HistoryViewConstants.Font.solutionTextSize))
                    .foregroundColor(.primary.opacity(HistoryViewConstants.Opacity.solutionTextOpacity))
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, HistoryViewConstants.Layout.entryRowPaddingVertical)
        }
        .padding(.horizontal, HistoryViewConstants.Layout.entryRowPaddingHorizontal)
    }
}

// Helper view for displaying difficulty stars
struct DifficultyStars: View {
    let difficulty: Difficulty
    
    var body: some View {
        HStack(spacing: HistoryViewConstants.Layout.starsSpacing) {
            ForEach(0..<4, id: \.self) { index in
                Image(systemName: index < difficulty.starCount ? "star.fill" : "star")
                    .font(.system(size: HistoryViewConstants.Font.starSize))
                    .foregroundColor(index < difficulty.starCount ? .yellow : .gray.opacity(HistoryViewConstants.Opacity.inactiveStarOpacity))
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
        HStack(spacing: HistoryViewConstants.Layout.cardValuesSpacing) {
            ForEach(Array(cards.enumerated()), id: \.offset) { _, card in
                Text(displayValue(for: card))
                    .font(.system(size: HistoryViewConstants.Font.cardValueSize, weight: .bold))
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