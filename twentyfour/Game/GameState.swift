import Foundation
import SwiftUI

class GameState: ObservableObject {
    @Published var currentHand: Hand?
    @Published var currentHandIndex: Int?
    private var recentHands: [Hand] = []
    private let maxRecentHands = 5
    private let preferences = FilterPreferences.shared
    
    func getRandomHand(from hands: [Hand]) {
        guard !hands.isEmpty else { return }
        
        // Filter hands by selected difficulties
        let filteredHands = hands.filter { preferences.selectedDifficulties.contains($0.difficulty) }
        guard !filteredHands.isEmpty else { return }
        
        var availableHands = filteredHands.filter { hand in
            !recentHands.contains(hand)
        }
        
        if availableHands.isEmpty {
            availableHands = filteredHands
            recentHands.removeAll()
        }
        
        if let randomIndex = availableHands.indices.randomElement() {
            let hand = availableHands[randomIndex]
            recentHands.append(hand)
            
            if recentHands.count > maxRecentHands {
                recentHands.removeFirst()
            }
            
            currentHand = hand
            currentHandIndex = hands.firstIndex(where: { $0.cards.map { $0.value }.sorted() == hand.cards.map { $0.value }.sorted() })
        }
    }
    
    var formattedSolution: String {
        guard let solution = currentHand?.solution else { return "" }
        return solution
            .replacingOccurrences(of: "*", with: "×")
            .replacingOccurrences(of: "/", with: "÷")
    }
} 