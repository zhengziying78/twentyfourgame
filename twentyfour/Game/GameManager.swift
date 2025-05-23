import Foundation
import SwiftUI

class GameManager: ObservableObject {
    static let shared = GameManager()
    private let dataset = HandDataset.shared
    private let state = GameState()
    
    var currentHand: Hand? { state.currentHand }
    var formattedSolution: String { state.formattedSolution }
    
    func getRandomHand() {
        state.getRandomHand(from: dataset.hands)
    }
} 