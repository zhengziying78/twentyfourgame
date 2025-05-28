import Foundation

struct HistoryEntry: Identifiable {
    let id: Int // Hand number
    let cards: [Card]
    let difficulty: Difficulty
    let solution: String
    let timestamp: Date
}

class HistoryManager: ObservableObject {
    static let shared = HistoryManager()
    private let maxEntries = 20
    
    @Published private(set) var entries: [HistoryEntry] = []
    @Published private(set) var totalHandsCount: Int = 0
    
    private init() {}
    
    func addEntry(handNumber: Int, cards: [Card], difficulty: Difficulty, solution: String) {
        let entry = HistoryEntry(
            id: handNumber,
            cards: cards,
            difficulty: difficulty,
            solution: solution,
            timestamp: Date()
        )
        
        entries.insert(entry, at: 0) // Add new entries at the start
        if entries.count > maxEntries {
            entries.removeLast() // Remove oldest entry if we exceed maxEntries
        }
        totalHandsCount += 1
    }
} 