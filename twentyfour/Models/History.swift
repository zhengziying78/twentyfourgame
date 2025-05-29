import Foundation

struct HistoryEntry: Identifiable, Equatable {
    let id = UUID()
    let handNumber: Int
    let cards: [Card]
    let difficulty: Difficulty
    let solution: String
    
    static func == (lhs: HistoryEntry, rhs: HistoryEntry) -> Bool {
        return lhs.id == rhs.id
    }
}

class HistoryManager: ObservableObject {
    static let shared = HistoryManager()
    @Published private(set) var entries: [HistoryEntry] = []
    private let maxEntries = 20
    
    var totalHandsCount: Int {
        return entries.count
    }
    
    func addEntry(handNumber: Int, cards: [Card], difficulty: Difficulty, solution: String) {
        let entry = HistoryEntry(
            handNumber: handNumber,
            cards: cards,
            difficulty: difficulty,
            solution: solution
        )
        
        entries.insert(entry, at: 0)
        
        // Keep only the last maxEntries
        if entries.count > maxEntries {
            entries.removeLast()
        }
    }
} 