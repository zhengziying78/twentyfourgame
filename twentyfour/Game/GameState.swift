import Foundation
import SwiftUI

class GameState: ObservableObject {
    @Published var currentHand: Hand?
    private var recentHands: [Hand] = []
    private let maxRecentHands = 5
    
    func getRandomHand(from hands: [Hand]) {
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
    
    var formattedSolution: String {
        guard let solution = currentHand?.solution else { return "" }
        return solution
            .replacingOccurrences(of: "*", with: "×")
            .replacingOccurrences(of: "/", with: "÷")
    }
} 