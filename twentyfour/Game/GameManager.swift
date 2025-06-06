import Foundation
import SwiftUI

class GameManager: ObservableObject {
    static let shared = GameManager()
    private let dataset: HandDataset
    private let state: GameState
    
    init(dataset: HandDataset = HandDataset.shared, state: GameState = GameState()) {
        self.dataset = dataset
        self.state = state
    }
    
    var currentHand: Hand? { state.currentHand }
    var formattedSolution: String { state.formattedSolution }
    var handNumber: Int? { state.currentHandIndex.map { $0 + 1 } }
    
    func getRandomHand() {
        state.getRandomHand(from: dataset.hands)
    }
    
    #if DEBUG
    func reset() {
        state.currentHand = nil
        state.currentHandIndex = nil
        state.recentHands.removeAll()
    }
    #endif
}