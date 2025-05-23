import Foundation
import SwiftUI

class GameData: ObservableObject {
    static let shared = GameData()
    
    @Published var currentHand: Hand?
    private var hands: [Hand] = []
    private var recentHands: [Hand] = []
    private let maxRecentHands = 5
    
    private init() {
        // Pre-generated dataset - you can expand this later
        let dataset: [(numbers: [Int], solution: String, difficulty: Difficulty)] = [
            ([2, 4, 4, 7], "4 * 2 * (7 - 4)", .easy),       // Simple multiplication and subtraction
            ([3, 3, 8, 8], "(8 / 3 + 8) * 3", .medium),     // Requires division and understanding order
            ([5, 5, 5, 5], "5 * 5 - (5 + 5)", .medium),     // Requires trying different groupings
            ([2, 3, 10, 13], "(13 - 10) * 2 * 3", .easy),   // Straightforward operations
            ([1, 4, 8, 8], "8 * 4 * (1 - 8)", .hard)        // Requires negative intermediate result
        ]
        
        hands = dataset.map { Hand(numbers: $0.numbers, solution: $0.solution, difficulty: $0.difficulty) }
    }
    
    var formattedSolution: String {
        guard let solution = currentHand?.solution else { return "" }
        return solution
            .replacingOccurrences(of: "*", with: "×")
            .replacingOccurrences(of: "/", with: "÷")
    }
    
    func getRandomHand() {
        guard !hands.isEmpty else { return }
        
        var availableHands = hands.filter { hand in
            !recentHands.contains(hand)
        }
        
        if availableHands.isEmpty {
            availableHands = hands
            recentHands.removeAll()
        }
        
        let hand = availableHands.randomElement()!
        recentHands.append(hand)
        
        if recentHands.count > maxRecentHands {
            recentHands.removeFirst()
        }
        
        currentHand = hand
    }
} 